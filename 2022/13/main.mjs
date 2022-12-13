import fs from 'node:fs'

const compare = (a, b) => {
    if (b === undefined) {
        return -1
    } else if (a === undefined) {
        return 1
    } else if (typeof a === typeof b && typeof a === 'number') {
        return a < b ? 1 : a === b ? 0 : -1
    } else if (typeof a === typeof b && typeof a === 'object') {
        for (let i = 0; i < a.length; i++) {
            if (compare(a[i], b[i]) === 1) {
                return 1
            } else if (compare(a[i], b[i]) === -1) {
                return -1
            }
        }
        if (b.length < a.length) {
            return -1
        }
        if (a.length === b.length) {
            return 0
        }
        return 1
    } else if (typeof a === 'number') {
        return compare([a], b)
    } else if (typeof b === 'number') {
        return compare(a, [b])
    }
    return 1
}

const partOne = (pairs) => {
    return pairs.reduce((acc, pair, i) => {
        const [a, b] = pair
        if (compare(a, b) !== -1) {
            acc.push(i + 1)
        }
        return acc
    }, []).reduce((acc, index) => acc + index)
}

const partTwo = (packets) => {
    const dividerA = [[2]]
    const dividerB = [[6]]
    const all = packets.concat([dividerA], [dividerB]).sort(compare).reverse()

    const indexA = all.findIndex((a) => a === dividerA) + 1
    const indexB = all.findIndex((b) => b === dividerB) + 1
    return indexA * indexB
}

fs.readFile("input.txt", { encoding: 'utf-8' }, (err, data) => {
    if (err) {
        console.error(err)
        os.exit(1)
    }

    console.log("part one:", partOne(
        data
            .split(/r?\n\n/)
            .map((str) =>
                str
                    .trim()
                    .split(/\n/)
                    .map((s) => s === '' ? 0 : JSON.parse(s))
            ))
    )

    console.log("part two:", partTwo(
        data
            .split(/r?\n/)
            .filter((str) => str.length !== 0)
            .map((str) => JSON.parse(str)))
    )
})
