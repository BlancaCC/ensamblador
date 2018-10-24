/*
	Media con signo
	Blanca Cano 
	*/
	.section .data
lista:	.int 1,3,-2,10
longlista:	.int (.-lista)/4
media:	.int
resto:	.int
formato:	.ascii "La media optendia ha sido %i, y de resto %i \n\0"

	.section .text
main:	.global main

	mov $lista, %ebp #COMIENZO LISTA
	mov longlista, %edi #longitud de la lista

	call suma

	idiv %edi
	mov %eax, media
	mov %edx, resto

	push media
	push resto
	push $formato
	call printf
	add $12, %esp

	# convenio de interrucción

	mov $1, %eax
	mov $0, %ebx
	int $0x80
	

suma:
	#inilización de registro y guardado de datos
	#ebp inicio lista y edi longitud
	
	push %esi
	push %ebx
	
	mov $0, %eax #parte menos significa
	mov $0,	%edx #acarrero
	mov $0, %esi # CONTADOR
	mov $0, %ecx # guardo eax
	mov $0, %ebx #guardo edx

bucle:
	mov (%ebp, %esi, 4), %eax

	cltd
	add %eax, %ecx
	adc %edx, %ebx

	inc %esi
	cmp %esi, %edi
	jne bucle

	mov %ecx, %eax
	mov %ebx, %edx

	
	
	pop %esi
	pop %ebx

ret
