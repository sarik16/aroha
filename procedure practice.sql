
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
  select count(*) into ccnt
  from sales s,product p
  where s.p_id=p.p_id and  prod_name=p_name and to_char(s_date,'yyyy') = to_char(sysdate,'yyyy') ;
  dbms_output.put_line(ccnt);
 
  select count(p_name) into pcnt
  from sales s,product p
  where s.p_id=p.p_id and  prod_name=p_name and to_char(s_date,'yyyy') = to_char(sysdate,'yyyy')-1 ;
  dbms_output.put_line(pcnt);
 
 
  end ;
  /
  exec sp('laptop');
 /
--4.Write a code which takes cust_id and display whether he is from metro city or not.
 
 /
create or replace procedure sp_metro (pc_id number) as
  cnt number;
 
  begin
  select count(cust_id) into cnt
  from customer_f c,city_f ct
  where c.city_id =ct.city_id and cust_id=pc_id and metro_flag='s';
  if cnt=0 then
  dbms_output.put_line('not from met city');
  else
  dbms_output.put_line(' from met city');
  end if;
  exception 
  when others then 
  dbms_output.put_line('unknown error'); 
  end;
  /
   exec sp_metro(100);



