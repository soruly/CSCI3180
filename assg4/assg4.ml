(* CSCI3180 Principles of Programming Languages
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
*)

datatype 'a bTree = nil | bt of 'a bTree * 'a * 'a bTree;

(*3a*)
fun inorder(nil) = []
  | inorder(bt(left,node,right)) = inorder(left)@(node::inorder(right));

(*3b*)
fun preorder(nil) = []
  | preorder(bt(left,node,right)) = node::(preorder(left)@preorder(right));

(*3c*)
fun postorder(nil) = []
  | postorder(bt(left,node,right)) = (postorder(left)@postorder(right))@node::[];

(*4a*)
fun symmetric(i,0,[]) = true
  | symmetric(1,n,lst) =
    if hd(lst) = hd(rev(lst))
    then true
    else false
  | symmetric(i,n,lst) = 
    if i = 1 orelse i = n (* either the head or tail hit the target *)
    then symmetric(1,n,lst) (* compare target element *)
    else symmetric(i-1,n-2,rev(tl(rev(tl(lst))))) (* remove first and last element *) 

(*4b*)
fun palindrome(0,[]) = true
  | palindrome(1,lst) = symmetric(1,1,lst)
  | palindrome(n,lst) = symmetric(n,n,lst) andalso palindrome(n-2,rev(tl(rev(tl(lst)))));

(*4c*)
(* rev is built-in function, so I use reverse instead of rev to avoid confusion *)
fun reverse([]) = []
  | reverse(a::b) = reverse(b)@a::[];
