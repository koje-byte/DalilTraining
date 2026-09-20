----- Phase 2: Create the Database and Tables (DDL) -----

CREATE TABLE members(
member_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
full_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
phone VARCHAR(20) UNIQUE NOT NULL,
country VARCHAR(30),
city VARCHAR(30),
street VARCHAR(50),
join_date DATE DEFAULT CURRENT_DATE,
status VARCHAR(10) DEFAULT 'active' CHECK ( status IN('active','inactive'))
);

CREATE TABLE trainers(
trainer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
full_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
phone VARCHAR(20) UNIQUE NOT NULL,
mentor_id INT REFERENCES trainers(trainer_id) ON DELETE SET NULL
);

ALTER TABLE trainers
ADD COLUMN years_of_exp INT;

CREATE TABLE categories(
category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE classes(
class_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
class_name VARCHAR(50) UNIQUE NOT NULL,
category_id INT REFERENCES categories(category_id) ON DELETE CASCADE
);

CREATE TABLE sessions(
session_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
session_date DATE NOT NULL,
start_time TIME NOT NULL ,
end_time TIME NOT NULL  ,
room_number INT NOT NULL,
class_id INT REFERENCES classes(class_id) ON DELETE CASCADE,
trainer_id INT REFERENCES trainers(trainer_id) ON DELETE SET NULL,
CHECK(end_time>start_time)
);

CREATE TABLE bookings(
booking_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
rating INT CHECK(rating >=1 and rating <=5) ,
comment VARCHAR(150),
member_id INT REFERENCES members(member_id) ON DELETE CASCADE,
session_id INT REFERENCES sessions(session_id) ON DELETE CASCADE,
UNIQUE(member_id,session_id)
);

-- 1) Add a new column:
--Update the structure of the members table so that it can store loyalty points for each member.
--The new field should be initialized with a default value of 0.

ALTER TABLE members
ADD COLUMN loyalty_points INT DEFAULT 0



-- 2) Change an existing column's type:
--Modify the members table so that the phone field can store phone numbers
--with up to 20 characters.
ALTER TABLE members
ALTER COLUMN phone TYPE VARCHAR(20)



-- 3) Truncate a table and restart identity:
--Remove all records from the bookings table and reset the auto-incrementing
--ID values so that future records start numbering from the beginning.
TRUNCATE TABLE bookings RESTART IDENTITY 

---

----- Phase 3: Insert Data(DML) -----

INSERT INTO members (full_name, email, phone, country, city, street, join_date, status)
	VALUES
	('John Smith', 'john.smith@example.com', '+12025550101', 'USA', 'New York', '5th Avenue', '2025-01-15', 'active'),
	('Emma Johnson', 'emma.johnson@example.com', '+447700900101', 'UK', 'London', 'Baker Street', '2025-02-03', 'active'),
	('Ali Hassan', 'ali.hassan@example.com', '+962790123456', 'Jordan', 'Amman', 'Rainbow Street', '2025-03-10', 'active'),
	('Sara Ahmed', 'sara.ahmed@example.com', '+201001234567', 'Egypt', 'Cairo', 'Tahrir Street', '2025-01-28', 'inactive'),
	('Liam Brown', 'liam.brown@example.com', '+61412345678', 'Australia', 'Sydney', 'George Street', '2025-04-12', 'active'),
	('Sophia Davis', 'sophia.davis@example.com', '+4915112345678', 'Germany', 'Berlin', 'Unter den Linden', '2025-02-18', 'active'),
	('Omar Khaled', 'omar.khaled@example.com', '+966501234567', 'Saudi Arabia', 'Riyadh', 'King Fahd Road', '2025-05-07', 'active'),
	('Mia Wilson', 'mia.wilson@example.com', '+33161234567', 'France', 'Paris', 'Rue de Rivoli', '2025-03-22', 'inactive'),
	('Layla Nasser', 'layla.nasser@example.com', '+971501234567', 'UAE', 'Dubai', 'Sheikh Zayed Road', '2025-04-30', 'active');

--Checking when the join_date isn't filled--(DEFAULT)

INSERT INTO members (full_name, email, phone, country, city, street,status)
	VALUES('Noah Martinez', 'noah.martinez@example.com', '+34911234567', 'Spain', 'Madrid', 'Gran Via','active')

UPDATE members
SET loyalty_points = 120
WHERE member_id = 1;

UPDATE members
SET loyalty_points = 85
WHERE member_id = 2;

UPDATE members
SET loyalty_points = 240
WHERE member_id = 3;

UPDATE members
SET loyalty_points = 60
WHERE member_id = 4;

UPDATE members
SET loyalty_points = 175
WHERE member_id = 5;

UPDATE members
SET loyalty_points = 310
WHERE member_id = 6;

UPDATE members
SET loyalty_points = 95
WHERE member_id = 7;

UPDATE members
SET loyalty_points = 40
WHERE member_id = 8;

UPDATE members
SET loyalty_points = 260
WHERE member_id = 9;

UPDATE members
SET loyalty_points = 150
WHERE member_id = 10;


INSERT INTO trainers (full_name, email, phone, mentor_id,years_of_exp)
	VALUES
	('Michael Carter', 'michael.carter@example.com', '+12025551001', NULL,10),
	('Jessica Lee', 'jessica.lee@example.com', '+447700900201', NULL,15),
	('Ahmed Saleh', 'ahmed.saleh@example.com', '+962790111111', 1,6),
	('Emily Brown', 'emily.brown@example.com', '+61412345001', 2,3),
	('Omar Faris', 'omar.faris@example.com', '+966501111111', 1,7),
	('Sophia Martin', 'sophia.martin@example.com', '+33161111222', 2,5);

INSERT INTO categories(category_name)
	VALUES('Yoga'),('Cardio'),('Weightlifting'),('Boxing'),('Zumba');

INSERT INTO classes (class_name, category_id)
	VALUES
	('Beginner Yoga', 1),
	('Power Yoga', 1),
	('Morning Cardio Blast', 2),
	('HIIT Cardio', 2),
	('Endurance Training', 2),
	('Strength Fundamentals', 3),
	('Advanced Weightlifting', 3),
	('Olympic Lifting', 3),
	('Boxing Basics', 4),
	('Kickboxing Fitness', 4);

INSERT INTO sessions(session_date, start_time, end_time, room_number, class_id, trainer_id)
	VALUES
	('2025-04-27','08:00:00','08:45:00',50,1,2),
	('2025-05-01','12:00:00','12:45:00',31,1,2),
	('2025-05-03','09:00:00','09:45:00',15,2,3),
	('2025-05-04','10:00:00','10:45:00',22,3,1),
	('2025-05-05','11:00:00','11:45:00',18,4,4),
	('2025-05-06','13:00:00','13:45:00',40,5,5),
	('2025-05-07','14:00:00','14:45:00',25,6,6),
	('2025-05-08','15:00:00','15:45:00',12,7,3),
	('2025-05-09','16:00:00','16:45:00',28,8,2),
	('2025-05-10','17:00:00','17:45:00',35,9,1),
	('2025-05-11','08:30:00','09:15:00',50,10,4),
	('2025-05-12','09:30:00','10:15:00',45,2,5),
	('2025-05-13','10:30:00','11:15:00',20,3,6),
	('2025-05-14','11:30:00','12:15:00',14,4,2),
	('2025-05-15','12:30:00','13:15:00',38,5,1),
	('2025-05-16','13:30:00','14:15:00',16,6,3),
	('2025-05-17','14:30:00','15:15:00',27,7,5),
	('2025-05-18','15:30:00','16:15:00',30,8,4),
	('2025-05-19','16:30:00','17:15:00',42,9,6),
	('2025-05-20','17:30:00','18:15:00',11,10,2);

INSERT INTO bookings (rating, comment, member_id, session_id)
	VALUES
	(5, 'Excellent session!', 1, 1),
	(4, 'Very informative.', 2, 2),
	(3, 'It was okay.', 3, 3),
	(5, 'Loved every minute.', 4, 4),
	(2, 'Could be improved.', 5, 5),
	(4, 'Great instructor.', 6, 6),
	(5, 'Highly recommend!', 7, 7),
	(3, 'Average experience.', 8, 8),
	(4, 'Well organized.', 9, 9),
	(5, 'Fantastic session!', 10, 10),
	(1, 'Not what I expected.', 1, 2),
	(5, 'Very engaging.', 2, 3),
	(4, 'Learned a lot.', 3, 4),
	(2, 'Too fast-paced.', 4, 5),
	(3, 'Decent overall.', 5, 6),
	(5, 'Outstanding!', 6, 7),
	(4, 'Good content.', 7, 8),
	(5, 'Would attend again.', 8, 9),
	(2, 'Needs more examples.', 9, 10),
	(4, 'Pretty useful.', 10, 1),
	(5, 'Exceeded expectations.', 3, 2);
	
--i did this to make user 7 have 0 bookings--
UPDATE bookings
SET member_id=9 WHERE member_id=7 


----- PHASE 5 : SQL FUNDEMENTALS & DML -----

--3)Show all members (full name and email) ordered by join date ascending,
--using AS to alias the full name column.
SELECT full_name AS member_name , email, FROM members
ORDER BY join_date ASC;

--4)Show the distinct cities found in the members table.
SELECT DISTINCT city FROM members;

--5)Show only the members whose status is 'active'.
SELECT * FROM members WHERE status='active';

--6)UPDATE a trainer's years of experience,
--using RETURNING to return the row after the update
UPDATE trainers
SET years_of_exp=13 WHERE trainer_id=1
RETURNING full_name, years_of_exp;



--7)DELETE one dummy booking you inserted specifically for this purpose,
--using RETURNING to return the deleted row.
DELETE FROM bookings WHERE booking_id=21
RETURNING *


---- Phase 6: Security & Administration (DCL) ----

---- Create a read-only user:
--Create a new database user named readonly_user with a secure password.
--The user should be able to connect to the fitzone_db database and have
--read-only access to all tables in the public schema.
CREATE USER readonly_user WITH PASSWORD '123';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;

-- Create an operations manager user
--Create a database user named manager_user with a secure password.
--Grant the user permission to view, add, and update records in all tables
--within the public schema.
CREATE USER manager_user WITH PASSWORD '246';
GRANT SELECT , INSERT , UPDATE ON ALL TABLES in SCHEMA public TO manager_user;

-- Revoke update permission from manager_user ( ANY Table ).
REVOKE UPDATE ON trainers FROM manager_user;

--Write a short paragraph explaining this database administrator working in a company. Include realistic scenarios where permissions are granted and later revoked.--

--A database administrator (DBA) is responsible for managing, securing, and maintaining the FitZone gym database.
--The DBA creates database users, assigns permissions, and controls what actions each user can perform. For example,
--the DBA can create a manager_user account for an operations manager and grant permissions such as SELECT, INSERT,
--and UPDATE on tables like members, sessions, and bookings because the operations manager needs to manage daily gym activities,
--including member records and session bookings. The DBA can also create a readonly_user account for employees who only need to view information, such as checking class schedules, sessions, 
--and member details, without allowing them to modify or delete any data. If a user's role changes or they leave the company, the DBA can revoke their permissions to prevent unauthorized access.
--In addition, the DBA is responsible for creating backups, monitoring database performance, improving query speed through indexing,
--and ensuring that the database remains secure, reliable, and available for the company.


----- Phase 7: Joins -----

--8)show every session with its class name and the responsible
--trainer's name.
SELECT s.session_id,c.class_name ,t.full_name AS trainer_name FROM
sessions s
INNER JOIN classes c ON s.class_id=c.class_id
INNER JOIN trainers t ON t.trainer_id=s.trainer_id

--9)show all members with their booking count, including members
--with zero bookings.
SELECT m.member_id,m.full_name, COUNT(b.booking_id) AS booking_count FROM members m
LEFT JOIN bookings b ON m.member_id=b.member_id
GROUP BY m.member_id,m.full_name;

--10)show all sessions even if they have no bookings
SELECT s.session_id, s.start_time,s.end_time,s.room_number,b.booking_id FROM
bookings b RIGHT JOIN sessions s  ON s.session_id=b.session_id

--11)show all categories together with all classes,
--including the category that currently has zero classes.
SELECT  cat.category_name,c.class_name
FROM categories cat LEFT JOIN classes c ON cat.category_id=c.category_id

--12)show each trainer along with the name of their Mentor (if any).
SELECT t.full_name AS trainer_name , m.full_name AS mentor_name 
FROM trainers t  LEFT JOIN trainers m ON m.trainer_id=t.mentor_id

----- Phase 7: Aggregation , Grouping & Subqueries -----

--13)Count the number of bookings per member.
SELECT m.member_id,m.full_name AS member_name ,COUNT(b.booking_id) AS booking_count
FROM members m  JOIN bookings b ON m.member_id = b.member_id
GROUP BY m.member_id, m.full_name

--14)Average rating per trainer, based on the rating column in bookings.
SELECT t.trainer_id,t.full_name AS trainer_name , AVG(b.rating) AS average_rating
FROM bookings b INNER JOIN sessions s ON b.session_id=s.session_id
INNER JOIN trainers t ON s.trainer_id=t.trainer_id
GROUP BY t.trainer_id,t.full_name

--15)Highest and lowest rating  given for each class.
SELECT c.class_name, MAX(b.rating) AS max_rating, MIN(b.rating) AS minimum_rating
FROM bookings b JOIN sessions s ON b.session_id=s.session_id
JOIN classes c ON s.class_id=c.class_id
GROUP BY c.class_id,c.class_name

--16)Total loyalty_points across all members, grouped by city
SELECT city,SUM(loyalty_points) AS total_loyalty_points FROM members
GROUP BY city

--17)Use GROUP BY with HAVING to show categories that have more than two classes
SELECT cat.category_name, COUNT(c.class_name) class_count
FROM categories cat LEFT JOIN classes c ON c.category_id=cat.category_id
GROUP BY cat.category_id,cat.category_name
HAVING COUNT(c.class_name)> 2

--18)Show members who have never made a booking (using NOT IN or NOT EXISTS)
SELECT m.full_name AS member_name FROM
members m 
WHERE m.member_id NOT IN(SELECT member_id FROM bookings)

--19)Wrishow trainers whose average rating is above the overall average rating of all trainers
SELECT t.full_name AS trainer_name , AVG(rating) AS average_rating
FROM bookings b JOIN sessions s ON b.session_id=s.session_id
JOIN trainers t ON s.trainer_id=t.trainer_id
GROUP BY t.trainer_id,t.full_name
HAVING AVG(b.rating)>(SELECT AVG(rating) FROM bookings)

----- Phase 8: Indexing -----
--Improve the query performance on the members table by creating an index on the column used to search for
--members by their email address.
CREATE INDEX idx_member_email ON members(email)
--Improve the query performance on the bookings table by creating an index on the column used to identify
--sessions.
CREATE INDEX idx_booking_session ON bookings(session_id)
-- Then drop one of the indexes as a test
DROP INDEX idx_booking_session

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'members' -- proof that the index exists -- 

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'bookings' -- proof that the index got dropped -- 
