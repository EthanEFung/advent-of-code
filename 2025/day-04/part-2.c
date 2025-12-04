#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_ROWS 1024
#define MAX_COLS 1024

typedef struct coor {
	int row, col;
} coor;

int main(void)
{
	char grid[MAX_ROWS][MAX_COLS];
	int rows = 0;
	int cols = 0;

	FILE *fp;
	fp = fopen("input.txt", "r");
	if (fp == NULL) {
		perror("Error opening file");
		return EXIT_FAILURE;
	}
	char buffer[MAX_COLS + 2]; // +1 for newline and +1 for null terminator
	while(fgets(buffer, sizeof buffer, fp) != NULL) {
		int len;
		char *new_line_pos = strchr(buffer, '\n');
		if (new_line_pos != NULL) {
			len = new_line_pos - buffer;
		} else {
			len = strlen(buffer);
		}
		if (len > MAX_COLS) {
			fprintf(stderr, "Warning: Row %d has more columns than MAX_COLS (%d). Truncating.\n", rows, MAX_COLS);
			len = MAX_COLS; // Truncate the line
		}
		if (rows == 0) {
			cols = len;
		}
		strncpy(grid[rows], buffer, cols);
		grid[rows][cols] = '\0';
		rows++;
	}
	fclose(fp);

	int count = 0;
	int removed;
	coor directions[8] = {
		{-1,-1}, {-1, 0}, {-1, 1},
		{ 0,-1},          { 0, 1},
		{ 1,-1}, { 1, 0}, { 1, 1}
	};

	do {
		removed = 0;
		for (int row = 0; row < rows; row++) {
			for (int col = 0; col < cols; col++) {
				if (grid[row][col] == '@') {
					// here we'll do the checking of whether a roll is accessible
					int surrounding = 0;

					coor dir;
					int adj_row;
					int adj_col;
					for (int i = 0; i < 8; i++) {
						dir = directions[i];
						adj_row = row + dir.row;
						adj_col = col + dir.col;

						if (adj_row < 0 || adj_row >= rows) {
							continue;
						}
						if (adj_col < 0 || adj_col >= cols) {
							continue;
						}
						if (grid[adj_row][adj_col] == '@' || grid[adj_row][adj_col] == 'X') {
							surrounding++;
						}
					}
					if (surrounding < 4) {
						grid[row][col] = 'X';
					}
				}
			}
		}

		for (int row = 0; row < rows; row++) {
			for (int col = 0; col < cols; col++) {
				if (grid[row][col] == 'X') {
					grid[row][col] = '.';
					removed++;
				}
			}
		}
		count += removed;
	} while (removed > 0);
	printf("Rolls %d\n", count);
}
