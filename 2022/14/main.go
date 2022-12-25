package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Grid struct {
	minX, minY int
	maxX, maxY int
	m          map[int]map[int]string
}

type coord struct {
	col, row int
}

func NewGrid() *Grid {
	return &Grid{m: make(map[int]map[int]string)}
}

func (g *Grid) Cell(col, row int) string {
	return g.m[row][col]
}

func (g *Grid) Set(col, row int, str string) {
	if _, has := g.m[row]; !has {
		g.m[row] = make(map[int]string)
	}
	g.m[row][col] = str
}

func (g *Grid) Draw() string {
	b := strings.Builder{}
	for i := 0; i <= g.maxY; i++ {
		for j := g.minX; j <= g.maxX; j++ {
			if _, has := g.m[i]; !has {
				b.WriteString(".")
				continue
			}
			if _, has := g.m[i][j]; !has {
				b.WriteString(".")
				continue
			}
			b.WriteString(g.m[i][j])
		}
		b.WriteString("\n")
	}
	return b.String()
}

func shouldFallDown(sand coord, g *Grid) bool {
	if _, has := g.m[sand.row+1]; !has {
		return true
	}
	str, has := g.m[sand.row+1][sand.col]
	if !has {
		return true
	}
	return str == "."
}

func shouldFallLeft(sand coord, g *Grid) bool {
	if _, has := g.m[sand.row+1]; !has {
		return true // is this a valid case?
	}
	str, has := g.m[sand.row+1][sand.col-1]
	if !has {
		return true
	}
	return str == "."
}
func shouldFallRight(sand coord, g *Grid) bool {
	if _, has := g.m[sand.row+1]; !has {
		return true // is this a valid case?
	}
	str, has := g.m[sand.row+1][sand.col+1]
	if !has {
		return true
	}
	return str == "."
}

func partOne(g *Grid) int {
	// fmt.Println(g)
	fmt.Println(g.minX, g.maxX)

	g.m[0] = make(map[int]string)
	g.m[0][500] = "+"
	// fmt.Println(g.Draw())
	active := coord{500, 0}
	var grainsAtRest int

	// we need to figure out how to model the condition to end the loop
	for active.row <= g.maxY {
		if shouldFallDown(active, g) {
			active.row++
		} else if shouldFallLeft(active, g) {
			active.row++
			active.col--
		} else if shouldFallRight(active, g) {
			active.row++
			active.col++
		} else { //  this means that there is no place for the sand to fall
			grainsAtRest++
			if _, has := g.m[active.row]; !has {
				g.m[active.row] = make(map[int]string)
			}
			g.m[active.row][active.col] = "o"
			active = coord{500, 0} // reset to source
			// fmt.Println(grainsAtRest, "grains of sand")
			// fmt.Println(g.Draw())
		}
	}
	// draw the new path
	active = coord{500, 0}
	for active.row <= g.maxY {
		if _, has := g.m[active.row]; !has {
			g.m[active.row] = make(map[int]string)
		}
		g.m[active.row][active.col] = "~"
		if shouldFallDown(active, g) {
			active.row++
		} else if shouldFallLeft(active, g) {
			active.row++
			active.col--
		} else if shouldFallRight(active, g) {
			active.row++
			active.col++
		} else { //  this means that there is no place for the sand to fall
			grainsAtRest++
			if _, has := g.m[active.row]; !has {
				g.m[active.row] = make(map[int]string)
			}
			g.m[active.row][active.col] = "o"
			active = coord{500, 0} // reset to source
			// fmt.Println(grainsAtRest, "grains of sand")
			// fmt.Println(g.Draw())
		}

	}

	fmt.Println(g.Draw())
	return grainsAtRest
}

func partTwo(grid *Grid) int {
	// first take the maxY and create logic that "draws" a floor 2 rows below it.
	lastRow := grid.maxY + 2
	
	active := coord{500, 0}
	grid.m[0] = make(map[int]string)
	grid.m[0][500] = "+"

	fmt.Println(grid.Draw())

	var grainsAtRest int
	for grid.m[0][500] != "o" {
		if active.row + 1 == lastRow {
			grainsAtRest++
			if _, has := grid.m[active.row]; !has {
				grid.m[active.row] = make(map[int]string)
			}
			grid.m[active.row][active.col] = "o"
			active = coord{500, 0} // reset to source
		} else if shouldFallDown(active, grid) {
			active.row++
		} else if shouldFallLeft(active, grid) {
			active.row++
			active.col--
			if active.col < grid.minX {
				grid.minX = active.col
			}
		} else if shouldFallRight(active, grid) {
			active.row++
			active.col++
			if active.col > grid.maxX {
				grid.maxX = active.col
			}
		} else {
			grainsAtRest++
			if _, has := grid.m[active.row]; !has {
				grid.m[active.row] = make(map[int]string)
			}
			grid.m[active.row][active.col] = "o"
			active = coord{500, 0} // reset to source
		}
		if active.row > grid.maxY {
			grid.maxY = active.row
		}
	}
	fmt.Println(grid.Draw())
	return grainsAtRest
}

func main() {
	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(f)

	grid := NewGrid()
	grid2 := NewGrid()	

	var c, r int
	for scanner.Scan() {
		text := scanner.Text()
		points := strings.Split(text, " -> ")
		for _, p := range points {
			point := strings.Split(p, ",")
			x, err := strconv.Atoi(point[0])
			if err != nil {
				panic(err)
			}
			y, err := strconv.Atoi(point[1])
			grid.Set(x, y, "#")
			grid2.Set(x, y, "#")
			if c == 0 && grid.minX == 0 || x < grid.minX {
				grid.minX = x
				grid2.minX = x
			}
			if r == 0 && grid.minY == 0 || y < grid.minY {
				grid.minY = y
				grid2.minY = y
			}
			if c == 0 && grid.maxX == 0 || x > grid.maxX {
				grid.maxX = x
				grid2.maxX = x
			}
			if r == 0 && grid.maxY == 0 || y > grid.maxY {
				grid.maxY = y
				grid2.maxY = y
			}
			if c == 0 && r == 0 {
				c, r = x, y
				continue
			}
			if x < c {
				for z := x + 1; z < c; z++ {
					grid.Set(z, y, "#")
					grid2.Set(z, y, "#")
				}
			} else if x > c {
				for z := x - 1; z > c; z-- {
					grid.Set(z, y, "#")
					grid2.Set(z, y, "#")
				}
			} else if y < r {
				for z := y + 1; z < r; z++ {
					grid.Set(x, z, "#")
					grid2.Set(x, z, "#")
				}
			} else if y > r {
				for z := y - 1; z > r; z-- {
					grid.Set(x, z, "#")
					grid2.Set(x, z, "#")
				}
			}
			c, r = x, y
		}
		c, r = 0, 0
	}

	fmt.Println("Part one:", partOne(grid))
	fmt.Println("Part two:", partTwo(grid2))
}
