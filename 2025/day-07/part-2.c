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

	unsigned long counts[rows][cols];
	for (int row = 0; row < rows; row++) {
		for (int col = 0; col < cols; col++) {
			counts[row][col] = 0;
		}
	}

	for (int row = rows - 2; row > 0; row--) {
		for (int col = 0; col < cols; col++) {
			if (diagram[row][col] == '^') {
				unsigned long val = 0;
				if (col > 0) {
					for (int i = 0; i < rows - row; i++) {
						if (counts[row+i][col-1] > 0) {
							val += counts[row+i][col-1];
							break;
						}
						if (i + row == rows - 1) {
							val++;
						}
					}
				}
				if (col < cols - 1) {
					for (int i = 0; i < rows - row; i++) {
						if (counts[row+i][col+1] > 0) {
							val += counts[row+i][col+1];
							break;
						}
						if (i + row == rows - 1) {
							val++;
						}
					}
				}
				counts[row][col] = val;
			}
		}
	}

	// for (int i = 0; i < rows; i++) {
	// 	for (int j = 0; j < cols; j++) {
	// 		if (counts[i][j] == 0) {
	//
	// 			printf("  ,");
	// 		} else {
	// 			printf("%.2lu,", counts[i][j]);
	// 		}
	// 	}
	// 	printf("\n");
	// }

	int s_col;
	for (int i = 0; i < cols; i++) {
		if (diagram[0][i] == 'S') {
			s_col = i;
			break;
		}
	}

	unsigned long total;
	for (int row = 1; row < rows; row++) {
		if (counts[row][s_col] > 0) {
			total = counts[row][s_col];
			break;
		}
	}
	printf("total: %lu\n", total);
}
