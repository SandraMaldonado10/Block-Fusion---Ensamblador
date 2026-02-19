 ; EQUIVALENCIAS USADAS PARA LA ESTRUCTURA DE MATRIZ
 FILSJUEGO     EQU 7
 COLSJUEGO     EQU 5
 TOTALCELDAS   EQU FILSJUEGO*COLSJUEGO 

 ;EQUIVALENCIAS DE COORDENADAS PARA PINTAR EN PANTALLA (FIL, COL)  
 FILMSJMODO    EQU 20  ; posicion msj modo inicial (DEMO o Juego) 
 COLMSJMODO    EQU 5 

 FILMSJPOT     EQU 22   ; posicion msj numero tope con el que jugar
 COLMSJPOT     EQU 5 

 FILENTPOT     EQU FILMSJPOT   ; posicion para pedir el numero tope con el que jugar
 COLENTPOT     EQU COLMSJPOT+60 

 FILPANTALLAJ  EQU 1   ; posicion para imprimir pantTablero
 COLPANTALLAJ  EQU 0

 FILINICIOTAB  EQU 3   ; posicion contenido 1ra celda del tablero
 COLINICIOTAB  EQU 5   
  
 FILMSJGNRAL   EQU 20  ; posicion msjs introduce un comando, ganar, perder y salir 
 COLMSJGNRAL   EQU 43    
 
 FILCOMANDO    EQU FILMSJGNRAL  ; posicion introducir comando
 COLCOMANDO    EQU COLMSJGNRAL+10 
  

data segment        
   comando   db 22 dup ('$')  ;contendra el comando de entrada
   
   ;La estructura que almacena el tablero de juego 
   TableroJuego      dw TOTALCELDAS dup(?) ;contiene los datos del tablero en el momento actual
   TableroJuegoDebug dw 0,0,0,0,0,0,4,2,8,2,0,8,4,2,2,0,2,2,2,2,0,8,2,8,8,0,2,2,8,2,0,8,4,2,16  ;matriz con datos precargados
   
   fil       db ? ; para ColocarCursor
   col       db ? 

   colMatriz db ? ; para VectorAMatriz y MatrizAVector
   filMatriz db ?            
   posMatriz dw ? 
   
   tope      dw ? ; valor maximo hasta el que se jugara 
      
   ;**************************CADENAS ********************************
   cad       db 5 dup(?)  ;para almacenar el numero de una celda tras convertirlo a cadena
   cadVacia  db "     $"  ;para borrar el numero de una celda
   cadTope db 7 dup ('$')    
         
   ;Mensajes de Interfaz                      
   msjModo    db "Entrar al juego en modo Debug - tablero precargado - (S/N)? $"  
   msjIntPot  db "Introduce un valor potencia de 2, entre 16 y 2048 (incls.): $"  

   msgBlancoLargo db 19 dup (' '),'$'   ;para borrar comandos incorrectos
    
   msjPartidaGanada      db "Has ganado la partida!  ;-)  $" 
   msjPartidaPerdida     db "Has perdido! ;-(  $"

   PantallaInicio        db 10, 13, 10  
db " _______   ___        ______    ______   __   ___",10,13 
db "|   _   \ |   |      /      \  /  _   \ |  | /   )",10,13
db "(. |_)  :)||  |     // ____  \(: ( \___)(: |/   /",10,13  
db "|:     \/ |:  |    /  /    ) :)\/ \     |    __/",10,13   
db "(|  _  \\  \  |___(: (____/ // //  \ _  (// _  \",10,13   
db "|: |_)  :)( \_|:  \\        / (:   _) \ |: | \  \",10,13  
db "(_______/  \_______)\ _____/   \_______)(__|  \__)",10,10,13
db "            _______  ____  ____   ________  __      ______    _____  ___",10,13
db "           /       |(   _||_   | /        )|  \    /      \  (\    \|   \",10,13
db "          (: ______)|   (  ) : |(:   \___/ ||  |  // ____  \ |.\\   \    |",10,13
db "           \/    |  (:  |  | . ) \___  \   |:  | /  /    ) :)|: \.   \\  |",10,13
db "           // ___)   \\ \__/ //   __/  \\  |.  |(: (____/ // |.  \    \. |",10,13
db "          (:  (      /\\ __ //\  /  \   :) /\  |\\        /  |    \    \ |",10,13
db "           \__/     (__________)(_______/ (__\_|_)\______/    \___|\____\)",10,13,'$' 

  
   pantTablero db "    |__1__|__2__|__3__|__4__|__5__|     -= COMANDOS =-",10,13
               db "    |     |     |     |     |     |" ,10,13
               db "   A|     |     |     |     |     |" ,10,13         
               db "    |_____|_____|_____|_____|_____|     Introduce 1ro una fila y columna de" ,10,13
               db "    |     |     |     |     |     |     origen, deja un espacio y luego usa" ,10,13
               db "   B|     |     |     |     |     |     las siguientes letras hasta llegar" ,10,13         
               db "    |_____|_____|_____|_____|_____|     al bloque de destino" ,10,13     
               db "    |     |     |     |     |     |" ,10,13
               db "   C|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|     Dcha  :D           Pasar       :P",10,13     
               db "    |     |     |     |     |     |" ,10,13
               db "   D|     |     |     |     |     |     Izq   :A",10,13
               db "    |_____|_____|_____|_____|_____|" ,10,13         
               db "    |     |     |     |     |     |     Abjo  :S           Nuevo Juego :N",10,13
               db "   E|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|     Arrb  :W           Salir       :E",10,13           
               db "    |     |     |     |     |     |" ,10,13
               db "   F|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|" ,10,13          
               db "    |     |     |     |     |     |        Comando>>" ,10,13
               db "   G|     |     |     |     |     |" ,10,13
               db "    |_____|_____|_____|_____|_____|",'$'
data ends


code segment
  include "PROCS_std.inc"  
  include "PROCS_clase.inc"

;*************************************************************************************                                                                                                                        
;*************************     procedimientos de IU    *******************************
;*************************************************************************************  

  
;*************************************************************************************                                                                                                                        
;**********************    procedimientos de funcionlidad    *************************
;*************************************************************************************    
  

;************************ PROGRAMA PRINCIPAL ***************
principal:
    mov ax, data
    mov ds, ax         


      
    mov ah, 4ch
    int 21h        
 ends 
end principal   
     