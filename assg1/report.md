1.	Conveniences and difficulties when implementing the program
a.	File I/O
The File I/O handling of Fortran is similar to C. It uses a system call to open a file, then use an integer as ID to refer back to the file handler while reading the contents of the file. The input is formatted while reading each line of the file. As I am familiar with C, I found it easy to handle file I/O in Fortran.
The File I/O handling of COBOL is much harder for me. Since the file format is defined in the File Section, it is rather hard to change file format or do type casting while reading each line from the file. It is inconvenient to change file I/O code because the handling is separated in File Section, Working-Storage Section and Procedure Division.
b.	DDA implementation
Fortran has better numerical functions. I can simply use nint() to round numbers to nearest integer, or use abs() to calculate absolute values.
COBOL is clumcy and ambiguous when it comes to arithmetic calculations. The assignment MOVE X TO Y is in fact copying the value of X to Y, which does not destroy the value of X. I think it should be called COPY instead of MOVE. It has syntax like Fortran with COMPUTE X = A+B, but also has basic functions like ADD A B GIVING X ROUNDED. It feels like COBOL keeps patching to support more features. As a result the program looks messy.
c.	Compiling and Debugging
I uses gfortran -std=legacy to compile and debug my program before using f77 in CSE department’s sparc machines.  The error message from gfortran clearly tells me why and where error occurs. I can quickly identify the lines with errors such as duplicated statement labels or incorrect data types.
Using the MS COBOL Compiler V2.20 is a nightmare. As a beginner of COBOL, it always gives me errors and never tells me why. The error messages always refer to the wrong place, giving me wrong hints to where error occurs. 

2.	Comparing Fortran and COBOL to modern programming languages
a.	Indentation
I understand that first few columns are important back to the days when we write programs with punchcards, but it is looks so stupid to leave blanks in the whole program source code. A smarter compiler should be able to do this for us. Those columns may be used for labeling or continuing the previous line, but does not actually reflect the program flow like python does. Python does not use begin end or {}, it uses indentions, which formulates python programmers to write codes in an easy-to-read style.
b.	Label and GOTO
Modern languages like python do not have label and goto. We cannot jump statements like we did in this assignment. But it is actually handled my compilers automatically so we can no longer do that. (Maybe no longer need to do that)
c.	Documentation
It is easy to find documents and tutorials for modern programming languages. Documents for Fortran77 and COBOL seem to have long gone. Even worse, materials I found on the internet are all about later versions of Fortran and COBOL, which shows me codes that are incompatible to the compiler used in marking. I have to refer to tutorials given by tutors. With the advancement of compliers, I believe modern Fortran and COBOL are much better.
