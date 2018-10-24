.section .data
lista:		.int 1,2,10, -20#,  1,2,0b10,  1,2,0x10
longlista:	.int (.-lista)/4
resultado:	.quad 0x0123456789ABCDE  #.quad por tratartse de un valor de 64B, se inicializa con un valor cualquiera
formato:	 .ascii "suma = %u = %x hex\n\0"


.section .text
main:	 .global main    #se escribe main porque vamos a compilar con gcc -o z

	mov    $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %eax, resultado
	mov %edx, resultado + 4

	## para imprimir en pantalla
	push resultado 	
	push resultado
	push $formato
	call printf
	add $12 , %esp
	
	#interrucciones para devolver el control al sistema principal
	mov $1, %eax
	mov $0, %ebx
	int $0x80 

suma:
push %ebp							#Se le hace un push a %ebp para usarlo en la función preservando su valor.
									#Se inicializan a 0 los registros que usaremos.
	mov $0, %eax	#miembro de la lista
	mov $0, %edi	#Acumulador de acarreos
	mov $0, %edx	#EAX extendido
	mov $0, %esi	#Iterador
	mov $0, %ebp	#Acumulador

bucle:									#Bucle usado para hacer la suma.

	mov (%ebx,%esi,4), %eax						#Se guarda en %eax lo que haya en la posición de memoria
									#%ebx+4*%esi, recordemos que %ebx guarda la dirección de inicio de lista y
									#%esi es el índice.
	cdq								#cdq extiende por defecto %eax a EDX:EAX, se usa para la doble precisión.
	add %eax, %ebp							#Se suman las cifras menos significativas al acumulador
	adc %edx, %edi							#Se suman las cifras más significativas y el acarreo al acumulador de acarreos

	inc       %esi							#Incremento del índice
	cmp  %esi,%ecx							#Condición de salida del bucle, equiparable a indice==longlista en C.
	jne bucle
	
	mov %edi, %edx							#Se coloca el valor provisional de la suma en EDX:EAX
	mov %ebp, %eax
	
	pop %ebp							#Se le hace un pop a %ebp para recuperar su valor antes de ser llamado por
									#función.
ret	
