.686
.model flat
.xmm

public _dziel

.data 
	align		16
	dzielnik	dd 4 dup (?)

.code

_dziel PROC
	push	ebp								; prolog
	mov		ebp, esp
	push	ebx
	push	edi

	mov		ebx, [ebp+20]					; float dzielnik		[adres, n, starsza czesc double , mlodsza czesc]
	mov		edi, 0							; iterator
	mov		ecx, 4
	mov		eax, offset dzielnik

petla_dzielnika:							; ustawianie dzielnika
	mov		[eax+4*edi], ebx
	inc		edi
	loop	petla_dzielnika

	mov		eax, [ebp+8]					; wskaznik na tablice __m128
	mov		ecx, [ebp+12]					; dlugosc tablicy
	mov		edi, 0							; iterator tablicy

	movaps	xmm1, xmmword ptr dzielnik		; wstawienie dzielnika do xmm1
	
petla:
	movups	xmm0, [eax+4*edi]				; dzielenie w programie
	divps	xmm0, xmm1
	movups	[eax+4*edi], xmm0
	add		edi, 4
	loop petla

	pop		edi
	pop		ebx
	pop		ebp
	ret
_dziel ENDP
END