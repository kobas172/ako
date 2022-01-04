; Program gwiazdki.asm
; Wyœwietlanie znaków * w takt przerwañ zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakoñczenie programu po naciœniêciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; procedura obs³ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u¿ywanych rejestrów
	push ax
	push bx
	push es
	push cx
; wpisanie adresu pamiêci ekranu do rejestru ES - pamiêæ
; ekranu dla trybu tekstowego zaczyna siê od adresu B8000H,
; jednak do rejestru ES wpisujemy wartoœæ B800H,
; bo w trakcie obliczenia adresu procesor ka¿dorazowo mno¿y
; zawartoœæ rejestru ES przez 16
	mov ax, 0B800h ;adres pamiêci ekranu
	mov es, ax
	mov bx, cs:tryb
; zmienna 'licznik' zawiera adres bie¿¹cy w pamiêci ekranu
	mov cl, cs:ciag[bx]
	mov bx, cs:licznik
	inc cs:tryb
	cmp cs:tryb, 12
	jb dalej
	mov byte PTR es:[bx], '.' ; kod ASCII
	mov byte PTR es:[bx+1], 00000111B ; kolor
	add bx, 2
	mov cs:tryb, 0
	jmp po_sekwencji
; przes³anie do pamiêci ekranu kodu ASCII wyœwietlanego znaku
; i kodu koloru: bia³y na czarnym tle (do nastêpnego bajtu)
dalej:
	mov byte PTR es:[bx], cl ; kod ASCII
	mov byte PTR es:[bx+1], 00000111B ; kolor
	jmp koncowka
po_sekwencji:
; zwiêkszenie o 2 adresu bie¿¹cego w pamiêci ekranu
	inc cs:dwadziescia
; sprawdzenie czy adres bie¿¹cy osi¹gn¹³ koniec pamiêci ekranu
koncowka:
	cmp cs:dwadziescia, 24
	jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie¿¹cego, gdy ca³y ekran zapisany
;zapisanie adresu bie¿¹cego do zmiennej 'licznik'
wysw_dalej:
	mov cs:licznik,bx
; odtworzenie rejestrów
	pop cx
	pop es
	pop bx
	pop ax
; skok do oryginalnej procedury obs³ugi przerwania zegarowego
	jmp dword PTR cs:wektor8
; dane programu ze wzglêdu na specyfikê obs³ugi przerwañ
; umieszczone s¹ w segmencie kodu
	licznik dw 78 ; wyœwietlanie pocz¹wszy od 2. wiersza
	wektor8 dd ?
	tryb	dw 0
	ciag	db "\', |, /,|,."
	dwadziescia db 0
obsluga_zegara ENDP
;============================================================
; program g³ówny - instalacja i deinstalacja procedury
; obs³ugi przerwañ
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartoœci wektora nr 8 i zapisanie go
; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamiêci 4 bajty
; pocz¹wszy od adresu fizycznego 8 * 4 = 32)
	mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
	mov cs:wektor8, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	mov ax, SEG obsluga_zegara ; czêœæ segmentowa adresu
	mov bx, OFFSET obsluga_zegara ; offset adresu
	cli ; zablokowanie przerwañ
; zapisanie adresu procedury do wektora nr 8
	mov ds:[32], bx ; OFFSET
	mov ds:[34], ax ; cz. segmentowa
	sti ;odblokowanie przerwañ
; oczekiwanie na naciœniêcie klawisza 'x'
aktywne_oczekiwanie:
	cmp cs:dwadziescia, 24
	jae koniec
	jmp aktywne_oczekiwanie
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeœli
; naciœniêto jakiœ klawisz
; odczytanie kodu ASCII naciœniêtego klawisza (INT 16H, AH=0)
; do rejestru AL
koniec:
; deinstalacja procedury obs³ugi przerwania zegarowego
; odtworzenie oryginalnej zawartoœci wektora nr 8
	mov eax, cs:wektor8
	cli
	mov ds:[32], eax ; przes³anie wartoœci oryginalnej
; do wektora 8 w tablicy wektorów
; przerwañ
	sti
; zakoñczenie programu
	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij