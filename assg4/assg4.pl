/* CSCI3180 Principles of Programming Languages
   -- Declaration ---
   I declare that the assignment here submitted 
   is original except for source material explicitly
   acknowledged. I also acknowledge that I am aware of
   University policy and regulations on honesty in 
   academic work, and of the disciplinary guidelines
   and procedures applicable to breaches of such policy
   and regulations, as contained in the website
   http://www.cuhk.edu.hk/policy/academichonesty/
   Assignment 4
   Name: 
   Student ID: 
   Email Addr: 
*/

/*

%1a
sum(0,X,X).
sum(s(X),Y,s(Z)):-sum(X,Y,Z).
product(0,Y,0).
product(s(X),Y,Z):-product(X,Y,A),sum(Y,A,Z).

%1b - product of 3 and 4
product(s(s(s(0))),s(s(s(s(0)))),X).

%1c - 8 divided by 4
product(s(s(s(s(0)))),X,s(s(s(s(s(s(s(s(0))))))))).

%1d - factors of 6
product(X,Y,s(s(s(s(s(s(0))))))).

%1e - X^Y = Z
exp(X,0,s(0)).
exp(0,X,0).
exp(X,s(Y),Z):-exp(X,Y,A),product(A,X,Z).

%1f - 2^3
exp(s(s(0)),s(s(s(0))),X).

%1g - log2(8)
exp(s(s(0)),X,s(s(s(s(s(s(s(s(0))))))))).

%2a
transition(a,0,c).
transition(a,1,a).
transition(b,0,c).
transition(b,1,a).
transition(c,0,c).
transition(c,1,b).

%2b
state(N):-transition(X,Y,N).

%2c
walk([],X,X).
walk([X],Y,Z):-transition(Y,X,Z).
walk([S|X],B,E):-walk(X,W,E),transition(B,S,W).

*/