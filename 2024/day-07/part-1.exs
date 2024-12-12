example = "
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
" |> String.trim()

input =
  case File.read("input.txt") do
    {:ok, content} -> content |> String.trim()
  end

defmodule Part1 do
  def parse([result, values]) do
    {
      String.to_integer(result),
      String.split(values) |> Enum.map(&String.to_integer/1)
    }
  end

  def valid({result, [final]}) do
    result == final
  end

  def valid({result, [this, that]}) do
    valid({result, [this + that]}) || valid({result, [this * that]})
  end

  def valid({result, [this, that | others]}) do
    valid({result, [this + that | others]}) ||
      valid({result, [this * that | others]})
  end

  def total(list) do
    for {result, _} <- list do
      result
    end
    |> Enum.sum()
  end
end

input
|> String.split("\n")
|> Enum.map(&String.split(&1, ": "))
|> Enum.map(&Part1.parse/1)
|> Enum.filter(&Part1.valid/1)
|> Part1.total()
|> IO.inspect(label: "count")
