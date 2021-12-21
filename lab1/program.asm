; program przykladowy (wersja 32-bitowa)
.686
.model flat

extern _ExitProcess@4: PROC
extern __write : PROC ; (dwa znaki podkreslenia)
public _main

.data
tekst	db 10, 'Nazywam sie . . . ' , 10
		db 'M', 162, 'j pierwszy 32-bitowy program '
		db 'asemblerowy dzia', 136, 'a ju', 190, ' poprawnie!', 10

.code
_main PROC
	mov ecx, 85 ; liczba znaków wyswietlanego tekstu
	; wywolanie funkcji ”write” z biblioteki jezyka C
	push ecx ; liczba znaków wyswietlanego tekstu
	push dword PTR OFFSET tekst ; polozenie obszara
	; ze znakami
	push dword PTR 1 ; uchwyt urzadzenia wyjsciowego
	call __write ; wyswietlenie znaków 
	; (dwa znaki podkreslenia _ )
	add esp, 12 ; usuniecie parametrów ze stosu
	; zakonczenie wykonywania programu
	push dword PTR 0 ; kod powrotu programu 
	call _ExitProcess@4 
_main ENDP

END