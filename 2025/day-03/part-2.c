#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
	FILE *fp;
	char s[1024];
	long total;
	char best[sizeof (int) * 12];

	fp = fopen("input.txt", "r");

	while (fgets(s, sizeof s, fp) != NULL) {
		unsigned long len = strlen(s);
		int last = -1;

		for (int i = 0; i < 12; i++) {
			int index_of_max = last + 1;
			for (int j = last + 1; j < len - (12 - i); j++) {
				int a = s[j] - '0';
				int max = s[index_of_max] - '0';
				if (a > max) {
					index_of_max = j;
				}
			}
			best[i] = s[index_of_max];
			last = index_of_max;
		}
		char *endPtr;
		total += strtol(best, &endPtr, 10);
	}
	printf("total %ld\n", total);
}
