defmodule Servy.Handler do
  @moduledoc "handles http request"
  @pages_path Path.expand("../../pages", __DIR__)
  @doc "transforms the request into a response"

  alias Servy.Conv

  alias Servy.BearController

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]

  import Servy.Parser, only: [parse: 1]

  import Servy.FileHandler, only: [handle_file: 2]

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    # |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.delete(conv, params)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    _file =
      Path.expand("../../pages", __DIR__)
      |> Path.join("form.html")
      |> File.read()
      |> handle_file(conv)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.post(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    file =
      Path.expand("../../pages", __DIR__)
      |> Path.join("about.html")
      |> File.read()
      |> handle_file(conv)

    # case File.read(file) do
    #   {:ok, content} ->
    #     %{conv | status: 200, resp_body: content}

    #   {:error, :enoent} ->
    #     %{conv | status: 404, resp_body: "file not found"}

    #   {:error, reason} ->
    #     %{conv | status: 500, resp_body: "file error: #{reason}"}
    # end
  end

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "no #{path} here"}
  end

  def format_response(%Conv{} = conv) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end
