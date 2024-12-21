defmodule Part1 do
  def parse(str) do
    String.split(str, "\n")
    |> Enum.map(&parse_robot/1)
  end

  def safety_factor(robots, {ax, ay} = area) do
    {mx, my} = {Integer.floor_div(ax, 2), Integer.floor_div(ay, 2)}

    Enum.map(robots, fn robot -> predict(robot, area, 1..100) end)
    |> Enum.reduce([0, 0, 0, 0], fn {{pos_x, pos_y}, _}, [q1, q2, q3, q4] ->
      cond do
        pos_x == mx || pos_y == my -> [q1, q2, q3, q4]
        pos_x < mx && pos_y < my -> [q1 + 1, q2, q3, q4]
        pos_x < mx -> [q1, q2 + 1, q3, q4]
        pos_y < my -> [q1, q2, q3 + 1, q4]
        true -> [q1, q2, q3, q4 + 1]
      end
    end)
    |> Enum.product()
  end

  defp parse_robot(str) do
    [px, py, vx, vy] =
      Regex.scan(~r/-*\d+/, str)
      |> Enum.concat()
      |> Enum.map(&String.to_integer/1)

    {{px, py}, {vx, vy}}
  end

  defp teleport({{pos_x, pos_y}, {vel_x, vel_y}}, {area_x, area_y}) do
    {delta_x, delta_y} = {pos_x + vel_x, pos_y + vel_y}

    delta_x =
      cond do
        delta_x < 0 ->
          delta_x + area_x

        delta_x >= area_x ->
          delta_x - area_x

        true ->
          delta_x
      end

    delta_y =
      cond do
        delta_y < 0 ->
          delta_y + area_y

        delta_y >= area_y ->
          delta_y - area_y

        true ->
          delta_y
      end

    {{delta_x, delta_y}, {vel_x, vel_y}}
  end

  defp predict(robot, area, steps) do
    Enum.reduce(steps, robot, fn _, prev -> teleport(prev, area) end)
  end
end

"p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"
|> String.trim()
|> Part1.parse()
|> Part1.safety_factor({11, 7})
|> IO.inspect(label: "example factor")

case File.read("input.txt") do
  {:ok, c} -> c
end
|> String.trim()
|> Part1.parse()
|> Part1.safety_factor({101, 103})
|> IO.inspect(label: "safety factor")
