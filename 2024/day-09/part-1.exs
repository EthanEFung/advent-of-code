defmodule Part1 do
  def decode(dense_fmt) do
    for {v, idx} <-
          String.to_integer(dense_fmt)
          |> Integer.digits()
          |> Enum.with_index() do
      case rem(idx, 2) do
        0 -> List.duplicate(Integer.floor_div(idx, 2), v)
        1 -> List.duplicate(".", v)
      end
    end
    |> Enum.concat()
  end

  def free(list) do
    reversed =
      Enum.reverse(list)
      |> Enum.filter(&is_integer/1)

    delta = length(list) - length(reversed)

    len = 0..(length(list) - delta - 1)

    replace(list, reversed, []) |> Enum.slice(len)
  end

  def checksum(disk_map) do
    disk_map
    |> Enum.with_index()
    |> Enum.map(fn {id, pos} -> id * pos end)
    |> Enum.sum()
  end

  def eq(sum, result), do: sum == result

  defp replace([], _, acc), do: Enum.reverse(acc)

  defp replace(["." | tail], [last_num | reversed], acc) do
    replace(tail, reversed, [last_num | acc])
  end

  defp replace([head | tail], reversed, acc) do
    replace(tail, reversed, [head | acc])
  end
end

"2333133121414131402"
|> Part1.decode()
|> Part1.free()
|> Part1.checksum()
|> Part1.eq(1928)
|> IO.inspect(label: "correct")

input =
  case File.read("input.txt") do
    {:ok, c} -> c |> String.trim()
  end

input
|> Part1.decode()
|> Part1.free()
|> Part1.checksum()
|> IO.inspect(label: "checksum")
