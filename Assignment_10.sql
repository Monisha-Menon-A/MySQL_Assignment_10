create database Assignment_10;
use Assignment_10;
create table teachers(id int,
					 name varchar(25),
                     subject varchar(25),
                     experience int,
                     salary decimal(10,2));
desc teachers; 
insert into teachers(id, name, subject, experience, salary)
values(1, 'Nithya Jayaram', 'English', 12, 50000),
(2, 'Femi Azad', 'Maths', 2, 9000),
(3, 'Divya John', 'Science', 5, 15000),
(4, 'Ajay Raj', 'Phyisical Training', 6, 25000),
(5, 'Aradhya Vijay', 'Music', 2, 9000),
(6, 'Anish Rahman', 'Computer', 5, 15000),
(7, 'Sithara Sidharth', 'Social Studies', 5, 15000),
(8, 'Sindhu Suresh', 'Art', 4, 12000);
select* from teachers;

/*Create a before insert trigger named before_insert_teacher that will raise an error
 “salary cannot be negative” if the salary inserted to the table is less than zero*/
Delimiter $$
create trigger before_insert_teacher
before insert on teachers
for each row
begin
if new.salary<0
then
signal sqlstate '45000' set message_text="salary cannot be negative";
end if;
end $$
Delimiter ;
insert into teachers(id, name, subject, experience, salary)
values(9, 'Haritha Shankar', 'Malayalam', 4, -12000);

/*Create an after insert trigger named after_insert_teacher that inserts a row with 
teacher_id,action, timestamp to a table called teacher_log when a new entry gets inserted
 to the teacher table. teacher_id -> column of teacher table, action -> the trigger action,
 timestamp -> time at which the new row has got inserted*/
create table teacher_log(teacher_id int,
					 action varchar(25),
                     timestamp timestamp default current_timestamp);
desc teacher_log; 

Delimiter $$
create trigger after_insert_teacher
after insert on teachers
for each row
begin
insert into teacher_log(teacher_id, action, timestamp)
values(new.id, 'insert', current_timestamp);
end $$
Delimiter ;
insert into teacher_log(teacher_id, action, timestamp)
values(1, 'insert', current_timestamp);
select* from teacher_log;
 
/*Create a before delete trigger that will raise an error when you try to delete a row
 that has experience greater than 10 years*/
Delimiter $$
create trigger before_delete_teacher
before delete on teachers
for each row
begin
if old.experience>10 
then
signal sqlstate '45000' set message_text="cannot delete teacher with experience greater than 10 years";
end if;
end $$
Delimiter ;
delete from teachers where id=1;

/*Create an after delete trigger that will insert a row to teacher_log table when 
that row is deleted from teacher table.*/
Delimiter $$
create trigger after_delete_teacher
after delete on teachers
for each row
begin
insert into teacher_log(teacher_id, action, timestamp)
values(old.id, 'delete', current_timestamp);
end $$
Delimiter ;
delete from teachers where id=2;
select* from teacher_log;
