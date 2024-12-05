filename = "input.txt"

right_list = File.stream!(filename)
  |> Enum.map(fn(str) ->
    str
    |> String.split
    |> List.last
    |> String.to_integer
  end)

freq = Enum.reduce(right_list, %{}, fn(x, acc) ->
  Map.update(acc, x, 1, fn curr -> curr + 1 end)
end)

left_list = File.stream!(filename)
  |> Enum.map(fn(str) -> str |> String.split |> List.first |> String.to_integer end)

scores = left_list
  |> Enum.map(fn(x) ->
    case Map.fetch(freq, x) do
      {:ok, count} -> x * count
      :error -> 0
    end
  end)

sum = Enum.reduce(scores, fn(x, sum) -> sum + x end)

IO.puts("Similarity Score")
IO.puts(sum)
