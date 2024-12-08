defmodule Part2 do
  def graphemes(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)
  end

  def extend(grid, extra) do
    grid = grid |> Enum.map(fn row -> row ++ for _ <- 0..(extra-1), do: "." end)
    cols = length(Enum.at(grid, 0))
    grid ++ for _ <- 0..(extra-1), do: for(_ <- 0..(cols-1), do: ".")
  end

  def create(input), do: input |> graphemes() |> extend(3)

  def patterns do
    [
      fn [
        ["M", _,"S"],
        [ _,"A",  _],
        ["M", _,"S"],
      ] -> true; _ -> false end,
      fn [
        ["M", _, "M"],
        [_, "A",   _],
        ["S", _, "S"],
      ] -> true; _ -> false end,
      fn [
        ["S", _, "M"],
        [_, "A",   _],
        ["S", _, "M"],
      ] -> true; _ -> false end,
      fn [
        ["S", _, "S"],
        [_, "A",   _],
        ["M", _, "M"],
      ] -> true; _ -> false end
    ]
  end

  def matches (subgrid) do
    Enum.filter(patterns(), fn matcher -> matcher.(subgrid) end)
    |> Enum.count()
  end

  def search(grid) do
    for row <- 0..length(grid) do
      for col <- 0..length(Enum.at(grid, 0)) do
        grid
        |> Enum.slice(row..(row + 2))
        |> Enum.map(&Enum.slice(&1, col..(col + 2)))
      end
    end
    |> Enum.concat()
    |> Enum.reduce(0, fn subgrid, total -> matches(subgrid) + total end)
  end
end

"
M.M
.A.
S.S
" |> Part2.create() |> Part2.search() |> IO.inspect(label: "test")

case File.read("example.txt") do
  {:ok, content} -> content
end
|> Part2.create() |> Part2.search() |> IO.inspect(label: "example")


case File.read("input.txt") do
  {:ok, content} -> content
end
|> Part2.create() |> Part2.search() |> IO.inspect(label: "input")
