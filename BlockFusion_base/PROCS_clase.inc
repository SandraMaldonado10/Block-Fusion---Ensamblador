;*************************************************************************************                                                                                                                        
;****************** procedimientos implementados en clase **************************** 
;************  PUEDES REEMPLAZARLOS POR LOS TUYOS SI MISMAS E/S  *********************                                                                                                                       
;************************************************************************************* 
                                                                                                                      
  ;F: transforma fil col de una matriz de COLSJUEGO columnas en una posicion de vector
  ;E: COLSJUEGO, 'filMatriz' y 'colMatriz' (db)
  ;S: 'posMatriz' (dw)
  MatrizAVector proc
	push ax

	mov al, COLSJUEGO
	mul filMatriz
    
    add al, colMatriz
	mov posMatriz, ax
    
	pop ax
    ret
  MatrizAVector endp


  ;F: transforma una posicion de vector en el equivalente en una matriz de NBITSREG columnas (fila / columna)
  ;E: COLSJUEGO y 'posMatrizJuego' (dw)
  ;S: 'filMatrizJuego' y  'colMatrizJuego'
  VectorAMatriz proc
	push ax
	push dx

	mov ax, posMatriz
	mov dl, COLSJUEGO
	div dl

	mov filMatriz, al
	mov colMatriz, ah

    pop dx
    pop ax
    ret
  VectorAMatriz endp        

     
  ;F: Copia un vector de tipo word de CX elementos en otro del mismo tipo y tamaño
  ;E: SI indice al vector origen
  ;   DI indice al vector destino
  ;   CX numero de elementos a copiar
  ;S: se modifica el contenido del vector apuntado por DI
  CopiarVector proc
	push ax
	push cx   ;loop
	push si
	push di

	ciclo:
	  mov ax, [si]
	  mov [di], ax
	  add si,2
	  add di,2
	loop ciclo

	pop di
	pop si
	pop cx
	pop ax
	ret
  CopiarVector endp


  ;F: pone a 0 los primeros CX elementos de un vector de tipo word
  ;E: DI puntero al vector 
  ;   CX numero de posiciones a borrar
  ;S: se modifica el contenido del vector apuntado por DI
  BorrarVector proc
    push cx ;loop
    push di
    
   limpiar:
	  mov [di], word ptr 0; no es suficiente mov [di],0 , que solo pone la parte baja a 0
	  add di,2
    loop limpiar

    pop di
    pop cx 
    ret
  BorrarVector endp

  ;F: Pinta en la pantalla TableroJuego   
  ;E: FILINICIOTAB, COLINICIOTAB (EQU) posicíon donde imprimir el contenido de la 1ra celda del tablero   
  ;E: tableroJuego (vector DB) y sus dimensiones como matriz FILJUEGO y COLJUEGO (EQU)
  ;E: fil y col para usar ColocarCursor
  ;E: cad y cadVacia (cadenas DB) para usar con ImprimirCadena
  ;S: pantalla
  PintarTableroJuego  PROC
    push ax
    push bx
    push cx
    push dx
    push si

    lea si, tableroJuego
      
    mov fil, FILINICIOTAB ;primera fila de la pantalla de juego
    xor bx, bx  
    mov cx, FILSJUEGO
     
   sigueFil:
    push cx
    mov col, COLINICIOTAB ; primera columna de la pantalla de juego 
    mov cx, COLSJUEGO 
 
   sigueCol:
    call ColocarCursor
    lea dx, cadVacia
    call ImprimirCadena
    call ColocarCursor 

    mov ax, [si+bx] 
    cmp ax, 0
    je siguecelda 
       
    lea dx, cad
    call NumeroACadena
    call imprimirCadena
      
   siguecelda:
    add bx, 2  
    add col, 6    ; se mueve por la misma fila
    loop sigueCol

    pop cx
    mov col, COLINICIOTAB 
    add fil, 3    ; cambia a la fila siguiente
  
    loop sigueFil
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret 
  PintarTableroJuego ENDP    
