
--You have to populate the prod_master table. Business rules are
--1.	Unique records between two systems are identified based on the SKU ID
--2.	If the names are different for the specific SKU between store and online product, then consider s_p_name from s_product table to populate the master table.
--3.	If cost of the product is different in both systems, then consider the highest one as the p_cost
--4.	Populate the p_code in the target only if that product comes from store product table
--5.	Populate the launch_dt in the target only if that product comes from online product table.

Create table store_product
(s_prod_id number,
S_p_code varchar2(20),
S_p_name varchar(20),
Sku_id number,
Cost number,
Price number
);


insert into store_product values(1101,'A1234','laptop',9456,30000,32000);
insert into store_product values(1102,'A1235','headphone',9457,5000,4000);
insert into store_product values(1103,'A1236','monitor',9458,1000,2000);
insert into store_product values(1104,'A1237','earphone',9459,500,600);
insert into store_product values(1105,'A1238','cpu',9460,6000,7000);

Create table online_product
(o_prod_id number,
prod_name varchar(20),
Sku_id number,
Online_Price number,
discount number,
Online_cost number,
Launch_dt date
);

insert into online_product values(1501,'Dell laptop',9456,35000,1000,40000,'21-jun-19');
insert into online_product values(1502,'headphone',9457,4000,500,3000,'11-mar-19');
insert into online_product values(1503,'Chair',9461,2000,200,1500,'13-jan-19');
insert into online_product values(1504,'Table',9462,8000,1200,7000,'26-feb-19');
insert into online_product values(1505,'Sofa',9463,70000,5000,75000,'09-sep-19');

Create table product_master
(p_id number,
Sku_id number,
P_name varchar(20),
P_cost number, 
Store_price number,
Online_price number,
P_code varchar2(20),
Launch_date date
);

select * from product_master;
select * from online_product;
select * from store_product;
CREATE SEQUENCE SEQ_CONT_prod;


/
create or replace procedure sp_online_store as
cursor c_store is select * from store_product;
cursor c_online is select * from online_product;
v_cnt number;
exist exception;
begin 
 for i in c_store loop
 insert into product_master(p_id,sku_id,p_name,p_cost,store_price,p_code) values(SEQ_CONT_prod.nextval,i.sku_id,i.s_p_name,i.cost,i.price,i.s_p_code);
 
end loop;

      for j in c_online loop
      select count(*) into v_cnt
      from product_master
      where sku_id =j.sku_id;
             if v_cnt =0 then 
             insert into product_master (p_id,sku_id,p_name,p_cost,online_price,launch_date) values 
             (SEQ_CONT_prod.nextval,j.sku_id,j.prod_name,j.online_cost,j.online_price,j.launch_dt);
             
             else
             update product_master set p_cost = j.online_cost
             where p_cost<j.online_cost and sku_id=j.sku_id;
                update product_master set online_price =j.online_cost,launch_date =j.launch_dt
                where sku_id=j.sku_id;
            end if;
           
       end loop;
       
exception
     when exist then
     dbms_output.put_line(sqlcode||','||sqlerrm);
  end;        
       
/
exec SP_ONLINE_STORE;
/
select * from product_master;
truncate table product_master;
/
--input  v_citys ='banglore,chenni,mangalore';
--output
--city1   : banglore
--city2   : chennai
--city3   : mangalore
  
 /
 declare
 v_citys varchar2(30) :='banglore,channi,mangalore';
 v_city1 varchar2(20);
 v_city2 varchar2(20);
 v_city3 varchar2(20);
 v_count number(10);
 v_position1 number(10);
 v_position2 number(10);
 ins number(10);
 sub varchar2(20);
 b number(10);
 v_int number(10);
 begin


   v_position1 := instr(v_citys,',');
   v_position2 := instr(v_citys,',',1,2);
   v_city1 :=substr(v_citys,1,v_position1-1);
   v_city2 :=substr(v_citys,v_position1+1,v_position2 -v_position1-1);
   v_city3 :=substr(v_citys,v_position2+1);
   
   
   dbms_output.put_line ('city 1 :'||v_city1);
     dbms_output.put_line ('city 2 :'||v_city2);
         dbms_output.put_line ('city 3 :'||v_city3);
            

 
 end;
/

set serveroutput on;
--input  v_citys ='banglore,chenni,mangalore';
--output
--city1=banglore
--city2=channi
--city3=mangalore
--no_of city_is:3

/
declare
   v_citys varchar2(30);
   v_city1 varchar2(30);
   v_count number(10);
   v_position number(10);
   v_s_position number(10) :=1;
   v_l_city varchar2(10);
   
   begin
     v_citys :='banglore,channi,mangalore';
     v_count:=0;
     for i in 1..length(v_citys) loop
     v_position := instr(v_citys,',',1,i);
     v_city1 := substr(v_citys,v_s_position,v_position-v_s_position);
      v_s_position := v_position+1;
      exit when v_city1 is null;
     dbms_output.put_line ('city'||i||'='||v_city1);
     v_count := v_count + 1;
     
end loop;
     v_l_city := substr(v_citys,instr(v_citys,',',-1,1)+1);
     
          dbms_output.put_line ('city'||(v_count+1)||'='||v_l_city);
     dbms_output.put_line ('no_of city_is:'||(v_count+1));
    
 end;
