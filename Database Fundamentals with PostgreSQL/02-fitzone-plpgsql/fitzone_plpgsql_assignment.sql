----- Phase 1: Blocks & Variables -----
-- 1) , 2)
DO $$
	DECLARE
		v_email members.email%TYPE;
		v_total_bookings INT;
	BEGIN
		SELECT email INTO v_email FROM members
		WHERE member_id = (SELECT MIN(member_id) FROM members);
		
		SELECT COUNT(*) INTO v_total_bookings FROM bookings
		GROUP BY member_id
		HAVING member_id =(SELECT MIN(member_id) FROM members);
		
		RAISE NOTICE 'The email of the member with
		the lowest ID is : % and their total amount of bookings are %',v_email,v_total_bookings;
		
	EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred';
	END;
$$;

--3)
--Running this logic as a plain SQL SELECT statement allows us only 
--to retrieve and display data from the database. 
--By using a PL/pgSQL block, we gain procedural capabilities such as 
--declaring variables, using conditional statements, 
--handling exceptions, and controlling the flow of execution with 
--loops. This allows us to perform more complex database operations 
--that cannot be achieved with plain SQL alone.




----- Phase 2: Control Flow & Loops -----
--4)
DO $$
DECLARE
    v_member_id INT := 2;
    v_status TEXT;
BEGIN
    SELECT status
    INTO v_status
    FROM members
    WHERE member_id = v_member_id;

    IF v_status = 'active' THEN
        RAISE NOTICE 'User with member ID % is Active', v_member_id;

    ELSIF v_status = 'inactive' THEN
        RAISE NOTICE 'User with member ID % is Inactive', v_member_id;

    ELSE
        RAISE NOTICE 'User with member ID % does not have a status',
        v_member_id;
    END IF;
END;
$$;

--5)
DO $$
DECLARE
    v_category_id INT := 1;
    v_class classes.class_name%TYPE;
BEGIN
    FOR v_class IN
        SELECT class_name
        FROM classes
        WHERE category_id = v_category_id
    LOOP
        RAISE NOTICE
        'Class % belongs to category %',
        v_class,
        v_category_id;
    END LOOP;
END;
$$;

--6)
DO $$
DECLARE
    v_trainer_id INT := 2;
    v_counter INT := 0;
    v_session_id INT := 0;
BEGIN
    WHILE v_session_id IS NOT NULL LOOP

        SELECT MIN(session_id)
        INTO v_session_id
        FROM sessions
        WHERE trainer_id = v_trainer_id
        AND session_id > v_session_id;

        IF v_session_id IS NOT NULL THEN
            v_counter := v_counter + 1;
        END IF;

    END LOOP;

    RAISE NOTICE
    'Trainer with ID % has led % sessions',
    v_trainer_id,
    v_counter;
END;
$$;

----- Phase 3: Functions -----
--7)
CREATE OR REPLACE FUNCTION get_member_full_name(
    p_member_id members.member_id%TYPE
)
RETURNS TEXT AS $$
BEGIN
    RETURN (
        SELECT full_name
        FROM members
        WHERE member_id = p_member_id
    );
END;
$$ LANGUAGE plpgsql;

--8)
CREATE OR REPLACE FUNCTION get_average_rating_by_trainer(
    p_trainer_id INT
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT AVG(b.rating)
        FROM bookings b
        JOIN sessions s
        ON b.session_id = s.session_id
        WHERE s.trainer_id = p_trainer_id
    );
END;
$$ LANGUAGE plpgsql;


--9)
CREATE OR REPLACE FUNCTION calculate_loyalty_points(
    p_member_id INT
)
RETURNS INT AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM bookings
        WHERE member_id = p_member_id
        AND rating = 5
    );
END;
$$ LANGUAGE plpgsql;

SELECT get_member_full_name(2);
SELECT get_average_rating_by_trainer(1);
SELECT calculate_loyalty_points(1);

----- Phase 4: Procedures -----
--10)
CREATE OR REPLACE PROCEDURE add_new_booking(
    p_member_id INT,
    p_session_id INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO bookings(member_id, session_id)
    VALUES(p_member_id, p_session_id);
END;
$$;

CALL add_new_booking(1,4);

--11)
CREATE OR REPLACE PROCEDURE update_member_status(
    p_member_id INT,
    p_new_status VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE members
    SET status = p_new_status
    WHERE member_id = p_member_id;
END;
$$;

CALL update_member_status(1,'inactive');

----- Phase 5: Error Handling & RECORD Variables -----
--12)
DO $$
	DECLARE
		v_rec RECORD;
		v_class INT :=1;
	BEGIN
		FOR v_rec IN SELECT session_date,room_number,trainer_id
		FROM sessions WHERE class_id=v_class
		LOOP
			RAISE NOTICE 'class % info : DATE % , room number % , trainer_id %',v_class,v_rec.session_date,v_rec.room_number,v_rec.trainer_id;
		END LOOP;
	END;
$$;

--13)
CREATE OR REPLACE PROCEDURE add_new_booking(
    p_member_id INT,
    p_session_id INT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO bookings(member_id, session_id)
    VALUES(p_member_id, p_session_id);
EXCEPTION
	WHEN foreign_key_violation THEN
	  RAISE NOTICE 'Invalid member ID % or session ID %',
        p_member_id,
        p_session_id;
END;
$$;
CALL add_new_booking(1,1000);


----- Phase 6: Practical Applications of PL/pgSQL -----
--14)
CREATE OR REPLACE FUNCTION get_member_by_email(
    p_email TEXT,
    OUT p_member_id INT,
    OUT p_full_name TEXT,
    OUT p_email1 TEXT,
    OUT p_phone TEXT,
    OUT p_country TEXT,
    OUT p_city TEXT,
    OUT p_street TEXT,
    OUT p_join_date DATE,
    OUT p_status TEXT,
    OUT p_loyalty_points INT
)
AS $$
BEGIN
    SELECT member_id, full_name, email, phone, country, city, street,
           join_date, status, loyalty_points
    INTO p_member_id, p_full_name, p_email1, p_phone, p_country,
         p_city, p_street, p_join_date, p_status, p_loyalty_points
    FROM members
    WHERE email = p_email;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Email % does not exist', p_email;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_member_by_email('john.smith@example.com');

--15)
CREATE OR REPLACE FUNCTION is_valid_rating(p_rating INT)
RETURNS BOOL AS $$
BEGIN
IF p_rating >=1 AND p_rating <=5 THEN
	RETURN TRUE;
ELSE
	RETURN FALSE;
END IF;
END;
$$ LANGUAGE plpgsql;

SELECT is_valid_rating(9);

--16)
CREATE OR REPLACE PROCEDURE apply_loyalty_bonus()
LANGUAGE plpgsql AS $$
DECLARE 
    v_member RECORD;
BEGIN
    FOR v_member IN 
        SELECT member_id
        FROM bookings
        GROUP BY member_id
        HAVING COUNT(booking_id) > 3
    LOOP
        UPDATE members
        SET loyalty_points = loyalty_points + 1
        WHERE member_id = v_member.member_id
        AND loyalty_points < 5;
    END LOOP;
END;
$$;

CALL apply_loyalty_bonus();

--17)
CREATE OR REPLACE FUNCTION count_available_seats(p_session_id INT)
RETURNS INT AS $$
DECLARE
    v_room_capacity CONSTANT INT := 15;
BEGIN
    RETURN (
        v_room_capacity - 
        (SELECT COUNT(*) 
         FROM bookings
         WHERE session_id = p_session_id)
    );
END;
$$ LANGUAGE plpgsql;

SELECT count_available_seats(1);


----- Phase 7: Named Exception Handling -----
--18)
DO $$
BEGIN
INSERT INTO trainers(full_name,email,phone,years_of_exp)
			VALUES('Ahmad hassan',
			'jessica.lee@example.com',
			'+1111111111',5);
EXCEPTION
	WHEN unique_violation THEN
	RAISE NOTICE 'Email already exists';
END;
$$;

--19)
DO $$
BEGIN
INSERT INTO bookings(member_id,session_id)
			VALUES(1,99999);
EXCEPTION
	WHEN foreign_key_violation THEN
	RAISE NOTICE 'This session does not exist';
END;
$$;

----- Phase 8: Additional PL/pgSQL Practice -----
--20)
DO $$
DECLARE
	v_total_members INT;
BEGIN
	SELECT COUNT(*) INTO v_total_members FROM members;
	RAISE NOTICE 'The total amount of members are % ',v_total_members;
END;
$$;

----- Phase 9: Triggers — Validation & Business Rules -----
----------
--21A)
CREATE OR REPLACE FUNCTION validate_rating()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.rating IS NOT NULL
       AND (NEW.rating < 1 OR NEW.rating > 5) THEN
        RAISE EXCEPTION
        'Rating must be between 1 and 5';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_rating
BEFORE INSERT OR UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION validate_rating();

UPDATE bookings
SET rating = -1
WHERE booking_id = 10; --> it fails here because the rating is out of bounds

--21B)
CREATE OR REPLACE FUNCTION prevent_rating_update()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.rating IS NOT NULL 
       AND NEW.rating IS DISTINCT FROM OLD.rating THEN
        RAISE EXCEPTION 'Rating can only be submitted once';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trg_prevent_rating_update
BEFORE UPDATE ON bookings
FOR EACH ROW
EXECUTE FUNCTION prevent_rating_update();

SELECT booking_id, rating
FROM bookings
WHERE rating IS NULL;

UPDATE bookings
SET rating = 4
WHERE booking_id = 26;

UPDATE bookings
SET rating = 3
WHERE booking_id = 26; --> It fails here because i tried to update it twice


----------

----- Phase 10: Audit Logging -----
--22)
----------
CREATE TABLE audit_log(
    audit_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id INT,
    operation VARCHAR(10),
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    username TEXT
);
CREATE OR REPLACE FUNCTION log_booking_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN

        INSERT INTO audit_log(booking_id, operation, username)
        VALUES (NEW.booking_id, 'INSERT', CURRENT_USER);

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        INSERT INTO audit_log(booking_id, operation, username)
        VALUES (NEW.booking_id, 'UPDATE', CURRENT_USER);

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        INSERT INTO audit_log(booking_id, operation, username)
        VALUES (OLD.booking_id, 'DELETE', CURRENT_USER);

        RETURN OLD;

    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_bookings
AFTER INSERT OR UPDATE OR DELETE
ON bookings
FOR EACH ROW
EXECUTE FUNCTION log_booking_changes();

INSERT INTO bookings(member_id, session_id)
VALUES (1, 5);

UPDATE bookings
SET rating = 5
WHERE booking_id = 1;

DELETE FROM bookings
WHERE booking_id = 1;

SELECT * FROM audit_log;
----------

----- Phase 11: Business Rules in the Database -----
--23)
----------
CREATE OR REPLACE FUNCTION increase_loyalty_after_rating()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.rating IS NULL AND NEW.rating IS NOT NULL THEN
        
        IF (SELECT loyalty_points 
            FROM members 
            WHERE member_id = NEW.member_id) < 5 THEN
            
            UPDATE members
            SET loyalty_points = loyalty_points + 1
            WHERE member_id = NEW.member_id;
            
        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_increase_loyalty_after_rating
AFTER UPDATE OF rating ON bookings
FOR EACH ROW
EXECUTE FUNCTION increase_loyalty_after_rating();

UPDATE bookings
SET rating = 5
WHERE booking_id = 29;
----------


