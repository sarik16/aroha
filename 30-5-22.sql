create table agency_src
(agency varchar(20),
program_name varchar(20),
fiscal_year int,
original_appr_amount numeric);

create table agency_tgt
(agency varchar(20),
program_name varchar(20),
fiscal_year int,
Original_appr_amount numeric,
program_amount numeric,
agency_amount numeric,
total_amount numeric);

select * from agency_src;
select * from agency_tgt;

insert into agency_src values('Education','High school grant',2005,350000);
insert into agency_src values('Education','Middle school grant',2005,50000);
insert into agency_src values('Education','High school grant',2004,250000);
insert into agency_src values('Dep','Air',2005,50000);
insert into agency_src values('Dep','Air',2004,60000);
insert into agency_src values('Dep','Water',2005,70000);

/
create or replace procedure sp_agency as
cursor c_agen is select * from agency_src;
exist exception;

begin
 for i in c_agen loop
 insert into agency_tgt values (i.agency,i.program_name,i.fiscal_year,i.original_appr_amount,
                                (select sum(original_appr_amount)
                                from agency_src
                                where program_name =i.program_name),
                                (select sum(original_appr_amount)
                                from agency_src
                                where agency =i.agency),
                                (select sum(original_appr_amount)
                                from agency_src));
   end loop;
   
   exception
     when exist then
     dbms_output.put_line(sqlcode||','||sqlerrm);
  end;   
/
exec sp_agency;
/
select * from agency_tgt;
/
truncate agency_tgt;

--. Write a procedure to delete the duplicate records using cursor.
/
create or replace procedure sp_delete as
cursor c_delete is select * from dept;
v_cnt int;
begin
 for i in c_delete loop
 delete table dept
 where rowid not in (select max(rowid) 
                      from dept
                      where deptno=i.deptno and dname=i.dname and loc=i.loc);
 end loop;
 end;
 /
exec sp_delete;
/
--. Write a procedure to print top 5 employees based on the salary in each dept using cursor

/
create or replace procedure sp_top_prod as
cursor cur_top_product is
select *
from (select count(s_id) count_sale ,p_name, dense_rank() over(order by count(s_id)desc) rnk
from sales s join product p
on s.p_id = p.p_id
group by p_name) a
where a.rnk < 5;
begin
for i in cur_top_product loop
dbms_output.put_line(i.count_sale ||','||i.p_name);
end loop;
end;
/
set serveroutput on;
exec sp_top_prod;
/
--.Write a procedure to print the Output as
--Deptname :Accounts
--John
--Smith
--Deptname: Hr
--Clark
--Miller

/
create or replace procedure sp_dept_emp as
cursor c_dept is select * from dept;
cursor c_emp is select * from emp ;
                 
                 
begin 
  for i in c_dept loop
  dbms_output.put_line('dept_name'||':'||i.dname);
    for j in c_emp loop
    dbms_output.put_line(j.ename);
  end loop;
  end loop;
end;  
/
exec sp_dept_emp;