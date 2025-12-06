#include <stdio.h>
#include <string.h>

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
	unsigned long ids[1024];

	while (fgets(buf, sizeof buf, fp) != NULL) {
		if (strcmp(buf, "\n") == 0) {
			flag = 1;
			continue;
		}
		if (flag == 0) {
			sscanf(buf, "%ld-%ld", &start, &end);
			ranges[rangesLen][0] = start;
			ranges[rangesLen][1] = end;
			rangesLen++;
			continue;
		}
		sscanf(buf, "%ld", &id);
		ids[idsLen] = id;
		idsLen++;
	}
	fclose(fp);

	int count = 0;

	for (int i = 0; i < idsLen; i++) {
		id = ids[i];

		for (int i = 0; i < rangesLen; i++) {
			start = ranges[i][0];
			end = ranges[i][1];
			if (id >= start && id <= end) {
				count++;
				break;
			}
		}
	}
	printf("count %d\n", count);
}
