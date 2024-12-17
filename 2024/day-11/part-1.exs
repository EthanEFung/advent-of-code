defmodule Part1 do
  def change(pebbles, 0), do: pebbles

  def change(pebbles, steps) do
    change(shift(pebbles), steps - 1)
  end

  defp shift([head]), do: transform(head)

  defp shift([head | tail]) do
    transform(head) ++ shift(tail)
  end

  defp transform(0), do: [1]

  defp transform(pebble) do
    digits = Integer.digits(pebble)

    if rem(length(digits), 2) == 0 do
      mid =
        Integer.floor_div(length(digits), 2)

      left =
        Enum.slice(digits, 0..(mid - 1))
        |> Integer.undigits()

      right =
        Enum.slice(digits, mid..length(digits))
        |> Integer.undigits()

      [left, right]
    else
      [pebble * 2024]
    end
  end
end

"2 77706 5847 9258441 0 741 883933 12"
|> String.trim()
|> String.split()
|> Enum.map(&String.to_integer/1)
|> Part1.change(25)
|> IO.inspect(label: "pebbles")
|> Enum.count()
|> IO.inspect(label: "count")
