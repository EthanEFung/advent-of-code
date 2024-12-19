defmodule Part1 do
  def count_trails(input) do
    tmap = graph(input)
    heads = trailheads(tmap)

    Enum.reduce(heads, 0, fn head, sum ->
      count_trail(tmap, head, sum)
    end)
  end

  defp graph(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn str -> String.graphemes(str) |> Enum.map(&String.to_integer/1) end)
  end

  defp trailheads(grid) do
    for row <- 0..(length(grid) - 1),
        col <- 0..(length(Enum.at(grid, row)) - 1),
        val(grid, {row, col}) == 0 do
      {row, col}
    end
  end

  defp count_trail(tmap, {head_row, head_col}, sum) do
    MapSet.size(search(tmap, {head_row, head_col}, MapSet.new(), MapSet.new())) + sum
  end

  defp search(tmap, {row, col}, set, seen) do
    if MapSet.member?(seen, {row, col}) do
      set
    else
      seen = MapSet.put(seen, {row, col})

      case val(tmap, {row, col}) do
        9 ->
          # we've found an unseen end of a trail, so we add to the set
          MapSet.put(set, {row, col})

        _ ->
          # visit each node of the cardinal directions
          [{row - 1, col}, {row, col + 1}, {row + 1, col}, {row, col - 1}]
          |> Enum.reduce(set, fn {drow, dcol}, set ->
            # search if within bounds of the grid and is an elevation of +1
            if drow >= 0 && drow < length(tmap) &&
                 dcol >= 0 && dcol < length(Enum.at(tmap, drow)) &&
                 val(tmap, {row, col}) == val(tmap, {drow, dcol}) - 1 do
              MapSet.union(set, search(tmap, {drow, dcol}, set, seen))
            else
              set
            end
          end)
      end
    end
  end

  defp val(grid, {row, col}), do: Enum.at(Enum.at(grid, row), col)
end

# # example
# "
# 89010123
# 78121874
# 87430965
# 96549874
# 45678903
# 32019012
# 01329801
# 10456732
# " |> String.trim() |> Part1.count_trails() |> IO.inspect(label: "trails")

case File.read("input.txt") do
  {:ok, c} -> String.trim(c)
end
|> Part1.count_trails()
|> IO.inspect(label: "trails")
