defmodule Part1 do
  def parse(str) do
    [towels_str, towel_pattern_str] =
      str
      |> String.trim()
      |> String.split("\n\n")

    [
      String.split(towels_str, ", "),
      String.split(towel_pattern_str, "\n")
    ]
  end

  def n_designs([towels, patterns]) do
    Enum.filter(patterns, fn pattern -> check(pattern, "", towels, []) end)
    |> Enum.count()
  end

  defp check(pattern, current, _, _) when pattern == current, do: true

  defp check(pattern, current, _, _) when length(pattern) <= length(current), do: false

  defp check(_, _, [], _), do: false

  defp check(pattern, current, [towel | towels] = unchecked, checked) do
    cond do
      String.starts_with?(pattern, current <> towel) ->
        check(pattern, current <> towel, unchecked ++ checked, []) or
          check(pattern, current, towels, [towel | checked])

      true ->
        check(pattern, current, towels, [towel | checked])
    end
  end
end

# example
"r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb"
|> Part1.parse()
|> Part1.n_designs()
|> IO.inspect(label: "example")

File.read!("input.txt")
|> Part1.parse()
|> Part1.n_designs()
|> IO.inspect(label: "count")
