defmodule Matrix do
  def create(content) do
    content |> String.split("\n", trim: true) |> Enum.map(&String.graphemes/1)
  end

  def extend(matrix, extra) do
    matrix = matrix |> Enum.map(fn row -> row ++ for _ <- 0..extra, do: "." end)
    cols = length(Enum.at(matrix, 0))
    matrix ++ for _ <- 0..extra, do: for(_ <- 0..(cols - 1), do: ".")
  end

  def patterns do
    [
      fn
        [["X", _, _, _], [_, "M", _, _], [_, _, "A", _], [_, _, _, "S"]] -> true
        _ -> false
      end,
      fn
        [["S", _, _, _], [_, "A", _, _], [_, _, "M", _], [_, _, _, "X"]] -> true
        _ -> false
      end,
      fn
        [[_, _, _, "X"], [_, _, "M", _], [_, "A", _, _], ["S", _, _, _]] -> true
        _ -> false
      end,
      fn
        [[_, _, _, "S"], [_, _, "A", _], [_, "M", _, _], ["X", _, _, _]] -> true
        _ -> false
      end,
      fn
        [["X", "M", "A", "S"], [_, _, _, _], [_, _, _, _], [_, _, _, _]] -> true
        _ -> false
      end,
      fn
        [["S", "A", "M", "X"], [_, _, _, _], [_, _, _, _], [_, _, _, _]] -> true
        _ -> false
      end,
      fn
        [["X", _, _, _], ["M", _, _, _], ["A", _, _, _], ["S", _, _, _]] -> true
        _ -> false
      end,
      fn
        [["S", _, _, _], ["A", _, _, _], ["M", _, _, _], ["X", _, _, _]] -> true
        _ -> false
      end
    ]
  end

  def matrix(input) do
    input |> create() |> extend(2)
  end

  def search(matrix) do
    for row <- 0..length(matrix) do
      for col <- 0..length(Enum.at(matrix, 0)) do
        matrix
        |> Enum.slice(row..(row + 3))
        |> Enum.map(&Enum.slice(&1, col..(col + 3)))
      end
    end
    |> Enum.concat()
    |> Enum.reduce(0, fn subgrid, total ->
      Enum.filter(patterns(), fn m -> m.(subgrid) end)
      |> Enum.count()
      |> (fn count -> count + total end).()
    end)
  end
end

case File.read("input.txt") do
  {:ok, content} -> content
end
|> Matrix.matrix()
|> Matrix.search()
|> IO.inspect(label: "count")

# result 8
_example1 =
  "
S..S..S
.A.A.A.
..MMM..
SAMXMAS
..MMM..
.A.A.A.
S..S..S" |> String.trim()

# result 8
_example2 =
  "
X..X..X
.M.M.M.
..AAA..
XMASAMX
..AAA..
.M.M.M.
X..X..X" |> String.trim()

# result 4
_example3 =
  "
XMAS
M..A
A..M
SAMX" |> String.trim()

# result 2
_example4 =
  "
X...
XMAS
..A.
...S" |> String.trim()

# result 2
_example5 =
  "
X...
XMAS
..A.
...S" |> String.trim()

# result 3
_example6 =
  "
XX..
XMAS
.AA.
.S.S" |> String.trim()

# result 2
_example7 =
  "
X.X.
.MM.
..A.
..SS" |> String.trim()

# result 2
_example8 =
  "
S..S
.AA.
.MM.
X..X" |> String.trim()
