#include <stdio.h>
#include <stdlib.h>

int main(void) {
	FILE *fp;
	char s[1024]; // big enough for any line this program will encounter
	
	char dir; // L or R
	int dist; // steps left or right
	int curr = 50; // where the dial is
	int next; // where the dial will be after traveling `dist`
	int count = 0;
	int passes; // local variable representing each time 0 is hit

	fp = fopen("input.txt", "r");

	while (fgets(s, sizeof s, fp) != NULL) {
		sscanf(s, "%c%d", &dir, &dist);

		passes = 0;
		if (dir == 'R') {
			next = (curr + dist) % 100;
			passes = (curr + dist) / 100;
		}
		if (dir == 'L') {
			next = (curr - dist) % 100; // negative modulo??
			if (next < 0) {
				next += 100;
			}

			if (dist <= curr) {
				passes = 0;
			} else {
				passes = ((dist - curr - 1) / 100) + 1;
			}
		}
		count += passes;
		curr = next;
	}
	printf("count: %d\n", count);

	fclose(fp);
}
