.686
.model flat

public _main
extern _ExitProcess@4 : PROC
extern __write : PROC

.data
	zmienna dd ?
	zmienna2 dd ?
	start	dd 0.1
	znaki	db 12 dup (?)
	tysiac	dd 1000.0

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
	mov byte PTR znaki [esi], '.'
	mov ebp, esi
	dec esi
	mov byte PTR znaki [esi], '1'
	dec esi
	mov edi, 2
	jmp wyswietl
ok:
	mov byte PTR znaki [esi], '.' ; kod spacji
	dec esi ; zmniejszenie indeksu
	mov byte PTR znaki [esi], '1'
	dec esi
	;jmp wypeln
wyswietl:
	;mov byte PTR znaki [0], 0AH ; kod nowego wiersza
	mov byte PTR znaki [11], 0AH ; kod nowego wiersza
; wyœwietlenie cyfr na ekranie
	push dword PTR 12 ; liczba wyœwietlanych znaków
	push dword PTR OFFSET znaki ; adres wyœw. obszaru
	push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
	call __write ; wyœwietlenie liczby na ekranie
	add esp, 12 ; usuniêcie parametrów ze stosu

	mov esi, 10
	mov ecx, 10
czyszczenie:
	mov byte PTR znaki [esi], 0
	dec esi
	loop czyszczenie

	popa
	ret
_wyswietl_EAX ENDP

_wez_X	PROC
	fld		dword ptr [esp+4]
	push	esi
	push	ecx
	mov		ecx, edi
	cmp		edi, 0
	je		koniec
petla_dwa:
	fld		dword ptr [esp+12]
	fadd
	loop petla_dwa


koniec:
	pop		ecx
	pop		esi
	ret
_wez_X	ENDP

_main PROC
	finit
	mov		ecx, 5
	push	start
	mov		edi, 0
petla:
	call	_wez_X
	
	fldl2e		;log2e
	fmulp 
	fst		st(1)
	frndint
	fsub	st(1), st(0)
	fxch
	f2xm1
	fld1
	faddp	st(1), st(0)
	fscale					; e^x
	inc		edi



	fst		st(1)			; powielam floata
	fld1					; dodaje zaokraglenie
	fsub	st(1), st(0)	; otrzymuje roznice

	fstp	st(0)			; usuwam zaokraglenie			
	fld		tysiac			; mnoze przez 1000
	fmulp 


	frndint


	fistp	zmienna
	fstp	st(0)

	mov		eax, zmienna
	

	call _wyswietl_EAX
	

	loop	petla


	push	0
	call	_ExitProcess@4
_main endp

END