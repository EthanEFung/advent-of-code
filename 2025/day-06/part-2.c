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

	char *chars[4096];
	int rows, cols;
	char buf[sizeof(char) * 4096];
	while (fgets(buf, sizeof buf, fp) != NULL) {
		buf[strcspn(buf, "\n")] = 0;
		if (rows == 0) {
			cols = strlen(buf);
		}
		chars[rows++] = strdup(buf);
	}
	fclose(fp);

	unsigned long total;
	unsigned long integers[1024];
	int integers_len = 0;
	for (int i = cols-1; i >= 0 ;i--) {
		char str[1024];
		int str_len = 0;
		char ch;
		for (int j = 0; j < rows-1; j++) {
			ch = chars[j][i];
			if (ch != ' ' && (ch >= '0' && ch <= '9')) {
				str[str_len++] = ch;
			}
		}
		str[str_len] = '\0';
		if (str_len == 0) {
			continue;
		}

		integers[integers_len++] = strtoul(str, NULL, 10);

		ch = chars[rows-1][i];
		unsigned long answer = 0;
		if (ch == '+') {
			answer = integers[0];
			printf("%lu", answer);
			for (int k = 1; k < integers_len; k++) {
				answer += integers[k];
				printf(" + %lu", integers[k]);
			}
			printf(" = %lu\n", answer);
			total += answer;
			integers_len = 0;
		} else if (ch == '*') {
			answer = integers[0];
			printf("%lu", answer);
			for (int k = 1; k < integers_len; k++) {
				answer *= integers[k];
				printf(" * %lu", integers[k]);
			}
			printf(" = %lu\n", answer);
			total += answer;
			integers_len = 0;
		}
	}

	printf("\ntotal %lu\n", total);
}
