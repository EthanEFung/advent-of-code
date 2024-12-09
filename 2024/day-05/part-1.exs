# create a map of the rules
# for each integer create list of integers
# for each update
# create a set of seen integers
# check if the integer has a list of rules
# if there is a list of rules check
#   for each rule check if the integer is found in "seen"
#     if so, return false (breaks the rule)

input =
  case File.read("input.txt") do
    {:ok, content} -> content |> String.trim()
  end

example = "
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
  " |> String.trim()

defmodule Part1 do
  def to_integers(grid_of_strs) do
    grid_of_strs |> Enum.map(&String.to_integer/1)
  end

  def parse(content) do
    [rules, updates] = content |> String.split("\n\n")

    %{
      rules:
        rules
        |> String.split("\n")
        |> Enum.map(fn str -> String.split(str, "|") |> to_integers() end)
        |> Enum.reduce(
          %{},
          fn [key, val], map ->
            Map.update(map, key, [val], fn existing -> existing ++ [val] end)
          end
        ),
      updates:
        updates
        |> String.split("\n")
        |> Enum.map(fn update ->
          update |> String.split(",") |> to_integers()
        end)
    }
  end

  def count(%{:updates => updates, :rules => rules}) do
    updates
    |> Enum.reduce(0, fn update, sum ->
      center_index = div(length(update) - 1, 2)

      center = Enum.at(update, center_index)

      if valid(update, rules) do
        sum + center
      else
        sum
      end
    end)
  end

  def valid(update, rules) do
    {valid, _, _} =
      Enum.reduce(update, {true, MapSet.new(), rules}, fn page, {valid, seen, rules} ->
        case valid do
          false ->
            {valid, seen, rules}

          true ->
            case Map.fetch(rules, page) do
              {:ok, page_rules} ->
                if Enum.any?(page_rules, fn r -> MapSet.member?(seen, r) end) do
                  {false, seen, rules}
                else
                  {true, MapSet.put(seen, page), rules}
                end

              :error ->
                {valid, MapSet.put(seen, page), rules}
            end
        end
      end)

    valid
  end
end

input
|> Part1.parse()
|> Part1.count()
|> IO.inspect(label: "sum")
