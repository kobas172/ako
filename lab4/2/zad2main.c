#include <stdio.h>

unsigned int check_system_dir(char* directory);

int main()
{
	char x[] = { "C:\\WINDOWS\\system32" };
	int wynik;

	wynik = check_system_dir(x);
	printf("\n%s = %d\n", x, wynik);

	char y[] = { "C:\\drive" };

	wynik = check_system_dir(y);
	printf("\n%s = %d\n", y, wynik);

	char z[] = { "C:\\WINDOWS\\system32\\przykladowy_folder" };

	wynik = check_system_dir(z);
	printf("\n%s = %d\n", z, wynik);

	return 0;
}