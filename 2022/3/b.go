package main 

import (
    "os"
    "bufio"
    "fmt"
)

func b() {
    fmt.Println('a')
    fmt.Println('A')

    f, err := os.Open("input.txt")
    if err != nil {
        panic(err)
    }
    scanner := bufio.NewScanner(f)

    var total int
    more := true
    for more {
        rucksacks := []string{}

        for i := 0; i< 3; i++ {
            has := scanner.Scan()
            if !has {
                more = false
                break
            }
            rucksack := scanner.Text()
            rucksacks = append(rucksacks, rucksack)
        }

        if !more {
            break
        }

        one, two := make(map[byte]bool), make(map[byte]bool)

        for i := range rucksacks[0] {
            one[rucksacks[0][i]] = true
        }

        for i := range rucksacks[1] {
            if one[rucksacks[1][i]] {
                two[rucksacks[1][i]] = true 
            }
        }

        var b byte
        for i := range rucksacks[2] {
            if two[rucksacks[2][i]] {
                b = rucksacks[2][i]
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



