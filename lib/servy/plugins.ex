defmodule Servy.Plugins do
  alias Servy.Conv

  def track(conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bear/#{id}"}
  end

  def rewrite_path(conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect(conv)

  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts("warning #{path} is on the loose")
    conv
  end
end
