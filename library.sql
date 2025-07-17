--Library mangment Table 
-- Creating branch table 
create table branch
(
  	branch_id	varchar(10) Primary key,
 	manager_id varchar(10),
  	branch_address varchar(55),	
  	contact_no varchar(10)

);

Drop table if exists employees;
Create Table employees 
(
  emp_id varchar(10) Primary key,
  emp_name varchar(25),
  position	varchar(15),
  salary Int,	
  branch_id varchar(25) --FK
);



Drop table if exists books;
create table books 
(
	isbn varchar(20)Primary key,
	book_title varchar(75),
	category varchar(10),	
	rental_price Float,
	status 	varchar(115),
	author	varchar(35),
	publisher varchar(55)

);

alter table books 
alter column category type varchar(25);

Drop table if exists members;
create table members
(
	member_id varchar(10) primary key,
	member_name varchar(25),
	member_address varchar(75),
	reg_date Date

);


create table issued_status 
(
 	issued_id varchar(10) primary key,
	issued_member_id varchar(10), --FK
	issued_book_name varchar(75),
	issued_date	date,
	issued_book_isbn varchar(25), --FK
	issued_emp_id varchar(10) --FK
);

create table return_status
(
	return_id varchar(10) primary key,
	issued_id  varchar(10),
	return_book_name  varchar(75),
	return_date date, 	
	return_book_isbn  varchar(20)

);

-- FORIEGN KEY 
ALTER TABLE issued_status 
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);

ALTER TABLE issued_status 
add constraint fk_employees
foreign key (issued_emp_id)
references employees(emp_id);

ALTER TABLE issued_status 
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn)

ALTER TABLE employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);

ALTER TABLE return_status
add constraint fk_issued_status 
foreign key (issued_id)
references issued_status(issued_id);