CREATE OR REPLACE PROCEDURE get_student_full_name_by_number(
    student_number int,
    OUT student_full_name varchar(30)
) AS $porcedure_text$
    BEGIN
        student_full_name := (
            SELECT full_name
            FROM student
            WHERE number = student_number
        );
    END;
$porcedure_text$ LANGUAGE plpgsql;

DO $calling_procedure$
    DECLARE
        student_full_name varchar(30);
        student_number int := 1;
    BEGIN
        CALL get_student_full_name_by_number(student_number);
        RAISE NOTICE 'Student full name: %', student_full_name;
    END;
$calling_procedure$;

CREATE OR REPLACE PROCEDURE display_student_marks_by_text(
    student_number int,
    subject_number int,
    input_date_of_exam date,
    OUT word_mark varchar(20)
) AS $porcedure_text$
    DECLARE
        find_mark int;
    BEGIN
        find_mark := (
            SELECT mark
            FROM exam
            WHERE
                student = student_number
                AND subject = subject_number
                AND date_of_exam = input_date_of_exam
        );
        word_mark := (CASE find_mark
            WHEN 5 THEN 'отлично'
            WHEN 4 THEN 'хорошо'
            WHEN 3 THEN 'удовлетворительно'
            WHEN 2 THEN 'неудовлетворительно'
            ELSE 'непр. значение'
        END);
    END
$porcedure_text$ LANGUAGE plpgsql;

DO $calling_procedure$
    DECLARE
        student int := 1;
        subject int := 1;
        test_date_of_exam date = '2021-06-10';
        output_mark varchar(20);
    BEGIN
        CALL display_student_marks_by_text(student, subject, test_date_of_exam, output_mark);
        RAISE NOTICE 'Оценка студента №% за предмет №%, сданный %, - %', student, subject, test_date_of_exam, output_mark;
    END
$calling_procedure$ LANGUAGE plpgsql;

CREATE PROCEDURE insert_new_student(
    student_number int,
    student_full_name varchar(30),
    student_group varchar(5),
    year_of_birth int)
AS $procedure_text$
    BEGIN
        IF NOT EXISTS (
            SELECT * FROM student
            WHERE full_name = student_full_name
              AND student_group = group_number
        ) THEN
            INSERT INTO student VALUES (
                student_number,
                student_full_name,
                student_group,
                year_of_birth
            );
        ELSE
            RAISE exception 'Такой студент уже есть';
        END IF;
    END;
$procedure_text$ LANGUAGE plpgsql;