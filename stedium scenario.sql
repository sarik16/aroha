create table stadium(std_id number(5) primary key,
                        std_code varchar(20),
                        std_name varchar(20),
                        std_capacity number(10),
                        std_type varchar(20),
                        sdt_city varchar(20),
                        std_opened_date date,
                        std_status char(1)
                        );


create table team ( team_id number(4) primary key,
                    team_nm varchar(20),
                    game varchar(20),
                    operational_form date,
                    manager varchar(20)
                    );
                   
create table team_owners ( own_id number(2) primary key,
                            own_name varchar(20),
                            team_id number(4),
                            percentage number(3),
                            foreign key(team_id) references team(team_id)
                            );

                           
create table match ( match_id number(3) primary key,
                    match_date date,
                    game varchar(20),
                    public_ticket number(10),
                    sponsor_tickets number(10),
                    public_ticket_price number(10),
                    sponsor_tickets_price number(10),
                    std_id number(5),
                    home_team number(4),
                    visiting_team number(4),
                    foreign key(std_id) references stadium(std_id),
                    foreign key(home_team) references team(team_id),
                    foreign key(visiting_team) references team(team_id)
                    );



insert into stadium values(1000,'KA-BLR-001','Chinnaswamy Stadium',15000,'OUTDOOR','Bangalore','10-Feb-69','A');
insert into stadium values(1001,'KA-BLR-002','Kanteerava Stadium',35000,'OUTDOOR','Bangalore','15-Aug-74','A');
insert into stadium values(1002,'KA-MYS-001','Mysore Stadium',15000,'OUTDOOR','Mysore','18-Nov-88','A');


insert into team values(50,'TITANS','Cricket','14-Mar-19','Shankar');
insert into team values(51,'FLYERS','FootBall','13-Nov-20','Pranav');
insert into team values(52,'BULLS','Cricket','18-Mar-18','Kumar');
insert into team values(53,'STARS','FootBall','15-Aug-17','Subhash');
insert into team values(54,'GIANTS','Cricket','12-Jan-17','Raman');


insert into team_owners values(1,'SURAJ',50,100);
insert into team_owners values(2,'RAGHAVAN',51,75);
insert into team_owners values(3,'Birla',51,25);
insert into team_owners values(4,'TATA Group',52,100);
insert into team_owners values(5,'Uma',53,30);
insert into team_owners values(6,'Vijay',53,60);
insert into team_owners values(7,'RAMA',54,100);
insert into team_owners values(8,'KAMAL',53,10);


insert into match values(10,'10-Jun-22','Cricket',10000,4000,450,300,1000,50,52);
insert into match values(11,'12-Jun-22','FootBall',25000,10000,300,150,1001,51,53);
insert into match values(12,'15-Jul-22','FootBall',12500,2500,425,270,1000,53,51);
insert into match values(13,'19-Jul-22','Cricket',10000,5000,600,250,1000,52,54);
insert into match values(14,'20-Aug-22','Cricket',30000,5000,250,100,1001,54,50);
commit;

select * from STADIUM;
select * from TEAM;
select * from TEAM_OWNERS;
select * from MATCH;


--Display the team_name, owner_name for all the teams	
select team_nm,own_name
from team t, team_owners o
where t.team_id = o.team_id;


--Display the teams which are operational from the year 2020 and belongs to game of cricket
select team_nm
from team
where team_id = (select team_id from team
                  where to_char(operational_form,'yyyy') =2020
                  and game ='cricket');
                  
--Display the team and the number of owners
select team_nm,count(own_id)
from team t, team_owners o
where t.team_id = o.team_id
group by team_nm;

--Display the oldest team in football game
select team_nm
from team
where operational_form =(select min(operational_form)
                         from team
                         where game ='FootBall');
--Display the team which has more than 2 owners associated
select team_nm,count(own_id)
from team t, team_owners o
where t.team_id = o.team_id
group by team_nm
having count(own_id)>2;

--What is the relationship between Teams and Match table
--one team played many match
--one match played by two team(many);
--many to many
--What is unique about the releationship between team and match table
 
 -- in team table have one primary key and match table have two forgin key it is a unique relation with team and match teble.
 

--Display match_id, match_date, sta_name, sta_capacity, home_team_name.

select match_id,match_date,std_name,std_capacity, team_nm as home_team_name
from stadium s,match m,team t
where s.std_id=m.std_id 
and t.team_id =m.home_team;


--Display the matches which are being played in Bangalore by BULLS team

select match_id
from match m,stadium s,team t
where s.std_id=m.std_id 
and t.team_id=m.visiting_team 
and sdt_city='Bangalore' and team_nm='BULLS' ;


--Display Match_id, match_date, home_team_name, opponent_team_name for all the matches.


select match_id,match_date,t1.team_nm as home_team_name,t2.team_nm as opponent_team_name
from match m,team t1,team t2
where   t1.team_id =m.home_team 
and m.visiting_team=t2.team_id ;
						
