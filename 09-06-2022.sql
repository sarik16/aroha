/
create or replace procedure sp_bank as
cursor c_bank is 
select l.cust_id,l.cust_f_nm ,l.cust_l_nm ,l.cust_dob,l.cust_phone,l.cust_city,l.crt_dt,'table_loan' as SOURCE_SYSTEM
from LOAN_CUSTOMER l
union all
select s.c_id,s.cust_name,null,s.dob,s.phone,s.city,s.crt_dt,'table_seving' as source_system
from SAVING_CUSTOMER s
where s.c_id not in(select cust_id from LOAN_CUSTOMER )
union all
select c.c_id,c.name,null,c.dob,c.phone,c.city,c.crt_dt,'table_credit' as source_system
from CREDIT_CARD_CUST c
where c.c_id not in (select cust_id from loan_customer)
and c.c_id not in(select c_id from saving_customer);

v_name number(2);
v_dob number(2);
v_phone number(2);

begin 
   for i in c_bank loop
   
     select count(c_f_nm),count(c_dob),count(c_phone) into v_name,v_dob,v_phone
     from CUST_DIM
     where c_f_nm=i.cust_f_nm and c_dob =i.cust_dob and c_phone =i.cust_phone;
      if v_name =0 and v_dob =0 and v_phone =0 then
       insert into CUST_DIM values (SEQ_BANK_CUST.nextval,i.cust_f_nm,i.cust_l_nm,i.cust_dob,i.cust_phone,i.cust_city,i.cust_id);
      
      end if;
    end loop;
exception
    when others then
      dbms_output.put_line('duplicate customer');
end;      
     
/
exec sp_bank
/
/
create or replace function fn_shop(p_shop_id number,p_year varchar)
return number as
v_sum number(5);

begin

   select sum(c.amount_sold) into v_sum
   from efashion.calender_lookup a,shop_dimension b,shop_facts c
   where a.week_id = c.week_id
   and b.shop_id =c.shop_id
   and b.shop_id = p_shop_id
   and a.yr = p_year;
      if c.amount_sold is null then 
           return -2;
      else
             return v_sum;
     end if;
 exception
   when no_data_found then
    return -1;
end;      

    
/