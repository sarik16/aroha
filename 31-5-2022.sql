create table input_mix	
(specification_mix varchar(20),	
actual_value int);

insert into input_mix values ('Ash 12345 Mix',12);
insert into input_mix values ('Moisture 1234 TY',13);
insert into input_mix values ('Protein 12A',10);
insert into input_mix values ('Ash ABC 124',11);
insert into input_mix values ('Moisture Winter Whea',14);

	
	
create table output_mix	
(specification_mix varchar(50),	
Actual_val int,	
Ash_val int,	
moisture_val int,	
protein_val int);	

select * from input_mix;
select * from output_mix;

/
create or replace procedure sp_mix as

exist exception;

begin
  
  insert into output_mix ( select specification_mix,actual_value,
                                 case when specification_mix in('Ash 12345 Mix','Ash ABC 124') then actual_value
                                 else 0 
                                 end ash_val,
                                 case when specification_mix in('Moisture 1234 TY','Moisture Winter Whea') then actual_value
                                 else 0 end moisture_val,
                                 case when specification_mix in('Protein 12A') then actual_value
                                 else 0 end protein_val from input_mix);
                                 

 exception
   when exist then 
    dbms_output.put_line(sqlcode||','||sqlerrm);
 end;   
/
exec sp_mix;
select * from output_mix;
truncate table output_mix;
--using like opretor
/
create or replace procedure sp_mix1 as
cursor c_mix is select * from input_mix;
exist exception;
v_a int :=0;
v_m int :=0;
v_p int :=0;
v_cnt int;
begin
  for i in c_mix loop

    select count(*) into v_cnt
    from output_mix
    where specification_mix =i.specification_mix
    and actual_val = i.actual_value;


  if v_cnt=0 then
      if i.specification_mix like 'Ash%' then
      insert into output_mix values (i.specification_mix,i.actual_value,i.actual_value,v_m,v_p);
         elsif i.specification_mix like 'Moisture%' then
      insert into output_mix values (i.specification_mix,i.actual_value,v_a,i.actual_value,v_p);
         elsif i.specification_mix like 'Protein%' then
      insert into output_mix values (i.specification_mix,i.actual_value,v_a,v_m,i.actual_value);
      else 
      dbms_output.put_line('insert not allow');
    end if; 
    end if;
 end loop;
 exception
   when exist then 
    dbms_output.put_line(sqlcode||','||sqlerrm);
 end;   
/
exec sp_mix1;
select * from output_mix;
truncate table output_mix;
/
create or replace procedure sp_agency1 as
cursor c_agen is select * from agency_src;
exist exception;

begin
 for i in c_agen loop
      insert into agency_tgt values (i.agency,i.program_name,i.fiscal_year,i.original_appr_amount,
                                (select sum(original_appr_amount) over(partition by i.program_name) program_sum,
                                sum(original_appr_amount) over(partition by i.agency) agency_sum,
                                sum(original_appr_amount) all_sum 
                                from agency_src);
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
truncate TABLE agency_tgt;