create table instore
(cust_id number,
cust_name varchar(20),
city varchar(20),
store_name varchar(20));

INSERT INTO INSTORE (CUST_ID, CUST_NAME, CITY, STORE_NAME) VALUES ('1', 'TIM', 'BANGALORE', 'COSTA COFEE');
INSERT INTO INSTORE (CUST_ID, CUST_NAME, CITY, STORE_NAME) VALUES ('2', 'BIM', 'MANGALORE', 'BIG BAZAR');
INSERT INTO INSTORE (CUST_ID, CUST_NAME, CITY, STORE_NAME) VALUES ('3', 'RICK', 'TEXAS', 'MORE');
INSERT INTO INSTORE (CUST_ID, CUST_NAME, CITY, STORE_NAME) VALUES ('4', 'SMITH', 'LONDON', 'SHOPER STOP');

create table web_cust
(cust_id number,
cust_name varchar(20),
cust_city varchar(20),
email varchar(30),
status varchar(20));

INSERT INTO WEB_CUST (CUST_ID, CUST_NAME, CUST_CITY, EMAIL, STATUS) VALUES ('11', 'RAM', 'KOLAR', 'RAM@GMAIL.COM', 'BOUNCED');
INSERT INTO WEB_CUST (CUST_ID, CUST_NAME, CUST_CITY, STATUS) VALUES ('12', 'SHAM', 'MYSORE', 'COMPLETED');
INSERT INTO WEB_CUST (CUST_ID, CUST_NAME, CUST_CITY, EMAIL, STATUS) VALUES ('13', 'SMITHA', 'TEXAS', 'SMITHA@GMAIL.COM', 'COMPLETED');
INSERT INTO WEB_CUST (CUST_ID, CUST_NAME, CUST_CITY, EMAIL, STATUS) VALUES ('14', 'SMITH', 'LONDON', 'SMITH@YAHOO.COM', 'PROCESSED'); 
INSERT INTO WEB_CUST (CUST_ID, CUST_NAME, CUST_CITY, EMAIL, STATUS) VALUES ('15', 'TIM', 'BANGALORE', 'TIM@YAHOO.COM', 'PROCESSED'); 

create table call_center_cust
(cust_id number,
cust_name varchar(20),
city varchar(20),
rep_name varchar(20),
phone number);

INSERT INTO CALL_CENTER_CUST (CUST_ID, CUST_NAME, CITY, REP_NAME, PHONE) VALUES ('21', 'RAM', 'KOLAR', 'RAJESH', '8876543345');
INSERT INTO CALL_CENTER_CUST (CUST_ID, CUST_NAME, CITY, REP_NAME, PHONE) VALUES ('22', 'TIM', 'BANGALORE', 'RAMESH', '2323245678');
INSERT INTO CALL_CENTER_CUST (CUST_ID, CUST_NAME, CITY, REP_NAME) VALUES ('23', 'MICK', 'TEXAS', 'NASREEN');
INSERT INTO CALL_CENTER_CUST (CUST_ID, CUST_NAME, CITY, REP_NAME, PHONE) VALUES ('24', 'DAVID', 'MAGALORE', 'THRUPA', '4576988999'); 

CREATE TABLE TARGET_TABLE_CUST_DIM(cust_id number,
cust_name varchar(20),
city varchar(20),
email varchar(30),
phone number,
rep_name varchar(20),
SRC_CUST_ID NUMBER,
SOURCE VARCHAR(20));

CREATE TABLE REJECT_CUST_TABLE
(REJ_ID NUMBER,
SRC_REC VARCHAR(20),
REASON VARCHAR(100));

select * from INSTORE ;
select * from WEB_CUST ;
select * from CALL_CENTER_CUST ;
select * from  TARGET_TABLE_CUST_DIM;
select * from REJECT_CUST_TABLE ;
create sequence seq_instore;
/
create or replace procedure sp_instore as
cursor c_store is select cust_id,cust_name,city,store_name from instore;
cursor c_call is select cust_id,cust_name,city,rep_name,phone from CALL_CENTER_CUST ;
cursor c_web is select cust_id,cust_name,cust_city,email,status from WEB_CUST ;

begin
  for i in c_store loop
  
      if i.store_name is null then
           insert into REJECT_CUST_TABLE values(seq_instore.nextval,i.cust_id,'store name is not avilable');
           else
           insert into TARGET_TABLE_CUST_DIM(cust_id,cust_name,city,rep_name,src_cust_id,source)
            values (seq_instore.nextval,i.cust_name,i.city,i.store_name,i.cust_id,'ins');
         
       end if;
     end loop;
        
        for j in c_call loop
             if j.phone is null then
                                    insert into REJECT_CUST_TABLE values(seq_instore.nextval,j.cust_id,'phone no is not avilable');
             elsif j.rep_name is null then
                                     insert into REJECT_CUST_TABLE values(seq_instore.nextval,j.cust_id,'rep name not avilable');
             else                        
                                     insert into TARGET_TABLE_CUST_DIM(cust_id,cust_name,city,phone,rep_name,src_cust_id,source)
                                     values (seq_instore.nextval,j.cust_name,j.city,j.phone,j.rep_name,j.cust_id,'cnc');

            end if;
     end loop;
     
       for k in c_web loop
             if k.email is null then
                                          insert into REJECT_CUST_TABLE values(seq_instore.nextval,k.cust_id,'email is not avilable');
             elsif k.Status = 'BOUNCED' then
                                     insert into REJECT_CUST_TABLE values(seq_instore.nextval,k.cust_id,'status bounced');
             else
                              insert into TARGET_TABLE_CUST_DIM(cust_id,cust_name,city,email,rep_name,src_cust_id,source)
                              values (seq_instore.nextval,k.cust_name,k.cust_city,k.email,k.status,k.cust_id,'web');
       end if;
     end loop;
exception 
    when others then
    dbms_output.put_line(sqlcode||','||sqlerrm);
end;     
     
/

exec SP_INSTORE;

/
select * from INSTORE ;
select * from WEB_CUST ;
select * from CALL_CENTER_CUST ;
select * from  TARGET_TABLE_CUST_DIM;
select * from REJECT_CUST_T ABLE ;
truncate table TARGET_TABLE_CUST_DIM;
truncate table REJECT_CUST_TABLE ;

/