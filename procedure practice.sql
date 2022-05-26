
--1. Write a procedure by passing the date and display the whether the year is leap year or not.
/
create or replace procedure sp_leap_year(p_year date)as
a number:=to_char(p_year,'yyyy');
begin
     if mod(a,4)=0 then 
     dbms_output.put_line (a||' is leap year');
      else 
      dbms_output.put_line (a||' is not leap year');
     end if;
end; 
/
set serveroutput on;
exec sp_leap_year('22-may-2024');



--2. Write a procedure which takes product name and print a message if it made sales today or not?
/
create or replace procedure sp_prod_nm(prod_name varchar2) as
p_cnt int;

begin
 select count(*) into p_cnt
 from product p ,sales s
 where p.p_id =s.p_id 
 and  prod_name =p_name
 and s_date = sysdate;
    if p_cnt=0 then
      dbms_output.put_line (prod_name||' is not sale today');
    else
        dbms_output.put_line (prod_name||' sales happend');
    end if;
end;  

 /

exec sp_prod_nm('laptop');
/

--3. Write a procedure which takes product name and print the no. of sales it made in the current year and in previous year.
/
create or replace procedure sp_no_sale(prod_name varchar) as
   ccnt number;
   pcnt number;
 
begin
  select count(p_name) into ccnt
  from sales s,product p
  where s.p_id=p.p_id and  prod_name=p_name and to_char(s_date,'yyyy') = to_char(sysdate,'yyyy') ;
  dbms_output.put_line(ccnt);
 
  select count(p_name) into pcnt
  from sales s,product p
  where s.p_id=p.p_id and  prod_name=p_name and to_char(s_date,'yyyy') = to_char(sysdate,'yyyy')-1 ;
  dbms_output.put_line(pcnt);
  end ;
  /
  exec sp_no_sale('laptop');
 /
--4.Write a code which takes cust_id and display whether he is from metro city or not.
 /
create or replace procedure sp_metro (pc_id number) as
  cnt number;
 
  begin
  select count(cu_id) into cnt
  from customer c,cityy ct
  where c.cityy_id =ct.cityy_id and cu_id=pc_id and metro_flag='s';
  if cnt=0 then
  dbms_output.put_line('not from met city');
  else
  dbms_output.put_line(' from met city');
  end if; 
  end;
  /
   exec sp_metro(100);
/
--5.Write a procedure which accepts an email id as input and prints the domain name of that email id (Eg: I/p john@gmail.com. o/p: gmail)
/
create or replace procedure sp_email(p_email varchar2)as
v_str varchar2(20);

begin
select substr(p_email,instr(p_email,'@')+1,instr(p_email,'.')-instr(p_email,'@')-1) into v_str
from dual;
dbms_output.put_line(v_str||' this is email');
end;

/
exec sp_email('shariquea16@gmail.com');
/
--6. Write a procedure to populate all the records from cust_src to 
--cust_tgt but the condition is there should not be any duplicate records.
--Cust_src
--Cust_id		cust_name	cust_addr	cust_city

--Cust_tgt
--Cust_id		Cust_name	cust_addr	Cust_city
/
create or replace procedure sp_trt_src as
cursor c is  
          select Cust_id,Cust_name,cust_addr,Cust_city
          from cust_src;
v_cnt number;
begin
    for i in c loop
       select count(*) into v_cnt
        from cust_src
        where cust_id = i.cust_id;
      if v_cnt =0 then
      insert into cust_tgt values (i.cust_id,i.cust_name,i.cust_addr,i.cust_city);
      else
       dbms_output.put_line('there is dup val');
       end if;
  end loop;
end;

/

exec sp_trt_src;
/

--7.Create a procedure which accepts an email id as input and prints if the 
--id is valid or not.
 --Conditions to qualify for a mail id to be valid:
-- There should be only a single @.
-- ID not to start with @ or end with @
/
 create or replace procedure sp_email(pemail varchar)as
  cnt  number;
  dcount number; 
  begin 
  select regexp_count(pemail,'@') into cnt
  from dual
  where pemail not like '@%';
  
  select regexp_count(substr(pemail,instr(pemail,'@')),'[.]') into dcount
   from dual; 
  if cnt=1 then 
  if dcount=2 then
  dbms_output.put_line('valed email');
 
  else
    dbms_output.put_line('invaled email');

  end if;
  end if;
  end;
   /
   set serveroutput on;
   exec sp_email('shariquea16@gmail.com')
   /
--8.Write a procedure to update the order completion date, 
--the condition to populate that column is If the order date is between 
--Monday and Thursday then insert completion date as Friday of that week and if the 
--order date is Friday,Saturday and Sunday then insert completion date 
--as next Monday date.

--Orders
--	Order_date	   Order_completion_date
--	1-jan-19	      4-Jan-19	   
--	10-jan-19	      11-Jan-19
--	1-feb-19	      4-Feb-19
--	20-feb-19	      22-Feb-19
--	25-Feb-19	      1-Mar-19
/
create or replace procedure sp_date as
v_cnt number(4);
v_start date;
v_end date;
v_date date:=to_char(sysdate,'dy');
begin
v_start := trunc(sysdate,'yyyy');
v_end := last_day(v_start);
while (v_start<=v_end) loop
select count(v_date) into v_cnt
from order_date
where v_date=v_start;
if to_char (v_start,'dy')in ('fri','sat','sun') and v_cnt=0 then
insert into order_completion values (v_date);
else
insert into order_completion values (v_date+7);
end if;
v_start := v_start+1;
end loop;
end;
/
exec sp_date;
/

--9.  Write a query to display the code of the recent procedure 
--which you have written using data dictionary?
/
select * from user_procedures;
/
