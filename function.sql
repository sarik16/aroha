/
create or replace function fn_cnt_product return number as
v_cnt int;
begin
select count(p_id) into v_cnt
from product;
return v_cnt;
end;
/
variable b_cnt number;
exec : b_cnt := fn_cnt_product;
print : b_cnt;
/
select * from product;
/
select fn_cnt_product from dual; 

/

/
--1.Write a function to print the factorial of a number.
/
create or replace function fn_factorial(a number) return number as
n number(10) :=1;
begin
for i in 1..a loop
n :=n*i;
end loop;
return n;
end;
/
select fn_factorial(5) from dual;
/
--2. Write a plsql function by passing age and gender, if age <18 then return 0 otherwise return the 
--no. of employees who are in that age and gender.
/
create or replace function fn_age_gender(emp_age number, emp_gender varchar2)
return number as
e_cnt number(10);
begin
select count(*) into e_cnt
from employee
where trunc(months_between(sysdate,emp_dob)/12) =emp_age
and gender = emp_gender;
if emp_age < 18 then
return 0;
else
return e_cnt;
end if;
end;
/
select * from employee;
/



--3. Write a function that takes P,R,T as inputs and returns SI. SI=P*R*T/100
/
create or replace function fn_multi(p number,r number,t number)
return number as
m number;
begin
m := p*r*t/100;
return m;
end;
/
select fn_multi(2,2,2) from dual;
/
--4.Write a function which takes a date in string format and display whether it is a valid date or not. 
/
create or replace function fn_take_date(p_date varchar2)
return varchar2 as

v_date date;
begin 
v_date := to_date(p_date,'dd-mon-yyyy');
if p_date = v_date then
return 'valid date';
else
return 'not valid date';
end if;
end;

/
select fn_take_date('31-jan-2022') from dual;
select fn_take_date('31-jan-22') from dual;

/


--5.Write a function which takes Email as input and display whether it is a valid email id or not.
--The rules for finding out validity of email is – 
--•	It should contain at least one ‘@’ symbol. 
--•	It should not contain more than one @ symbol.
--•	Email id should not start and end with @
--•	After @ there should be at least 2 tokens.  (i.e .co.in but not .com)
/
create or replace function fn_email(email varchar2)
return varchar2 as

begin
if instr(emails, '@') = 1 and

	select instr('aroha','b') from dual;
    select substr('aroha tech',7,4) from dual;
/






--6.Write a function to print the factorial of a number without using loop(Hint:Use recursive function)
/
create or replace function factorial_recursive(n number) return number as

begin
if n = 1 then
return n;
else
return n * factorial_recursive(n-1);
end if;
end;
 /
 select factorial_recursive(3) from dual;
 /

--7. Write a function which takes a value from the user and check whether the given values is a number or not. 
--If it is a number, return ‘ valid Number’ otherwise ‘invalid number’.
--Phone Number- should have 10 digits, all should be numbers and phno should start with 9 or 8 or 7.
/
create or replace function fn_mob_num (mobil varchar2)
return varchar2 as

begin
if  length(to_char(mobil)) = 10 and substr(mobil,1,1) in (9,8,7) then
return 'valid number';
else
return 'invalid number';
end if;
end;
/
select fn_mob_num ('7890654320') from dual;
select fn_mob_num ('789065432') from dual;
select fn_mob_num ('6890654320') from dual;

/
--8. Can we write DML inside a function? If yes, Write a plsql function to update the job of an employee by 
--passing empno and returning the updated job. Can we execute in Select statement?Use returning clause to return the updated job.





--9.Create a function that takes date as input and return the no of customers who made sales in that year.
/
create or replace function fn_cust_sale(cs_date varchar2)
return number as
c_cnt number;
begin
select count(*) into c_cnt
from customers c ,sale s
where c.cu_id = s.cu_id
and to_char(s_date,'yy') = cs_date;

return c_cnt;
end;
/
select fn_cust_sale('01') from dual;
select fn_cust_sale('03') from dual;
select fn_cust_sale('05') from dual;

/
select * from customers;
select * from sale;
/
--10.Write  a function by passing 2 dates and return the no. of Saturdays between two dates.
/
create or replace function fn_two_dates(f_date varchar2 ,l_date varchar2)
return number as
v_cnt number := 0;
a_date date := f_date;
b_date date := l_date;
begin
while a_date <= b_date loop
if to_char(a_date,'dy') = 'sat'then
 v_cnt := v_cnt + 1;
end if;
 a_date := a_date +1;
end loop;
return v_cnt;
exception
when others then 
return -1;
end;
/
select fn_two_dates('01-may-2022','30-may-2022') from dual;
/
--11.Write a function by passing  2 dates and display the months between 2 dates. Ex jan-15 and jul-15   o/p  Feb-15,Mar-15,Apr-15,May-15,Jun-15.
/
create or replace function fn_mon_between(f_date varchar2, l_date varchar2)
return varchar2 as
--v_date varchar2(500);
a_date date :=f_date;

begin
while a_date <= l_date loop
a_date := add_months(f_date,1);
  -- v_date := v_date +1;
--end if;
 a_date := a_date +1;
--end loop;
return a_date;
end loop;
end;
/
select fn_mon_between('15-jan-2022','15-may-2022') from dual;


/
--12.Create a function by passing to  2 strings, if it is a number print the sum of 2 numbers else print the concatenation of 2 strings.
/
create or replace function fn_str_num(f_str varchar2,s_str varchar2)
return varchar2 as
begin
if regexp_like(f_str,'^[0-9]+$') and regexp_like(s_str,'^[0-9]+$') then
return f_str + s_str;
else
return f_str || s_str;
end if;
end;

/
select fn_str_num(2,2) from dual;
select fn_str_num('ab','cd') from dual;

/

--13.Write a function to return all the column names by passing table_name at runtime.
/
create or replace fn_pass_table (t_name varchar2)
return varchar2 as
v_emp varchar2(500) ;
v_col int ;

begin
v_emp := 'select count(column_name) from user_tab_columns where table_name='||''''||upper( t_name)||'''';
execute immediate v_emp into v_col;
return v_col;
end;


/
--14.Can we call a procedure inside function or can we call function inside a function? Write a code with your own scenario.

--15.Write a function to return the YTD sales amount of current year and previous year.

--16.Can we call procedure inside a function or function inside a procedure? Write a code with your own scenario.

--17. Write a query to display all the functions created in the database using data dictionary.

select * from employee;