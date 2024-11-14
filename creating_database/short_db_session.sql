DROP DATABASE IF EXISTS short_db_session(FORCE);

CREATE DATABASE short_db_session;

CREATE TABLE student (
    number int not null primary key,
    full_name varchar(30),
    group_number int,
    birth_year decimal(4)
);
CREATE TABLE subject (
    number int not null primary key,
    full_name varchar(50),
    hours_volume int
);
CREATE TABLE exam (
    student int,
    subject int,
    date_of_exam date,
    mark decimal(1),
    primary key (student, subject, date_of_exam),
    foreign key (student)
        references student(number)
        on delete cascade,
    foreign key (subject)
        references subject(number)
        on delete cascade
);
INSERT INTO student VALUES
    (1,'Иванов И.И.',140,2003),
    (2,'Петров П.П.',140,2003),
    (3,'Сидоров С.С.',145,2003),
    (4,'Кузнецов К.К.',145,2004);
INSERT INTO subject VALUES
    (1,'Математика',100),
    (2,'Физика',200),
    (3,'Программирование',200)
;
INSERT INTO exam VALUES
    (1,1,'2021-06-10',5),
    (1,2,'2021-06-20',4),
    (1,3,'2021-06-30',3),
    (2,1,'2021-06-10',5),
    (2,2,'2021-06-20',5),
    (3,1,'2021-06-10',2)
;