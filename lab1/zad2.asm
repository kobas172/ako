; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
extern _MessageBoxW@16 : PROC
public _main
.data
tytul			dw 'T','e','s','t',' ','U','T','F','-','1','6', 0
magazyn			dw 'w','y','r','a','z','_','A',' ','w','y','r','a','z','_','B',' ','w','y','r','a','z','_','C', 0
magazyn2		dw 160 dup (?)
nowa_linia		db 10
indeks			dd ?
.code
_main PROC
; kody ASCII napisanego tekstu zostały wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczbę
; wprowadzonych znaków
	;mov liczba_znakow, eax
; rejestr ECX pełni rolę licznika obiegów pętli
	mov ecx, 44
	mov ebx, 0 ; indeks początkowy
	mov al, 0
	mov edi, 0
	mov eax, 0
ptl: mov dx, magazyn[ebx] ; pobranie kolejnego znaku
	cmp al, 0
	je sprawdzenie
	cmp al, 1
	je sprawdzenie2
	cmp al, 2
	je dodanie

sprawdzenie: cmp dh, ' '
	jne dalej
	mov al, 1
	jmp dalej

sprawdzenie2: cmp dh, ' '
	jne dalej
	mov al, 2
	jmp dalej

dodanie: mov magazyn2[edi], dx
	inc edi

	dalej: inc ebx ; inkrementacja indeksu
	loop ptl ; sterowanie pętlą

	inc edi
	inc edi
	mov magazyn2[edi], ' '
	inc edi
	inc edi
	;mov indeks, edi

	mov ecx, 44
	mov ebx, 0 ; indeks początkowy
	mov al, 0
	mov eax, 0

	ptl1: mov dx, magazyn[ebx] ; pobranie kolejnego znaku
	cmp al, 0
	je pierwszy
	cmp al, 1
	je drugi
	jmp dalej1

pierwszy: cmp dh, ' '
	je dodaniespacji1
	;mov magazyn2[edi], dx
	;inc edi
	jmp dalej1

dodaniespacji1:
	;mov magazyn2[edi], dx
	;inc edi
	mov al, 1
	jmp dalej1

drugi: cmp dh, ' '
	je dodaniespacji2
	mov magazyn2[edi], dx
	inc edi
	jmp dalej1

dodaniespacji2:
	mov magazyn2[edi], dx
	inc edi
	mov al, 2
	jmp dalej1

	dalej1: inc ebx ; inkrementacja indeksu
	loop ptl1 ; sterowanie pętlą
	
	inc edi
	inc edi
	mov magazyn2[edi], ' '
	inc edi
	inc edi

	mov ecx, 44
	mov ebx, 0 ; indeks początkowy
	mov al, 0
	mov eax, 0

	ptl2: mov dx, magazyn[ebx] ; pobranie kolejnego znaku
	cmp al, 0
	je pierwszywyraz
	jmp dalej2

pierwszywyraz:
	cmp dh, ' '
	je wyjscie
	mov magazyn2[edi], dx
	inc edi
	jmp dalej2

wyjscie: mov al, 1
	jmp dalej2


	dalej2: inc ebx ; inkrementacja indeksu
	loop ptl2 ; sterowanie pętlą

; wyświetlenie przekształconego tekstu
	push 0
	push OFFSET tytul
	push OFFSET magazyn2
	push 0
	call _MessageBoxW@16
	push 0
	call _ExitProcess@4 ; zakończenie programu
_main ENDP
END
