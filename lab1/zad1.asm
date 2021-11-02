; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
public _main
.data
tekst_pocz		db 10, 'Prosz', 169, ' napisa', 134,' jaki', 152,' tekst '
				db 'i nacisn', 165, 134, ' Enter', 10
koniec_t		db ?
magazyn			db 80 dup (?)
nowa_linia		db 10
liczba_znakow	dd ?
.code
_main PROC
; wyświetlenie tekstu informacyjnego
; liczba znaków tekstu
	mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	push ecx
	push OFFSET tekst_pocz ; adres tekstu
	push 1 ; nr urządzenia (tu: ekran - nr 1)
	call __write ; wyświetlenie tekstu początkowego
	add esp, 12 ; usuniecie parametrów ze stosu
; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znaków
	push OFFSET magazyn
	push 0 ; nr urządzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znaków z klawiatury
	add esp, 12 ; usuniecie parametrów ze stosu
; kody ASCII napisanego tekstu zostały wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczbę
; wprowadzonych znaków
	mov liczba_znakow, eax
; rejestr ECX pełni rolę licznika obiegów pętli
	mov ecx, eax
	mov ebx, 0 ; indeks początkowy
ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	cmp dl, 32
	jb dalej ; skok, gdy znak nie wymaga zamiany
	cmp dl, 125 
	ja dalej ; skok, gdy znak nie wymaga zamiany
	cmp dl, 110
	ja przeskok
	add dl, 15 ; zamiana na wielkie litery
; odesłanie znaku do pamięci
	mov magazyn[ebx], dl
	jmp dalej
przeskok: mov al, 125
	mov ah, 15
	sub al, dl
	sub ah, al
	add ah, 32
	mov magazyn[ebx], ah
	dalej: inc ebx ; inkrementacja indeksu
	loop ptl ; sterowanie pętlą
; wyświetlenie przekształconego tekstu
	push liczba_znakow
	push OFFSET magazyn
	push 1
	call __write ; wyświetlenie przekształconego  tekstu
	add esp, 12 ; usuniecie parametrów ze stosu
	push 0
	call _ExitProcess@4 ; zakończenie programu
_main ENDP
END
