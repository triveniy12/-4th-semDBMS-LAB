                    LAB 5
          AIRLINE FLIGHT DATABASES

create table flights(flno int,from varchar(20),
to varchar(20),distance int,depart timestamp,
arrives timestamp,price int,primary key(flno));

create table aircrafts(aid int,aname varchar(20),
cruisingrange int,primary key(aid));

create table employess(eid int,ename varchar(20),
salary int,primary key(eid));

create table certified(eid int,aid int,
foreign key(eid) references employess(eid),
foreign key(aid) references aircrafts(aid));


insert into aircrafts values('&aid','&aname','&cruisingrange')


insert into employess values('&eid','&ename','&salary');

insert into certified values('&eid','&aid');

alter session set nls_timestamp_format='rr/mm/dd hh24:mi:ssxff';
alter session set nls_date_language ='english';
insert into flights values('&flno','&ffrom','&tto','&distance','&depart','&arrives','&price');
 

Queries:-

Q1) select distinct aname from aircrafts
where aid in(select c.aid from certified c, 
employess e where c.eid=e.eid and 
not exists( select * from employess e1 where e1.eid=e.eid
and e1.salary<80000));

Q2) select c.eid ,max(a.cruisingrange) from
certified c, aircrafts a where
c.aid=a.aid group by
c.eid having count(*)>3;

Q3) select ename from employess
where salary<(select min(f.price) from
flights f where f.ffrom='bangalore' ;

Q4) select temp.name, temp.avgsalary
from ( select a.aid, a.aname as name, avg (e.salary) as avgsalary
from aircrafts a, certified c, employess e
where a.aid = c.aid and c.eid = e.eid and a.cruisingrange > 1000
group by a.aid, a.aname ) temp;

Q5)select distinct e.ename from employess e, certified c, aircrafts a
where e.eid=c.eid and c.aid=a.aid and a.aname like 'boeing%';

Q6) select aid from aircrafts a
where a.cruisingrange>(select min(f.distance) from 
flights f where f.ffrom='bangalore' and f.tto='frankfurt');

Q7)select f.depart
from flights f
where f.flno in ( ( select f0.flno
from flights f0
where f0.ffrom = 'bangalore' and f0.tto = 'delhi'
and extract(hour from f0.arrives) < 18 )
union
( select f0.flno
from flights f0, flights f1
where f0.ffrom = 'bangalore' and f0.tto <> 'delhi'
and f0.tto = f1.ffrom and f1.tto = 'delhi'
and f1.depart > f0.arrives

and extract(hour from f1.arrives) < 18)
union
( select f0.flno
from flights f0, flights f1, flights f2
where f0.ffrom = 'bangalore'
and f0.tto = f1.ffrom
and f1.tto = f2.ffrom
and f2.tto = 'delhi'
and f0.tto <> 'delhi'
and f1.tto <> 'delhi'
and f1.depart > f0.arrives
and f2.depart > f1.arrives
and extract(hour from f2.arrives) < 18));

Q8) select e.ename, e.salary
from employess e
where e.eid not in ( select distinct c.eid
from certified c )
and e.salary >( select avg (e1.salary)
from employess e1
where e1.eid in
( select distinct c1.eid
from certified c1 ) );


