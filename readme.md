# Project Specification:
We must have DOSBox 8086 Assembler to run this project.
We have to download and install DOSBox.
## Download link of DOSBox:
https://www.dosbox.com/download.php?main=1
## Download TASM:
https://drive.google.com/file/d/0BxFfQqBvZCltMHdNbFFCZVJkUlE/view?usp=sharing
First install the DOSBox.
Then, extract the TASM folder in C drive.
All files should be placed in C:/Tasm folder.
## We have 3 files:
1.	Project.asm 	(main procedure)
2.	Lib.asm		(for macros and procedures)
3.	File.txt		(the file to be read)

# To run this project, we have to open DOSBox:
## How to run Program on DOSBox:
### Please follow these steps:
1.	mount c c:\Tasm
2.	c: (enter)
3.	tasm project.asm
4.	tlink project
5.	project.exe (or project)

## How command Line arguments works:
### We can also pass argument to program using -h, -r and -p. like:
#### project -h (will display help)
#### project -r (display the data in reverse order)
#### project -p (display the data with paging feature)

# Note: lib.asm is used in project asm, I develeped myself this lib.asm file which seperate the functionality of procedures and macros in seperate files.
