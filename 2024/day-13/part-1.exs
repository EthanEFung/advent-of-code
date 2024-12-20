defmodule Part1 do
  def parse(str) do
    String.split(str, "\n\n")
    |> Enum.map(&parse_machine_state/1)
  end

  def cheapest_solve(%{:a => {ax, ay}, :b => {bx, by}, :prize => {px, py}}) do
    for b_token <- 1..100,
        a_token <- 1..100 do
      {a_token, b_token}
    end
    |> Enum.filter(fn {a_token, b_token} ->
      {px, py} == {a_token * ax + b_token * bx, a_token * ay + b_token * by}
    end)
    |> Enum.reduce(100 + 300 + 1, fn {a_token, b_token}, least ->
      cond do
        a_token * 3 + b_token < least -> a_token * 3 + b_token
        true -> least
      end
    end)
  end

  def total_spent(tokens) do
    Enum.filter(tokens, fn cost -> cost < 401 end) |> Enum.sum()
  end

  defp parse_machine_state(state) do
    [[ax, ay], [bx, by], [px, py]] =
      String.split(state, "\n")
      |> Enum.map(&get_int_values/1)

    %{
      a: {ax, ay},
      b: {bx, by},
      prize: {px, py}
    }
  end

  # use some regex to grab the numbers and parse them into integers
  defp get_int_values(str) do
    Regex.scan(~r/\d+/, str) |> Enum.concat() |> Enum.map(&String.to_integer/1)
  end
end

"
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
"
|> String.trim()
|> Part1.parse()
|> IO.inspect()
|> Enum.map(&Part1.cheapest_solve/1)
|> Part1.total_spent()
|> IO.inspect()

case File.read("input.txt") do
  {:ok, c} -> c |> String.trim()
end
|> Part1.parse()
|> Enum.map(&Part1.cheapest_solve/1)
|> Part1.total_spent()
|> IO.inspect(label: "spent")
