Create table student_data
(st_id number(5),
St_name varchar2(20),
Marks number(5));

insert into student_data values(100,'ram',45);
insert into student_data values(101,'tim',85);
insert into student_data values(102,'bala',95);

Create table mark_data
(st_id number(5),
St_name varchar2(20),
Marks number(5),
Top_marks number(5),
Least_marks number(5),
Varience_from_lowest number(5),
Varience_from_highest number(5));


select * from student_data;
select * from  mark_data;


/
create or replace procedure sp_stu_mrk as
  cursor c_stu_mrk is select * from student_data;
  v_cnt number(5);
  v_max number(5);
  v_min number(5);
begin 
   for i in c_stu_mrk loop
       select count(*) into v_cnt
       from mark_data
       where st_id =i.st_id
       and st_name =i.st_name
       and marks = i.marks;
          select max(marks),min(marks) into v_max,v_min
          from student_data;
          if v_cnt =0 then
              insert into mark_data values (i.st_id,i.st_name,i.marks,v_max,v_min,i.marks-v_min,i.marks-v_max);
           else
              dbms_output.put_line('already exist');
            end if;
       end loop;
 exception 
    when others then
    dbms_output.put_line(sqlcode||','||sqlerrm);
end;    

/
exec sp_stu_mrk;
/

--Display the youngest actor name

select actor_name
from actor
where dob =(select max(dob)
            from actor);
--  Display the youngest and the oldest actor name      
select actor_name
from actor
where dob=(select max(dob)
           from actor)
union
select actor_name
from actor
where dob=(select min(dob)
           from actor);
           
--Display the movies of type action released in the current year


 select movie_name
 from movie
 where to_char(release_date,'yyyy')=to_char(sysdate,'yyyy') 
 and movie_type_id=(select movie_type_id
                from movie_type
                where movie_type_desc='ACTION');
 select movie_name
 from movie m , movie_type mt
 where m.movie_type_id =m.movie_type_id
 and movie_type_desc = 'ACTION'
 and to_char(release_date,'yyyy')=to_char(sysdate,'yyyy');

--Display all the actor names who are currently not associated with any movies

select actor_name
from actor
where actor_id not in (select actor_id 
                       from role
                       where start_date < sysdate and end_date >sysdate );
                       

select * from role;
--Display movie names that have more than 10 actors               
select movie_name
from movie m,role r
where m.movie_id=r.movie_id
group by movie_name
having count(actor_id)>10;

--Display movie type wise no of movies and no of roles

select movie_type_desc,count(movie_name),count(role_id)
from role r,movie m,movie_type mt
where m.movie_id=r.movie_id and m.movie_type_id=mt.movie_type_id
group by movie_type_desc;

--Display the movie names that have more no of roles than the movie ?ad
    
    select movie_name
    from movie m,-role r
    where r.movie_id=m.movie_id
    group by movie_name
    having count(role_id) > (select count(role_id)
                             from role r,movie m
                             where r.movie_id=m.movie_id
                             and movie_name='PIZZA');
  
                    
--display the actor name who play the more then one role in same movie                      
select actor_name
from actor a,role r, movie m
where a.actor_id=r.actor_id and m.movie_id=r.movie_id
group by actor_name
having count(actor_id)>1;
                       
--Display the movie name wise no of male and female actors   
select movie_name , count(case when gender ='m' then a.actor_id end) male, count(case when gender ='f' then a.actor_id end) femail
from movie m , role r ,actor a
where m.movie_id = r.movie_id
and r.actor_id = a.actor_id
group by m.movie_name;