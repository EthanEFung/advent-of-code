defmodule Part1 do
  def sum(input) do
    {warehouse, instructions} = parse(input)
    final = execute(warehouse, instructions, robot_indices(warehouse))

    for row <- 0..(length(final) - 1),
        col <- 0..(length(Enum.at(final, row)) - 1),
        val(final, {row, col}) == "O" do
      100 * row + col
    end
    |> Enum.sum()
  end

  defp parse(str) do
    [warehouse_str, dirs_str] = String.split(str, "\n\n")
    {warehouse(warehouse_str), instructions(dirs_str)}
  end

  defp warehouse(str) do
    String.split(str, "\n") |> Enum.map(&String.graphemes/1)
  end

  defp instructions(str) do
    String.replace(str, "\n", "") |> String.graphemes()
  end

  defp is_robot(char), do: char == "@"

  defp val(grid, {row, col}), do: Enum.at(Enum.at(grid, row), col)

  defp update(grid, {row, col}, value) do
    List.update_at(grid, row, fn r -> List.update_at(r, col, fn _ -> value end) end)
  end

  defp shift(grid, from, to) do
    to_val = val(grid, to)
    update(grid, to, val(grid, from)) |> update(from, to_val)
  end

  defp robot_indices(grid) do
    row_index = Enum.find_index(grid, fn row -> Enum.find_index(row, &is_robot/1) != nil end)
    col_index = Enum.at(grid, row_index) |> Enum.find_index(&is_robot/1)
    {row_index, col_index}
  end

  defp execute(warehouse, [], {_, _}), do: warehouse

  defp execute(warehouse, [first | instructions], {row, col}) do
    velocity =
      case first do
        "^" ->
          {-1, 0}

        ">" ->
          {0, 1}

        "v" ->
          {1, 0}

        "<" ->
          {0, -1}
      end

    {vr, vc} = velocity

    case move(warehouse, {row, col}, velocity) do
      {:ok, new_warehouse} ->
        execute(new_warehouse, instructions, {row + vr, col + vc})

      :noop ->
        execute(warehouse, instructions, {row, col})
    end
  end

  defp move(warehouse, {row, col}, {vel_r, vel_c}) do
    next = {row + vel_r, col + vel_c}

    case val(warehouse, next) do
      "#" ->
        :noop

      "." ->
        {:ok, shift(warehouse, {row, col}, next)}

      "O" ->
        case move(warehouse, next, {vel_r, vel_c}) do
          :noop ->
            :noop

          {:ok, new_warehouse} ->
            {:ok, shift(new_warehouse, next, {row, col})}
        end
    end
  end
end

# small example
"
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
"
|> String.trim()
|> Part1.sum()
|> IO.inspect(label: "small")

# large example
"
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
"
|> String.trim()
|> Part1.sum()
|> IO.inspect(label: "large")

case File.read("input.txt") do
  {:ok, c} -> c
end
|> String.trim()
|> Part1.sum()
|> IO.inspect(label: "input")
