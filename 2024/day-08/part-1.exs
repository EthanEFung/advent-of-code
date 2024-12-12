example = "
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
" |> String.trim()

input =
  case File.read("input.txt") do
    {:ok, c} -> c |> String.trim()
  end

defmodule Part1 do
  def diff({row_a, col_a}, {row_b, col_b}), do: {row_a - row_b, col_a - col_b}

  def antinode({row_a, col_a} = a, b) do
    {diff_row, diff_col} = diff(a, b)
    {row_a + diff_row, col_a + diff_col}
  end

  def within(grid, {row, col}) do
    row >= 0 && row < length(grid) && col >= 0 && col < length(Enum.at(grid, row))
  end

  def val(grid, {row, col}) do
    Enum.at(grid, row) |> Enum.at(col)
  end

  def graphemes(content) do
    String.split(content, "\n") |> Enum.map(&String.graphemes/1)
  end

  def antennas(grid) do
    {grid,
     for r <- 0..(length(grid) - 1),
         c <- 0..(length(Enum.at(grid, r)) - 1),
         val(grid, {r, c}) != "." do
       {val(grid, {r, c}), {r, c}}
     end
     |> Enum.group_by(
       fn {v, _} -> v end,
       fn {_, {r, c}} -> {r, c} end
     )}
  end

  def plot(grid, ants) do
    for a <- ants,
        b <- ants,
        a != b do
      antinode(a, b)
    end
    |> Enum.filter(&Part1.within(grid, &1))
  end

  def count_all({grid, map}) do
    Enum.map(map, fn {_, list} -> plot(grid, list) end)
    |> Enum.concat()
    |> Enum.uniq()
    |> Enum.count()
  end
end

input
|> Part1.graphemes()
|> Part1.antennas()
|> Part1.count_all()
|> IO.inspect(label: "# of antinodes")
