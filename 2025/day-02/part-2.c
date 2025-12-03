#include <stdio.h>
#include <string.h>

int is_invalid(long num)
{
	if (num <= 0) {
		return 0;
	}
	int len = 0;
	long temp = num;
	while (temp > 0) {
		len++;
		temp = temp / 10;
	}

	long digits = len / 2;
	long curr;
	long next;
	long power_of_10;
	int invalid;
	while (digits > 0) {
		if (len % digits != 0) {
			digits--;
			continue;
		}
		power_of_10 = 1;
		for (int i = 0; i < digits; i++) {
			power_of_10 = power_of_10 * 10;
		}

		curr = num;
		next = curr;

		invalid = 1;
		while (next > 0) {
			if (next % power_of_10 != curr % power_of_10) {
				invalid = 0;
				break;
			}
			next /= power_of_10;
		}

		if (invalid) {
			return invalid;
		}
		digits--;
	}
	return 0;
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
