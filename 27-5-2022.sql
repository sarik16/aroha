reate table cont_tab(
contract_id number(20),
contract_type varchar2(40),
cont_s_date date,
cont_e_date date,
cpt_id number(20),
cont_amt number(20),
ins_date date,
upd_date date);

insert into cont_tab values(12345,'government','10-jan-10','10-jan-11',101,700000,'10-jan-10',null);
insert into cont_tab values(12879,'government','03-feb-11','15-feb-12',102,489938,'03-feb-11',null);
insert into cont_tab values(12987,'government','15-feb-11','20-feb-13',103,200000,'15-feb-11',null);
insert into cont_tab values(12346,'government','01-sep-12','10-feb-13',100,400000,'01-Sep-12','10-apr-13');

create table expd_rcv_tab(exp_rec_id number(4),exp_rec_date date,contract_id number(20),amount number(20));
  
create table con_pay_terms(cpt_id number(20),freq_of_pmt varchar2(30));

insert into con_pay_terms values(100,'monthly');
insert into con_pay_terms values(101,'quarterly');
insert into con_pay_terms values(102,'half yearly');
insert into con_pay_terms values(103,'yearly');

select * from cont_tab;
select * from con_pay_terms;
SELECT * FROM expd_rcv_tab;
commit;

CREATE SEQUENCE SEQ_CONT
START WITH 11
INCREMENT BY 1
MINVALUE 10
MAXVALUE 100
CYCLE 
CACHE 5;

/
CREATE OR REPLACE PROCEDURE SP_CONTRACT AS
CURSOR C IS SELECT * FROM CONT_TAB;
v_cnt number :=0;
m_cnt number :=0;
a_date date;
exist exception;
begin
for i in c loop
   select count(*) into v_cnt
   from expd_rcv_tab
   where exp_rec_date = i.cont_s_date
   and contract_id = i.contract_id;
   
      if v_cnt =0 then
      m_cnt := months_between(i.cont_e_date,i.cont_s_date) ;
      a_date := add_months(i.cont_s_date,m_cnt);
        if i.cpt_id =100 then
           while i.cont_s_date<a_date loop
           insert into expd_rcv_tab values (SEQ_CONT.nextval,i.cont_s_date,i.contract_id,i.cont_amt/m_cnt);
           i.cont_s_date := add_months( to_char(i.cont_s_date),1);
           end loop;
        elsif i.cpt_id =101 then
           while i.cont_s_date<a_date loop
           insert into expd_rcv_tab values (SEQ_CONT.nextval,i.cont_s_date,i.contract_id,i.cont_amt/(m_cnt/3));
           i.cont_s_date := add_months( to_char(i.cont_s_date),3);
           end loop;
        elsif i.cpt_id =102 then
           while i.cont_s_date<a_date loop
           insert into expd_rcv_tab values (SEQ_CONT.nextval,i.cont_s_date,i.contract_id,i.cont_amt/(m_cnt/6));
           i.cont_s_date := add_months( to_char(i.cont_s_date),6);
           end loop;
        elsif i.cpt_id =103 then
           while i.cont_s_date<a_date loop
           insert into expd_rcv_tab values (SEQ_CONT.nextval,i.cont_s_date,i.contract_id,i.cont_amt/(m_cnt/12);
           i.cont_s_date := add_months( to_char(i.cont_s_date),12);
           end loop;
        end if;
     end if;
   end loop;
exception
when exist then
dbms_output.put_line('The contract details are already present');
end;

  
 
 

/
EXEC SP_CONTRACT;
                  
SET SERVEROUTPUT ON

SELECT * FROM EXPD_RCV_TAB;

TRUNCATE TABLE EXPD_RCV_TAB;


--1. Write a procedure to display the records of employees whose salary is greater than 10000.
select * from employee;
/
create or replace procedure sp_check_sal as
cursor c is select * from employee where emp_sal>10000;
v_sal int;
begin
for i in c loop
 
 dbms_output.put_line(i.emp_name|| '' ||i.emp_sal);
 
 end loop;
 end;
/
exec sp_check_sal;

--2. Write a procedure to increment the salary of an employee based on his salary
--If salary>20000 increment by 1500
--If salary>10000 increment by 1000
--If salary>5000 increment by 500
--Else ‘no increment’
/
create or replace procedure sp_inc_sal as
cursor c_sal is select * from emp for update;
v_sal int;
begin
for i in c_sal loop
  
    
    if i.sal>2000 then
    update emp
    set sal = i.sal+150 
    where current of c_sal;
    
    elsif i.sal>1000 then
    update emp
    set sal = i.sal+100
    where current of c_sal;
    
    elsif i.sal>500 then
    update emp
    set sal = i.sal+50
    where current of c_sal;
    
    else 
    dbms_output.put_line('no increment');
    end if;
 end loop;
end; 

/
exec sp_inc_sal;
/
select * from emp;
--3. Write a procedure to print total salary with respect to department.(deptwise total sal)
/
create or replace procedure sp_sal_dept as
cursor c_sum_sal is select deptno, sum(sal) sum_sal from emp group by deptno;

begin
for i in c_sum_sal loop
   dbms_output.put_line(i.deptno||','||i.sum_sal);
end loop;
end;
/
exec sp_sal_dept;
/
set serveroutput on
--4. Write a procedure to print ename, job, mgr and deptno using record type by passing the empno at runtime.
create or replace procedure sp_empno(p_empno number) as
cursor c_empno is select * from emp where empno=p_empno;

begin

for i in c_empno loop
  dbms_output.put_line(i.ename||','||i.sal||','||i.job||','||i.deptno);
end loop;
end;

/
exec sp_empno(7369);
/
set serverout on;
select * from emp;