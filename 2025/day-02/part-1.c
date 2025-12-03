#include <stdio.h>
#include <string.h>
#include <limits.h>

int is_invalid(long num)
{
	if (num <= 0) {
		return 0;
	}
	int digits = 0;
	long temp = num;
	while (temp > 0) {
		digits++;
		temp = temp / 10;
	}
	if (digits % 2 != 0) {
		return 0;
	}
	int half = digits / 2;

	long power_of_10 = 1;
	for (int i = 0; i < half; i++) {
		power_of_10 = power_of_10 * 10;
	}

	long front = num / power_of_10;
	long back = num % power_of_10;

	return front == back;
}

long sum_invalid(char str[], int len)
{
	long start, end;
	long sum = 0;
	sscanf(str, "%ld-%ld", &start, &end);

	for (long curr = start; curr <= end; curr++) {
		if (is_invalid(curr)) {
			sum += curr;
		}
	}
	return sum;
}

int main(void)
{
	FILE *fp;
	char s[1024];
	char c;
	int i = 0;
	long total = 0;

	fp = fopen("input.txt", "r");

	while ((c = fgetc(fp)) != EOF) {
		if (c == ',') {
			s[i] = '\0';
			total += sum_invalid(s, strlen(s));
			i = 0;
		} else {
			s[i] = c;
			i++;
		}
	}
	s[i] = '\0';
	total += sum_invalid(s, strlen(s));
	printf("Total: %ld\n", total);

	fclose(fp);
}
