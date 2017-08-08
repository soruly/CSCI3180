C       CSCI3180 Principles of Programming Languages
C       --- Declaration ---
C       I declare that the assignment here submitted 
C       is original except for source material explicitly
C       acknowledged. I also acknowledge that I am aware of
C       University policy and regulations on honesty in 
C       academic work, and of the disciplinary guidelines
C       and procedures applicable to breaches of such policy
C       and regulations, as contained in the website
C       http://www.cuhk.edu.hk/policy/academichonesty/
C       Assignment 1
C       Name: 
C       Student ID: 
C       Email Addr: 
        
        PROGRAM dda
           IMPLICIT NONE
           integer a, b, n, h, i, j, k, xi, yi, xj, yj
           integer fio, io
           real m
           character c
           character graph(23,79)
           
C          initialize the array and draw axis
           i = 23
           j = 1
010        IF (i .GE. 1) GOTO 020
015        GOTO 040
020           IF (j .LE. 79) GOTO 030
025           GOTO 040
C                print *, i, j
030              graph(i,j) = ' '
                 IF (i .EQ. 1 .AND. j .EQ. 1) GOTO 033
                 IF (j .EQ. 1) GOTO 031
                 IF (i .EQ. 1) GOTO 032
                 GOTO 035
031              graph(i,j) = '|'
                 GOTO 035
032              graph(i,j) = '-'
                 GOTO 035
033              graph(i,j) = '+'
                 GOTO 035
035              j = j + 1
                 IF (j .GT. 79) GOTO 038
                 GOTO 020
038                 j = 1
                    i = i - 1
                    GOTO 010
C          =========================================
                    
C          start reading file input
040        open(unit=1234,file="input.txt",status='old',IOSTAT=fio)
           if (fio .NE. 0) GOTO 050
           GOTO 060
050        PRINT *,"Cannot open input.txt"
           PRINT *,"Program terminates"
           GOTO 340
C          read the first line (number of points)
060        k = 1
           read (1234,*) n
           
C          read the first point
           k = 2
           read (1234,*, end=340) a,b
           xj = a
           yj = b
           
C          check whether we have read all points
100        IF (k .LE. n) GOTO 105
           GOTO 300
105           k = k + 1
              GOTO 110
              
C          read the next point
110        read (1234,111, IOSTAT=io) a,c,b
111        format (I2,A1,I2)
C          print *, a,b
           xi = xj
           yi = yj
           xj = a
           yj = b
C          handle divide by zero first
           IF (xj .NE. xi) GOTO 112
           m = float(999)
           GOTO 210
112        m = float(yj - yi) / float(xj - xi)
          
C          Case 1 : |m| <= 1
210        IF (m .LE. 1 .AND. m .GE. -1) GOTO 211
           GOTO 220
211           i = 0
              a = xj
              b = yj
              h = xi - xj
212           IF (xi .LT. xj) GOTO 213
              GOTO 214
213              a = xi
                 b = yi
                 h = xj - xi
214           IF (i .LE. h) GOTO 215
              GOTO 220
215              j = nint(b + i * m)
                 graph(j+1,a+i+1) = '*'
                 i = i + 1
                 GOTO 214
           
C          Case 2 : |m| > 1
220        IF (m .GT. 1 .OR. m .LT. -1) GOTO 221
           GOTO 299
221           i = 0
              a = xj
              b = yj
              h = yi - yj
222           IF (yi .LT. yj) GOTO 223
              GOTO 224
223              h = yj - yi
                 a = xi
                 b = yi
224           IF (i .LE. h) GOTO 225
              GOTO 299
225              j = nint(a + i / m)
C                special case for vertical lines
                 IF (m .GT. 998) GOTO 226
                 GOTO 227
226              j = a
227              graph(b+i+1,j+1) = '*'
                 i = i + 1
                 GOTO 224
           
299        graph(yi+1,xi+1) = '*'
           graph(yj+1,xj+1) = '*'
           GOTO 100
C          =========================================

C          Display the graph
300        i = 23
           j = 1
310        IF (i .GE. 1) GOTO 320
315        GOTO 340
320           IF (j .LE. 79) GOTO 330
325           GOTO 340
330              write (*,"(a,$)"), graph(i,j)
                 j = j + 1
                 IF (j .GT. 79) GOTO 335
                 GOTO 320
335                 write (*,"(a)"), ""
                    j = 1
                    i = i - 1
                    GOTO 310
340     close(1234, iostat=fio)
        END