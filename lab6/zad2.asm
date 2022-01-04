; Program gwiazdki.asm
; Wy�wietlanie znak�w * w takt przerwa� zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zako�czenie programu po naci�ni�ciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; procedura obs�ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u�ywanych rejestr�w
	push ax
	push bx
	push es
; wpisanie adresu pami�ci ekranu do rejestru ES - pami��
; ekranu dla trybu tekstowego zaczyna si� od adresu B8000H,
; jednak do rejestru ES wpisujemy warto�� B800H,
; bo w trakcie obliczenia adresu procesor ka�dorazowo mno�y
; zawarto�� rejestru ES przez 16
	mov bl, cs:przerwanie
	inc bl
	mov cs:przerwanie, bl

	mov ax, 0B800h ;adres pami�ci ekranu
	mov es, ax
; zmienna 'licznik' zawiera adres bie��cy w pami�ci ekranu
	mov bx, cs:licznik
; przes�anie do pami�ci ekranu kodu ASCII wy�wietlanego znaku
; i kodu koloru: bia�y na czarnym tle (do nast�pnego bajtu)
	mov byte PTR es:[bx], '*' ; kod ASCII
	mov byte PTR es:[bx+1], 00000111B ; kolor
; zwi�kszenie o 2 adresu bie��cego w pami�ci ekranu
	add bx,2
; sprawdzenie czy adres bie��cy osi�gn�� koniec pami�ci ekranu
	cmp bx,4000
	jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie��cego, gdy ca�y ekran zapisany
	mov bx, 0
;zapisanie adresu bie��cego do zmiennej 'licznik'
	wysw_dalej:
	mov cs:licznik,bx
; odtworzenie rejestr�w
	pop es
	pop bx
	pop ax
; skok do oryginalnej procedury obs�ugi przerwania zegarowego
	jmp dword PTR cs:wektor8
; dane programu ze wzgl�du na specyfik� obs�ugi przerwa�
; umieszczone s� w segmencie kodu
	licznik dw 0 ; wy�wietlanie pocz�wszy od 2. wiersza
	wektor8 dd ?
	przerwanie db 0
obsluga_zegara ENDP

klawiatura PROC

	in al, 60h
	cmp al, 45
	je ustaw
	jmp brak
ustaw:
	mov cs:przerwij, byte PTR 1

brak:
	jmp dword PTR cs:wektor9
	wektor9 dd ?
	przerwij db 0
klawiatura ENDP
;============================================================
; program g��wny - instalacja i deinstalacja procedury
; obs�ugi przerwa�
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
mov al, 0
    mov ah, 5
    int 10
    mov ax, 0
    mov ds, ax

    ; odczytanie zawartoci wektora nr 8 i zapisanie go w zmiennej 'wektor8'
    ; (wektor nr 8 zajmuje w pamici 4 bajty poczwszy od adresu fizycznego 8 * 4 = 32) 
    mov    eax,ds:[32]  ; adres fizyczny 0*16 + 32 = 32 
    mov    cs:wektor8, eax   
     
    ; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara' 
    mov    ax, SEG obsluga_zegara ; cz segmentowa adresu 
    mov    bx, OFFSET obsluga_zegara  ; offset adresu 
 
    cli    ; zablokowanie przerwa  
 
    ; zapisanie adresu procedury do wektora nr 8 
    mov    ds:[32], bx   ; OFFSET           
    mov    ds:[34], ax   ; cz. segmentowa 
 
    sti     

    mov    eax,ds:[36] 
    mov    cs:wektor9, eax   



    mov    ax, SEG klawiatura    
	mov    bx, OFFSET klawiatura 
 
    cli   
 
    mov  ds:[36], bx      
    mov  ds:[38], ax   
 
    sti 


	aktywne_oczekiwanie:
	cmp cs:przerwanie, 120
	jae koniec
	cmp cs:przerwij, 1
	je koniec
	jmp aktywne_oczekiwanie

; deinstalacja procedury obs�ugi przerwania zegarowego
; odtworzenie oryginalnej zawarto�ci wektora nr 8
koniec:
    mov    eax, cs:wektor8 
    cli 
    mov    ds:[32], eax  ; przes�anie wartoci oryginalnej do 
                         ; wektora 8 w tablicy wektor�w przerwa 
    sti 
 
    ; odtworzenie oryginalnej zawartoci wektora nr 8 
    mov    eax, cs:wektor9
    cli 
    mov    ds:[36], eax  ; przes�anie wartoci oryginalnej do 
                         ;wektora 8 w tablicy wektor�w przerwa 
    sti 
; zako�czenie programu
	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij
