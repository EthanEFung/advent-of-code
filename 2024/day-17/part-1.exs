defmodule Part1 do
  def parse(str) do
    [registers, program] = String.split(str, "\n\n")

    {
      registers
      |> String.split("\n")
      |> Enum.map(fn reg -> Regex.run(~r/\d+/, reg) end)
      |> Enum.concat()
      |> Enum.map(&String.to_integer/1),
      Regex.scan(~r/\d+/, program) |> Enum.concat() |> Enum.map(&String.to_integer/1)
    }
  end

  def run({registers, program}) do
    step(program, 0, registers, [])
  end

  defp step(program, pointer, _, out) when pointer >= length(program) do
    Enum.reverse(out) |> Enum.join(",")
  end

  defp step(program, pointer, [a, b, c] = registers, out) do
    opcode = Enum.at(program, pointer)
    literal = Enum.at(program, pointer + 1)

    case exec(opcode, literal, registers) do
      {:adv, result} -> step(program, pointer + 2, [result, b, c], out)
      {:bxl, result} -> step(program, pointer + 2, [a, result, c], out)
      {:bst, result} -> step(program, pointer + 2, [a, result, c], out)
      {:jnz, :none} -> step(program, pointer + 2, registers, out)
      {:jnz, result} -> step(program, result, registers, out)
      {:bxc, result} -> step(program, pointer + 2, [a, result, c], out)
      {:out, result} -> step(program, pointer + 2, registers, [result | out])
      {:bdv, result} -> step(program, pointer + 2, [a, result, c], out)
      {:cdv, result} -> step(program, pointer + 2, [a, b, result], out)
    end
  end

  defp combo(op, [a, b, c]) do
    case op do
      4 -> a
      5 -> b
      6 -> c
      _ -> op
    end
  end

  defp exec(0, op, [a, _, _] = registers) do
    denominator = Integer.pow(2, combo(op, registers))
    {:adv, Integer.floor_div(a, denominator)}
  end

  defp exec(1, op, [_, b, _]) do
    {:bxl, Bitwise.bxor(b, op)}
  end

  defp exec(2, op, registers) do
    {:bst, rem(combo(op, registers), 8)}
  end

  defp exec(3, op, [a, _, _]) do
    {:jnz,
     case a do
       0 -> :none
       _ -> op
     end}
  end

  defp exec(4, _, [_, b, c]) do
    {:bxc, Bitwise.bxor(b, c)}
  end

  defp exec(5, op, registers) do
    # if the program outputs multiple values they are seperated by commas COME BACK TO THIS
    {:out, rem(combo(op, registers), 8)}
  end

  defp exec(6, op, [a, _, _] = registers) do
    denominator = Integer.pow(2, combo(op, registers))
    {:bdv, Integer.floor_div(a, denominator)}
  end

  defp exec(7, op, [a, _, _] = registers) do
    denominator = Integer.pow(2, combo(op, registers))
    {:cdv, Integer.floor_div(a, denominator)}
  end
end

# example
"Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
"
|> String.trim()
|> Part1.parse()
|> Part1.run()
|> IO.inspect()

case File.read("input.txt") do
  {:ok, c} -> c
end
|> String.trim()
|> Part1.parse()
|> Part1.run()
|> IO.inspect()
