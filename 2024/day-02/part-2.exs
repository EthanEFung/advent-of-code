filename = "input.txt"

rows =
  case File.read(filename) do
    {:ok, contents} ->
      contents
      |> String.split("\n", trim: true)
      |> Enum.map(fn str ->
        str |> String.split() |> Enum.map(&String.to_integer/1)
      end)

    _ ->
      IO.puts("Something went wrong, please try again")
  end

defmodule Valid do
  def asc([a, b], strikes) do
    a - b <= -1 && a - b >= -3 && strikes >= 0
  end

  def asc([a, b | _] = integers, strikes) do
    cond do
      a - b <= -1 && a - b >= -3 ->
        asc(List.delete(integers, a), strikes)

      strikes < 1 ->
        false

      true ->
        asc(List.delete(integers, a), strikes - 1) ||
          asc(List.delete(integers, b), strikes - 1)
    end
  end

  def desc([a, b], strikes) do
    a - b >= 1 && a - b <= 3 && strikes >= 0
  end

  def desc([a, b | _] = integers, strikes) do
    cond do
      a - b >= 1 && a - b <= 3 ->
        desc(List.delete(integers, a), strikes)

      strikes < 1 ->
        false

      true ->
        desc(List.delete(integers, a), strikes - 1) ||
          desc(List.delete(integers, b), strikes - 1)
    end
  end
end

# IO.inspect(rows)
IO.puts("Safe Reports:")

# count
rows
|> Enum.reduce(0, fn row, acc ->
  cond do
    Valid.asc(row, 1) ->
      acc + 1

    Valid.desc(row, 1) ->
      acc + 1

    true ->
      acc
  end
end)
|> IO.puts()
