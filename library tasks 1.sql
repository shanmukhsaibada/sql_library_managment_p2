select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;


INSERT INTO members(member_id, member_address) 
VALUES
('C101',  '123 Main St'),
('C102', '456 Elm St'),
('C103',  '789 Oak St'),
('C104', '567 Pine St'),
('C105',  '890 Maple St'),
('C106',  '234 Cedar St'),
('C107',  '345 Walnut St'),
('C108',  '456 Birch St'),
('C109',  '567 Oak St' ),
('C110', '678 Pine St'),
('C118',  '133 Pine St'),    
('C119',  '143 Main St');
SELECT * FROM members;

--project task

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')" 

insert into books(isbn,book_title,category,rental_price,status,author,publisher )
values 
( '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'

)

--Update an Existing Member's Address

update members 
set member_address = '125 Oak St'
where member_id = 'c103'
 -- either one
UPDATE members
SET member_address = 
  CASE 
    WHEN member_address = '789 Oak Stt' THEN '125 oak st'
    ELSE member_address  -- keeps other rows unchanged
  END;

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.


delete from issued_status 
where issued_id ='IS121'

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.


SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

--Task 5 : List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id, count(issued_emp_id) from issued_status
group by 1
having count(*)> 1

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_cnts
as 
select b.isbn ,
       b.book_title,
       count(ist.issued_book_isbn)
from books as b
JOIN 
issued_status as ist 
on ist.issued_book_isbn = b.isbn   
group by 1 ,2

select * from book_cnts;

-- Task 7. Retrieve All Books in a Specific Category:

select * from books 
where category = 'Classic';

--Task 8: Find Total Rental Income by Category:

select 
b.category,
sum(b.rental_price),
count(ist.issued_book_isbn)
from books as b 
join 
issued_status as ist 
on b.isbn = ist.issued_book_isbn
group by 1

--TASK:9 List Members Who Registered in the Last 180 Days:

select * from members
where reg_date >= current_date - interval '180 days';

--Task 10 : List Employees with Their Branch Manager's Name and their branch details:

select 
 e1.emp_id,
 e1.emp_name,
 e1.position,
 b.manager_id,
 e2.emp_name as manager  
from employees as e1
join 
branch as b 
on e1.branch_id = b.branch_id
join 
employees as e2
on b.manager_id = e2.emp_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table Expensive_Books as 
select 
* from  books 
where rental_price > '7'

--Task 12: Retrieve the List of Books  Returned

select 
ist.issued_member_id,
ist.issued_book_name,
ist.issued_date,
rst.return_date,
rst.return_id
from issued_status as ist
join return_status as rst 
on ist.issued_id = rst.issued_id

--Task 12: part 2 Retrieve the List of Books not yet Returned

select 
*
from issued_status as ist
left join return_status as rst 
on ist.issued_id = rst.issued_id
where rst.return_id is null;