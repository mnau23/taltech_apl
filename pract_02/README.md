# Task
> Generate MIPS32 assembly code for a PIC32MX trainer board.


## Usage
Install MPLAB X IDE and MPLAB XC32 Compiler.
Open CygWin Terminal.


```bash
flex pic.l
bison -d pic.y
gcc *.c -o pic -Wall
./pic example.pic
```