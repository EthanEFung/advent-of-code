package main

import (
	"bufio"
	"fmt"
	"os"
)

func partOne(grid [][]int) int {
	edges := 2 * (len(grid) + len(grid[0]) - 2)

	var inner int
	for i := 1; i < len(grid)-1; i++ {
		for j := 1; j < len(grid[i])-1; j++ {
			inner += visible(i, j, grid)
		}
	}

	return inner + edges
}

// returns 1 if the tree is visible within the grid
func visible(i, j int, grid [][]int) int {
	// top
	visible := true
	for k := i - 1; k >= 0; k-- {
		if grid[k][j] >= grid[i][j] {
			visible = false
			break
		}
	}
	if visible {
		return 1
	}

	// right
	visible = true
	for k := j + 1; k < len(grid[i]); k++ {
		if grid[i][k] >= grid[i][j] {
			visible = false
			break
		}
	}
	if visible {
		return 1
	}

	// down
	visible = true
	for k := i + 1; k < len(grid); k++ {
		if grid[k][j] >= grid[i][j] {
			visible = false
			break
		}
	}
	if visible {
		return 1
	}

	// left
	visible = true
	for k := j - 1; k >= 0; k-- {
		if grid[i][k] >= grid[i][j] {
			visible = false
			break
		}
	}
	if visible {
		return 1
	}

	return 0
}

func partTwo(grid [][]int) int {
	var best int
	for i := 0; i < len(grid); i++ {
		for j := 0; j < len(grid[i]); j++ {
			s := score(i, j, grid)
			if s > best {
				best = s
			}
		}
	}
	return best
}

func score(i, j int, grid [][]int) int {
	// top
	var top int
	for k := i - 1; k >= 0; k-- {
		top++

		if grid[k][j] >= grid[i][j] {
			break
		}
	}
	if top == 0 {
		top++
	}

	// right
	var right int
	for k := j + 1; k < len(grid[i]); k++ {
		right++
		if grid[i][k] >= grid[i][j] {
			break
		}
	}
	if right == 0 {
		right++
	}

	// down
	var down int
	for k := i + 1; k < len(grid); k++ {
		down++
		if grid[k][j] >= grid[i][j] {
			break
		}
	}
	if down == 0 {
		down++
	}

	// left
	var left int
	for k := j - 1; k >= 0; k-- {
		left++
		if grid[i][k] >= grid[i][j] {
			break
		}
	}
	if left == 0 {
		left++
	}

	return top * left * down * right
}

func main() {
	grid := [][]int{}

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(f)

	for scanner.Scan() {
		line := scanner.Text()
		grid = append(grid, []int{})
		j := len(grid) - 1

		for _, r := range line {
			grid[j] = append(grid[j], int(r-'0'))
		}
	}

	fmt.Println("Part one:", partOne(grid))
	fmt.Println("Part two:", partTwo(grid))
}
