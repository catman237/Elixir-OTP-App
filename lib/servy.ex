defmodule Servy do
  @moduledoc """
  Documentation for `Servy`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Servy.hello()
      :world

  """
  def hello(name) do
    "hello, #{name}!"
  end
end

IO.puts(Servy.hello("greg"))
