package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type addX struct {
	delay, x int
}

func parse(str string) (string, int) {
	items := strings.Split(str, " ")
	if len(items) > 1 {
		x, err := strconv.Atoi(items[1])
		if err != nil {
			panic(err)
		}
		return items[0], x
	}
	return items[0], 0
}

func partOne(instructions []string) int {
	value := 1
	var sum int
	var i int
	queue := []addX{}

	for cycle := 1; cycle <= 220; cycle++ {
		if len(queue) == 0 {
			// event loop is ready for more instructions
			if i >= len(instructions) {
				break
			}
			action, y := parse(instructions[i])
			i++
			exec := addX{0, 0}
			if action == "addx" {
				exec = addX{1, y}
			}
			queue = append(queue, exec)
		}

		if (cycle-20)%40 == 0 {
			sum += value * cycle
		}

		if queue[0].delay == 0 {
			value += queue[0].x
			queue = queue[1:]
		} else {
			queue[0].delay--
		}
	}

	return sum
}

func partTwo(instructions []string) string {
	b := strings.Builder{}
	sprite := 1
	var i int
	queue := []addX{}

	for cycle := 1; cycle <= 240; cycle++ {
		if len(queue) == 0 {
			if i >= len(instructions) {
				break
			}
			action, y := parse(instructions[i])
			i++
			exec := addX{0, 0}
			if action == "addx" {
				exec = addX{1, y}
			}
			queue = append(queue, exec)
		}

		c := cycle % 40

		if sprite == c || sprite == c-1 || sprite == c-2 {
			b.WriteRune('#')
		} else {
			b.WriteRune('.')
		}

		if c == 0 {
			b.WriteRune('\n')
		}

		if queue[0].delay == 0 {
			sprite += queue[0].x
			queue = queue[1:]
		} else {
			queue[0].delay--
		}
	}

	return b.String()
}

func main() {
	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}

	scanner := bufio.NewScanner(f)
	lines := []string{}
	for scanner.Scan() {
		text := scanner.Text()
		lines = append(lines, text)
	}

	fmt.Println("part one:", partOne(lines))
	fmt.Printf("part two:\n%s", partTwo(lines))
}
