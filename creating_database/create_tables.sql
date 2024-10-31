CREATE TABLE student (
	code INT NOT NULL PRIMARY KEY,
	firstname VARCHAR(20) NOT NULL,
	lastname VARCHAR(25) NOT NULL,
	surname VARCHAR(20),
	birthday DATE,
	scholarship money
);
CREATE TABLE subject (
	code INT NOT NULL PRIMARY KEY,
	full_name VARCHAR(50) NOT NULL,
	hours_count INT NOT NULL CHECK  (hours_count BETWEEN 8 AND 512),
	semesters_count INT NOT NULL CHECK (semesters_count BETWEEN 1 AND 12)
);
CREATE TABLE teacher (
	code INT NOT NULL PRIMARY KEY,
	firstname VARCHAR(20) NOT NULL,
	lastname VARCHAR(25) NOT NULL,
	surname VARCHAR(20),
	department INT,
	rank VARCHAR(20),
	post VARCHAR(25)
);
CREATE TABLE department (
	code INT NOT NULL PRIMARY KEY,
	full_name VARCHAR(50) NOT NULL UNIQUE,
	manager INT
);
ALTER TABLE teacher
    ADD CONSTRAINT fk_teacher_to_department
        FOREIGN KEY (department)
            REFERENCES department(code)
;
ALTER TABLE department
    ADD CONSTRAINT fk_department_manager_to_teacher
        FOREIGN KEY (manager)
            REFERENCES teacher(code)
;
CREATE TABLE student_group (
	code VARCHAR(6) NOT NULL PRIMARY KEY,
	teacher INT,
	department INT
);
ALTER TABLE student_group
    ADD CONSTRAINT fk_department_to_student_group
        FOREIGN KEY (department)
            REFERENCES department(code)
;
ALTER TABLE student_group
    ADD CONSTRAINT fk_teacher_to_student_group
        FOREIGN KEY (teacher)
            REFERENCES teacher(code)
;
CREATE TABLE students_in_group (
	student INT,
	group_name VARCHAR(6),
	date_start DATE,
	date_end DATE,
	CONSTRAINT pk_students_in_groups
	    PRIMARY KEY (student, group_name)
);
ALTER TABLE students_in_group
    ADD CONSTRAINT fk_student_in_groups_to_student_group
        FOREIGN KEY (group_name)
            REFERENCES student_group(code)
;
ALTER TABLE students_in_group
    ADD CONSTRAINT FK_m2mStudentClass_Student
        FOREIGN KEY (student)
            REFERENCES student (code)
;
CREATE TABLE session_results (
	student INT,
	subject INT,
	teacher INT,
	date_of_exam DATE,
	mark INT NOT NULL CHECK (mark BETWEEN 2 AND 5),
	CONSTRAINT pk_session
	    PRIMARY KEY (student, subject, date_of_exam)
);
ALTER TABLE session_results
    ADD CONSTRAINT fk_session_to_student
        FOREIGN KEY (student)
            REFERENCES student (code)
;
ALTER TABLE session_results
    ADD CONSTRAINT fk_session_to_subject
        FOREIGN KEY (subject)
            REFERENCES subject (code)
;
ALTER TABLE session_results
    ADD CONSTRAINT fk_session__to_teacher
        FOREIGN KEY (teacher)
            REFERENCES teacher(code)
;
INSERT INTO student (
    code, firstname, surname, lastname, birthday, scholarship)
VALUES
    (1, 'Тимур', 'Тютючкин', 'Иванович', '2006-05-09', 1600),
    (2, 'Максим', 'Булатов', 'Игоревич', '2003-10-18', 3400),
    (3, 'Артем', 'Васильев', 'Денисович', '1999-03-03', 700),
    (4, 'Иван', 'Луковкин', 'Иванович', '2006-04-04', 5600),
    (5, 'Владислав', 'Бекренев', 'Петрович', '2005-05-05', 1900),
    (6, 'Александра', 'Маликова', 'Александровна', '2006-06-06', 1500),
    (7, 'Екатерина', 'Першина', 'Станиславовна', '2006-07-07', 1100),
    (8, 'Евгений', 'Вольский', 'Михайлович', '2005-08-08', 1200),
    (9, 'Михаил', 'Паршиков', 'Денисович', '2005-09-09', 1300),
    (10, 'Максим', 'Картаков', 'Викторович', '2004-10-10', 1400),
    (11, 'Николай', 'Задонский', 'Иванович', '2005-12-09', 1300),
    (12, 'Анна', 'Потапова', 'Владимировна', '2005-02-25', 1300),
    (13, 'Дмитрий', 'Андреев', 'Андреевич', '2006-10-11', 1300),
    (14, 'Кирилл', 'Сурыгин', 'Александрович', '2006-06-21', 1300),
    (15, 'Дмитрий', 'Аккуратов', 'Андреевич', '2006-06-20', 1300),
    (16, 'Татьяна', 'Бурцева', 'Николаевна', '2006-12-30', 1300),
    (17, 'Елизавета', 'Петрова', 'Валерьевна', '2005-01-15', 1300)
;
INSERT INTO subject (code, full_name, hours_count, semesters_count)
VALUES
    (1, 'Информатика', 108, 2),
    (2, 'Физика', 512, 2),
    (3, 'Базы данных', 108, 3),
    (4, 'Программирование на SQL', 216, 5),
    (5, 'ЭВМ и ПУ', 264, 3),
    (6, 'Высшая математика', 512, 2),
    (7, 'Математическая логика', 108, 2),
    (8, 'Иностранный язык', 512, 3),
    (9, 'Философия', 72, 2),
    (10, 'Экономика', 72, 3)
;
INSERT INTO department (code, full_name)
VALUES
    (1, 'Кафедра ЭВМ'),
    (2, 'Кафедра ОиЭФ'),
    (3, 'Кафедра САПР ВС'),
    (4, 'Кафедра ВМ'),
    (5, 'Кафедра ВПМ'),
    (6, 'Кафедра ИТГД'),
    (7, 'Кафедра ИБ'),
    (8, 'Кафедра иностранных языков'),
    (9, 'Кафедра ИФП'),
    (11, 'Кафедра КТ'),
    (10, 'Кафедра ЭМОП')
;
INSERT INTO teacher(
    code, firstname, surname, lastname, department, rank, post)
VALUES
    (1, 'Борис', 'Костров', 'Васильевич', 1, 'Профессор', 'Зав. кафедрой'),
    (2, 'Ангелина', 'Вьюгина', 'Алексеевна', 1, 'Доцент', 'Старший преподаватель'),
    (3, 'Наталья', 'Гринченко', 'Николаевна', 1, 'Кандидат наук', 'Доцент'),
    (4, 'Геннадий', 'Овечкин', 'Владимирович', 5, 'Доктор наук', 'Профессор'),
    (5, 'Светлана', 'Баранова', 'Николаевна', 1, 'Без звания', 'Ассистент'),
    (6, 'Марина', 'Бакулева', 'Алексеевна', 3, 'Кандидат наук', 'Доцент'),
    (7, 'Вячеслав', 'Корячко', 'Петрович', 3, 'Доктор наук', 'Зав. кафедрой'),
    (8, 'Дмитрий', 'Перепелкин', 'Александрович', 3, 'Доктор наук', 'Профессор'),
    (9, 'Алексей', 'Бубнов', 'Алексеевич', 5, 'Кандидат наук', 'Доцент'),
    (11, 'Михаил', 'Дубков', 'Викторович', 2, 'Доктор наук', 'Зав. кафедрой'),
    (12, 'Кирилл', 'Бухенский', 'Валентинович', 4, 'Кандидат наук', 'Зав. кафедрой'),
    (13, 'Дмитрий', 'Наумов', 'Анатольевич', 6, 'Кандидат наук', 'Зав. кафедрой'),
    (14, 'Виктор', 'Пржегорлинский', 'Николаевич', 7, 'Кандидат наук', 'Зав. кафедрой'),
    (15, 'Наталья', 'Есенина', 'Евгеньевна', 8, 'Кандидат наук', 'Зав. кафедрой'),
    (16, 'Александр', 'Соколов', 'Станиславович', 9, 'Доктор наук', 'Зав. кафедрой'),
    (17, 'Елена', 'Евдокимова', 'Николаевна', 10, 'Доктор наук', 'Зав. кафедрой'),
    (18, 'Дмитрий', 'Устюков', 'Игоревич', 1, 'Кандидат наук', 'Доцент'),
    (19, 'Сергей', 'Гусев', 'Игоревич', 11, 'Доктор наук', 'Зав. кафедрой'),
    (10, 'Ирина', 'Панина', 'Сергеевна', 1, 'Без звания', 'Старший преподаватель')
;

UPDATE department
    SET manager = CASE code
        WHEN 1 THEN 1
        WHEN 2 THEN 11
        WHEN 3 THEN 7
        WHEN 4 THEN 12
        WHEN 5 THEN 4
        WHEN 6 THEN 13
        WHEN 7 THEN 14
        WHEN 8 THEN 15
        WHEN 9 THEN 16
        WHEN 10 THEN 17
        WHEN 11 THEN 19
    END
WHERE code BETWEEN 1 AND 11;


INSERT INTO student_group (code, teacher, department)
VALUES
    ('245', 18, 1),
    ('240', 10, 1),
    ('246', 6, 3),
    ('2415', 19, 11),
    ('345', 5, 1),
    ('270', 17, 10),
    ('3714', 3, 1),
    ('3724', 3, 1),
    ('2414', 9, 5),
    ('142', 14, 7)
;
INSERT INTO students_in_group (student, group_name, date_start, date_end)
VALUES
    (1, '345', '2023-09-01', NULL),
    (2, '142', '2021-09-01', NULL),
    (3, '142', '2021-09-01', NULL),
    (4, '245', '2022-09-01', NULL),
    (5, '245', '2022-09-01', NULL),
    (6, '245', '2022-09-01', NULL),
    (7, '3714', '2023-09-01', NULL),
    (8, '3714', '2023-09-01', NULL),
    (9, '3714', '2023-09-01', NULL),
    (11, '345', '2023-09-01', NULL),
    (12, '345', '2023-09-01', NULL),
    (13, '2415', '2022-09-01', NULL),
    (14, '240', '2022-09-01', NULL),
    (15, '246', '2022-09-01', NULL),
    (16, '246', '2022-09-01', NULL),
    (17, '245', '2022-09-01', '2023-07-01'),
    (17, '246', '2023-07-02', NULL),
    (10, '345', '2023-09-01', NULL)
;

INSERT INTO session_results (student, subject, teacher, date_of_exam, mark)
VALUES
    (4, 3, 3, '2023-12-20', 5),
    (5, 3, 3, '2023-12-20', 4),
    (6, 3, 3, '2023-12-20', 5),
    (13, 3, 3, '2023-12-20', 5),
    (15, 3, 3, '2023-12-20', 4),
    (16, 3, 3, '2023-12-20', 4),
    (17, 3, 3, '2023-12-20', 3),
    (4, 8, 15, '2023-12-22', 5),
    (5, 8, 15, '2023-12-22', 5),
    (6, 8, 15, '2023-12-22', 5),
    (13, 8, 15, '2023-12-22', 5),
    (15, 8, 15, '2023-12-22', 5),
    (16, 8, 15, '2023-12-22', 5),
    (17, 8, 15, '2023-12-22', 5),
    (4, 5, 18, '2024-01-15', 5),
    (5, 5, 18, '2024-01-15', 3),
    (6, 5, 18, '2024-01-15', 4),
    (13, 5, 18, '2024-01-15', 5),
    (15, 5, 18, '2024-01-15', 3),
    (16, 5, 18, '2024-01-15', 4),
    (17, 5, 18, '2024-01-15', 2),
    (17, 5, 18, '2024-02-07', 4),
    (1, 8, 15, '2023-12-18', 3),
    (11, 8, 15, '2023-12-18', 4),
    (10, 8, 15, '2023-12-18', 4),
    (1, 1, 18, '2023-12-18', 3),
    (11, 1, 18, '2023-12-18', 4),
    (10, 1, 18, '2023-12-18', 4),
    (1, 2, 11, '2024-01-18', 2),
    (11, 2, 11, '2024-01-18', 2),
    (10, 2, 11, '2024-01-18', 2),
    (1, 2, 11, '2024-02-18', 3),
    (11, 2, 11, '2024-02-10', 3),
    (10, 2, 11, '2024-03-03', 4),
    (1, 2, 11, '2024-06-10', 4),
    (11, 2, 11, '2024-06-10', 4),
    (10, 2, 11, '2024-06-10', 4),
    (1, 5, 18, '2024-06-16', 3),
    (11, 5, 18, '2024-06-16', 3),
    (10, 5, 18, '2024-06-16', 4),
    (7, 1, 2, '2024-06-10', 5),
    (8, 1, 2, '2024-06-10', 4),
    (9, 1, 2, '2024-06-10', 4),
    (7, 9, 16, '2024-06-22', 5),
    (8, 9, 16, '2024-06-22', 5),
    (9, 9, 16, '2024-06-22', 5)
;