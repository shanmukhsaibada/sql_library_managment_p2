UPDATE members
SET member_address = '123 Main St'
WHERE member_id = 'C101';

UPDATE members
SET member_address = '456 Elm St'
WHERE member_id = 'C102';

UPDATE members
SET member_address = '789 Oak Stt'
WHERE member_id = 'C103';

UPDATE members
SET member_address = '567 Pine St'
WHERE member_id = 'C104';

UPDATE members
SET member_address = '890 Maple St'
WHERE member_id = 'C105';

UPDATE members
SET member_address = '234 Cedar St'
WHERE member_id = 'C106';

UPDATE members
SET member_address = '345 Walnut St'
WHERE member_id = 'C107';

UPDATE members
SET member_address = '456 Birch St'
WHERE member_id = 'C108';

UPDATE members
SET member_address = '567 Oak St'
WHERE member_id = 'C109';

UPDATE members
SET member_address = '678 Pine St'
WHERE member_id = 'C110';

UPDATE members
SET member_address = '133 Pine St'
WHERE member_id = 'C118';

UPDATE members
SET member_address = '143 Main St'
WHERE member_id = 'C119';

insert into members
(
member_id, member_name, member_address, reg_date 
)
values
('c117', 'Alpha Boi', '923 W Uni','2025-07-09'),
('c116', 'Shanmukh', '826 W Uni','2025-06-19')

UPDATE members SET member_id = 'C117' WHERE member_id = 'c117';
UPDATE members SET member_id = 'C116' WHERE member_id = 'c116';
