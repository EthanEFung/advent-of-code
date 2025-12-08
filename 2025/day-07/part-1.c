#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
	FILE *fp;

	fp = fopen("input.txt", "r");
	if (fp == NULL) {
		perror("failed to open file");
		return 1;
	}

	char *diagram[4096];
	int rows, cols;
	char buf[4096];
	while (fgets(buf, sizeof buf, fp) != NULL) {
		buf[strcspn(buf, "\n")] = 0;
		diagram[rows] = strdup(buf);
		if (diagram[rows] == NULL) {
			perror("memory allocation failure");
			for (int i = 0; i < rows; i++) {
				free(diagram[i]);
			}
			fclose(fp);
			return 1;
		}
		if (rows == 0) {
			cols = strlen(buf);
		}
		rows++;
	}

	int flag;
	do {
		flag = 0;
		for (int row = 0; row < rows - 1; row++) {
			for (int col = 0; col < cols; col++) {
				// handle beams
				if (
					(diagram[row][col] == '|' || diagram[row][col] == 'S') &&
					diagram[row+1][col] == '.'
				) {
					flag = 1;
					diagram[row+1][col] = '|';
				}

				// handle splitters
				if (row > 0 && diagram[row][col] == '^' && diagram[row-1][col] == '|') {
					if (col > 0 && diagram[row][col-1] == '.') {
						flag = 1;
						diagram[row][col-1] = '|';
					}
					if (col < cols - 1 && diagram[row][col+1] == '.') {
						flag = 1;
						diagram[row][col+1] = '|';
					}
				}
			}
		}
	} while (flag);

	for (int row = 0; row < rows; row++) {
		for (int col = 0; col < cols; col++) {
			printf("%c", diagram[row][col]);
		}
		printf("\n");
	}

	int count;
	for (int row = 1; row < rows - 1; row++) {
		for (int col = 0; col < cols; col++) {
			if (diagram[row][col] == '^' && diagram[row-1][col] == '|') {
				count++;
			}
		}
	}
	printf("total %d\n", count);
}
