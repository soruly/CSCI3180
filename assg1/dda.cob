      * CSCI3180 Principles of Programming Languages
      * --- Declaration ---
      * I declare that the assignment here submitted 
      * is original except for source material explicitly
      * acknowledged. I also acknowledge that I am aware of
      * University policy and regulations on honesty in 
      * academic work, and of the disciplinary guidelines
      * and procedures applicable to breaches of such policy
      * and regulations, as contained in the website
      * http://www.cuhk.edu.hk/policy/academichonesty/
      * Assignment 1
      * Name: 
      * Student ID: 
      * Email Addr: 
      
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DDA.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE
               ASSIGN TO DISK
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE
               ASSIGN TO DISK
               ORGANIZATION IS LINE SEQUENTIAL.
      
       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE
           LABEL RECORDS ARE STANDARD
            VALUE OF FILE-ID IS "input.txt".
       01  FILE-DATA-POINT.
           05  FILE-X     PIC XX.
           05  FILE-S     PIC X.
           05  FILE-Y     PIC XX.
       
       FD  OUTPUT-FILE
           LABEL RECORDS ARE STANDARD
            VALUE OF FILE-ID IS "output.txt".
       01  OUTPUT-GRAPH.
           05 OUTPUT-LINE PIC X(79).
      
       WORKING-STORAGE SECTION.
       01  DATA-POINT.
           05  X1     PIC 99.
           05  Y1     PIC 99.
           05  X2     PIC 99.
           05  Y2     PIC 99.
       01  END-OF-FILE            PIC X VALUE "N".
       01  LINES-COUNT       PIC 99.
       01  A       PIC 9999.
       01  B       PIC 9999.
       01  C       PIC 9999.
       01  D       PIC 9999.
       01  I       PIC 9999.
       01  J       PIC 9999.
       01  K       PIC 9999.
       01  X       PIC 9999.
       01  Y       PIC 9999.
       01  M       PIC S9999V9999.
       01  M-DISPLAY PIC -9999.9999.
       01  GRAPH-2D.
           05 GRAPH-LINE OCCURS 23 TIMES INDEXED BY GRAPH-X-INDEX.
              10 GRAPH OCCURS 79 TIMES INDEXED BY GRAPH-Y-INDEX.
                 15 GRAPH-P PIC X.
       
       PROCEDURE DIVISION.
       MAIN-LOGIC SECTION.
       
      * GRAPH is the working storage
      * This program "draws" directly on this variable
      * This program runs in this order
      * Init
      * Draw Graph Axis
      * Load lines from file
      *  - read each line
      *  - draw the line
      * Display the graph
      * Save the graph to file
      
       PROGRAM-BEGIN.
           GO TO INIT.
           
       PROGRAM-DONE.
           STOP RUN.
       
       INIT.
           MOVE " " TO GRAPH-2D.
           GO TO DRAW-AXIS.
       
       DRAW-AXIS.
           MOVE "+" TO GRAPH(1 1).
           MOVE 2 TO I.
           GO TO DRAW-AXIS-X.
       DRAW-AXIS-X.
           MOVE "-" TO GRAPH(1 I).
           COMPUTE I = I + 1.
           IF I < 80
               GO TO DRAW-AXIS-X.
           MOVE 2 TO I.
           GO TO DRAW-AXIS-Y.
       DRAW-AXIS-Y.
           MOVE "|" TO GRAPH(I 1).
           COMPUTE I = I + 1.
           IF I < 24
               GO TO DRAW-AXIS-Y.
           GO TO LOAD-LINES.
       
      * Load total number of lines
       LOAD-LINES.
           OPEN INPUT INPUT-FILE.
           READ INPUT-FILE.
           INSPECT FILE-X REPLACING ALL ' ' BY '0'.
           MOVE FILE-X TO LINES-COUNT.
           MOVE 0 TO I.
           MOVE 0 TO X2.
           MOVE 0 TO Y2.
           GO TO READ-LINES.
           
      * Load each lines from file
       READ-LINES.
           MOVE X2 TO X1.
           MOVE Y2 TO Y1.
           READ INPUT-FILE NEXT RECORD
               AT END
               MOVE "Y" TO END-OF-FILE.
           INSPECT FILE-X REPLACING ALL ' ' BY '0'.
           INSPECT FILE-Y REPLACING ALL ' ' BY '0'.
           MOVE FILE-X TO X2.
           MOVE FILE-Y TO Y2.
           COMPUTE I = I + 1.
           IF I EQUAL 1
               GO TO READ-LINES.
           IF I NOT GREATER THAN LINES-COUNT
               GO TO DRAW-LINE.
           IF I > LINES-COUNT
               CLOSE INPUT-FILE
               GO TO DISPLAY-GRAPH.
               
       DRAW-LINE.
           COMPUTE M = (Y2 - Y1) / (X2 - X1).
           MOVE M TO M-DISPLAY.
           IF M NOT GREATER THAN 1 AND M NOT LESS THAN -1
               GO TO DRAW-GENTLE-LINE.
           GO TO DRAW-STEEP-LINE.
       
      * Case 1
       DRAW-GENTLE-LINE.
           MOVE 0 TO J.
           MOVE X1 TO A.
           MOVE Y1 TO B.
           MOVE X2 TO C.
           MOVE Y2 TO D.
           MOVE X2 TO X.
           MOVE Y2 TO Y.
           IF X2 > X1
               MOVE X2 TO A
               MOVE Y2 TO B
               MOVE X1 TO C
               MOVE Y1 TO D
               MOVE X1 TO X
               MOVE Y1 TO Y.
           GO TO DRAW-GENTLE-LINE-LOOP.
   
       DRAW-GENTLE-LINE-LOOP.
           IF X < A
               COMPUTE X = C + J
               ADD D M GIVING Y ROUNDED
               COMPUTE Y ROUNDED = D + (J * M)
               COMPUTE X = X + 1
               COMPUTE Y = Y + 1
               MOVE "*" TO GRAPH(Y X)
               COMPUTE X = X - 1
               COMPUTE Y = Y - 1
               COMPUTE J = J + 1
               GO TO DRAW-GENTLE-LINE-LOOP.
           GO TO READ-LINES.
       
      * Case 2
       DRAW-STEEP-LINE.
           MOVE 0 TO J.
           MOVE X1 TO A.
           MOVE Y1 TO B.
           MOVE X2 TO C.
           MOVE Y2 TO D.
           MOVE X2 TO X.
           MOVE Y2 TO Y.
           IF Y2 > Y1
               MOVE X2 TO A
               MOVE Y2 TO B
               MOVE X1 TO C
               MOVE Y1 TO D
               MOVE X1 TO X
               MOVE Y1 TO Y.
           GO TO DRAW-STEEP-LINE-LOOP.
       
       DRAW-STEEP-LINE-LOOP.
           IF Y < B
               COMPUTE Y = D + J
               ADD C M GIVING X ROUNDED
               COMPUTE X ROUNDED = C + (J / M)
               COMPUTE X = X + 1
               COMPUTE Y = Y + 1
               MOVE "*" TO GRAPH(Y X)
               COMPUTE X = X - 1
               COMPUTE Y = Y - 1
               COMPUTE J = J + 1
               GO TO DRAW-STEEP-LINE-LOOP.
           GO TO READ-LINES.
           
       DISPLAY-GRAPH.
           MOVE 23 TO I.
           GO TO DISPLAY-GRAPH-LOOP.
       DISPLAY-GRAPH-LOOP.
           DISPLAY GRAPH-LINE(I).
           COMPUTE I = I - 1.
           IF I > 0
               GO TO DISPLAY-GRAPH-LOOP.
           GO TO SAVE-GRAPH.  
           
       SAVE-GRAPH.
           OPEN OUTPUT OUTPUT-FILE.
           MOVE 23 TO I.
           GO TO SAVE-GRAPH-LOOP.
       SAVE-GRAPH-LOOP.
           MOVE GRAPH-LINE(I) TO OUTPUT-LINE.
           WRITE OUTPUT-GRAPH.
           COMPUTE I = I - 1.
           IF I > 0
               GO TO SAVE-GRAPH-LOOP.
           CLOSE OUTPUT-FILE.
           GO TO PROGRAM-DONE.
           