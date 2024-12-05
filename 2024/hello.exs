# strings
IO.puts "String"

# variables
hello = "Variable"
IO.puts(hello)

# lists
nums = [1, 2, 3, 4, 5]
IO.puts(nums)

# maps
person = %{ "name" => "Ethan" }

# atoms
guy = %{ name: "atom value" }
IO.puts(guy.name)

# functions
greeting = fn name -> "Hello, #{name}" end
IO.puts(greeting.(person["name"]))
person = %{ "name" => "Frank" }
IO.puts(greeting.(person["name"]))

# capture groups
greeting = &("Hello, #{&1}")
IO.puts(greeting.("World"))

# pattern matching
%{name: name_of_person} = guy
IO.puts(name_of_person)

people = [
  %{name: "Izzy", age: 20, gender: "Female"},
  %{name: "Lizzy", age: 30, gender: "Female"},
  %{name: "Frizzy", age: 21, gender: "Male"},
  %{name: "Dizzy", age: 25, gender: "Female"},
]
[first, second | others] = people

greet_person = fn
  %{name: name} -> "Hey, #{name}"
  %{} -> "Hi what's your name?"
  _ -> "I don't know how to respond"
end

IO.puts greet_person.(first)
IO.puts greet_person.(second)
IO.puts greet_person.(%{age: 20})
IO.puts greet_person.(%{})
IO.puts greet_person.("somthing else")

# IO
# name = IO.gets "Whats your name?\n"
# IO.puts(greeting.(name))

# immutability
sentence = "normal sentence"
modified = String.replace(sentence, "normal", "not normal")
upcased_sentence = String.upcase(modified)
IO.puts(sentence)
IO.puts(modified)
IO.puts(upcased_sentence)

# working with lists
cities = ["vienna", "melbourne", "osaka", "calgary", "sydney"]
Enum.each(cities, &IO.puts/1)

cities = Enum.map(cities, &String.capitalize/1)
Enum.each(cities, &IO.puts/1)

numbers = [1,2,3,4,5]
doubled = Enum.map(numbers, fn (number) -> number * 2 end)
Enum.each(doubled, &IO.puts/1)
sum = Enum.reduce(doubled, fn(num, acc) -> num + acc end)
IO.puts(sum)

# working with maps
Enum.each(first, fn ({key, value}) -> IO.puts value end)

forecast = %{
  "Monday" => 28,
  "Tuesday" => 29,
  "Wednesday" => 29,
  "Thursday" => 24,
  "Friday" => 16,
  "Saturday" => 16,
  "Sunday" => 20,
}

fahr = Enum.map(forecast, fn ({day, temp}) -> {day, temp * 1.8 + 32} end)
fahr = Enum.into(fahr, %{})

# pipe
IO.puts "hello world" |> String.upcase() |> String.reverse()

forecast
|> Enum.map(fn ({day, c}) -> {day, c + 1.8 + 32} end)
|> Enum.into(%{})
|> IO.inspect

# TODO: make sure to go over the maps again:
# https://joyofelixir.com/10-maps/

# conditionals

## case
case File.read("joy/haiku.txt") do
  {:ok, contents} ->
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.reverse/1)
    |> Enum.join("\n")
    |> IO.puts
  {:error, :enoent} ->
    IO.puts "Could not find haiku.txt"
  {:error, _} ->
    IO.puts "Received an error, please try again"
  _ ->
    IO.puts "Something went wrong, please try again"
end

## cond
num = 40
cond do
  num < 50 -> IO.puts "Number is less than 50"
  num > 50 -> IO.puts "Number is greater than 50"
  num == 50 -> IO.puts "Number is 50"
end

## if else 
if num == 40 do
  IO.puts "Number is exactly 40"
else
  IO.puts "Not quite 40"
  end

## unless
unless num == 50 do
  IO.puts "Number is not 50"
  end

## with
file_data = %{name: "joy/haiku.txt"}
with {:ok, name} <- Map.fetch(file_data, :name),
     {:ok, contents} <- File.read(name) do
  contents
  |> String.split("\n", trim: true)
  |> Enum.map(&String.reverse/1)
  |> Enum.join("\n")
  |> IO.puts
else
  :error -> IO.puts ":name key missing in file_data"
  {:error, :enoent} -> IO.puts "Couldn't read file"
end
