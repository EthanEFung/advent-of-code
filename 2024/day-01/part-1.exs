filename = "input.txt"

left_list = File.stream!(filename)
  |> Enum.map(fn(str) -> str |> String.split |> List.first |> String.to_integer end)
  |> Enum.sort

right_list = File.stream!(filename)
  |> Enum.map(fn(str) -> str |> String.split |> List.last |> String.to_integer end)
  |> Enum.sort

tuples = Enum.zip(left_list, right_list)

sum = Enum.reduce(tuples, 0, fn({x, y}, acc) -> abs(x - y) + acc end)

IO.puts("Total Distance")
IO.puts(sum)
