[org 0x100]
jmp start

scoreMessage: db 'Score = '
timeMessage: db 'Time = '
nextBMessage: db 'Next Block'
score: dw 0
num : db ' '
sen1: db ' < Welcome   to   Tetrus > '
len1: dw 27
num2 : db '*'
num3 : db '-'
num4 : db '|'
endscrstr1: db ' TIME = '
endscrstr1len: dw 8
endscrstr2: db ' SCORE = '
endscrstr2len: dw 9
border: db "----*----*----*----*----*----*----"
borderlen : dw 29


currpos: dw 0
base: times 840 dw 0
index: dw 0
leftlim: times 20 dw 0
rightlim: times 20 dw 0
upperlim: times 40 dw 0
currshape: dw 0        ; 0 square , 1 plus , 2 L , 3 vertical line
nextshape: dw 1
Iver1: dw 1
Iver2: dw 0
Lver1: dw 1
Lver2: dw 0
Lver3: dw 0
Lver4: dw 0
boundary: times 10 dw 0      ; to store di values covered by current block
flag: dw 0
endgame: dw 0
rowsdis: times 21 dw 0


tickcount: dw 0
min1: dw 0
min2: dw 0
sec1: dw 0
sec2: dw 0

timerflag: dw 0
rowcompleteflag: dw 0




;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
			

printnum: 		push bp
			mov bp, sp
			push es
			push ax
			push bx
			push cx
			push dx
			push di
			
			
			mov ax, 0xb800
			mov es, ax 
			mov ax, [bp+4] 
			mov bx, 10 
			mov cx, 0 
			
			
nextdigit: 		mov dx, 0 
			div bx 
			add dl, 0x30
			push dx 
			inc cx 
			cmp ax, 0 
			jnz nextdigit
			mov di, [bp+6]
			
			
nextpos: 		pop dx 
			mov dh, 0x07 
			mov [es:di], dx 
			add di, 2 
			loop nextpos 
			
			
			pop di
			pop dx
			pop cx
			pop bx
			pop ax
			pop es
			pop bp
			ret 4
		
		
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
	
timer: 			push ax

			cmp word[cs:timerflag],0
			je near backk
			
			inc word [cs:tickcount]; increment tick count
			cmp word[cs:tickcount],18
			jne skip
			
			mov word[cs:tickcount],0
			inc word[cs:sec2]
			cmp word[cs:sec2],10
			jne skip
			
			mov word[cs:sec2],0
			inc word[cs:sec1]
			cmp word[cs:sec1],6
			jne skip
			
			mov word[cs:sec1],0
			inc word[cs:min2]
			
			cmp word[min2],5
			jne skip
			
			mov word[cs:endgame],1
		
skip:			mov ax,756
			push ax
			mov ax,[cs:min1]
			push ax
			call printnum
		
		
			mov ax,758
			push ax
			mov ax,[cs:min2]
			push ax
			call printnum
			
			mov ax,0xb800
			mov es,ax
			mov ah,0x07
			mov al,':'
			mov word[es:760],ax
			mov ax,762
			push ax
			mov ax,[cs:sec1]
			push ax
			call printnum
			
			
			mov ax,764
			push ax
			mov ax,[cs:sec2]
			push ax
			call printnum
		
		
		
backk:			mov al, 0x20
			out 0x20, al ; end of interrupt
			pop ax
			iret ; return from interrupt	                         

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------


delay: 			push bp
                        mov bp,sp
                        push cx
                        push ax
                        
                        mov cx,0xffff
                        
delayloop:              mov ax,10
                        add ax,5
                        loop delayloop
                        
                        pop ax
                        pop cx
                        pop bp
                        
                        ret

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------

delay2:                 push bp
                        mov bp,sp
                        push cx
                   
                        
                        mov cx,[bp+4]
                        
delayloop2:             call delay
                        loop delayloop2
                        
                        pop cx
                        pop bp
                        
                        ret 2


;------------------------------------------------------------------------------------------------------------------------------------------------------------------------


clrscr: 		push bp
                        mov bp,sp
			push es
			push ax
			push di
			mov ax, 0xb800
			mov es, ax 					; point es to video base
			mov di, 0 					; point di to top left column
			mov ax,[bp+4]
			nextloc: mov [es:di], ax     		        ; clear next char on screen
			add di, 2 					; move to next screen location
			cmp di, 4000 					; has the whole screen cleared
			jne nextloc 					; if no clear next position
			pop di
			pop ax
			pop es
			pop bp
			ret 2
			
			
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


printstr: 		push bp
			mov bp, sp
			push es
			push ax
			push cx
			push si
			push di
			
			mov ax, 0xb800
			mov es, ax 
		
			mov di, [bp+8] 					; point di to passed parameter di value
			mov si, [bp+6] 					; point si to string
			mov cx, [bp+4] 	
			mov ax,[bp+10]                                  ; colour in ax
			
			
nextchar: 		mov al, [si] 					; load next char of string
			mov [es:di], ax 				; show this char on screen
			add di, 2 					; move to next screen location
			add si, 1 					; move to next char in string
			loop nextchar 					; repeat the operation cx times
			
			
			pop di
			pop si
			pop cx
			pop ax
			pop es
			pop bp
			ret 8


;------------------------------------------------------------------------------------------------------------------------------------------------------------------------

printbox:               push bp
                        mov bp,sp
                        push ax
                        push di
                        push es
                        
                        
                        mov ax,0xb800
                        mov es,ax
                        
                        mov di,[bp+4]
                        mov ax,[bp+6]
                        
                        mov [es:di],ax
                        
                        add di,2
                        
                        mov [es:di],ax
                        
                        
                        
                        pop es
                        pop di
                        pop ax
                        pop bp
                        
                        ret 4


;------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; receives di value as parameter (di val where we want to sttart printing I
printI:         	push bp
                	mov bp,sp
                	push ax
                	push di
                	push es
                
                
                        cmp word[Iver2],1
                        je vv2
                
                	mov di,[bp+4]
                	
                	
                        mov ax,0x4720
                        push ax
                        mov di,[bp+4]
                        push di
                        call printbox
                        
                            
                        
                	add di,160
                	;mov ax,0x5720
                	push ax
                	push di
                	call printbox
                
                	
                
                
                	add di,160
                	;mov ax,0x6720
                	push ax
                	push di
                	call printbox
                	jmp endy
                
                	
vv2:			mov di,[bp+4]
                	
                	
                        mov ax,0x4720
                        push ax
                        mov di,[bp+4]
                        push di
                        call printbox
                        
                            
                        
                	add di,4
                	;mov ax,0x5720
                	push ax
                	push di
                	call printbox
                
                	
                
                
                	sub di,8
                	;mov ax,0x6720
                	push ax
                	push di
                	call printbox

          
                
endy:                	pop es
                	pop di
                	pop ax
                	pop bp
                
                	ret 2

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------

printL:         	push bp
                	mov bp,sp
                	push ax
                	push di
                	push es
                
                	
                	mov di,[bp+4]
                	
                	cmp word[Lver1],1
                	jne xx1
                	
                        mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	add di,160
                        ;mov ax,0x1720
                        push ax
                        push di
                        call printbox
                        
                        
                
                	add di,4
                	;mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	jmp xend
                	
xx1:                    cmp word[Lver2],1
                        jne xx2
                        
                        mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	add di,160
                        ;mov ax,0x1720
                        push ax
                        push di
                        call printbox
                        
                        
                
                	sub di,156
                	;mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	jmp xend
                	
        
        
xx2:                    cmp word[Lver3],1
			jne xx3
			
			
                	mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	add di,4
                        ;mov ax,0x1720
                        push ax
                        push di
                        call printbox
                        
                        
                
                	add di,160
                	;mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	jmp xend
                	
                
xx3:                    add di,4

			mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	add di,160
                        ;mov ax,0x1720
                        push ax
                        push di
                        call printbox
                        
                        
                
                	sub di,4
                	;mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	
                
xend:                	pop es
                	pop di
                	pop ax
                	pop bp
                	

                
                	ret 2

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                
 printSQ:       	push bp
                	mov bp,sp
                	push ax
                	push di
                	push es
                
                
                	
                	
                	mov di,[bp+4]
                        
                        
                        mov ax,0x6720
                        push ax
                        push di
                        call printbox
                        
                        
                        
                        add di,4
                	;mov ax,0x1720
                	push ax
                	push di
                	call printbox
                	
                	
                	
                        
                        add di,160
                	;mov ax,0x5720
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	
                	sub di,4
                	;mov ax,0x1720
                	push ax
                	push di
                	call printbox
                
                
                	pop es
                	pop di
                	pop ax
                	pop bp
                
                	ret 2 

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------


printPLUS:              push bp
                	mov bp,sp
                	push ax
                	push di
                	push es
                
                
                	mov ax,0x5720
                	mov di,[bp+4]
                        push ax
                        push di
                        call printbox
                        
                        
        
                	add di,160
                        ;mov ax,0x6720
                        push ax
                        push di
                        call printbox
                
               	 	
                
                	sub di,4
                	;mov ax,0x4720
                        push ax
                        push di
                        call printbox
                        
                        
                        
                        add di,8
                	;mov ax,0x5720
                        push ax
                        push di
                        call printbox
                	
                	
                	
                	add di,156
                	;mov ax,0x2720
                	push ax
                        push di
                        call printbox
                	
                
                
                	pop es
                	pop di
                	pop ax
                	pop bp
                
                	ret 2 

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------


clearI:         	push bp
                	mov bp,sp
                	push ax
                	push di
                	push es
                
                
                        cmp word[Iver2],1
                        je cvv2
                
                	mov di,[bp+4]
                	
                	
                        mov ax,0x0020
                        push ax
                        mov di,[bp+4]
                        push di
                        call printbox
                        
                            
                        
                	add di,160
                	;mov ax,0x5720
                	push ax
                	push di
                	call printbox
                
                	
                
                
                	add di,160
                	;mov ax,0x6720
                	push ax
                	push di
                	call printbox
                	jmp cendy
                	
cvv2:			mov di,[bp+4]
                	
                	
                        mov ax,0x0020
                        push ax
                        mov di,[bp+4]
                        push di
                        call printbox
                        
                            
                        
                	add di,4
                	;mov ax,0x5720
                	push ax
                	push di
                	call printbox
                
                	
                
                
                	sub di,8
                	;mov ax,0x6720
                	push ax
                	push di
                	call printbox

                
                
cendy:                	pop es
                	pop di
                	pop ax
                	pop bp
                
                	ret 2


;------------------------------------------------------------------------------------------------------------------------------------------------------------------------

clearL:         	push bp
                	mov bp,sp
                	push ax
                	push di
                	push es
                
                	
                	mov di,[bp+4]
                	
                	cmp word[Lver1],1
                	jne cxx1
                	
                        mov ax,0x0020
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	add di,160
                        ;mov ax,0x1720
                        push ax
                        push di
                        call printbox
                        
                        
                
                	add di,4
                	;mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	jmp cxend
                	
cxx1:                   cmp word[Lver2],1
                        jne cxx2
                        
                        mov ax,0x0020
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	add di,160
                        ;mov ax,0x1720
                        push ax
                        push di
                        call printbox
                        
                        
                
                	sub di,156
                	;mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	jmp cxend
                	
        
        
cxx2:                   cmp word[Lver3],1
			jne cxx3
			
			
                	mov ax,0x0020
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	add di,4
                        ;mov ax,0x1720
                        push ax
                        push di
                        call printbox
                        
                        
                
                	add di,160
                	;mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	jmp cxend
                	
                
cxx3:                   add di,4

			mov ax,0x0020
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	add di,160
                        ;mov ax,0x1720
                        push ax
                        push di
                        call printbox
                        
                        
                
                	sub di,4
                	;mov ax,0x2720
                	push ax
                	push di
                	call printbox
                	
                	
                
cxend:                	pop es
                	pop di
                	pop ax
                	pop bp
                	

                
                	ret 2
                	


;------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                
 clearSQ:       	push bp
                	mov bp,sp
                	push ax
                	push di
                	push es
                
                
                	
                	mov ax,0x0720
                	mov di,[bp+4]
                        
                        
                        
                        push ax
                        push di
                        call printbox
                        
                        
                        
                        add di,4
                	push ax
                	push di
                	call printbox
                	
                	
                	
                        
                        add di,160
                	push ax
                	push di
                	call printbox
                	
                	
                	
                	
                	sub di,4
                	push ax
                	push di
                	call printbox
                
                
                	pop es
                	pop di
                	pop ax
                	pop bp
                
                	ret 2 

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------


clearPLUS:              push bp
                	mov bp,sp
                	push ax
                	push di
                	push es
                
                
                	mov ax,0x0720
                	mov di,[bp+4]
                        push ax
                        push di
                        call printbox
                        
                        
        
                	add di,160
                        push ax
                        push di
                        call printbox
                
               	 	
                
                	sub di,4
                        push ax
                        push di
                        call printbox
                        
                        
                        
                        add di,8
                        push ax
                        push di
                        call printbox
                	
                	
                	
                	add di,156
                	push ax
                        push di
                        call printbox
                	
                
                
                	pop es
                	pop di
                	pop ax
                	pop bp
                
                	ret 2        
                	

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------       
clearboundary:          push bp
                        mov bp,sp
                        push ax
                        push cx
                        push di
                        push es
                        
                        push cs
                        pop es
                        
                        mov di,boundary
                        mov ax,0
                        
                        mov cx,10
                        
                        rep stosw
                        
                        pop es
                        pop di
                        pop cx
                        pop ax
                        pop bp
                        
                        ret
                
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------            
calcboundaryI:         	push bp
                	mov bp,sp
                	push di
                	push si
                	
                        call clearboundary
                
                	mov di,[bp+4]
                	mov si,boundary                     ; si points to the boundary variable  it is a global variable to store boundary dii vallues of current shape
                	
                	cmp word[Iver1],1
                	jne bvv2
                	
                	push di
                        mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di   
                        
                        
                	add di,160
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di     	
                
                
                	add di,160
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                        jmp bend
                        
                        
                        
bvv2:                   push di
                        mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di   
                        
                        
                	add di,4
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di     	
                
                
                	sub di,8
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di
                
bend:                	pop si
                	pop di
                	pop bp
                
                	ret 2
                	

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------

calcboundaryL:         	push bp
                	mov bp,sp
                	push di
                	push si
                
                	call clearboundary
                	
                	mov di,[bp+4]
                	mov si,boundary                     ; si points to the boundary variable  it is a global variable to store boundary dii vallues of current shape
                	
                	
                	cmp word[Lver1],1
                	jne mn1
                	
                	push di
                        mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di   
                        
                        
                	add di,160
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di     	
                
                
                	add di,4
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                        jmp mnend
                        
                        
mn1:                    cmp word[Lver2],1
                	jne mn2
                	
                	push di
                        mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di   
                        
                        
                	add di,160
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di     	
                
                
                	sub di,156
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                        jmp mnend
                        
                        
                        
mn2:                    cmp word[Lver3],1
                	jne mn3
                	
                	push di
                        mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di   
                        
                        
                	add di,4
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di     	
                
                
                	add di,160
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                        jmp mnend
                        
                        
                        
mn3:                    add di,4
			push di
                        mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di   
                        
                        
                	add di,160
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di     	
                
                
                	sub di,4
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                
                
 mnend:               	pop si
                	pop di
                	pop bp
                
                	ret 2
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------                
calcboundarySQ:         push bp
                	mov bp,sp
                	push di
                	push si
                
                	call clearboundary
                	
                	mov di,[bp+4]
                	mov si,boundary                     ; si points to the boundary variable  it is a global variable to store boundary dii vallues of current shape
                	
                	
                	push di
                        mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di   
                        
                        
                	add di,4
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di     	
                
                
                	add di,160
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                        
                        sub di,4
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                        
                
                	pop si
                	pop di
                	pop bp
                
                	ret 2                
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

calcboundaryPLUS:       push bp
                	mov bp,sp
                	push di
                	push si
                	
                	call clearboundary
                
                	
                	mov di,[bp+4]
                	mov si,boundary                     ; si points to the boundary variable  it is a global variable to store boundary dii vallues of current shape
                	
                	
                	push di
                        mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di   
                        
                        
                	add di,160
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di     	
                
                
                	sub di,4
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                        
                        add di,8
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                        
                        
                        add di,156
                	push di
                	mov [si],di
                        add si,2
                        add di,2
                        mov [si],di
                        add si,2
                        pop di 
                
                	pop si
                	pop di
                	pop bp
                
                	ret 2 
                	

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

rotateshaperight:      push bp
                       mov bp,sp
                       push ax
                       
                       
                       mov ax,[bp+4]
                       
                       cmp ax,2 
                       je LROTR
                       
                       cmp ax,3
                       je IROTR
                       

                       jmp oend
                       
                       
LROTR:                 push word[currpos]
                       call clearL
                       push word[currpos]
                       call calcboundaryL
                       
		       cmp word[Lver1],1
                       jne g1
                       mov word[Lver1],0
                       mov word[Lver2],1
                       jmp oend
                       
g1:                    cmp word[Lver2],1
                       jne g2
                       mov word[Lver2],0
                       mov word[Lver3],1
                       jmp oend
                       
g2:                    cmp word[Lver3],1
                       jne g3
                       mov word[Lver3],0
                       mov word[Lver4],1
                       jmp oend                       
                       
g3:                    mov word[Lver4],0
                       mov word[Lver1],1
                       jmp oend    
                       
IROTR:                 push word[currpos]
                       call clearI
                       push word[currpos]
                       call calcboundaryI
                       
                       cmp word[Iver1],1
                       jne g4
                       
                       mov word[Iver1],0
                       mov word[Iver2],1
                       jmp oend
                       
g4:                    mov word[Iver1],1
                       mov word[Iver2],0
                       
                     
                     
oend:                  pop ax
                       pop bp
                       
                       ret 2
                       
                       
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

rotateshapeleft:       push bp
                       mov bp,sp
                       push ax
                       
                       
                       mov ax,[bp+4]
                       
                       cmp ax,2 
                       je LROTL
                       
                       cmp ax,3
                       je IROTL
                       

                       jmp opend
                       
                       
LROTL:                 push word[currpos]
                       call clearL
                       push word[currpos]
                       call calcboundaryL
                       
		       cmp word[Lver1],1
                       jne gg1
                       mov word[Lver1],0
                       mov word[Lver4],1
                       jmp opend
                       
gg1:                   cmp word[Lver2],1
                       jne gg2
                       mov word[Lver2],0
                       mov word[Lver1],1
                       jmp opend
                       
gg2:                   cmp word[Lver3],1
                       jne gg3
                       mov word[Lver3],0
                       mov word[Lver2],1
                       jmp opend                       
                       
gg3:                   mov word[Lver4],0
                       mov word[Lver3],1
                       jmp opend    
                       
IROTL:                 push word[currpos]
                       call clearI
                       push word[currpos]
                       call calcboundaryI
                       
		       cmp word[Iver1],1
                       jne gg4
                       
                       mov word[Iver1],0
                       mov word[Iver2],1
                       jmp opend
                       
gg4:                   mov word[Iver1],1
                       mov word[Iver2],0
                       
                     
                     
opend:                 pop ax
                       pop bp
                       
                       ret 2                      
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

addboundary:           push bp
                       mov bp,sp
                       push ax
                       push bx
                       push cx
                       push si
                       push di
                       push es
                       
                       push cs
                       pop es
                       
                       mov di,base
                       mov si,boundary
                       mov bx,[index]
                       shl bx,1
                       add di,bx
                       mov cx,0
                       
hello:                 cmp word[si],0
                       je skipp
                       
                       lodsw
                       stosw
                       
                       inc cx
                       
                       jmp hello
                       
                       

skipp:                 add word[index],cx
                       pop es
                       pop di
                       pop si
                       pop cx
                       pop bx
                       pop ax
                       pop bp
                       
                       ret
                       
                       
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


printShape:            push bp
                       mov bp,sp
                       push ax
                       
                       mov ax,[bp+4]         ;; shape number
                       
                       cmp ax,0
                       je e1
                       cmp ax,1
                       je e2
                       cmp ax,2
                       je e3
                       cmp ax,3
                       je e4
                       
e1:                    push word[bp+6]
                       call printSQ
                       jmp fin
                       
e2:                    push word[bp+6]
                       call printPLUS
                       jmp fin

e3:                    push word[bp+6]
                       call printL
                       jmp fin
                       
e4:                    push word[bp+6]
                       call printI 
                   
                       
fin:                   pop ax
                       pop bp
                       
                       ret 4
                       
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


clearShape:            push bp
                       mov bp,sp
                       push ax
                       
                       mov ax,[bp+4]         ;; shape number
                       
                       cmp ax,0
                       je ee1
                       cmp ax,1
                       je ee2
                       cmp ax,2
                       je ee3
                       cmp ax,3
                       je ee4
                       
ee1:                   push word[bp+6]
                       call clearSQ
                       jmp finn
                       
ee2:                   push word[bp+6]
                       call clearPLUS
                       jmp finn

ee3:                   push word[bp+6]
                       call clearL
                       jmp finn
                       
ee4:                   push word[bp+6]
                       call clearI
                      
                       
finn:                  pop ax
                       pop bp
                       
                       ret 4
                       
                       
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------            

calcboundaryShape:     push bp
                       mov bp,sp
                       push ax
                       
                       mov ax,[bp+4]         ;; shape number
                       
                       cmp ax,0
                       je eee1
                       cmp ax,1
                       je eee2
                       cmp ax,2
                       je eee3
                       cmp ax,3
                       je eee4
                       
eee1:                  push word[bp+6]
                       call calcboundarySQ
                       jmp finnn
                       
eee2:                  push word[bp+6]
                       call calcboundaryPLUS
                       jmp finnn

eee3:                  push word[bp+6]
                       call calcboundaryL
                       jmp finnn
                       
eee4:                  push word[bp+6]
                       call calcboundaryI
                      
                       
finnn:                 pop ax
                       pop bp
                       
                       ret 4
                       
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------                    
                       
                       
checkmovposs:           push bp
                        mov bp,sp
                        push ax
                        push bx
                        push cx
                        push di
                        push si
                        push ds
                        push es
                        
                        
                        push ds
                        pop es
                        
                        mov si,boundary
                        mov cx,10
                        
j1:                     mov di,base
                        push cx
                        
                        mov ax,[si]
                        add si,2
                        
                        mov cx,[index]
                        
                        repne scasw
                        
                        
                        cmp cx,0
                        jne inv
                        
                        pop cx
                 
                        
                        loop j1
                        
                        
                        
                        
                        mov si,boundary
                        mov cx,10
                        
j2:                     mov ax,[si]
                        add si,2
                        cmp ax,0
                        je ended
                        
kk1:                    sub ax,160
                        cmp ax,160
                        jae kk1
                        
                        cmp ax,10
                        jbe ended2
                        
                        cmp ax,94
                        jae ended3
                 
                        
                        loop j2
                        
                        jmp ended 
                        
                        
inv:                   pop cx
                       mov dx,1
                       jmp ended
                      
                   
            
                        
ended:                  pop es
                        pop ds
                        pop si
                        pop di
                        pop cx
                        pop bx
                        pop ax
                        pop bp
                        
                        ret
                        
ended2:                 pop es
                        pop ds
                        pop si
                        pop di
                        add di,4
                        pop cx
                        pop bx
                        pop ax
                        pop bp
                        
                        ret
                        
                        
ended3:                 pop es
                        pop ds
                        pop si
                        pop di
                        sub di,4
                        pop cx
                        pop bx
                        pop ax
                        pop bp
                        
                        ret
                        
                        
                        
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

checkrowcomplete:       push bp
                        mov bp,sp
                        push ax
                        push cx
                        push di
                        push es
                        
                        
                        mov ax,0xb800
                        mov es,ax
                        
                        mov di,[bp+4]
                        mov ax,0x0020
                        
	                cld
	                
	                mov cx,40
	                repne scasw
	                
	                cmp cx,0
	                jne endh
                        
                        mov dx,1

        
endh:                   pop es
                        pop di
                        pop cx
                        pop ax
                        pop bp
                        
                        ret 2
                        
                        
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------       
destroyrow:             push bp
                        mov bp,sp
                        push ax
                        push bx
                        push cx
                        push dx
                        push di
                        push si
                        push es
                        push ds
                        
                        mov ax,0xb800
                        mov ds,ax
                        mov es,ax
                        
                        mov di,[bp+4]
                        
                        mov cx,21
                        
                        add di,78
                        mov si,di
                        sub si,160
                        
                        std
                        
uu1: 			push si
                        push di
                        push cx
                        mov cx,40
                        
                        rep movsw
                        
                        pop cx
                        pop di
                        pop si
                        
                        sub di,160
                        sub si,160
                        
                        loop uu1
                        
                        
                        mov di,332
                        cld
                        mov ax,0x0020
                        mov cx,40
                        
                        rep stosw
                        
                        
                        push cs
                        pop ds
                        
                        mov si,base
                        
                        mov cx,840
                        
flop1:                  mov di,[bp+4]
			cmp word[si],di
                        jb skiop
                        
                        add di,80
                        cmp word[si],di
                        ja skiop2
                        
                        mov word[si],0            ;remove from stored dis
                        dec word[index]
                        
                        push si
                        call updatebasearr
                        jmp skiop3
                        
skiop:                  cmp word[si],0
                        je skiop2
                        
                        
                        add word[si],160
                        
skiop2:                 add si,2
skiop3:
                        loop flop1
                        
                        add word[score],10
                        mov di,600
                        push di
                        push word[score]
                        call printnum
                        
                        pop ds
                        pop es
                        pop si
                        pop di
                        pop dx
                        pop cx
                        pop bx
                        pop ax
                        pop bp
                        
                        ret 2

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

updatebasearr:         push bp
                       mov bp,sp
                       push ax
                       push bx
                       push cx
                       push si
                       
                     
                       
                       mov si,[bp+4]
                       
lw:                    cmp word[si+2],0
                       je donee
                       mov ax,[si+2]
                       mov bx,[si]
                    
                       mov [si+2],bx
                       mov [si],ax
                       
                       add si,2
                       
                       jmp lw
                       
donee:                 pop si
		       pop cx
		       pop bx
		       pop ax
		       pop bp
		       
		       ret 2
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

print :         push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di

		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+4]
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov ah, 0x37
		mov al, [num]
                mov cx,5
                
 
a1:              mov word [es:di],ax
                 add di,160
                 loop a1
                    
                
   
                pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 4

print2:         push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di

		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+4]
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov ah, 0x37
		mov al, [num]
                mov cx,4

a2:              mov word [es:di],ax
                 add di,2
                 loop a2
                    
                
   
                pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 4

print_3:        push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di

		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+4]
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov ah, 0x44
		mov al, [num]
                mov cx,2


 a3:              mov word [es:di],ax
                  add di,320
                  loop a3

                pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 4
                

 print_4:        push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di

		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+4]
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov ah, 0xE0
		mov al, [num2]
                mov word [es:di],ax

 pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 4


print_5:         push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di

		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+4]
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov ah, 0x44
		mov al, [num]
                mov cx,2

a5:              mov word [es:di],ax
                 add di,4
                 loop a5
                    
                
   
                pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 4

print_6:         push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di

		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+4]
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov ah, 0xD0
		mov al, [num3]
                mov cx,49

a6:              mov word [es:di],ax
                 add di,2
                 loop a6
                    
                
   
                pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 4
print_7 :         push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di

		mov ax, 0xb800
		mov es, ax
		mov al, 80
		mul byte [bp+4]
		add ax, [bp+6]
		shl ax, 1
		mov di, ax
		mov ah, 0xD0
		mov al, [num4]
                mov cx,14
                
 
a7:              mov word [es:di],ax
                 add di,160
                 loop a7
                    
                
   
                pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 4
                	

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                	
mainscr:                push bp
                        mov bp,sp
                        push ax
                        push bx
                        push cx
                        push di
                        push es
                        
                        mov ax,0xb800
                        mov es,ax
                        
                        mov ax,0x7720
                	push ax
                	call clrscr
                	
                        mov di,12
                        mov bx,23
                        
                        
l1:                     mov cx,40
l2:                     mov word[es:di],0x0020
                        add di,2
                        loop l2
                        
                        add di,80
                        sub bx,1
                        jnz l1
                        
                        
                        mov di,420
                        mov bx,10
                        
                        
l3:                     mov cx,25
l4:                     mov word[es:di],0x0020
                        add di,2
                        loop l4
                        
                        add di,110
                        sub bx,1
                        jnz l3    
                        
                        mov ax,0x0707
                        push ax
                        mov di,582
                        push di
                        mov bx,scoreMessage
                        push bx
                        mov bx,8
                        push bx
                        call printstr
                        
                        mov di,600
                        push di
                        push word[score]
                        call printnum
                        
                        mov di,582
                        mov ax,0x0707
                        push ax
                        add di,160
                        push di
                        mov bx,timeMessage
                        push bx
                        mov bx,12
                        push bx
                        call printstr
                        
                        
                        mov di,2180
                        mov bx,10
                        
l5:                     mov cx,25
l6:                     mov word[es:di],0x0020
                        add di,2
                        loop l6
                        
                        add di,110
                        sub bx,1
                        jnz l5       
                        
                        mov ax,0x0707
                        push ax
                        mov di,2342
                        push di
                        mov bx,nextBMessage
                        push bx
                        mov bx,10
                        push bx
                        call printstr
                        
                        
                        
                        mov di,368
		        push di
		        call printSQ
		        
		        mov [currpos],di
		        
		        
		        mov di,3000
		        push di
		        call printPLUS
		        
		        
		        mov cx,40
		        
		        push ds
		        pop es
		        mov di,base
		        mov ax,3692
		        
		        cld
		        
setbase:                stosw
                        add ax,2
                        loop setbase
                        
                        mov word[index],40
                        
                        
                        mov di,upperlim
                        mov ax,650
                        mov cx,40
                        cld
                        
                        mov dx,0
                        
        
                        mov word[timerflag],1
                        
play:                   mov word[flag],0
			;mov word[rowcompleteflag],0
                        mov di,[currpos]
                        push di
                        add di,160
                        
                        
                        
                        mov ah,0x01
                        int 16h
                        
                        jz cont
                        
                        mov ah,0x00
                        int 16h
                        
                        cmp al,'a'
                        je s1
                        cmp al,'A'
                        je s1
                        cmp al,'D'
                        je s2
                        cmp al,'d'
                        je s2
                        cmp al,'s'
                        je s3
                        cmp al,'S'
                        je s3
                        cmp al,'W'
                        je s4
                        cmp al,'w'
                        je s4
                        
                        jmp cont
                        
s1:                     sub di,4
                        jmp cont
                        
s2:                     add di,4
			jmp cont
			
s3:                     push word[currshape]
                        call rotateshaperight
                        jmp cont
                        
s4:                     push word[currshape]
			call rotateshapeleft
		
                        
                        
                        
cont:                   push di
                        push word[currshape]
                        call calcboundaryShape
                        
                
                        call checkmovposs
                        
 	                cmp dx,0
                        je near continue
                        
                        cmp di,732
                        ja ship
                        
                        mov word[endgame],1

                        
                        cmp word[endgame],1
                        je continue
                        
                        
ship:                   pop ax
                        mov di,ax
                        push di
                        push word[currshape]
                        call calcboundaryShape
                        call addboundary
                        
         		push ax
                        
                        mov word[flag],1
                        
                        mov dx,0
                        
                        mov di,3000
                        push di
                        push word[nextshape]
                        call clearShape
                        
                        push dx
                        mov ax,3532
                        mov cx,21
                        
destr:                  push ax
                        mov dx,0
                        call checkrowcomplete
                       
                        cmp dx,1
                        jne ff1
                        
                        push ax
                        call destroyrow
                        
                        
ff1:                    sub ax,160
                        loop destr
                        
                        pop dx
                        
                        inc word[nextshape]
                        cmp word[nextshape],4
                        jne fd1
                        
                        mov word[nextshape],0
                
        		
        		
                        
fd1:                 	mov di,3000
                        push di
                        push word[nextshape]
                        call printShape
                        
                        
                        mov di,368
                        inc word[currshape]
                        
                        
                        
                     
                        
                        cmp word[currshape],4
                        jne continue
                        
                        mov word[currshape],0
                        
continue:               pop ax

                        cmp word[endgame],1
                        je just

                        cmp word[flag],1
                        je lesgo
                        
                        push di
                        mov di,ax
                        
                        push di
                        push word[currshape]
                        call clearShape
                        
                        pop di
                        
                        
lesgo:                  mov [currpos],di
                        push di
                        push word[currshape]
                        call printShape
                        
 just:                  mov ax,5
                        push ax
                        call delay2
                        
                        
                        
                       
                        
                        
			cmp word[endgame],0
                        je play

                       mov word[timerflag],0
                        
endd:                   pop es
                        pop di
                        pop cx
                        pop bx
                        pop ax
                        pop bp
                        
                        
                        ret
                        
                        
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                        
                        
startscr:      		push bp
                 	mov bp,sp
                 	push ax
                 	
                 	mov ax,0x0720
                	push ax
                	call clrscr
                 	
                 	mov ax,25
			push ax
			mov ax,7
			push ax

			call print
			mov ax,26
			push ax
			mov ax,9
			push ax
			call print2

			mov ax,30
			push ax
			mov ax,7
			push ax
			call print ;H end

			mov ax,33  ;O start
			push ax
			mov ax,7
			push ax
			call print

			mov ax,34
			push ax
			mov ax,7
			push ax
			call print2

			mov ax,34
			push ax
			mov ax,11
			push ax
			call print2 

			mov ax,38 
			push ax
			mov ax,7
			push ax
			call print ;O end

			mov ax,41
			push ax
			mov ax,7
			push ax
			call print

			mov ax,42 
			push ax
			mov ax,11
			push ax
			call print2 ; L end

			mov ax,48
			push ax
			mov ax,7
			push ax
			call print

			mov ax,49
			push ax
			mov ax,7
			push ax
			call print2

			mov ax,49
			push ax
			mov ax,9
			push ax
			call print2

			mov ax,52
			push ax
			mov ax,7
			push ax
			call print ;A end

			mov ax,21 ;flower1
			push ax
			mov ax,8
			push ax
			call print_3

			mov ax,21 
			push ax
			mov ax,9
			push ax
			call print_4

			mov ax,20 
			push ax
			mov ax,9
			push ax
			call print_5

			mov ax,56 ;flower2
			push ax
			mov ax,8
			push ax
			call print_3

			mov ax,56 
			push ax
			mov ax,9
			push ax
			call print_4



			mov ax,55 
			push ax
			mov ax,9
			push ax
			call print_5
                        
                        mov ax,0x0707
                        push ax
			mov ax,2452
			push ax
			mov ax, sen1
			push ax
			push word [len1]
			call printstr

			mov ax,15
			push ax
			mov ax,3
			push ax
			call print_6

			mov ax,15
			push ax
			mov ax,17
			push ax
			call print_6

			mov ax,15
			push ax
			mov ax,4
			push ax
			call print_7

			mov ax,63
			push ax
			mov ax,4
			push ax
			call print_7
                
                
                        pop ax
                        pop bp
                        
                        ret
                        
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                        
endscr: mov ax,0020
        push ax
        call clrscr


 mov ax, 0x000d ; set 640x350  x200 graphics mode
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,26
ll1: 
int 0x10 ; bios video services
sub cx,1
cmp cx,17
jne ll1
;************************{top -}
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,27
ll2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,17
jne ll2
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,28
ll3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,17
jne ll3

 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,29
ll4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,17
jne ll4

;****************** {|}
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 17 ; x position 200
 mov dx,70
 
ll5: 
int 0x10 ; bios video services
sub dx,1
cmp dx,30
jne ll5
;****
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,18
 mov dx,70
 
ll6: 
int 0x10 ; bios video services
sub dx,1
cmp dx,30
jne ll6
;****
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,19
 mov dx,70
 
l7: 
int 0x10 ; bios video services
sub dx,1
cmp dx,29
jne l7

;------------------ {-}

;----------
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,70
l11: 
int 0x10 ; bios video services
sub cx,1
cmp cx,20
jne l11
;*******
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,69
l12: 
int 0x10 ; bios video services
sub cx,1
cmp cx,20
jne l12
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,68
l13: 
int 0x10 ; bios video services
sub cx,1
cmp cx,20
jne l13

 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,67
l14: 
int 0x10 ; bios video services
sub cx,1
cmp cx,19
jne l14


;------------------ mid {-}

;----------
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 50 ; x position 200
 mov dx,45
l21: 
int 0x10 ; bios video services
sub cx,1
cmp cx,38
jne l21
;*******
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 50 ; x position 200
 mov dx,46
l22: 
int 0x10 ; bios video services
sub cx,1
cmp cx,38
jne l22
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 50 ; x position 200
 mov dx,47
l33: 
int 0x10 ; bios video services
sub cx,1
cmp cx,38
jne l33

 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 50 ; x position 200
 mov dx,48
l44: 
int 0x10 ; bios video services
sub cx,1
cmp cx,38
jne l44
;--------------------------half |

;****************** {|}
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 40 ; x position 200
 mov dx,66
 
ll55: 
int 0x10 ; bios video services
sub dx,1
cmp dx,49
jne ll55
;****
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,38
 mov dx,66
 
ll66: 
int 0x10 ; bios video services
sub dx,1
cmp dx,49
jne ll66
;****
 int 0x10 ; bios video services
 mov ax, 0x0Cf3; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,39
  mov dx,66
 
ll7: 
int 0x10 ; bios video services
sub dx,1
cmp dx,48
jne ll7

;------------------------------------------------------------------------a char----------------------------------------------------------------------------------

;---------------------------{|}------------------------
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 56 ; x position 200
 mov dx,70
a11: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne a11
;****
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,58
 mov dx,70
a12: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne a12
;****
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,57
 mov dx,70 
a13:
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne a13
;-------------------a dash top---------------------------------
;****** - ******
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 70; x position 200
 mov dx,27
a22: 
int 0x10 ; bios video services
sub cx,1
cmp cx,56
jne a22
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 70 ; x position 200
 mov dx,26
a23: 
int 0x10 ; bios video services
sub cx,1
cmp cx,56
jne a23

 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 70 ; x position 200
 mov dx,25
a24: 
int 0x10 ; bios video services
sub cx,1
cmp cx,56
jne a24

;-----right|------------------------------
;---------------------------{|}------------------------
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 71 ; x position 200
 mov dx,70
ai: 
int 0x10 ; bios video services
sub dx,1
cmp dx,25
jne ai
;****

 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,72
 mov dx,70
ai2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,25
jne ai2

;****
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,73
 mov dx,70 
ai3:
int 0x10 ; bios video services
sub dx,1
cmp dx,25
jne ai3
;---------- "-" dash-------
;****** - ******
 int 0x10 ; bios video services
 mov ax, 0x0cfc ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 70; x position 200
 mov dx,50
ad1: 
int 0x10 ; bios video services
sub cx,1
cmp cx,59
jne ad1
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color

 xor bx, bx ; page number 0
 mov cx, 70 ; x position 200
 mov dx,51
ad2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,59
jne ad2

 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 70 ; x position 200
 mov dx,49
ad3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,58
jne ad3

;-------------------------------------------------- M character----------------------------------------------------
;-------------{|}-------------------
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 83 ; x position 200
 mov dx,70
mi: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne mi
;****

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,84
 mov dx,70
mi2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne mi2

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,85
 mov dx,70 
mi3:
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne mi3
;
;-------------------a dash top---------------------------------
;****** - ******
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 120; x position 200
 mov dx,26
md2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,83
jne md2
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 120 ; x position 200
 mov dx,25
md3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,83
jne md3

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 120 ; x position 200
 mov dx,27
md4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,83
jne md4
;-------------{|}-------------------center
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 102; x position 200
 mov dx,70
mii: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne mii
;****

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,100
 mov dx,70
mii2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne mii2

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,101
 mov dx,70 
mii3:
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne mii3
;
;----------------------{|} last
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 118; x position 200
 mov dx,70
miii: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne miii
;****

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,120
 mov dx,70
miii2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne miii2

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,119
 mov dx,70 
miii3:
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne miii3
;------------------------------------------- e character ------------------------------------------------------------

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 136; x position 200
 mov dx,70
ei: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne ei
;****

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,135
 mov dx,70
ei2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne ei2

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,134
 mov dx,70 
ei3:
int 0x10 ; bios video services
sub dx,1
cmp dx,28
jne ei3
;--------------------------------------------------<dash upper>
;****** - ******
 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 160; x position 200
 mov dx,26
ed2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,135
jne ed2
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 160 ; x position 200
 mov dx,25
ed3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,135
jne ed3

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 160 ; x position 200
 mov dx,27
ed4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,135
jne ed4
;-----------------<mid das>---------- "-" dash-------
;****** - ******
 int 0x10 ; bios video services
 mov ax, 0x0cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 160; x position 200
 mov dx,50
md11: 
int 0x10 ; bios video services
sub cx,1
cmp cx,136
jne md11
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color

 xor bx, bx ; page number 0
 mov cx, 160 ; x position 200
 mov dx,51
md22: 
int 0x10 ; bios video services
sub cx,1
cmp cx,136
jne md22

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 160 ; x position 200
 mov dx,49
md33: 
int 0x10 ; bios video services
sub cx,1
cmp cx,136
jne md33
;-----------------<end  das>---------- "-" dash-------
;****** - ******
 int 0x10 ; bios video services
 mov ax, 0x0cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 160; x position 200
 mov dx,68
md111: 
int 0x10 ; bios video services
sub cx,1
cmp cx,137
jne md111
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color

 xor bx, bx ; page number 0
 mov cx, 160 ; x position 200
 mov dx,70
md222: 
int 0x10 ; bios video services
sub cx,1
cmp cx,137
jne md222

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 160 ; x position 200
 mov dx,69
md333: 
int 0x10 ; bios video services
sub cx,1
cmp cx,137
jne md333

;----------------------------------------------------- o character ------------------------------------------------------------------
;---------------------------{|}------------------------
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 180; x position 200
 mov dx,160
o1: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne o1
;****

 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,181
 mov dx,160
o2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne o2

 int 0x10 ; bios video services
 mov ax, 0x0Cf3; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,182
 mov dx,160
o3:
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne o3

;---bott of o
;****** - ******
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 200; x position 200
 mov dx,158
oo2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,183
jne oo2
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 200 ; x position 200
 mov dx,160
oo3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,183
jne oo3

 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 200 ; x position 200
 mov dx,159
oo4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,183
jne oo4

;-------------top o----------
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 200; x position 200
 mov dx,110
ooo2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,183
jne ooo2
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 200 ; x position 200
 mov dx,111
ooo3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,183
jne ooo3

 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 200 ; x position 200
 mov dx,112
ooo4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,183
jne ooo4
;---------------right | of o ---------------------
 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 201; x position 200
 mov dx,160
odd1: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne odd1
;****

 int 0x10 ; bios video services
 mov ax, 0x0Cf3 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,202
 mov dx,160
odd2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne odd2

 int 0x10 ; bios video services
 mov ax, 0x0Cf3; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,203
 mov dx,160
odd3:
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne odd3

;------------------------------------------------v character ---------------------------------------------------------
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 211; x position 200
 mov dx,157
v1: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne v1

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,212
 mov dx,157
v2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne v2

 int 0x10 ; bios video services
 mov ax, 0x0Cf1; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,213
 mov dx,157
v3:
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne v3
;*****************
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 219; x position 200
 mov dx,160
vv1: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne vv1
;****

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,220
 mov dx,160
 
vv22: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne vv22

 int 0x10 ; bios video services
 mov ax, 0x0Cf1; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,221
 mov dx,160
vv3:
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne vv3
;---bott of o
;****** - *****
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 221; x position 200
 mov dx,158
vvv2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,215
jne vvv2
;********
 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 221 ; x position 200
 mov dx,160
vvv3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,215
jne vvv3

 int 0x10 ; bios video services
 mov ax, 0x0Cf1 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 221 ; x position 200
 mov dx,159
vvv4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,214
jne vvv4

;----------------------------------------------------- e character---------------------------------------------------------------

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 230; x position 200
 mov dx,160
ce1: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne ce1

 int 0x10 ; bios video services
 mov ax, 0x0Cfd; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,231
 mov dx,160
ce2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne ce2

 int 0x10 ; bios video services
 mov ax, 0x0Cfd; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,232
 mov dx,160
ce3:
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne ce3

;************
 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244; x position 200
 mov dx,160
cee2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne cee2

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244 ; x position 200
 mov dx,159
cee3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne cee3

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244 ; x position 200
 mov dx,158
cee4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne cee4
;-----------------------------mid dash
 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244; x position 200
 mov dx,140
ceee2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne ceee2

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244 ; x position 200
 mov dx,139
ceee3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne ceee3

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244; x position 200
 mov dx,141
ceee4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne ceee4
;--------------------------up dash
 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244; x position 200
 mov dx,110
ceeee2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne ceeee2

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244 ; x position 200
 mov dx,111
ceeee3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne ceeee3

 int 0x10 ; bios video services
 mov ax, 0x0Cfd ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 244; x position 200
 mov dx,112
ceeee4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,233
jne ceeee4

;---------------------------------------------------- r character---------------------------------------------------

 int 0x10 ; bios video services
 mov ax, 0x0Cf4; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 252; x position 200
 mov dx,160
r1: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne r1

 int 0x10 ; bios video services
 mov ax, 0x0Cf4; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,253
 mov dx,160
r2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne r2

 int 0x10 ; bios video services
 mov ax, 0x0Cf4; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,254
 mov dx,160
r3:
int 0x10 ; bios video services
sub dx,1
cmp dx,110
jne r3
;
;--------------------------up dash
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 270; x position 200
 mov dx,110
rr2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,254
jne rr2

 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 270 ; x position 200
 mov dx,111
rr3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,254
jne rr3

 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 270; x position 200
 mov dx,112
rr4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,254
jne rr4
;
;--------------------------mid dash
 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 270; x position 200
 mov dx,130
rrr2: 
int 0x10 ; bios video services
sub cx,1
cmp cx,254
jne rrr2

 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 270 ; x position 200
 mov dx,131
rrr3: 
int 0x10 ; bios video services
sub cx,1
cmp cx,254
jne rrr3

 int 0x10 ; bios video services
 mov ax, 0x0Cf4 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 270; x position 200
 mov dx,132
rrr4: 
int 0x10 ; bios video services
sub cx,1
cmp cx,254
jne rrr4

;--------------------------half |

 int 0x10 ; bios video services
 mov ax, 0x0Cf4; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 270; x position 200
 mov dx,130
rrrr1: 
int 0x10 ; bios video services
sub dx,1
cmp dx,113
jne rrrr1

 int 0x10 ; bios video services
 mov ax, 0x0Cf4; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,271
 mov dx,130
rrrr2: 
int 0x10 ; bios video services
sub dx,1
cmp dx,112
jne rrrr2

 int 0x10 ; bios video services
 mov ax, 0x0Cf4; put pixel in white color
 xor bx, bx ; page number 0
 mov cx,269
 mov dx,130
rrrr3:
int 0x10 ; bios video services
sub dx,1
cmp dx,113
jne rrrr3
;--------------------------------

;--------------------------------
; \ slanted line of r 
int 0x10 ; bios video services
 mov ax, 0x0C04 ; put pixel in white color
 xor bx, bx ; page number 0
 mov cx, 592 ; x position 200
 mov dx, 157 ; y position 200
l51: int 0x10 ; bios video services
 dec dx ; decrease y position
 sub cx,1
 cmp cx,571
 jne l51 ; decrease x position and repeat
 
 mov ax,60
 push ax
 call delay2
 
  mov ah, 0 ; service 0 – get keystroke
 int 0x16 ; bios keyboard services
 mov ax, 0x0003 ; 80x25 text mode
 int 0x10 ; bios video services
 
 
 ret
    
;;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

endscr2:                 push bp
                        mov bp,sp
                        push ax
                        
                        
                        mov ax,0x0720
                        push ax
                        call clrscr
                        
                        mov ax,0x0101
                        push ax
                        mov ax,1330
                        push ax
                        mov ax,border
                        push border
                        mov ax,[borderlen]
                        push ax
                        
                        call printstr
                        
                        mov ax,0x0707
                        push ax
                        mov ax,1668
                        push ax
                        mov ax,endscrstr1
                        push ax
                        mov ax,[endscrstr1len]
                        push ax
                        
                        call printstr
                        
                        
                        mov ax,1686
			push ax
			mov ax,[cs:min1]
			push ax
			call printnum
		
		
			mov ax,1688
			push ax
			mov ax,[cs:min2]
			push ax
			call printnum
			
			mov ax,0xb800
			mov es,ax
			mov ah,0x07
			mov al,':'
			mov word[es:1690],ax
			mov ax,1692
			push ax
			mov ax,[cs:sec1]
			push ax
			call printnum
			
			
			mov ax,1694
			push ax
			mov ax,[cs:sec2]
			push ax
			call printnum
			
			
                        
                        mov ax,0x0707
                        push ax
                        mov ax,1988
                        push ax
                        mov ax,endscrstr2
                        push ax
                        mov ax,[endscrstr2len]
                        push ax
                        
                        call printstr
                        
                        mov ax,2006
                        push ax
                        mov ax,[score]
                        push ax
                        call printnum
                        
                        mov ax,0x0101
                        push ax
                        mov ax,2290
                        push ax
                        mov ax,border
                        push border
                        mov ax,[borderlen]
                        push ax
                        
                        call printstr
                        
                        push ax
                        mov ax,border
                        push border
                        mov ax,[borderlen]
                        push ax
                        
                        call printstr
                        
                        
                        mov cx,30
                        mov di,28
                        mov ax,0xb800
                        mov es,ax
                        
kkk1:                  mov word[es:di],0x0720
                       add di,2
                       loop kkk1
                        
                        
                        
                        
                        
                        pop ax
                        pop bx
                        
                        ret

        


;;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

start:	        

	        call startscr
                
           
                
                xor ax, ax
		mov es, ax ; point es to IVT base
		
		
		
		cli ; disable interrupts
		mov word [es:8*4], timer; store offset at n*4
		mov [es:8*4+2], cs ; store segment at n*4+2
		sti ; enable interrupts
                
                mov ax,50
                push ax
                call delay2

                call mainscr
                
                
                mov ax,50
                push ax
                call delay2

                call endscr
                
                call endscr2
                
                mov ax,60
                push ax
                call delay2
                
                mov ah,01
                int 0x21
                
		mov ax, 0x4c00 ; 
		int 0x21; 
                
                
                
                