--must specify at least 1 column
SELECT FROM dept;

--must specify table
SELECT * FROM;

--commas only between column names
SELECT deptno, loc, 
FROM dept;

--operations need 2 operands
SELECT ename, sal, sal+-100* 
FROM emp;

--parentheses must end
SELECT ename, sal, (sal+100*1.2
FROM emp;

--no arithmetic operations with tables
SELECT * 
FROM emp - dept;

--no logical operations with tables
SELECT * 
FROM dept IS NULL;

--alias needs to be specified
SELECT ename AS 
FROM emp;

--only 1 alias
SELECT ename AS name name
FROM emp;

--only 1 AS
SELECT ename AS name AS name2
FROM emp;

--concatenation needs 2 operands as well
SELECT ename || ' is a ' || AS "Employee Details" 
FROM emp;

--WHERE clause after from
SELECT	ename, job, deptno
WHERE	job='CLERK'
FROM	emp;

--invalid comparison operator
SELECT	ename, sal, comm
FROM	emp
WHERE	sal><comm;

--faulty BETWEEN
SELECT	ename, sal
FROM	emp
WHERE	sal BETWEEN 1000;

--"IS" is required
SELECT	ename, mgr
FROM	emp
WHERE	mgr NULL;

--OR operator requires comparisons
SELECT	empno, ename, job, sal
FROM	emp
WHERE	sal 
OR	'CLERK';

--NOT NULL
SELECT	ename, job
FROM	emp
WHERE	comm IS NOT;
