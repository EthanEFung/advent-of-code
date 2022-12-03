package main

import (
	"bufio"
	"fmt"
	"os"
)

func a() {
	fmt.Println('a')
	fmt.Println('A')

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(f)

	var total int
	for scanner.Scan() {
		rucksack := scanner.Text()

		m := len(rucksack) / 2

		one := make(map[byte]bool)

		for i := 0; i < m; i++ {
			one[rucksack[i]] = true
		}

		var b byte
		for i := m; i < len(rucksack); i++ {
			if one[rucksack[i]] {
				b = rucksack[i]
				break
			}
		}
		if b >= 'a' {
			total += int(b) - 97 + 1
		} else if b >= 'A' {
			total += int(b) - 65 + 27
		}
	}
	fmt.Println("total", total)
}
