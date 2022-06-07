create table product_day5
(prod_bkey varchar2(5),
prod_name varchar2(20),
price number(10),
family varchar2(20)
);

insert all
into product_day5 values('p1','laptop',30000,'electronics')
into product_day5 values('p2','headphone',3000,'electronics')
into product_day5 values('p3','earphone',100,'electronics')
into product_day5 values('p4','chocolates',100,'food')
into product_day5 values('p5','biscuits',50,'food')
into product_day5 values('p6','chips',80,'food')
select * from dual;
/

/
create table customer_day5
(cust_bkey varchar2(5),
cust_name varchar2(20),
dob date,
phone number(10),
address varchar2(20),
city varchar2(20),
zip number(10),
state varchar2(20)
);


insert all
into customer_day5 values(11,'ram','12-aug-1996',8907879778,'vijayanagar','bangalore',56086,'ka')
into customer_day5 values(12,'sham','15-jun-1986',9007879778,'jayanagar','bangalore',56087,'ka')
into customer_day5 values(13,'krisna','10-may-1993',8907879334,'vidyanagr','darwad',58080,'ka')
into customer_day5 values(14,'adbul','06-jan-1994',7907879778,'shantinagar','rameshwar',56089,'tn')
into customer_day5 values(15,'john','23-nov-1987',8904879778,'rajnagar','hydrabad',56082,'ap')
into customer_day5 values(16,'abhi','14-sep-1996',8907879778,'laxmianagar','vijayapur',56096,'ka')
into customer_day5 values(17,'vinod','28-feb-1996',8934879778,'gandianagar','bangalore',56046,'ka')
select * from dual;



create table sales_day5
(sales_id varchar2(5),
cust_bkey varchar2(5),
prod_bkey varchar2(5),
store_bkey varchar2(5),
qty number(10),
sales_amount number(10),
sales_date date
);

insert all
into sales_day5 values(1001,12,'p1',101,10,10000,'10-jul-2021')
into sales_day5 values(1002,11,'p2',102,12,20000,'03-jan-2022')
into sales_day5 values(1003,13,'p3',103,14,50000,'19-mar-2019')
into sales_day5 values(1004,14,'p4',104,13,5000,'02-jun-2020')
into sales_day5 values(1005,15,'p1',105,10,8000,'20-sep-2021')
into sales_day5 values(1006,16,'p5',106,16,4000,'30-dec-2018')
into sales_day5 values(1007,12,'p6',101,16,60000,'10-feb-2021')
into sales_day5 values(1008,17,'p2',108,13,9000,'23-nov-2020')
select * from dual;
/



create table stores_day5
(store_bkey varchar2(5),
store_name varchar2(20),
address varchar2(20),
phone number(10),
city varchar2(20),
zip number(10),
state varchar2(20)
);

insert all
into stores_day5 values(101,'abc','jayanagar',9898987779,'bangalore',57484,'ka')
into stores_day5 values(102,'xyz','vijaynagar',9898987788,'hubli',57483,'ka')
into stores_day5 values(103,'pqr','vidyanagar',9898987708,'mangalore',57482,'ka')
into stores_day5 values(104,'lmn','rajajinagar',9898987878,'bangalore',57482,'ka')
into stores_day5 values(107,'jkl','gandinagar',9898987798,'chennai',57481,'tn')
into stores_day5 values(108,'iso','indiranagar',9898987578,'hydrabad',57480,'ap')
into stores_day5 values(109,'klm','jp nagar',9898987728,'gadag',57489,'ka')
into stores_day5 values(110,'kfc','shanti nagar',9898687778,'rameshwar',57485,'ka')
into stores_day5 values(111,'who','om nagar',9898987438,'mysore',57481,'ka')
select * from dual;

/
select * from stores_day5;
select * from sales_day5;
select * from customer_day5;
select * from product_day5;
-- 1 Get the customer names who made sales on or before 1st jan 2014.
select cust_name
from customer_day5 c,  sales_day5 s
where c.cust_bkey = s.cust_bkey
and to_char(sales_date,'dd-mon-yy') <='01-jan-22';

--2 Get the customer names who made sales yesterday and today.
select cust_name
from customer_day5 c,  sales_day5 s
where c.cust_bkey = s.cust_bkey
and to_char(sales_date,'dd-mon-yy') = sysdate

union all

select cust_name
from customer_day5 c,  sales_day5 s
where c.cust_bkey = s.cust_bkey
and to_char(sales_date,'dd-mon-yy') = sysdate -1;

--3.	Get the customer names who made max total sale (qty*price) on 1st jan 2014.
select cust_name,max(qty*price) max_total_sale
from customer_day5 c,  sales_day5 s,product_day5 p
where c.cust_bkey = s.cust_bkey
and  s.prod_bkey = p.prod_bkey
and to_char(sales_date,'dd-mon-yy') ='01-jan-22'
group by cust_name;
--4.	Get the customer name who bought ‘abc’ manufacturers.
select cust_name
from customer_day5 c,  sales_day5 s,product_day5 p
where c.cust_bkey = s.cust_bkey
and  s.prod_bkey = p.prod_bkey
and store_bkey =(select store_bkey from stores_day5
                   where store_name='abc');

--5.	Get the number of customers who bought ‘ABC’ manufacturers till today.
select store_name,count(cust_bkey)
from stores_day5 sd, sales_day5 s,product_day5 p
where sd.store_bkey = s.store_bkey
and  p.prod_bkey = s.prod_bkey
and store_name ='abc'
and to_char(sales_date,'dd-mon-yy') = sysdate
group by store_name;



--6.	Get the details of products which has not been sold till today.
select prod_name
from product_day5
where prod_bkey not in (select prod_bkey from sales_day5
                        where to_char(sales_date,'dd-mon-yy') = sysdate);
 
--7.	Get the total sale value (qty*price) of each product.
select prod_name,max(qty*price) max_total_sale
from sales_day5 s,product_day5 p
where   s.prod_bkey = p.prod_bkey
group by prod_name;

--8.	Display the unique product names.
select distinct(prod_name)
from product_day5 ;

--9.	Display the products which are sold in the first quarter of current year.
select prod_name
from product_day5 p,sales_day5 s
where p.prod_bkey =s.prod_bkey
and to_char(sales_date,'q') = 1
and to_char(sales_date,'yyyy') = to_char(sysdate,'yyyy');

/
create or replace procedure sp_shop as
v_cnt number(5);

begin
   
   
   select count(*) into v_cnt
   from shop_dimension
   where shop_id = -1;
   
   if v_cnt = 0 then
   
   insert into shop_dimension values (-1,'unknown','unknown''unknown','n',0,0,'unknown',null,null);
   commit;
   else
   dbms_output.put_line('data already');
   
   end if;
exception 
    when others then
    dbms_output.put_line(sqlcode||','||sqlerrm);
end; 
   /
   
create or replace function fn_age(v_empno number) return varchar2 as
v_emp_age  varchar2(40);
begin

     select  ( case when trunc(months_between(sysdate,DATE_OF_BIRTH)/12) between 20 and 35 then 'junoir in the copmany'
                   when trunc(months_between(sysdate,DATE_OF_BIRTH)/12) between 35 and 50 then 'mid level in the company'
                   when trunc(months_between(sysdate,DATE_OF_BIRTH)/12) > 50 then 'senior in the company'
                   when trunc(months_between(sysdate,DATE_OF_BIRTH)/12) < 20 then 'unknown' end) into v_emp_age
                   
    from employee
    where emp_id=v_empno;
    return v_emp_age;
exception
when others then
dbms_output.put_line(sqlcode||'-'||sqlerrm);
 
end;

select * from employee;

/
select fn_age (102) from dual;
/
create or replace function fn_age_group(v_empno number) return varchar2 as
v_age_group varchar2(20);
v_age number(20);
    begin
         select months_between(sysdate,date_of_birth)/12 into v_age
         from employee
         where emp_id=v_empno;
         
             if v_age between 20 and 35 then
             v_age_group:='junior in the company';
             elsif v_age between 35 and 50 then
             v_age_group:='mid in the company';
             elsif v_age > 50 then
             v_age_group:='senior in the company';
             elsif v_age < 20 then
             v_age_group:='unknown';
             end if;
             return v_age_group;
exception
when no_data_found then
return 'empno not valid';
when others then
dbms_output.put_line(sqlcode||'-'||sqlerrm);
end;
   