defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li> #{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      # below will sort the filtered bears by name in ascending alphabetical order.
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join()

    %{conv | status: 200, resp_body: "<ul><li>#{items}</li></ul>"}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{conv | status: 200, resp_body: "Bear #{bear.id} is named #{bear.name}"}
  end

  def delete(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | status: 403, resp_body: "Deleting bear #{id} is forbidden"}
  end

  def post(conv, %{"name" => name, "type" => type}) do
    %{
      conv
      | status: 201,
        resp_body: "you created a #{type} bear named #{name}"
    }
  end
end
