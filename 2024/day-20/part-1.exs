defmodule Part1 do
  def parse(str) do
    grid = str |> String.trim() |> String.split("\n") |> Enum.map(&String.graphemes/1)
    start = indices(grid, "S")
    finish = indices(grid, "E")
    {grid, start, finish}
  end

  def n_cheats({grid, start, finish}, perform) do
    {route, dist_grid} = distances(grid, start, finish)
    optimal = find_optimal(route, dist_grid, 0, [])
    Enum.count(optimal, fn saving -> saving >= perform end)
  end

  defp indices(grid, val) do
    row = Enum.find_index(grid, fn r -> Enum.find(r, fn v -> v == val end) end)
    {row, Enum.find_index(Enum.at(grid, row), fn v -> v == val end)}
  end

  defp value(grid, {row, col}), do: Enum.at(Enum.at(grid, row), col)

  defp update_at(grid, {row, col}, val) do
    List.update_at(grid, row, fn r -> List.update_at(r, col, fn _ -> val end) end)
  end

  defp distances(grid, start, finish) do
    dist_grid =
      for r <- 0..(length(grid) - 1) do
        for _ <- 0..(length(Enum.at(grid, r)) - 1) do
          nil
        end
      end

    route = path(grid, start, finish, [], MapSet.new())

    {_, dist_grid} =
      Enum.reduce(route, {1, dist_grid}, fn coor, {d, g} ->
        {d + 1, update_at(g, coor, d)}
      end)

    {
      Enum.reverse(route),
      dist_grid
    }
  end

  defp cardinal(grid, {row, col}, dist) do
    [
      {row - dist, col},
      {row, col + dist},
      {row + dist, col},
      {row, col - dist}
    ]
    |> Enum.filter(fn {dr, dc} ->
      dr >= 0 && dr < length(grid) && dc >= 0 && dc < length(Enum.at(grid, dr))
    end)
  end

  defp path(_, curr, finish, path, _) when curr == finish, do: [curr | path]

  defp path(grid, curr, finish, path, visited) do
    next =
      cardinal(grid, curr, 1)
      |> Enum.find(fn delta ->
        MapSet.member?(visited, delta) == false && value(grid, delta) != "#"
      end)

    path(grid, next, finish, [curr | path], MapSet.put(visited, curr))
  end

  defp find_optimal([], _, _, total), do: total

  defp find_optimal([coor | route], dist_grid, steps, list) do
    val = value(dist_grid, coor)

    new_list =
      Enum.filter(cardinal(dist_grid, coor, 2), fn dcoor ->
        dval = value(dist_grid, dcoor)
        dval != nil && dval < val
      end)
      |> Enum.map(fn dcoor ->
        value(dist_grid, coor) - value(dist_grid, dcoor) - 2
      end)
      |> Enum.concat(list)

    find_optimal(route, dist_grid, steps + 1, new_list)
  end
end

# example
"
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
"
|> Part1.parse()
|> Part1.n_cheats(20)

File.read!("input.txt")
|> Part1.parse()
|> Part1.n_cheats(100)
|> IO.inspect(label: "optimal")
