1.	Comparing features of object-oriented Perl  and Ruby
a.	Classes in Perl are simulated using hash reference and bless. When creating an object of a class, the class create it a hash object, then use the bless function to associate the reference of that object with the class. After the bless function, the instance can call the methods of the class as instance methods. So, objects are not exactly of that type, where instances in Ruby are clearly defined when they are created. When Perl execute a hash expression, it copies the content of the hash. This makes it able to simulate the creation of multiple instances of the same class.

b.	Since Perl only associate the instance with the class, it can “cast” the object to another class. This is similar to dynamic typing in Ruby.

c.	In Perl, we use package to simulate the class / module as a namespace. In Ruby, it uses “class” to specify a class. Where module is a segment of code that is for being included in multiple classes. In Perl, the simulated class with package only provides variable scoping, but does not mean that it provides other class features such as inheritance.

d.	Ruby can inherit classes by using “<”. Perl can simulate class inheritance by using @ISA. Using @ISA as a global array, it goes through the packages listed in it can look for the package (class) if it is not found within the invoked package. This is not as convenient as Ruby as we have to specify the classes in @ISA.

2.	Differences of scoping in C++ and Perl
a.	C++ only has two types of variable scope, local and global. Variable scope in C++ is static. Perl has local (prefixed with “my”) and global (with $) variable scope, it also has package variables. Package variables except those declared by “our” has dynamic scope. Variables prefixed with local would be temporally masked, so that only itself and the subroutine it call would be able to access it. C++ does not have this feature.

b.	Perl has package and C++ has namespaces. They are very similar, and also similar in syntax. If variables are defined in package or namespaces, they cannot be accessed from other packages / namespaces. In case we need to do that, in Perl we can specify the package name of the variable, like $MyPackage::myVariable. In C++ we can also do the same like mynamespace::myvariable. 


3.	Is dynamic scoping needed in a programming language?
a.	I don’t see much importance of having dynamic scoping. In case we need this feature, there are better ways of doing it. If we write programs for task 2 in object oriented programming, we can just create a Client class that takes credit limit as a parameter in the constructor. So that once after the instance is created, each of them has a separate credit limit. However when Perl was designed, it does not seem to have object oriented programming in mind, so that it would not be as strict forward when writing an object oriented version of task 2 in Perl.

b.	Dynamic scoping would be handy in some condition. The program is written by one person, is relatively short and has a few variables. Task 2 does fit in these conditions so it is OK to use dynamic scoping. In Task 2, the repayment and payment subroutine, the dynamic scoping on variable $creditLimit allows these subroutine to first look for the variable from where it is called, then look for the global scope if the variable is not found in the caller. The local scope of creditLimit in premierClient behaves like overriding the global predefined creditlimit of 5000. 


c.	Dynamic scoping would be chaotic when the program is large, has many (global) variables and cooperating with more programmers. Readability of programs with dynamic scoping would be a headache. If there are any bugs, tracing a variable would be hard because we not only have to trace the variable by its name, but also have to trace where the subroutine is being called. Looking for whether a variable is being modified
