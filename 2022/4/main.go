package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"
    "strconv"
)

func a(scanner *bufio.Scanner) {
    var n int

    for scanner.Scan() {
        line := scanner.Text()

        ranges := strings.Split(line, ",")
        a, b := ranges[0], ranges[1]

        numsA := strings.Split(a, "-")
        numsB := strings.Split(b, "-")
        
        ax, ay := numsA[0], numsA[1]
        bx, by := numsB[0], numsB[1]

        a1, _ := strconv.Atoi(ax)
        a2, _ := strconv.Atoi(ay)
        b1, _ := strconv.Atoi(bx)
        b2, _ := strconv.Atoi(by)

        if a1 >= b1 && a2 <= b2 {
            n++
        } else if b1 >= a1 && b2 <= a2 {
            n++
        }
    }
    
    fmt.Println("n pairs: ", n)
}

func b(scanner *bufio.Scanner) {
    var n int

    for scanner.Scan() {
        line := scanner.Text()

        ranges := strings.Split(line, ",")
        a, b := ranges[0], ranges[1]

        numsA := strings.Split(a, "-")
        numsB := strings.Split(b, "-")
        
        ax, ay := numsA[0], numsA[1]
        bx, by := numsB[0], numsB[1]

        a1, _ := strconv.Atoi(ax)
        a2, _ := strconv.Atoi(ay)
        b1, _ := strconv.Atoi(bx)
        b2, _ := strconv.Atoi(by)

        if a1 >= b1 && a1 <= b2 {
            n++
        } else if a2 >= b1 && a2 <= b2 {
            n++
        } else if b1 >= a1 && b1 <= a2 {
            n++
        } else if b2 >= a1 && b2 <= a2 {
            n++
        }
    }
    
    fmt.Println("n pairs: ", n)
}

func main() {
    f, err := os.Open("input.txt")
    if err != nil {
        panic(err)
    }

    scanner := bufio.NewScanner(f)
    // a(scanner)
    b(scanner)
}
