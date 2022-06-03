Create table guests
(name varchar2(20),
Phone number(10),
City varchar2(20),
Pro_flg char(1));

insert into guests (name,phone,city) values('rajesh',783738,'blr');
insert into guests (name,phone,city) values('bala',78939,'chn');
insert into guests (name,phone,city) values('arun',892393,'del');
insert into guests (name,phone,city) values('john',770260,'blr');
insert into guests (name,phone,city) values('gundu',77026089,'blr');
insert into guests (name,phone,city) values('tom',8555900,'hyd');
insert into guests (name,phone,city) values('rom',8555900,'hyd');


Create table customer_guest
(c_id number(4),
c_nm varchar2(20),
c_phone number(10),
c_city varchar2(20));

insert into customer_guest values(1,'raj',12345,'blr');
insert into customer_guest values(2,'rani',989734,'hyd');
insert into customer_guest values(3,'kimm',878384,'chn');
insert into customer_guest values(4,'rajesh',783738,'blr');
insert into customer_guest values(5,'ram',89239311,'del');

create table call
(call_id number(10),
c_nm varchar2(20),
phone number(10),
city varchar2(20));

select * from call;
select * from guests;
select * from customer_guest ;
/
create or replace procedure sp_guest as
cursor cur_guest is select name,city ,phone, pro_flg from guests for update;
v_cnt int;
pro_flag varchar(20);
begin
     for i in cur_guest loop
         select count(*) into v_cnt
         from customer_guest
          where c_nm = i.name and  c_phone = i.phone and c_city = i.city;
              if v_cnt = 1 then

                  delete from guests
                  where current of cur_guest;
                   dbms_output.put_line('delete same row');
              else
                    insert into call values (seq_guests.nextval,i.name,i.phone,i.city );
                        update guests 
                        set pro_flg = 'y'
                        where current of cur_guest;
                             dbms_output.put_line('updated pro_flg');
                 end if;
      end loop;
    commit;
exception
      when no_data_found then
            dbms_output.put_line('not exist');
    when others then
            dbms_output.put_line(sqlcode||','||sqlerrm);
end;
/


/
create sequence seq_guests
start with  7
increment by 1
minvalue 1
maxvalue 100
nocycle;

/


EXEC SP_GUEST;
