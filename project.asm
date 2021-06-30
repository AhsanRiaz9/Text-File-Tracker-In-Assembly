.model huge
.stack 200h
.386
include lib.asm						; include lib in program for macros and procedures
.data
	dateMsg db "Date: $"
	displaySpace db "               $"
	timeMsg db "Time: $"
	FNAME db "file.txt"				;File name for reading data
	HANDLE DW ?						; file handler
	BUFFER DB 60000 DUP(?)			; Buffer to read data from file
	counter db 0					; counter will store the no. of digits in number
	val dw 0						; store number which will be print, here it will be used for line number
	totalSentence dw 0				; store total sentences in file
	index dw 500 dup (?)			; index used for save addresses of each sentence
	newLine db 13,10,'$'			; new line string
 	; menu msg string
	helpMsg1 db "HELP MENU",13,10,'$'
	helpMsg2 db "Program vypise vsetky vety zo vstupu a pred kazdu vetu vypise jej poradove cislo$"
	helpMsg3 db "'-p' vystup bude strankovany",13,10,'$'
	helpMsg4 db "'-r' vypis v opacnom poradi od konca",13,10,'$'
	; command line arguments
	isAbout db 0			; if -h, then isAbout = 1, else isAbout = 0
	isReverse db 0			; if -r, then isReverse = 1, else isReverse = 0
	pageFlag db 0			; if -p, then pageFlag is set 1
	temp db ?
	pageCount db 0
	pageIndexArray dw 50 dup (?)
	pageLineNoArray dw 50 dup (?)
	currentPageIndex dw ?
	currentLineIndex dw ?
	totalPages dw ?
	totalPageMsg db "Total Pages: $"
	pageMsg db "  Current Page No.: $"
	pagePercentageMsg db "  Total Page Dispalyed%: $"
.code 
main proc
	
	; getting command line arguments
	mov si,82h			; si will store the starting byte of command line arguments
	mov dh,[si]
	mov dl,[si+1]
	
	push dx		; save commands arguments arguments
	
	mov ax,@data				; set ds to @data segment, to access variables
	mov ds,ax
	
	clearScreen					;clear the screen
	setCursorAtTopLeft			; set the screen cursor at top left corner 0,0 position
	call fileReading			; read data from file
	clearScreen					;clear the screen
	setCursorAtTopLeft			; set the screen cursor at top left corner 0,0 position
	mov ah,'-'
	mov al,'h'
	pop dx						; dx store command line argument
	cmp ax,dx					; if dx is '-h', then display help
	JE displayHelp
	mov al,'r'
	cmp dx,ax					; if dx is '-r', then reverse the file
	JE displayReverse
	mov al,'p'
	cmp dx,ax					; if dx is '-p', then used paging to display data
	JE displayPaging
	JMP defaultDisplay			; if not '-p', then display all sentence from top to bottom	
displayHelp:	
	call printHelp				; call printHelp
	JMP exit					; then exit the program
	
defaultDisplay:	
	call displayFromStart		; call displayFromStart
	JMP exit					; then exit the program
	
displayReverse:
	call displayFromEnd			; call displayFromEnd
	JMP exit
displayPaging:
	call countTotalPages
	call displayWithPaging
exit:	
	mov ah,4ch	; exit of program		
	int 21h

main endp
end main
