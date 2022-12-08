package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func a(stacks [][]byte, directions []string) {
	for _, stack := range stacks {
		fmt.Printf("%s", string(stack[len(stack)-1]))
	}
	fmt.Println()
	for _, dir := range directions {
		words := strings.Split(dir, " ")
		n, err := strconv.Atoi(words[1])
		if err != nil {
			panic(err)
		}
		from, err := strconv.Atoi(words[3])
		if err != nil {
			panic(err)
		}
		to, err := strconv.Atoi(words[len(words)-1])
		if err != nil {
			panic(err)
		}

		for i := 0; i < n; i++ {
			top := stacks[from-1][len(stacks[from-1])-1]
			stacks[from-1] = stacks[from-1][0 : len(stacks[from-1])-1]
			stacks[to-1] = append(stacks[to-1], top)
		}
	}

	// iterate to find the top of each stack

	for _, stack := range stacks {
		fmt.Printf("%s", string(stack[len(stack)-1]))
	}
	fmt.Println()
}

func b(stacks [][]byte, directions []string) {
	for _, stack := range stacks {
		fmt.Printf("%s", string(stack[len(stack)-1]))
	}
	fmt.Println()
	for _, dir := range directions {
		words := strings.Split(dir, " ")
		n, err := strconv.Atoi(words[1])
		if err != nil {
			panic(err)
		}
		from, err := strconv.Atoi(words[3])
		if err != nil {
			panic(err)
		}
		to, err := strconv.Atoi(words[len(words)-1])
		if err != nil {
			panic(err)
		}

		m := len(stacks[from-1]) - n
		if m < 0 {
			m = len(stacks[from-1])
		}
		sub := stacks[from-1][m:]
		stacks[from-1] = stacks[from-1][:m]
		stacks[to-1] = append(stacks[to-1], sub...)
	}

	// iterate to find the top of each stack

	for _, stack := range stacks {
		if len(stack) == 0 {
			continue
		}
		fmt.Printf("%s", string(stack[len(stack)-1]))
	}
	fmt.Println()
}

func main() {
	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}

	scanner := bufio.NewScanner(f)
	var rows []string
	for scanner.Scan() {
		text := scanner.Text()
		if text == "" {
			break
		}
		rows = append(rows, text)
	}
	for _, str := range rows {
		fmt.Println(str)
	}

	stacks := [][]byte{}

	lastRow := rows[len(rows)-1]

	for j := range lastRow {
		if lastRow[j] != ' ' {
			stack := []byte{}

			for i := len(rows) - 2; i >= 0; i-- {
				if rows[i][j] == ' ' {
					continue
				}
				stack = append(stack, rows[i][j])
			}
			stacks = append(stacks, stack)
		}
	}

	directions := []string{}
	for scanner.Scan() {
		text := scanner.Text()
		directions = append(directions, text)
	}

	// a(stacks, directions)
	b(stacks, directions)
}
