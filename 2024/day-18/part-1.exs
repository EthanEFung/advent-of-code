defmodule Part1 do
  def parse(str, dimensions, n) do
    initial =
      for _ <- dimensions do
        for _ <- dimensions do
          "."
        end
      end

    coors = str |> String.trim() |> String.split("\n") |> Enum.slice(0..(n - 1))

    Enum.reduce(coors, initial, fn coor, grid ->
      [col, row] =
        String.split(coor, ",") |> Enum.map(&String.to_integer/1)

      List.update_at(grid, row, fn ls -> List.update_at(ls, col, fn _ -> "#" end) end)
    end)
  end

  def count(grid) do
    traverse(grid, :queue.from_list([{0, {0, 0}}]), MapSet.new())
  end

  defp traverse(grid, queue, visited) do
    case :queue.out(queue) do
      {{:value, {steps, {row, col}}}, next_queue} ->
        end_index = length(grid) - 1

        cond do
          MapSet.member?(visited, {row, col}) ->
            traverse(grid, next_queue, visited)

          row == end_index && col == end_index ->
            steps

          true ->
            neighbors =
              Enum.filter(cardinal({row, col}), fn {r, c} ->
                r >= 0 && r <= end_index &&
                  c >= 0 && c <= end_index &&
                  Enum.at(Enum.at(grid, r), c) != "#"
              end)
              |> Enum.map(fn {r, c} -> {steps + 1, {r, c}} end)
              |> :queue.from_list()

            traverse(grid, :queue.join(next_queue, neighbors), MapSet.put(visited, {row, col}))
        end
    end
  end

  defp cardinal({row, col}) do
    [
      {row - 1, col},
      {row, col + 1},
      {row + 1, col},
      {row, col - 1}
    ]
  end
end

"5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0"
|> Part1.parse(0..6, 12)
|> Part1.count()
|> IO.inspect(label: "example")

case File.read("input.txt") do
  {:ok, c} -> c
end
|> Part1.parse(0..70, 1024)
|> Part1.count()
|> IO.inspect(label: "count")
