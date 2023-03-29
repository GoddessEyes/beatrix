defmodule BeatrixWeb.Services.MdAstParses do

  def get_entity([]), do: nil

  def get_entity(list) do
    [head | tail] = list
    get_entity(tail, head)
  end

  def get_entity(tail, {"h2", [], [category_name], %{}}) do
    IO.puts category_name
    get_entity(tail)
  end

  def get_entity(tail, _) do
    get_entity(tail)
  end

end
