package main

import (
	"bufio"
	"fmt"
	"io"
	"math/big"
	"os"
	"strconv"
	"strings"
)

type op int

const (
	multiply op = iota
	divide
	subtract
	add
)

type monkey struct {
	items   []*big.Int
	op      op
	divisor *big.Int
	x       *big.Int
	y       *big.Int
	monkeyA int
	monkeyB int
	n       int
}

func New() *monkey {
	return new(monkey)
}

func (m *monkey) operation(old *big.Int) *big.Int {
	m.n++
	x, y := old, old

	if m.x != nil {
		x = m.x
	}
	if m.y != nil {
		y = m.y
	}

	z := new(big.Int)

	switch m.op {
	case add:
		return z.Add(x, y)
	case subtract:
		return z.Sub(x, y)
	case multiply:
		return z.Mul(x, y)
	case divide:
		return z.Div(x, y)

	default:
		panic("unknown operation")
	}
}

func (m *monkey) test(val *big.Int) int {
    z := new(big.Int)
	if z.Mod(val, m.divisor).Int64() == 0 {
		return m.monkeyA
	} else {
		return m.monkeyB
	}
}

func (m *monkey) addItem(item *big.Int) {
	m.items = append(m.items, item)
}

func (m *monkey) setOp(op op) {
	m.op = op
}

func (m *monkey) setDivisor(divisor *big.Int) {
	m.divisor = divisor
}

func (m *monkey) setTruthy(passTo int) {
	m.monkeyA = passTo
}

func (m *monkey) setFalsey(passTo int) {
	m.monkeyB = passTo
}

func parseInputs(f io.Reader) []*monkey {
	scanner := bufio.NewScanner(f)
	monkeys := []*monkey{}
	var m *monkey

	for scanner.Scan() {
		input := scanner.Text()
		input = strings.TrimSpace(input)
		line := strings.Split(input, " ")

		if input == "" {
			continue
		} else if line[0] == "Monkey" {
			m = New()
			monkeys = append(monkeys, m)
		} else if line[0] == "Starting" {
			for i := 2; i < len(line); i++ {
				x := line[i]
				if x[len(x)-1] == ',' {
					x = x[:len(x)-1]
				}
				z := new(big.Int)
				item, success := z.SetString(x, 10)

				if !success || item == nil {
					panic("could not parse integer in starting")
				}
				m.addItem(item)
			}
		} else if line[0] == "Operation:" {
			x, op, y := line[3], line[4], line[5]

			if x != "old" {
				z := new(big.Int)
				num, success := z.SetString(x, 10)
				if !success || num == nil {
					panic("could not parse integer in operation")
				}
				m.x = num
			}
			if y != "old" {
				z := new(big.Int)
				num, success := z.SetString(y, 10)
				if !success || num == nil {
					panic("could not parse integer in operation")
				}
				m.y = num
			}
			switch op {
			case "*":
				m.op = multiply
			case "/":
				m.op = divide
			case "-":
				m.op = subtract
			case "+":
				m.op = add
			}
		} else if line[0] == "Test:" {
			z := new(big.Int)
			divisor, success := z.SetString(line[3], 10)
			if !success || divisor == nil {
				panic(success)
			}
			m.setDivisor(divisor)
		} else if line[1] == "true:" {
			monkeyA, err := strconv.Atoi(line[5])
			if err != nil {
				panic(err)
			}
			m.setTruthy(monkeyA)
		} else if line[1] == "false:" {
			monkeyB, err := strconv.Atoi(line[5])
			if err != nil {
				panic(err)
			}
			m.setFalsey(monkeyB)
		}
	}
	return monkeys
}


func partOne(monkeys []*monkey) {
    for i, monkey := range monkeys {
        fmt.Printf("monkey %d: ", i)
        for _, item := range monkey.items {
            fmt.Printf("%d,", item)
        }
        fmt.Println()
    }
	for round := 1; round <= 20; round++ {
		for _, monkey := range monkeys {
			n := len(monkey.items)
			for i := 0; i < n; i++ {
				item := monkey.items[0]
				monkey.items = monkey.items[1:]

				val := monkey.operation(item)

                z := new(big.Int)

				val = z.Div(val, big.NewInt(3))

				index := monkey.test(val)
				monkeys[index].items = append(monkeys[index].items, val)
			}
		}
		fmt.Println("Round", round)
		for i, monkey := range monkeys {
			fmt.Printf("monkey %d: ", i)
			for _, item := range monkey.items {
				fmt.Printf("%d,", item)
			}
			fmt.Println()
		}
	}

	for i, monkey := range monkeys {
		fmt.Printf("monkey %d: inspected %d items\n", i, monkey.n)
	}
}

func partTwo(monkeys []*monkey) {
    bigmod := big.NewInt(1)
    
    for _, monkey := range monkeys {
        bigmod = bigmod.Mul(bigmod, monkey.divisor)
    }
	for round := 1; round <= 10000; round++ {
		for _, monkey := range monkeys {
			n := len(monkey.items)
			for i := 0; i < n; i++ {
				item := monkey.items[0]
				monkey.items = monkey.items[1:]
				val := monkey.operation(item)

				index := monkey.test(val)

                z := new(big.Int)
                val = z.Mod(val, bigmod)
				monkeys[index].items = append(monkeys[index].items, val)
			}
		}
        if round == 1 || round == 20 || round%1000 == 0 {
			fmt.Println("Round", round)
			for i, monkey := range monkeys {
				fmt.Printf("monkey %d: inspected %d items\n", i, monkey.n)
			}
		}
	}
}

func main() {
	f, err := os.Open("_input.txt")
	if err != nil {
		panic(err)
	}

	inputs := parseInputs(f)
	// partOne(inputs)
	partTwo(inputs)
}
