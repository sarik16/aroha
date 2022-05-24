/
declare
cursor cust_detels is select * from customer;
v_rec customer%rowtype;
begin
open cust_detels;
loop
fetch cust_detels into v_rec;
exit when cust_detels%notfound;
dbms_output.put_line(v_rec.cu_name ||' , '|| v_rec.cu_phone);
end loop;
close cust_detels;
end;
/ 
set serveroutput on;

select * from employee;


/ 
declare
cursor crs_emp is select emp_name,emp_sal from employee;
v_name employee.emp_name%type;
v_sal employee.emp_sal%type;
begin
open crs_emp;
loop
fetch crs_emp into v_name,v_sal;
exit when crs_emp%notfound;
if v_sal >2500 then
dbms_output.put_line (v_name||' , '||v_sal || 'a gread');
elsif v_sal >1500 then
dbms_output.put_line (v_name||' , '||v_sal || 'b gread');
elsif v_sal >1000 then
dbms_output.put_line (v_name||' , '||v_sal || 'c gread');
else
dbms_output.put_line (v_name||' , '||v_sal || 'b gread');
end if;
end loop;
close crs_emp;
end;
/


declare
cursor cur_emp is select * from employee;


begin
for i in cur_emp loop 
dbms_output.put_line(i.emp_name ||' , '|| i.emp_sal);

end loop;
end;
/
SET SERVEROUTPUT ON;
----parameterized cursor

declare
cursor cur_emp_details(p_deptno number) is select * from emp where deptno=p_deptno;
begin
for i in cur_emp_details(20) loop
dbms_output.put_line(i.ename||','||i.sal||','||i.job||','||i.deptno);
end loop;
end;
/
set serveroutput on;


/

 
create or replace procedure sp_top_prod as
cursor cur_top_product is
select *
from (select count(s_id) count_sale ,p_name, dense_rank() over(order by count(s_id)desc) rnk
from sales s join product p
on s.p_id = p.p_id
group by p_name) a
where a.rnk < 10;
begin
for i in cur_top_product loop
dbms_output.put_line(i.count_sale ||','||i.p_name);
end loop;
end;
/

exec sp_top_prod;









