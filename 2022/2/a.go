package main

import (
    "fmt"
    "bufio"
    "os"
)

/*
For example, suppose you were given the following strategy guide
A Y
B X
C Z

1. first round your opponent will choose Rock(A) and you
should choose Paper. This is a score of 8 (2 because you chose paper, and 6 because
you won
 
2. In the second round, your opponent will choose Paper (B), and you should choose
Rock (X) this ends in a loss with a score of 1 + 0

Hello, how are you? Now that you've spent a little bit of time to think about


A for Rock
B for Paper
C for Scissors

X for Rock (also worth 1 point)
Y for Paper (worth 2 points)
Z for Scissors (worth 3 points)

Your total scoe is the sum of your scores for each round. The socre for a single round 
is the score for the sahap you selected
1 for Rock
2 for Paper
3 for Scissors

0 points if you lost
3 points if you draw
6 points if you win

*/
func main() {
    outcomes := make(map[byte]map[byte]int)
    outcomes['X'] = make(map[byte]int)
    outcomes['Y'] = make(map[byte]int)
    outcomes['Z'] = make(map[byte]int)

    outcomes['X']['A'] = 3 + 1
    outcomes['X']['B'] = 0 + 1
    outcomes['X']['C'] = 6 + 1

    outcomes['Y']['A'] = 6 + 2
    outcomes['Y']['B'] = 3 + 2
    outcomes['Y']['C'] = 0 + 2

    outcomes['Z']['A'] = 0 + 3
    outcomes['Z']['B'] = 6 + 3
    outcomes['Z']['C'] = 3 + 3


    f, err := os.Open("./input.txt")
    if err != nil {
        panic(err)
    }

    scanner := bufio.NewScanner(f)

    var total int
    for scanner.Scan() {
        text := scanner.Text()
        op, you := text[0], text[2]
        total += outcomes[you][op]
    }
    fmt.Println("total:", total)
}
