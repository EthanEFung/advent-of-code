#include <stdio.h>

int main(void) {
	FILE *fp;
	char s[1024]; // big enough for any line this program will encounter
	
	char dir;
	int dist;
	int dial = 50;
	int count = 0;

	fp = fopen("input.txt", "r");

	while (fgets(s, sizeof s, fp) != NULL) {
		sscanf(s, "%c%d", &dir, &dist);

		if (dir == 'L') {
			dial = dial - dist;
		}
		if (dir == 'R') {
			dial = dial + dist;
		}
		while (dial > 99) {
			dial = dial - 100;
		}
		while (dial < 0) {
			dial = dial + 100;
		}

		if (dial == 0) {
			count++;
		}
	}
	printf("count: %d\n", count);

	fclose(fp);
}
