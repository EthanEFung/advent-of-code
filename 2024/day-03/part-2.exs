filename = "input.txt"

defmodule Mult do
  defp match(), do: ~r/do(?:n't)?\(\)/

  def dos_and_donts(input) do
    tokens =
      Regex.scan(match(), input)
      |> List.flatten()
      |> List.insert_at(0, "do()")

    strs =
      String.split(input, match())

    Enum.zip(tokens, strs)
  end

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

sum =
  case File.read(filename) do
    {:ok, contents} ->
      contents
      |> Mult.dos_and_donts()
      |> Enum.filter(fn {k, _} -> k == "do()" end)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.flat_map(&Mult.scan/1)
      |> Enum.map(&Mult.get_numbers/1)
      |> Enum.map(&Mult.mult/1)
      |> Enum.sum()
  end

IO.puts("sum of products: #{sum}")

# "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
# |> IO.inspect()
# |> Mult.dos_and_donts()
# |> IO.inspect()

# "don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
# |> IO.inspect()
# |> Mult.dos_and_donts()
# |> IO.inspect()
#
# "do()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
# |> IO.inspect()
# |> Mult.dos_and_donts()
# |> IO.inspect()
