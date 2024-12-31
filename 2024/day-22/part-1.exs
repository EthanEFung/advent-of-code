alias ExUnit.Assertions
Assertions

defmodule Part1 do
  def mix(secret, val), do: Bitwise.bxor(secret, val)

  def prune(secret), do: rem(secret, 16_777_216)

  def rand(secret) do
    mix(secret, secret * 64)
    |> prune()
    |> (&mix(&1, Integer.floor_div(&1, 32))).()
    |> prune()
    |> (&mix(&1, &1 * 2048)).()
    |> prune()
  end

  def gen_rand(secret, times) do
    Enum.reduce(times, secret, fn _, secret ->
      rand(secret)
    end)
  end

  def parse(lines) do
    String.trim(lines) |> String.split("\n") |> Enum.map(&String.to_integer/1)
  end

  def sum(lines) do
    parse(lines) |> Enum.map(&gen_rand(&1, 1..2000)) |> Enum.sum()
  end
end

# example
example =
  "
1
10
100
2024
"

Assertions.assert(Part1.mix(42, 15) == 37, "mix produces the correct value")
Assertions.assert(Part1.prune(100_000_000) == 16_113_920, "prune produces the correct value")
Assertions.assert(Part1.rand(123) == 15_887_950, "rand produces the correct value")
Assertions.assert(Part1.rand(15_887_950) == 16_495_136, "rand produces the correct value")
Assertions.assert(Part1.gen_rand(123, 1..10) == 5_908_254, "gen rand produces the correct value")
Assertions.assert(Part1.parse(example) == [1, 10, 100, 2024], "parse produces the correct value")
Assertions.assert(Part1.sum(example) == 37_327_623, "sum produces the correct value")

File.read!("input.txt")
|> Part1.sum()
|> IO.inspect(label: "sum")
