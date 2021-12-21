#include <stdio.h>

int dzielenie(int* dzielna, int** dzielnik);

int main()
{
	int dzielna;
	int dzielnik;
	int* wskaznik_na_dzielnik;
	int wynik;

	wskaznik_na_dzielnik = &dzielnik;
	dzielna = -60;
	dzielnik = 20;

	wynik = odejmowanie(&dzielna, &wskaznik_na_dzielnik);
	printf("\nDzielna: %d / Dzielnik: %d = %d\n", dzielna, dzielnik, wynik);

	dzielna = 2;
	dzielnik = 4;
	wynik = odejmowanie(&dzielna, &wskaznik_na_dzielnik);
	printf("\nDzielna: %d / Dzielnik: %d = %d\n", dzielna, dzielnik, wynik);

	dzielna = 9;
	dzielnik = 3;
	wynik = odejmowanie(&dzielna, &wskaznik_na_dzielnik);
	printf("\nDzielna: %d / Dzielnik: %d = %d\n", dzielna, dzielnik, wynik);

	return 0;
}