#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
	FILE *fp;

	fp = fopen("input.txt", "r");
	if (fp == NULL) {
		perror("could not open file");
		return 1;
	}

	char *lines[sizeof (char) * 4096];
	int lines_len = 0;
	char buf[sizeof (char) * 4096]; // OOOOOH
	while (fgets(buf, sizeof buf, fp) != NULL) {
		buf[strcspn(buf, "\n")] = 0;

		lines[lines_len] = strdup(buf);
		// printf("%s\n", buf);
		if (lines[lines_len] == NULL) {
			perror("Memory allocation failure");
			for (int i = 0; i < lines_len; i++) {
				free(lines[i]);
			}
			fclose(fp);
			return 1;
		}

		lines_len++;
	}
	fclose(fp);

	unsigned long grid[256][1024];
	unsigned long total = 0;

	for (int i = 0; i < lines_len; i++) {
		char *line = lines[i];
		char *line_copy = strdup(line);
		if (line_copy == NULL) {
			perror("Memory allocation failure");
			for (int i = 0; i < lines_len; i++) {
				free(lines[i]);
			}
			return 1;
		}

		char *token;
		char *rest = line_copy;

		token = strtok_r(rest, " ", &rest);
		if (token == NULL) {
			free(line_copy);
			continue;
		}

		int len = 0;

		if (i == lines_len - 1) {
			// handle operators
			do {
				char operator = token[0];
				unsigned long answer = grid[0][len];
				for (int j = 1; j < lines_len - 1; j++) {
					if (operator == '+') {
						answer += grid[j][len];
					} else if (operator == '*') {
						answer *= grid[j][len];
					}
				}
				printf("%d: %lu\n", len, answer);
				total += answer;
				len++;
				token = strtok_r(rest, " ", &rest);
			} while (token != NULL);
			free(line_copy);
			continue;
		}

		// handle numbers;
		unsigned long val;
		do {
			char *endptr;
			val = strtoul(token, &endptr, 10);
			grid[i][len++] = val;
			token = strtok_r(rest, " ", &rest);
		} while (token != NULL);
		printf("\n");
		free(line_copy);
	}
	printf("total %lu\n", total);
}
