filename = "input.txt"

dir = fn integers ->
  case integers do
    [first, second | _] ->
      cond do
        first > second -> :desc
        first < second -> :asc
        true -> :error
      end

    _ ->
      :error
  end
end

dists = fn integers ->
  integers
  |> Enum.with_index()
  |> Enum.map(fn {val, i} ->
    if i == 0 do
      0
    else
      val - Enum.at(integers, i - 1)
    end
  end)
  |> List.delete_at(0)
end

is_safe_asc = fn list ->
  is_nil(Enum.find(list, nil, fn x -> x < 1 || x > 3 end))
end

is_safe_desc = fn list ->
  is_nil(Enum.find(list, nil, fn x -> x < -3 || x > -1 end))
end

ints = fn row ->
  String.split(row)
  |> Enum.map(fn x -> String.to_integer(x) end)
end

count =
  File.stream!(filename)
  |> Enum.filter(fn row ->
    integers = ints.(row)

    case dir.(integers) do
      :asc -> integers |> dists.() |> is_safe_asc.()
      :desc -> integers |> dists.() |> is_safe_desc.()
      :error -> false
    end
  end)
  |> Enum.count()

IO.puts("Safe Reports:")
IO.puts(count)
