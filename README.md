# Mini-LISP Interpreter
Final project in NCU CSIE Compiler, 2023 Fall.

## 1.Description Documents
* [Compiler Final Project](./Compiler%20Final%20Project.pdf)
* [Mini-LISP](./Compiler%20Final%20Project.pdf)

## 2.Developement
* Operating System: Mac OS M2
* Language: C++14, Lex, Yacc (Bison)

## 3.Features
### (1) Basic Feature
| Feature              | Description                                       | Points | Pass |
|----------------------|---------------------------------------------------|--------|------|
| Syntax Validation    | Print “syntax error” when parsing invalid syntax  | 10     | ✔️   |
| Print                | Implement print-num statement                     | 10     | ✔️   |
| Numerical Operations | Implement all numerical operations                | 25     | ✔️   |
| Logical Operations   | Implement all logical operations                  | 25     | ✔️   |
| if Expression        | Implement if expression                           | 8      | ✔️   |
| Variable             | Able to define a variable                         | 8      | ✔️   |
| Function             | Able to declare and call an anonymous function    | 8      |     |
| Named Function       | Able to declare and call a named function         | 6      |     |

### (2) Bonus featires
| Feature              | Description                                       | Points | Pass |
|----------------------|---------------------------------------------------|--------|------|
| Recursion            | Support recursive function call                   | 5      |      |
| Type Checking        | Print error messages for type errors              | 5      |      |
| Nested Function      | Nested function                                   | 5      |      |
| First-class Function | Able to pass functions, support closure           | 5      |      |

## 4.Usage
* [run_final.sh](./run_final.sh)
Run this file to compile lex, yacc.
```bash
bison -d -o final.tab.c final.y
gcc -c -g -I. final.tab.c
lex -o lex.yy.c final.l
gcc -c -g -I. lex.yy.c
gcc -o final final.tab.o lex.yy.o -ll
```
* [run_test.py](./run_test.py)
Use this file to run the asset test.

## 5. 


