/*
	Suma con signo de 64 bits en una arquitectura de 32bits
	Blanca Cano Camarero 
	*/

	.section .data
lista:	.int -1,-1,-1
longlista:	.int(.-lista)/4
resultado:	.quad  
formato:	.ascii "El resultado de la suma %i \n\0"

	.section .text
main:	.global main

	mov $lista, %ebx 	# DIR primer dígito de la lista
	mov longlista, %esi 	# LONGITUD lista

	call suma
	mov %eax, resultado
	mov %edx, resultado+4

	#imprimir
	push resultado
	push resultado
	push $formato
	call printf
	add $12, %esp

	#interrupción del sistema principal

	mov $1, %eax
	mov $0, %ebx
	int $0x80

suma:
	#edx:eax contendrá el resutlado
	# esi, contiene el máximo de la lista
	
	push %ebp
	push %edi

	mov $0, %ecx 	# eax -> ecx, parte menos significa
	mov $0, %ebp 	# edx -> ebp, parte más significativa
	mov $0, %edi 	# CONTADOR de la lista
	mov $0, %eax
	mov $0, %ecx

bucle:	
	mov (%ebx,%edi,4), %eax
	
	cltd 		# extensión para signo edx:eax
	add %eax, %ecx	# Parte menosn significa
	adc %edx, %ebp  # parte con acarrero

	inc %edi
	cmp %edi, %esi
	
	jne bucle

	mov %ecx, %eax
	mov %ebp, %edx

	pop %ebp
	pop %edi
ret 	
