package main

import (
	// "math"
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type coor struct {
	x, y int
}

type input struct {
	sensor coor
	beacon coor
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func l1Distance(x1, y1, x2, y2 int) int {
	return abs(x1-x2) + abs(y1-y2)
}

func tuningFreq(c coor) int {
	fmt.Println("coord", c)
	return (c.x * 4000000) + c.y
}

func partOne(inputs []input, row int) int {
	coordinates := make(map[coor]bool)
	for _, input := range inputs {
		s, b := input.sensor, input.beacon
		sx, sy, bx, by := s.x, s.y, b.x, b.y
		// now we find the manhatten distances to the beacon and to the row
		toBeacon := l1Distance(sx, sy, bx, by)
		toRow := l1Distance(sx, sy, sx, row)
		l1FromRowToB := toBeacon - toRow

		// first add the one point directly above or below the sensor on the row
		coordinates[coor{sx, row}] = true
		// now add all the coordinates that are before
		for i := 1; i <= l1FromRowToB; i++ {
			coordinates[coor{sx - i, row}] = true
		}
		// now add all the coordinates that are after
		for i := 1; i <= l1FromRowToB; i++ {
			coordinates[coor{sx + i, row}] = true
		}
		// don't count any beacons on the row
		if coordinates[input.beacon] {
			delete(coordinates, input.beacon)
		}
	}
	return len(coordinates)
}

func partTwo(inputs []input, outside int) int {
	distress := coor{}
	// for part two we have to create a beacon network
	// another way of potentially finding the missing beacon,
	// is by checking each coordinate on the perimeter of each beacon.
	// if the coordinate is not within the network we return this coordinate.

	// first lets calculate the manhattan distances for all sensors
	radiuses := make(map[coor]coor)
	distances := make(map[coor]int)
	for _, input := range inputs {
		sx, sy := input.sensor.x, input.sensor.y
		bx, by := input.beacon.x, input.beacon.y
		distances[input.sensor] = l1Distance(sx, sy, bx, by)
		radiuses[input.sensor] = input.beacon
	}

	// now for each sensor, lets check every point just outside of its manhattan
	// distance to the closest beacon to find whether that point has been accounted
	// for
	for sensor, dist := range distances {
		sx, sy := sensor.x, sensor.y - dist - 1
		if sx < 0 || sx > outside || sy < 0 || sy > outside {
			continue
		}
		for sy <= sensor.y {
			// here we'll double check to make sure the point is within
			var inRange bool
			for alt, altDist := range distances {
				if alt.x < 0 || alt.x > outside || alt.y < 0 || alt.y > outside {
					continue
				}
				if l1Distance(sx, sy, alt.x, alt.y) < altDist {
					inRange = true
					continue
				}
			}
			if !inRange {
				distress = coor{sx, sy}
				return tuningFreq(distress)
			}
			sy++
			sx++
		}  

		for sy <= sensor.y + dist + 1 {
			// here we'll double check to make sure the point is within
			var inRange bool
			for alt, altDist := range distances {
				if alt.x < 0 || alt.x > outside || alt.y < 0 || alt.y > outside {
					continue
				}
				if l1Distance(sx, sy, alt.x, alt.y) < altDist {
					inRange = true
					continue
				}
			}
			if !inRange {
				distress = coor{sx, sy}
				return tuningFreq(distress)
			}
			sy++
			sx--
		}  

		for sy >= sensor.y {
			// here we'll double check to make sure the point is within
			var inRange bool
			for alt, altDist := range distances {
				if alt.x < 0 || alt.x > outside || alt.y < 0 || alt.y > outside {
					continue
				}
				if l1Distance(sx, sy, alt.x, alt.y) < altDist {
					inRange = true
					continue
				}
			}
			if !inRange {
				distress = coor{sx, sy}
				return tuningFreq(distress)
			}
			sy--
			sx--
		}

		for sy >= sensor.y - dist - 1 {
			// here we'll double check to make sure the point is within
			var inRange bool
			for alt, altDist := range distances {
				if alt.x < 0 || alt.x > outside || alt.y < 0 || alt.y > outside {
					continue
				}
				if l1Distance(sx, sy, alt.x, alt.y) < altDist {
					inRange = true
					continue
				}
			}
			if !inRange {
				distress = coor{sx, sy}
				return tuningFreq(distress)
			}
			sy--
			sx++
		}

	}
	panic(fmt.Errorf("got to the end even though it shouldn't have"))
}

func parse(str string) input {
	strs := strings.Split(str, ":")
	a, b := strs[0], strs[1]
	ca, cb := strings.Split(a, " "), strings.Split(b, " ")
	ca, cb = ca[len(ca)-2:], cb[len(cb)-2:]
	ax, ay := strings.Trim(ca[0][2:], ","), ca[1][2:]
	bx, by := strings.Trim(cb[0][2:], ","), cb[1][2:]
	sx, err := strconv.Atoi(ax)
	if err != nil {
		panic(err)
	}
	sy, err := strconv.Atoi(ay)
	if err != nil {
		panic(err)
	}
	bex, err := strconv.Atoi(bx)
	if err != nil {
		panic(err)
	}
	bey, err := strconv.Atoi(by)
	if err != nil {
		panic(err)
	}
	sensor := coor{sx, sy}
	beacon := coor{bex, bey}
	return input{
		sensor: sensor,
		beacon: beacon,
	}
}

func main() {
	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(f)
	inputs := []input{}
	for scanner.Scan() {
		text := scanner.Text()
		inputs = append(inputs, parse(text))
	}
	fmt.Println("Part one:", partOne(inputs, 2000000))
	fmt.Println("Part two:", partTwo(inputs, 4000000))
}
