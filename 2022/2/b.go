package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    f, err := os.Open("./input.txt")
    if err != nil {
        panic(err)
    }

    scanner := bufio.NewScanner(f)

    outcomes := make(map[byte]map[byte]int)
    outcomes['A'] = make(map[byte]int)
    outcomes['B'] = make(map[byte]int)
    outcomes['C'] = make(map[byte]int)

    outcomes['A']['X'] = 3 + 0
    outcomes['A']['Y'] = 1 + 3
    outcomes['A']['Z'] = 2 + 6

    outcomes['B']['X'] = 1 + 0
    outcomes['B']['Y'] = 2 + 3
    outcomes['B']['Z'] = 3 + 6

    outcomes['C']['X'] = 2 + 0
    outcomes['C']['Y'] = 3 + 3
    outcomes['C']['Z'] = 1 + 6

    var total int
    for scanner.Scan() {
        text := scanner.Text()
        op, you := text[0], text[2]
        total += outcomes[op][you]
    }
    fmt.Println("total:", total)
}
