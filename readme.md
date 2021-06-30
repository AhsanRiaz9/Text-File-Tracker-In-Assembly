### Programming in Assembly language ###

## Requirement:

Write a program (in Assembly language -> GUI Turbo Assembler) that allows the user to use the arguments specified on the command line when running the program to perform the selected function for the specified input.
If the program run with '-h' switch, the program must display information about the program and its use.
In the program, use the macro with the parameter, as well as the appropriate OS calls (BIOS) to set the cursor, list the string, clear the screen, work with files, etc. Macro definitions must be in a separate file. 
The program must correctly process files up to 64 kB in length. When reading, use an array of a suitable size (buffer), while the entire size of the array will be moved from the file to the memory repeatedly (except for the last reading).


## Program Function:
Read all sentences from the input and list its order number before each sentence. (see below)

## EXAMPLE:
INPUT:
This is my first message. Now you read my second message. This is third sentence. Now Im writing text.

OUTPUT:
1.This is my first message. 2.Now you read my second message. 3.This is third sentence. 4.Now Im writing text.


###################

#Project Specification:
We must have DOSBox 8086 Assembler to run this project.
We have to download and install DOSBox.
##Download link of DOSBox:
https://www.dosbox.com/download.php?main=1
##Download TASM:
https://drive.google.com/file/d/0BxFfQqBvZCltMHdNbFFCZVJkUlE/view?usp=sharing
First install the DOSBox.
Then, extract the TASM folder in C drive.
All files should be placed in C:/Tasm folder.
##We have 3 files:
1.	Project.asm 	(main procedure)
2.	Lib.asm		(for macros and procedures)
3.	File.txt		(the file to be read)

#To run this project, we have to open DOSBox:
##How to run Program on DOSBox:
###Please follow these steps:
1.	mount c c:\Tasm
2.	c: (enter)
3.	tasm project.asm
4.	tlink project
5.	project.exe (or project)

## How command Line arguments works:
### We can also pass argument to program using -h, -r and -p. like:
o	project -h (will display help)
o	project -r (display the data in reverse order)
o	project -p (display the data with paging feature)
