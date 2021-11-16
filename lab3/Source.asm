.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC

public _main
; obszar danych programu
.data
; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr
	znaki db 12 dup (?)
	n	  db 100
; obszar instrukcji (rozkazów) programu
.code

_wyswietl_EAX PROC
	pusha

	mov edi, 0
	cmp eax, 0
	jge dalej
	neg eax
	mov edi, 1

dalej:
	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik równy 10
konwersja:
	mov edx, 0 ; zerowanie starszej czêœci dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX,
; iloraz w EAX
	add dl, 30H ; zamiana reszty z dzielenia na kod
; ASCII
	mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy
; wype³nienie pozosta³ych bajtów spacjami i wpisanie
; znaków nowego wiersza
wypeln:
	or esi, esi
	jz wyswietl ; skok, gdy ESI = 0
	cmp edi, 2
	je ok
	cmp edi, 0
	mov edi, 2
	je ok
	cmp edi, 1
	mov byte PTR znaki [esi], '-'
	dec esi
	mov edi, 2
	jmp wypeln
ok:
	mov byte PTR znaki [esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jmp wypeln
wyswietl:
	mov byte PTR znaki [0], 0AH ; kod nowego wiersza
	mov byte PTR znaki [11], 0AH ; kod nowego wiersza
; wyœwietlenie cyfr na ekranie
	push dword PTR 12 ; liczba wyœwietlanych znaków
	push dword PTR OFFSET znaki ; adres wyœw. obszaru
	push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
	call __write ; wyœwietlenie liczby na ekranie
	add esp, 12 ; usuniêcie parametrów ze stosu

	popa
	ret
_wyswietl_EAX ENDP

_szereg PROC
	pusha

	mov edx, OFFSET n
	mov ecx, [edx]
	mov eax, 1
	mov ebx, 0
	mov edi, 0
ptl:
	cmp edi, 0
	je dodatnie
	jmp ujemne

dodatnie:
	add eax, ebx
	call _wyswietl_EAX
	mov edi, 1
	jmp koniec
ujemne:
	sub eax, ebx
	call _wyswietl_EAX
	mov edi, 0
	jmp koniec

koniec:
	inc ebx
	loop ptl

	popa
	ret
_szereg ENDP

_main PROC

	call _szereg

	push 0 
	call _ExitProcess@4
_main ENDP
END