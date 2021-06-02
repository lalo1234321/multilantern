.ORG      0x00

rjmp      INICIO    ;rjmp: salto relativo


INICIO: ;Etiqueta

ldi  R16,low(RAMEND)               ;ldi carga instantanea
out  SPL,R16                      ;out port // puerto externo
ldi  r16,HIGH(RAMEND)
out  SPH,R16

;PORTB= pb7 pb6 pb5 pb4 pb4 pb3 pb2 pb1 pb0
;        0   0   0   0   0   0   0   0   0    0x00
;        1   1   1   1   1   1   1   1   1    0xFF
ldi R28, low(RAMEND)
;ldi R26, high(RAMEND)
ldi R28, 0
;ldi R26, 1



ldi  R16, 0xFF                    ;almacena en R16 el valor de 0xFF
out  DDRB,R16                     ;Declara al puerto B como salida

cbi DDRD, 7 ;Declara a PD7 como entrada

;----------------------------------------------------------------------------------------------
;Programam principal 
main:
	sbi PORTD, 7
	cbi PORTB, 0
	cbi PORTB, 1
cicle:
	sbis PIND, 7; Salta si el botón no es presionado
	rjmp compare
	
	adiw R28, 1
	;RCALL PAUSA_0P016s
	RCALL PAUSA_0P5s
	rjmp cicle

compare:
	cpi R28, 1
	

	breq then
	cpi R28, 2
	breq then1
	cpi R28, 3
	breq then2
	cpi R28, 4
	breq then3
else: 
	ldi R28, 0
	cbi PORTB, 0
	cbi PORTB, 1
	cbi PORTB, 2
	cbi PORTB, 3
	jmp done
then: 
	;RCALL PAUSA_0P5s
	sbi PORTB,0
	;RCALL PAUSA_0P016s
	;RCALL PAUSA_0P5s
	cbi PORTB,1
	;RCALL PAUSA_0P5s
	jmp done
then1:
	sbi PORTB,0
	sbi PORTB,1
	
	jmp done
then2:
	sbi PORTB, 0
	sbi PORTB, 1
	sbi PORTB, 2
	jmp done
then3:
	sbi PORTB, 0
	sbi PORTB, 1
	sbi PORTB, 2
	sbi PORTB, 3
	RCALL PAUSA_0P6s
	;RCALL PAUSA_0P6s
	cbi PORTB, 3
	RCALL PAUSA_0P6s
	jmp done
done:
	jmp cicle

rjmp main

;----------------------------------------------------------------------------------------------
;rutinas o subprogramas 
;2.28
PAUSA_0P5s:
ldi R20,10
LOOP:
  PAUSA_0P016s:
  adiw R24,1             ;suma de inmediato a la plabra(2bites=16bits) suma el valor de 1 a R24 y R25(2 ciclos de reloj) 
  brne PAUSA_0P016s        ;si no es igual a 0 salta a PAUSA_0P016s(2 ciclos), si el
                       ;4*65535=262,140*0.0000000625=0.016s

					   ;4*65535+2+1=262,143;(8 000 000)/262,143=30.517, 30 o 31
					   ;(262,143)*(30*0.0000000625)=0.49
					   ;(262,143)*(31*0.0000000625)=0.5
                       ;resultado es cero continua a la siguiente linea(1 ciclo)

dec R20
brne LOOP
ret

PAUSA_0P6s:
ldi R20,170
LOOP1:
  PAUSA_0P016s1:
  adiw R24,1             ;suma de inmediato a la plabra(2bites=16bits) suma el valor de 1 a R24 y R25(2 ciclos de reloj) 
  brne PAUSA_0P016s1        ;si no es igual a 0 salta a PAUSA_0P016s(2 ciclos), si el
                       ;4*65535=262,140*0.0000000625=0.016s

					   ;4*65535+2+1=262,143;(8 000 000)/262,143=30.517, 30 o 31
					   ;(262,143)*(30*0.0000000625)=0.49
					   ;(262,143)*(31*0.0000000625)=0.5
                       ;resultado es cero continua a la siguiente linea(1 ciclo)

dec R20
brne LOOP1
ret