clearScreen MACRO 	;this macro will clear screen	
	pushAllRegisters
	mov ah,06h
	mov bh,07h
	mov cx,0			; cx = 0, ch =0, cl =0
	mov dx,184Fh		; dh = 24 (18h), dl = 79 (4Fh)
	int 10h
	popAllRegisters
	ENDM

setCursorAtTopLeft MACRO ;this macro will set cursor at top left position
	pushAllRegisters
	mov ah,02h
	mov bh,00h
	mov dx,0h			; dx = 0, dh = 0, dl = 0
	int 10h
	popAllRegisters
	ENDM
	
pushAllRegisters MACRO	; this macro will push all registers on stack
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	ENDM
	
popAllRegisters MACRO	; this macro will pop all registers from stack
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ENDM	
.code	

; this proc  will display new line on screen
printNewLine proc 
	mov ah,09h
	lea dx,newLine
	int 21h
ret	
printNewLine endp



;this proc  will display the number in decimal
displayNumber proc 

	pushAllRegisters					; save all registers	
	mov counter,0						; counter = no of digitst in num, set no of digit = 0
	mov bx,10							
	mov ax,val							; save value in ax
	cmp ax,0							; if num is zero, then print 0 and exit
	JNE saveDigit						; if num is not zero then save digit
	mov ah,02h		
	mov dl,'0'	
	int 21h
	JMP stopPrint						; if val = 0 , then display zero only and exit						
saveDigit:
	cmp ax,0							; stop when val become zero or less mean when ax<0					
	JBE stopSaveDigit 
	mov dx,0							; set dx=0
	div bx								; div ax by bx, divide number by base 
	push dx								; remainder will save on dx, we will push it on stack	
	inc counter							; inc counter, increase the no of digits	
	JMP saveDigit						; save next digit
stopSaveDigit:
	
	mov cl,1							;loop counter cl =1
startPrint:
	cmp cl,counter						;check if cl > no of digitst , then stop printing the digit
	JA stopPrint						
	mov ah,02h					
	pop dx	
	add dl,'0'							; digit to character
	int 21h
	inc cl								; inc the loop counter
	JMP startPrint						; print next digit
stopPrint:								;stop print
	popAllRegisters
	ret
displayNumber endp

;Display Part
DISP proc 
    mov dl,bh      ; Since the values are in bx, bh Part
    mov ah,02H     ; To Print in DOS
	add dl,30H     ; ASCII Adjustment
    int 21H
    mov dl,bl      ; bl Part
	mov ah,02H     ; To Print in DOS	
    add dl,30H     ; ASCII Adjustment
    int 21H
RET
DISP ENDP      ; End Disp proc edure

displayDate proc     
    ;Day Part
    DAY:        
    mov ah,2ah    ; To get System Date
    int 21H
    mov al,dl     ; Day is in dl
    aam
    mov bx,ax
    call DISP

    mov dl,'/'
    mov ah,02H    ; To Print / in DOS
    int 21H

    ;Month Part
    MONTH:
    mov ah,2ah    ; To get System Date
    int 21H
    mov al,dh     ; Month is in dh
    aam
    mov bx,ax
    call DISP

    mov dl,'/'    ; To Print / in DOS
    mov ah,02H
    int 21H

    ;Year Part
    YEAR:
    mov ah,2ah    ; To get System Date
    int 21H
    add cx,0F830H ; To negate the effects of 16bit value,
    mov ax,cx     ; since aam is applicable only for al (YYYY -> YY)
    aam
    mov bx,ax
    call DISP
	ret
displayDate endp

displayTime proc 
;Hour Part
HOUR:
	mov ah,2ch    ; To get System Time
	int 21H
	mov al,ch     ; Hour is in ch
	aam
	mov bx,ax
	call DISP

	mov dl,':'
	mov ah,02H    ; To Print : in DOS
	int 21H

;Minutes Part
MINUTES:
	mov ah,2ch    ; To get System Time
	int 21H
	mov al,cl     ; Minutes is in CL
	aam
	mov bx,ax
	call DISP
	
	mov dl,':'    ; To Print : in DOS
	mov ah,02H
	int 21H

;Seconds Part
	Seconds:
	mov ah,2ch    ; To get System Time
	int 21H
	mov al,dh     ; Seconds is in dh
	aam
	mov bx,ax
	call DISP
ret
displayTime endp

;this proecdure will diplay date and time
displayDetail proc 
	pushAllRegisters
	mov ah,09h
	lea dx,dateMsg
	int 21h
	call displayDate
	mov ah,09h
	lea dx,displaySpace
	int 21h
	mov ah,09h
	lea dx,timeMsg
	int 21h
	call displayTime
	call printNewLine
	popAllRegisters
	ret
displayDetail endp

; this proc edure will display the Total page, page no, and page displayed in percentage
displayPageDetail proc 
	pushAllRegisters
	mov ah,09h
	lea dx, totalPageMsg
	int 21h
	mov ax,totalPages
	mov val,ax
	call displayNumber
	mov ah,09h
	lea dx, pageMsg
	int 21h
	mov ax,0
	mov al,pageCount
	mov val,ax
	call displayNumber
	mov ah,09h
	lea dx,pagePercentageMsg
	int 21h
	mov ax,0
	mov al,pageCount
	mov bx,100
	mov dx,0
	mul bx
	mov bx,totalPages
	div bx
	mov val,ax
	call displayNumber
	mov ah,02h
	mov dl,'%'
	int 21h
	call printNewLine
	popAllRegisters
	ret
displayPageDetail endp



; this proc edure will dispaly the help menu
printHelp proc 	
	mov ah,09h
	lea dx,helpMsg1
	int 21h
	mov ah,09h
	lea dx,helpMsg2
	int 21h
	mov ah,09h
	lea dx,helpMsg3
	int 21h
	mov ah,09h
	lea dx,helpMsg4
	int 21h
	ret
printHelp endp

; read all buffer data, and store '$' where we found NULL(0) 
placeEndOfFile proc 

	lea si,buffer		; si will store the starting byte address of buffer
	mov bl,0h			; bh = 0, null
readBuf:				; read all bytes to null
	mov al,[si]
	cmp al,bl
	JE endRead
	inc si
	JMP readBuf
endRead:
	mov al,'$'				; store '$' where we find null, 0
	mov [si],al
	inc si
	mov [si],al
ret
placeEndOfFile endp

; this proc edure will find no of setences in buffer
findTotalSentence proc 
	lea si,buffer			; si will point buffer array
	lea di,index			; di will point index array
	mov al,0
	
	mov [di],al				; set first index to 0, because first sentence start at 0 index
	mov [di+1],al
	
	add di,2	
	mov bx,0
	mov cx,0				; cx will be used to count total sentences
startFind:				
	mov al,[si]				; store current element of buffer in al
	cmp al,'$'				; if al = '$' then stop finding the total sentences
	JE stopFind
	cmp al,'.'				; if al contains '.', '!', or '?' then save address of sentence
	JE k
	cmp al,'?'
	JE k
	cmp al,'!'
	JE k
	JMP skip
k:	
	; put '$' , after the '!','.', or '?' character
	mov al,'$'			
	inc bx	
	inc si
	mov [si],al		; update character, to store '$'		
	mov [di],bx		; update the index of next sentence
	inc cx
	add di,2
skip:
	inc si			; next character
	inc bx			; next index
	JMP startFind
stopFind:
	mov totalSentence,cx		; store total sentences
ret
findTotalSentence endp

;this proc edure will read the file data and store it in buffer array
fileReading proc 
	
	mov ah,3dh					; for opening a file
	mov dx,OFFSET FNAME			; dx store file name
	mov al,0  ; al = 0 mean reading mode
	int 21H						; file handler will be stored in Ax
	mov HANdlE,ax				; store file handler in handle variable
	
	mov ah,3FH					; reading the file contents
	mov bx,HANdlE				; seting file handler
	mov dx,OFFSET(BUFFER)		; dx = offset buffer, where data will be stored
	mov cx,60000				; no. of characters to read
	int 21H	
	call placeEndOfFile			; shrik the buffer and place the  '$' at the end of buffer string
	call findTotalSentence		; call this proecdure to find total sentences in file
ret
fileReading endp

; this proc edure will display the file data stored in buffer from top top bottom with ordering 1 to n
displayFromStart proc 
	mov si,offset index
	mov cx,1			; cx is used as loop counter, cx 1 to total sentences
printAgain1:	
	cmp cx,totalSentence
	JA endDis
	mov val,cx
	; display line number 
	call displayNumber
	mov ah,02h
	mov dl,'.'					; dispaly '.'
	int 21h
	; get index of sentence
	mov ax, word ptr [si]
	mov di,offset buffer		; di will point firtst byte of buffer
	cmp cx,1					
	JE K1
	add di,1	
k1:	add di,ax				; add di + ax, to jump to next sentence
	mov ah,09h				; display the sentence
	mov dx,di
	int 21h
	mov ah,02h
	mov dl,' '				; dispay ' '
	int 21h
	add si,2
	inc cx				; next sentences
	JMP printAgain1
endDis:
ret 

displayFromStart endp

; this proc edure will count the total no. of pages
countTotalPages proc 
	lea si, index
	mov bx,1
	pushAllRegisters
	mov ax, si
	mov si, offset pageIndexArray
	mov [si], ax
	mov di, offset pageLineNoArray
	mov [di], bx
	mov currentPageIndex,word ptr si
	mov currentLineIndex,word ptr di
	popAllRegisters
	call displayDetail
	mov pageCount,1
readPage:	
	cmp bx,totalSentence
	JA stopPageCount
	mov val,bx
	call displayNumber
	mov ah,02h
	mov dl,'.'
	int 21h
	mov di,offset buffer
	add di, word ptr [si]
	cmp bx,1
	JE y1
	add di,1
y1:	
	mov ah,09h
	mov dx,di
	int 21h
	pushAllRegisters
	;getting current position of cursor
	mov ah,03h				
	mov bh,0h
	int 10h
	cmp dh,22
	JB y2
	clearScreen		; if last line then clear screen and set cursor at top left position
	setCursorAtTopLeft
	call displayDetail
	inc pageCount
	pushAllRegisters
	mov ax, si
	mov si,word ptr currentPageIndex
	add si,2
	mov [si], ax
	mov di, word ptr currentLineIndex
	add di,2
	mov [di], bx
	mov currentPageIndex,si
	mov currentLineIndex,di
	popAllRegisters
y2:	
	popAllRegisters
	add si,2
	inc bx
	mov ah,02h
	mov dl,' '
	int 21h
	JMP readPage
stopPageCount:
	clearScreen		; if last line then clear screen and set cursor at top left position
	setCursorAtTopLeft
	mov ax,0
	mov al,pageCount
	mov totalPages,ax 
	ret 
countTotalPages endp

;this proc edure will display all pages with up and down arrow key -p command line argument
displayWithPaging proc 
	
	mov si, offset pageIndexArray
	mov di, offset pageLineNoArray
	mov currentPageIndex,si
	mov currentLineIndex, di
	sub currentPageIndex,2
	sub currentLineIndex,2
	lea si, index
	mov bx,1
	call displayDetail
	mov pageCount,1
	call displayPageDetail
sPrint:	
	cmp bx,totalSentence
	JA spEnd
	mov val,bx
	call displayNumber
	mov ah,02h
	mov dl,'.'
	int 21h
	mov di,offset buffer
	add di, word ptr [si]
	cmp bx,1
	JE x1
	add di,1
x1:	
	mov ah,09h
	mov dx,di
	int 21h
	pushAllRegisters
	inc bx
	cmp bx,totalSentence
	JA stopPaging
	popAllRegisters
	JMP x3
stopPaging:
	popAllRegisters
	jmp spEnd
x3:	
	pushAllRegisters
	;getting current position of cursor
	mov ah,03h				
	mov bh,0h
	int 10h
	cmp dh,23
	JB nextSen
w:
	mov ah,00h
	int 16h
	cmp ah,50h
	JE x2
	mov al,pageCount
	cmp al,1
	JBE w
	cmp ah,48h
	JE goUp
	JMP w
goUp:
	clearScreen		; if last line then clear screen and set cursor at top left position
	setCursorAtTopLeft
	dec pageCount
	call displayDetail
	call displayPageDetail
	popAllRegisters
	mov di,currentPageIndex
	mov si,word ptr [di]	
	mov di,currentLineIndex
	mov bx, word ptr [di]
	sub currentPageIndex, 2
	sub currentLineIndex, 2
	JMP sPrint
x2:	
	inc pageCount
	clearScreen		; if last line then clear screen and set cursor at top left position
	setCursorAtTopLeft
	call displayDetail
	call displayPageDetail
	popAllRegisters
	add si,2
	inc bx
	add currentPageIndex, 2
	add currentLineIndex, 2
	mov ah,02h
	mov dl,' '
	int 21h
	JMP sPrint
nextSen:	
	popAllRegisters
	add si,2
	inc bx
	mov ah,02h
	mov dl,' '
	int 21h
	JMP sPrint
spEnd:	
ret 

displayWithPaging endp

;this sproc edure will dispaly the sentences from bottom to down with ordering n to 1
displayFromEnd proc 
	mov bx,1			; bx is used as loop counter
	mov ax,totalSentence
printAgain2:
	cmp bx,totalSentence		; if bx = totalSentence then stop
	JA stopRevPrint
	
	;dispaly line number
	mov val,ax
	call displayNumber
	
	;print '.'
	push ax
	push dx
	mov ah,02h
	mov dl,'.'
	int 21h

	pop dx
	pop ax
	
	pushAllRegisters
	; goto last element of index array, and sub the counter and display read the value and jump to that address
	; then display the sentence
	mov cx,ax
	lea si,index
	dec cx
	add cx,cx
	add si,cx
	mov cx,word ptr[si]
	mov ah,09h
	lea dx,buffer
	add dx,cx
	; dispaly the sentences
	cmp bx,totalSentence
	JE k4
	add dx,1
k4:	
	int 21h
	mov ah,02h
	mov dl,' '		; display char
	int 21h
	mov bl,pageFlag
	cmp bl,0
	JE k6
	pushAllRegisters		; save all registers 
	; get current position of cursor
	mov ah,03h
	mov bh,0h	
	int 10h				
	cmp dh,23		; if last then clear screen 
	JB k5
	mov ah,01h
	int 21h
	clearScreen
	setCursorAtTopLeft
k5:	
	popAllRegisters	

k6:	
	inc bx
	popAllRegisters		; pop all registers
	inc bx				; bx = bx + 1, for next sentence
	dec ax				; dec the ax, decremnt the line number
	JMP printAgain2		
stopRevPrint:	
ret
displayFromEnd endp

