#include <stdio.h>
#include <string.h>

int main(void)
{
	FILE *fp;
	char s[1024];
	int total;

	fp = fopen("input.txt", "r");

	while (fgets(s, sizeof s, fp) != NULL) {
		unsigned long len = strlen(s);
		int max = 0;
		for (int i = 0; i < len - 1; i++) {
			for (int j = i + 1; j < len; j++) {
				int a = s[i] - '0';
				int b = s[j] - '0';
				int num = a * 10 + b;
				if (max < num) {
					max = num;
				}
			}
		}
		total += max;
	}
	printf("total %d\n", total);
}
