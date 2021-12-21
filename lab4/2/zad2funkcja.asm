.686
.model flat
public _check_system_dir
extern _GetSystemDirectoryA@8 : PROC

.code

_check_system_dir PROC
	push	ebp
	mov		ebp, esp
	sub		esp, 24
	push	ebx
	push	esi
	push	edi
	
	mov		eax, [ebp+8]
	mov		ebx, 24
	push	ebx
	lea		eax, [ebp-24]
	push	eax
	call	_GetSystemDirectoryA@8 
	
	mov		ecx, eax
	mov		ebx, 0
	mov		edx, 0

ptl:
	lea		esi, [ebp-24+ebx]
	mov		al, [esi]
	mov		edi, [ebp+8]
	add		edi, ebx
	mov		dl, [edi]
	cmp		al, dl
	jne		zero
	add		ebx, 1
	loop	ptl

	mov		eax, 1
	jmp koniec

zero:
	mov		eax, 0

koniec:
	add		esp, 24
	pop		edi
	pop		esi
	pop		ebx
	pop		ebp
	ret
_check_system_dir ENDP
END