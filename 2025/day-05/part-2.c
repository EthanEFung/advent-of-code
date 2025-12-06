#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int compare(const void *a, const void *b)
{
	const unsigned long *rangeA = (const unsigned long *)a;
	const unsigned long *rangeB = (const unsigned long *)b;
	if (rangeA[0] > rangeB[0]) {
		return 1;
	}
	if (rangeA[0] < rangeB[0]) {
		return -1;
	}
	if (rangeA[1] > rangeB[1]) {
		return 1;
	}
	if (rangeA[1] < rangeB[1]) {
		return -1;
	}
	return 0;
}

int main(void)
{
	FILE *fp;

	fp = fopen("input.txt", "r");
	if (fp == NULL) {
		return 1;
	}

	char buf[1024];
	int flag = 0;
	int rangesLen = 0;
	int idsLen = 0;
	unsigned long start;
	unsigned long end;
	unsigned long id;
	unsigned long ranges[1024][2];

	while (fgets(buf, sizeof buf, fp) != NULL) {
		if (strcmp(buf, "\n") == 0) {
			break;
		}
		sscanf(buf, "%ld-%ld", &start, &end);
		ranges[rangesLen][0] = start;
		ranges[rangesLen][1] = end;
		rangesLen++;
	}
	fclose(fp);

	qsort(ranges, rangesLen, sizeof(ranges[0]), compare);

	unsigned long count = 0;
	start = ranges[0][0];
	end = ranges[0][1];
	for (int i = 1; i < rangesLen; i++) {
		unsigned long curr_start = ranges[i][0];
		unsigned long curr_end = ranges[i][1];
		if (end < curr_start) {
			count += end - start + 1;
			start = curr_start;
			end = curr_end;
			continue;
		}
		if (curr_end > end) {
			end = curr_end;
		}
	}
	count += end - start + 1;

	printf("count %ld\n", count);
}
