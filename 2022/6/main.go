package main

import (
    "bufio"
    "fmt"
    "os"
)

func lines() []string {
    f, err := os.Open("input.txt")
    lines := []string{}
    if err != nil {
        panic(err)
    }
    scanner := bufio.NewScanner(f)
    
    for scanner.Scan() {
        text := scanner.Text()
        lines = append(lines, text)
    }

    return lines
}

func partOne(input string) int {
    m := make(map[byte]int)
    for i := range input {
        if i >= 4 {
            m[input[i-4]]--
        }
        m[input[i]]++
        var total int
        var noop bool
        for _, count := range m {
            if count > 1 {
                noop = true
                continue
            }
            total += count
        }
        if noop {
            continue
        }
        if total == 4 {
            return i+1 
        }
    }
    return -1
}

func partTwo(input string) int {
    m := make(map[byte]int)
    for i := range input {
        if i >= 14 {
            m[input[i-14]]--
        }
        m[input[i]]++

        var total int
        var noop bool
        for _, count := range m {
            if count > 1 {
                noop = true
                continue
            }
            total += count
        }
        if noop {
            continue
        }
        if total == 14 {
            return i+1 
        }
    }
    return -1
}

func main() {
    input := lines()
    fmt.Println(partOne(input[0]))
    fmt.Println(partTwo(input[0]))
}
