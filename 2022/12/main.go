package main

import (
	"bufio"
	"fmt"
	"os"
)

type coor struct {
	r, c int
}

func New(r, c int) coor {
	return coor{r, c}
}

func partOne(rows []string) int {
	// find start
	var start coor
	var end coor

	// shortest paths to each cell
	paths := make(map[coor]int)

	for i := range rows {
		for j := range rows[i] {
			c := New(i, j)
			if rows[i][j] == 'S' {
				start = c
			}
			if rows[i][j] == 'E' {
				end = c
			}
		}
	}

	endRow := rows[end.r]
	rows[end.r] = endRow[:end.c] + "z" + endRow[end.c+1:]

	fmt.Printf("start: %v, end: %v\n", start, end)
	fmt.Printf("%s\n%s\n", endRow, rows[end.r])

	queue := []coor{start}

	for len(queue) > 0 {
		first := queue[0]
		queue = queue[1:]

		r, c := first.r, first.c
		dirs := []coor{
			{r + 1, c},
			{r, c + 1},
			{r - 1, c},
			{r, c - 1},
		}
		for _, dir := range dirs {
			ar, ac := dir.r, dir.c
			if ar < 0 || ar >= len(rows) {
				continue
			}
			if ac < 0 || ac >= len(rows[ar]) {
				continue
			}
			if rows[r][c] != 'S' && rows[ar][ac] > rows[r][c]+1 {
				continue
			}
			if paths[dir] != 0 {
				continue
			}
        
			paths[dir] = paths[first] + 1
			// fmt.Printf("adding path for %v, %d\n", dir, paths[first]+1)
			queue = append(queue, dir)
		}
	}
	return paths[end]
}

func partTwo(rows []string) int {
	/* the idea here is to start from the end, and find the quickest way downward */

	var trailEnd coor
    var bestStart coor
	paths := make(map[coor]int)

	for i := range rows {
		for j := range rows[i] {
			if rows[i][j] == 'E' {
				trailEnd = coor{i, j}
				rows[i] = rows[i][:j] + "z" + rows[i][j+1:]
			}
            if rows[i][j] == 'S' {
				rows[i] = rows[i][:j] + "a" + rows[i][j+1:]
            }
		}
	}

    fmt.Println("trail end", trailEnd)

	queue := []coor{trailEnd}
    
    for len(queue) > 0 {
        first := queue[0]
        queue = queue[1:]
        
        r, c := first.r, first.c
        if rows[r][c] == 'a' {
            bestStart = first
            
            break
        }
        dirs := []coor{
            {r+1, c},
            {r, c+1},
            {r-1, c},
            {r, c-1},
        }
        for _, dir := range dirs {
            ar, ac := dir.r, dir.c
			if ar < 0 || ar >= len(rows) {
				continue
			}
			if ac < 0 || ac >= len(rows[ar]) {
				continue
			}
            if paths[dir] != 0 {
				continue
			}
            if rows[r][c] > rows[ar][ac] + 1 {
                continue
            }
            paths[dir] = paths[first] + 1
            queue = append(queue, dir) 
        }
    }
    return paths[bestStart]
}

func main() {
	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(f)
	rows := []string{}
	for scanner.Scan() {
		rows = append(rows, scanner.Text())
	}

	// fmt.Println("part one:", partOne(rows))
	fmt.Println("part two:", partTwo(rows))

}
