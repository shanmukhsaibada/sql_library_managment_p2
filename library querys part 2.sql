--sql library advance queries p2

 SELECT * from employees;
 SELECT * from books;
 SELECT * from branch;
 SELECT * from members;
 SELECT * from issued_status;
 SELECT * from return_status;

--Advance sql tasks 

/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue.
*/ 

select 
m.member_id,
m.member_name,
b.book_title,
ist.issued_date,
--rst.return_date,
current_date - ist.issued_date as overduedate
from 
issued_status as ist
join members as m
on ist.issued_member_id = m.member_id
join books as b 
on ist.issued_book_isbn = b.isbn 
left join return_status as rst
on ist.issued_id = rst.issued_id
where rst.return_date is null 
and 
current_date - ist.issued_date > 30
order by 1;

/*
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/

select * from issued_status
where issued_book_isbn = '978-0-451-52994-2';

select* from books 
where isbn = '978-0-451-52994-2';

update books
set status ='no'
where isbn = '978-0-451-52994-2';

 SELECT * from return_status
 where issued_id ='IS130';
 
insert into return_status(return_id, issued_id, return_date , book_quality)
values 
('RS125','IS130', current_date,'Good');
SELECT * from return_status
 where issued_id ='IS130';

 update books
set status ='yes'
where isbn = '978-0-451-52994-2';

-- store proccedures

create or replace procedure add_return_records(p_return_id varchar(10), p_issued_id varchar(10),p_book_quality varchar(15))
language plpgsql
as $$

declare 
		v_isbn varchar(50);
		v_book_name varchar(80);
begin
-- all your logic and code 
-- inserting into returns based on user inputs 
insert into return_status(return_id, issued_id, return_date , book_quality)
values 
(p_return_id,p_issued_id,current_date,p_book_quality);

select
	issued_book_isbn,
	issued_book_name
	into
	v_isbn,
	v_book_name
	from issued_status
	where issued_id = p_issued_id;

	update books
	set status ='yes'
	where isbn = v_isbn;

	raise notice 'thank you for returning the book: %', v_book_name;

end;
$$

-- testing the procedures;
call add_return_records()

select * from return_status
where issued_id = 'IS135'

issued_id = IS135 
ISBN = where isbn = '978-0-307-58837-1'

 call add_return_records('RS138','IS135', 'Good');

/*
 Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/
 -- issued_status= employees =  returned_status = books 

create table Branch_reports
as
select 
b.branch_id,
b.manager_id,
count(ist.issued_id) as number_book_issued,
sum(bk.rental_price) as total_revenue,
count(rst.return_id) as  number_book_returned 
from issued_status as ist 
join employees as emp
on ist.issued_emp_id = emp.emp_id 
left join return_status as rst
on ist.issued_id = rst.issued_id 
join books as bk
on ist.issued_book_isbn = bk.isbn
join branch as b
on emp.branch_id = b.branch_id  
group by 1, 2

select * from branch_reports;

/*CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
*/ 

create table  Active_Members as

select ist.issued_member_id, 
ist.issued_date, 
m.member_name, 
m.member_address, 
m.reg_date from issued_status as ist
join members as m
on ist.issued_member_id = m.member_id
where ist.issued_date >= current_date - interval '2 month';

select * from Active_Members

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
*/ 

select count(ist.issued_emp_id) as books_issued ,
e.emp_id, e.emp_name, 
e.position,
sum(b.rental_price)


from issued_status as ist 
join employees as e 
on ist.issued_emp_id = e.emp_id 
join books as b 
on ist.issued_book_isbn = b.isbn
group by 2
order by books_issued desc
limit 3

/*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.
*/ 

select m.member_name, b.book_title, count(ist.issued_id)
from issued_status as ist
join members as m 
on ist.issued_member_id = m.member_id
join books as b 
on ist.issued_book_isbn = b.isbn 
join return_status as rst 
on ist.issued_id = rst.issued_id 
where book_quality = 'Damaged'
Group by 1, 2
having count(ist.issued_id) > 2;

--Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. Description: Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
-- all the variabable
    v_status VARCHAR(10);

BEGIN
-- all the code
    -- checking if book is available 'yes'
    SELECT 
        status 
        INTO
        v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN

        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
            SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;


    ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;
END;
$$

-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'








/*Task 20: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines
*/
create table over_due_books 
as
select    m.member_id,
    COUNT(CASE 
            WHEN rst.return_date > ist.issued_date + INTERVAL '30 days' 
            THEN 1 
         END) AS overdue_books,
    SUM(CASE 
            WHEN rst.return_date > ist.issued_date + INTERVAL '30 days' 
            THEN EXTRACT(DAY FROM rst.return_date - (ist.issued_date + INTERVAL '30 days')) * 0.5
            ELSE 0
        END) AS total_fine,
    COUNT(ist.issued_id) AS total_books_issued
from 
issued_status as ist 
join members as m 
on ist.issued_member_id = m.member_id
join return_status as rst 
on ist.issued_id = rst.issued_id 
group by m.member_id;