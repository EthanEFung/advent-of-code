type coordinate = [number, number, number]
type cube = number[][][]
type list = { val: coordinate, next: list } | null

function partOne(coordinates: coordinate[]): cube {
	const cube: cube = []

	for (const [x, y, z] of coordinates) {
		if (cube[z] === undefined) {
			cube[z] = []
		}
		if (cube[z][y] === undefined) {
			cube[z][y] = []
		}

		cube[z][y][x] = 1
	}

	let faces = 0

	for (let z = 0; z < cube.length; z++) {
		if (cube[z] === undefined) {
			continue
		}
		for (let y = 0; y < cube[z].length; y++) {
			if (cube[z][y] === undefined) {
				continue
			}
			for (let x = 0; x < cube[z][y].length; x++) {
				if (!cube[z][y][x]) {
					continue
				}
				const dirs: coordinate[] = [
					[x + 1, y, z],
					[x, y + 1, z],
					[x, y, z + 1],
					[x - 1, y, z],
					[x, y - 1, z],
					[x, y, z - 1],
				]

				for (const [ax, ay, az] of dirs) {
					if (cube[az] && cube[az][ay] && cube[az][ay][ax]) {
						continue
					}
					faces++
				}
			}
		}
	}
	console.log("Part one:", faces)
	return cube
}

function partTwo(cube: cube) {
	// lets fill the cube with sides of water, to model
	// what it would be like for the lava to fall into a pond

	// first lets make sure that the first index is filled in with 2s
	// while we're at it we'll also check to see what longest row is
	let ly = 0, lx = 0;
	for (let z = 0; z < cube.length; z++) {
		if (!cube[z]) {
			cube[z] = []
		}
		if (cube[z].length > ly) {
			ly = cube[z].length + 1
		}
		for (let y = 0; y < cube[z].length; y++) {
			if (!cube[z][y]) {
				cube[z][y] = [0]
			}
			if (cube[z][y].length > lx) {
				lx = cube[z][y].length + 1
			}
		}
	}

	for (let z = 0; z < cube.length; z++) {
		for (let y = 0; y < ly; y++) {
			if (!cube[z][y]) {
				cube[z][y] = []
			}

			cube[z][y][lx] = 0;
			// here we're going to prepend a zero to every row
			cube[z][y] = [0, ...cube[z][y]]
			// cube[z][y][0] = 0;
		}
	}

	// now lets prepend another panel to the top of the grid to make sure
	// that we don't miss any droplets
	//
	
	
    const panel: number[][] = []
	for (let y = 0; y <= ly; y++) {
		for (let x = 0; x <= lx; x++) {
			if (!panel[y]) {
				panel[y] = []
			}
			panel[y][x] = 0;
		}
	}
	cube = [panel, ...cube, [...panel]]
	console.log(cube)
	// great, now lets try to flood fill

	const queue: list = {
		val: [0, 0, 0],
		next: null
	}
	let tail = queue;

	for (let curr: list = queue; curr != null; curr = curr.next) {
		
		const [x, y, z] = curr.val;
		if (!!cube[z][y][x]) {
			continue
		}

		cube[z][y][x] = 2;
		const sides: coordinate[] = [
			[x + 1, y, z],
			[x, y + 1, z],
			[x, y, z + 1],
			[x - 1, y, z],
			[x, y - 1, z],
			[x, y, z - 1],
		]
		
		for (const side of sides) {
			const [sx, sy, sz] = side
			if (sz < 0 || sy < 0 || sx < 0) {
				continue
			}
			if (
				sz >= cube.length
				|| sy >= cube[sz].length
				|| sx >= cube[sz][sy].length
			) {
				continue
			}
			if (!cube[sz][sy][sx]) {
				tail.next = { val: side, next: null };
				tail = tail.next
			}
		}
	}


	// once we've modeled all the water, now we can make a distinction
	// between areas reachable by water vs areas trapping air
	// lets finish this by trying to count all the faces that are externally facing
	//
	let total = 0;
	for (let z = 0; z < cube.length; z++) {
		for (let y = 0; y < cube[z].length; y++) {
			for (let x = 0; x < cube[z][y].length; x++) {
				if (cube[z][y][x] !== 1) {
					continue
				}
				const sides: coordinate[] = [
					[x + 1, y, z],
					[x, y + 1, z],
					[x, y, z + 1],
					[x - 1, y, z],
					[x, y - 1, z],
					[x, y, z - 1],
				]
				let faces = 6;
				for (const [sx, sy, sz] of sides) {
					if (sz < 0 || sy < 0 || sx < 0) {
						continue
					}
					if (
						sz >= cube.length
						|| sy >= cube[sz].length
						|| sx >= cube[sz][sy].length
					) {
						continue
					}
					if (cube[sz][sy][sx] != 2) {
						faces--
					}
				}
				total += faces;
			}
		}

	}
	// console.log(cube)
	console.log("Part Two:", total)
}

async function main() {
	const text: string = await Deno.readTextFile("./input.txt")
	const coordinates = text.trimEnd()
		.split(/\n/)
		.map((str) => str.split(','))
		.map((arr) => arr.map((x) => parseInt(x, 10)) as coordinate)

	const cube = partOne(coordinates)
	partTwo(cube)
}
main()
