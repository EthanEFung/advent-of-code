package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Readables interface {
	Name() string
	Size() int
}

type Dir struct {
	name     string
	parent   *Dir
	children []Readables
}

func (d *Dir) Name() string {
	return d.name
}

func (d *Dir) Size() int {
	var total int
	for _, c := range d.children {
		total += c.Size()
	}
	return total
}

type File struct {
	name   string
	parent *Dir
	size   int
}

func (f *File) Name() string {
	return f.name
}

func (f *File) Size() int {
	return f.size
}

func partOne(root *Dir) int {
	var total int
	for _, child := range root.children {
		dir, ok := child.(*Dir)
		if ok {
			if dir.Size() <= 100000 {
				total += dir.Size()
			}
			total += partOne(dir)
		}
	}
	return total
}

func partTwo(root *Dir) int {
	totalFS := 70000000
    used := root.Size()
    unused := totalFS - used
	need := 30000000
    required := need - unused


	// lets just do a breadth first search
    queue := []*Dir{root}
	best := root.Size()

    for len(queue) > 0 {
        first := queue[0]
        queue = queue[1:]

        size := first.Size()

        if size < required {
            continue
        }

        if best > size {
            best = size
        }

        for _, child := range first.children {
            folder, ok := child.(*Dir)
            if ok {
                queue = append(queue, folder)
            }
        }
    }

	return best

}

func main() {
	f, err := os.Open("input.txt")

	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(f)
	root := &Dir{"/", nil, []Readables{}}
	curr := root

	for scanner.Scan() {
		line := scanner.Text()

		args := strings.Split(line, " ")

		if args[0] == "$" {
			if args[1] == "ls" {
				continue
			}
			// assume this must be a cd
			if args[2] == "/" {
				curr = root
			} else if args[2] == ".." {
				curr = curr.parent
			} else {
				// the assumption is that args 2 is the name of the folder
				for _, child := range curr.children {
					if child.Name() == args[2] {
						curr = child.(*Dir)
					}
				}
			}
			continue
		}
		// probably the output of ls
		if args[0] == "dir" {
			curr.children = append(curr.children, &Dir{
				name:     args[1],
				parent:   curr,
				children: []Readables{},
			})
			continue
		}
		// must be a file that was read by ls
		sInt, err := strconv.Atoi(args[0])
		if err != nil {
			panic(err)
		}

		curr.children = append(curr.children, &File{
			name:   args[1],
			parent: curr,
			size:   sInt,
		})
	}

	fmt.Println("Part one:", partOne(root))
    fmt.Println("Part two:", partTwo(root))
}
