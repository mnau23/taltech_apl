# Task
> Write a parser using Flex & Bison that describes enough of SQL grammar that it:
> - can parse every statement in file oracle.sql and would print that the statement is OK;
> - cannot parse statements in error.sql and would print the parser error message.
>
> Please note that the final parser shouldn't have any shift/reduce conflicts.


## Usage
Open CygWin Terminal.

```bash
flex task.l
bison -d -r all task.y
gcc lex.yy.c task.tab.c -o task
./task oracle.sql
./task error.sql
```