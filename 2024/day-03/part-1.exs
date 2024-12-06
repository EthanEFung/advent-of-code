filename = "input.txt"

defmodule Mult do
  def scan(input) do
    Regex.scan(~r/mul\(\d+\,\d+\)/, input)
    |> Enum.map(&List.first/1)
  end

  def get_numbers(input) do
    Regex.scan(~r/(\d+)/, input)
    |> Enum.map(&List.first/1)
    |> Enum.map(&String.to_integer/1)
  end

  def mult([x, y]), do: x * y
end

# Lets go
case File.read(filename) do
  {:ok, contents} ->
    contents
    |> Mult.scan()
    |> Enum.map(fn capture ->
      capture
      |> Mult.get_numbers()
      |> Mult.mult()
    end)
    |> Enum.reduce(fn product, sum -> sum + product end)

  _ ->
    "Something happened"
end
|> IO.puts()
