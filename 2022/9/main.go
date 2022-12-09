package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Knot struct {
	x, y int
	Next *Knot
}

func (h *Knot) Spring() Knot {
	up, down, left, right := h.Next.y+1, h.Next.y-1, h.Next.x-1, h.Next.x+1

	if h.y > up {
		if h.x > h.Next.x {
			return Knot{right, up, h.Next.Next}
		}
		if h.x < h.Next.x {
			return Knot{left, up, h.Next.Next}
		}

		return Knot{h.Next.x, up, h.Next.Next}
	}

	if h.y < down {
		if h.x > h.Next.x {
			return Knot{right, down, h.Next.Next}
		}
		if h.x < h.Next.x {
			return Knot{left, down, h.Next.Next}
		}
		return Knot{h.Next.x, down, h.Next.Next}
	}

	if h.x > right {
		if h.y > h.Next.y {
			return Knot{right, up, h.Next.Next}
		}
		if h.y < h.Next.y {
			return Knot{right, down, h.Next.Next}
		}
		return Knot{right, h.Next.y, h.Next.Next}
	}

	if h.x < left {
		if h.y > h.Next.y {
			return Knot{left, up, h.Next.Next}
		}
		if h.y < h.Next.y {
			return Knot{left, down, h.Next.Next}
		}
		return Knot{left, h.Next.y, h.Next.Next}
	}

	return *h.Next
}

func partOne(motions []string) int {
	// ...
	t := Knot{0, 0, nil}
	h := Knot{0, 0, &t}
	tails := make(map[Knot]bool)
	for _, m := range motions {
		input := strings.Split(m, " ")
		direction, amt := input[0], input[1]
		n, err := strconv.Atoi(amt)
		if err != nil {
			panic(err)
		}
		for i := 0; i < n; i++ {
			switch direction {
			case "U":
				h.y++
			case "R":
				h.x++
			case "L":
				h.x--
			case "D":
				h.y--
			}
			tail := h.Spring()
			tails[tail] = true
			h.Next = &tail
		}

	}

	return len(tails)
}
func partTwo(motions []string) int {
	rope := &Knot{0, 0, nil}
	curr := rope
	for i := 0; i < 9; i++ {
		curr.Next = &Knot{0, 0, nil}
		curr = curr.Next
	}
	tails := make(map[Knot]bool)
	for _, m := range motions {
		input := strings.Split(m, " ")
		direction, amt := input[0], input[1]
		n, err := strconv.Atoi(amt)
		if err != nil {
			panic(err)
		}
		for i := 0; i < n; i++ {
			switch direction {
			case "U":
				rope.y++
			case "R":
				rope.x++
			case "L":
				rope.x--
			case "D":
				rope.y--
			}

			curr := rope
			for ; curr.Next != nil; curr = curr.Next {
				tail := curr.Spring()
				curr.Next = &tail
			}

			tails[*curr] = true
		}

	}

	return len(tails)
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

	fmt.Println("Part one:", partOne(lines))
	fmt.Println("Part two:", partTwo(lines))
}
