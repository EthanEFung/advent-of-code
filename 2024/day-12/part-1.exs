defmodule Part1 do
  def total_price(str) do
    g = grid(str)

    {total, _} =
      for row <- 0..(length(g) - 1),
          col <- 0..(length(Enum.at(g, row)) - 1) do
        {row, col}
      end
      |> Enum.reduce({0, MapSet.new()}, fn {row, col}, agg ->
        region_price(g, {row, col}, agg)
      end)

    total
  end

  defp grid(str) do
    str |> String.split("\n") |> Enum.map(&String.graphemes/1)
  end

  defp cardinal({row, col}) do
    [
      {row - 1, col},
      {row, col + 1},
      {row + 1, col},
      {row, col - 1}
    ]
  end

  defp region_price(grid, {row, col}, {sum, seen}) do
    if MapSet.member?(seen, {row, col}) do
      {sum, seen}
    else
      {area, perimeter, visited} = search(grid, {row, col}, seen)
      {area * perimeter + sum, MapSet.union(seen, visited)}
    end
  end

  # returns a tuple of area, perimeter of a region and a map_set of the plots that were visited
  defp search(grid, {row, col}, seen) do
    do_search(grid, :queue.from_list([{row, col}]), MapSet.put(seen, {row, col}), 0, 0)
  end

  defp do_search(grid, queue, visited, area, perimeter) do
    case :queue.out(queue) do
      {:empty, _} ->
        {area, perimeter, visited}

      {{:value, {row, col}}, queue} ->
        {new_queue, new_visited} =
          Enum.filter(cardinal({row, col}), fn {drow, dcol} ->
            inbounds(grid, {drow, dcol}) && matches(grid, {row, col}, {drow, dcol}) and
              not MapSet.member?(visited, {drow, dcol})
          end)
          |> Enum.reduce({queue, visited}, fn {drow, dcol}, {q, v} ->
            {:queue.in({drow, dcol}, q), MapSet.put(v, {drow, dcol})}
          end)

        do_search(
          grid,
          new_queue,
          new_visited,
          area + 1,
          perimeter + find_perimeter(grid, {row, col})
        )
    end
  end

  defp find_perimeter(grid, {row, col}) do
    Enum.count(cardinal({row, col}), fn {drow, dcol} ->
      inbounds(grid, {drow, dcol}) == false || matches(grid, {row, col}, {drow, dcol}) == false
    end)
  end

  defp inbounds(grid, {row, col}) do
    row >= 0 && row < length(grid) && col >= 0 && col < length(Enum.at(grid, row))
  end

  defp matches(grid, {r, c}, {dr, dc}) do
    Enum.at(Enum.at(grid, r), c) == Enum.at(Enum.at(grid, dr), dc)
  end
end

# examples
"
AAAA
BBCD
BBCC
EEEC
" |> String.trim() |> Part1.total_price() |> IO.inspect(label: "total")

"
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
" |> String.trim() |> Part1.total_price() |> IO.inspect(label: "total")

"
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
" |> String.trim() |> Part1.total_price() |> IO.inspect(label: "total")

case File.read("input.txt") do
  {:ok, c} -> c
end
|> String.trim()
|> Part1.total_price()
|> IO.inspect(label: "total")
