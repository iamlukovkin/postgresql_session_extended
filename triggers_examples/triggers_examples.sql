--- Задание: Запретить пересдачу экзамена более трех раз

-- Функция ограничения числа пересдач экзаменов
CREATE OR REPLACE FUNCTION limit_exam_retakes()
RETURNS TRIGGER AS $$ --
DECLARE
    exam_count INT; -- Количество пересдач
BEGIN
    -- Подсчет пересдач для студента и предмета
    SELECT COUNT(*) INTO exam_count
    FROM Session
    WHERE student = NEW.student AND subject = NEW.subject;

    -- Проверка лимита пересдач
    IF exam_count >= 3 THEN
        RAISE EXCEPTION 'Студент не может пересдать экзамен более трех раз';
    END IF;

    RETURN NEW; -- Возврат новой записи
END;
$$ LANGUAGE plpgsql;

-- Триггер для вызова функции перед добавлением или обновлением записи
CREATE TRIGGER trg_limit_exam_retakes
BEFORE INSERT OR UPDATE ON Session
FOR EACH ROW EXECUTE FUNCTION limit_exam_retakes();

--- Пример применения 
--- Вставка первой пересдачи
INSERT INTO Session (student, subject, teacher, date_of_exam, mark)
VALUES
       (1, 1, 18, '2023-12-20', 4); -- первая сдача
       
--- Попытка вставить четвертую пересдачу
INSERT INTO Session (student, subject, teacher, date_of_exam, mark)
VALUES (10, 2, 11, '2024-09-01', 4); -- четвертая сдача


   
--- Задание: При переводе студента в другую группу в предыдущей группе
--- студента устанавливать дату окончания на день раньше чем зачисление в новую

-- Функция для обновления даты окончания у студента при переводе в другую группу
CREATE FUNCTION update_end_date_on_class_transfer()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    -- Устанавливаем дату окончания на день до новой даты начала
    UPDATE students_in_group
    SET date_end = NEW.date_start - INTERVAL '1 day'
    WHERE student = NEW.student
      AND date_end IS NULL;

    RETURN NEW;
END;
$$;

-- Установка владельца функции
ALTER FUNCTION update_end_date_on_class_transfer() OWNER TO postgres;

-- Создание триггера для функции
CREATE TRIGGER trg_update_end_date_on_class_transfer
BEFORE INSERT OR UPDATE
ON students_in_group
FOR EACH ROW
EXECUTE PROCEDURE update_end_date_on_class_transfer();

---Пример применения
-- Вставка данных о переводе студента в новую группу
INSERT INTO students_in_group (student, group_id, date_start, date_end)
VALUES (4, 10, '2024-01-01', NULL);



--- Задание: При получении студентом оценки 3 стипендию установить NULL

-- Создаем или заменяем функцию, которая будет вызываться триггером
CREATE OR REPLACE FUNCTION set_scholarship_null_on_low_mark()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем, если новая оценка (mark) равна 3
    IF NEW.mark = 3 THEN
        -- Если условие выполняется, устанавливаем значение studGrant в NULL у соответствующего студента
        UPDATE Student
        SET scholarship  = NULL
        WHERE code = NEW.student;  -- Идентифицируем студента по его коду (studCode)
    END IF;

    -- Возвращаем новую строку, которая была вставлена или обновлена
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер, который будет срабатывать после вставки или обновления записи в таблице Session
CREATE TRIGGER trg_set_scholarship_null_on_low_mark
AFTER INSERT OR UPDATE ON Session
FOR EACH ROW  -- Указываем, что триггер должен срабатывать для каждой измененной строки
EXECUTE FUNCTION set_scholarship_null_on_low_mark();  -- Указываем функцию, которая будет выполнена

--- пример применения
INSERT INTO Session (student, subject, teacher, date_of_exam, mark)
VALUES (17, 8, 1, '2023-03-10', 3);  -- Оценка 3, это вызовет изменение стипендии

SELECT * FROM Student WHERE code = 17;


--- Задание: Куратор группы должен быть с той же кафедры, к которой прикреплена группа

-- Функция для проверки соответствия куратора кафедре группы
CREATE OR REPLACE FUNCTION check_curator_department()
RETURNS TRIGGER AS $$
DECLARE
    teacher_department INT;  -- Переменная для хранения кафедры куратора
BEGIN
    SELECT department INTO teacher_department
    FROM Teacher
    WHERE code = NEW.teacher;

    IF teacher_department <> NEW.department THEN
        RAISE EXCEPTION 'Куратор группы должен быть с той же кафедры, к которой прикреплена группа.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для проверки при вставке или обновлении группы
CREATE TRIGGER trg_check_curator_department
BEFORE INSERT OR UPDATE ON student_group
FOR EACH ROW
EXECUTE FUNCTION check_curator_department();


--- Пример применения
--- попытка вставить корректные данные
INSERT INTO student_group (code, teacher, department)
VALUES ('348', 1, 1);  -- Здесь куратор (Борис Костров) из кафедры 'Кафедра ЭВМ' (depCode = 1)

-- Попытка вставить некорректные данные
INSERT INTO student_group (code, teacher, department)
VALUES ('349', 1, 5);  -- Куратор Борис Костров (depCode = 1), а кафедра 'Кафедра ВПМ' (depCode = 5)

--- Пример обновления данных таблицы
-- Сначала добавим класс с корректным куратором
INSERT INTO student_group (code, teacher, department)
VALUES ('350', 2, 1);  -- Куратор (Ангелина Вьюгина) из кафедры 'Кафедра ЭВМ' (depCode = 1)

-- Теперь попытаемся изменить кафедру на неподходящую
UPDATE student_group
SET department = 5  -- Меняем на 'Кафедра ВПМ'
WHERE code = '350';



----Задание: Нельзя назначить доцентом преподавателя, не имеющего степени.

-- Функция для проверки наличия ученой степени у доцента
CREATE OR REPLACE FUNCTION check_academic_degree()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверка, если должность преподавателя 'Доцент' и ученая степень отсутствует
    IF NEW.teacherPost = 'Доцент' AND NEW.academicTitle IS NULL THEN
        -- Генерация исключения с сообщением об ошибке
        RAISE EXCEPTION 'Нельзя назначить преподавателя доцентом без ученой степени.';
    END IF;

    -- Возвращение новой записи
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для проверки должности и ученой степени при вставке или обновлении преподавателя
CREATE TRIGGER trg_check_academic_degree
BEFORE INSERT OR UPDATE ON Teacher
FOR EACH ROW
EXECUTE FUNCTION check_academic_degree();

---Пример применения

-- Попробуем вставить преподавателя без степени, назначенного доцентом
INSERT INTO Teacher
VALUES 
(
    22,               -- Код преподавателя
    'Светлана',      -- Имя
    'Гребенкина',    -- Фамилия
    'Петровна',      -- Отчество
    1,                -- Код кафедры
    NULL,            -- Ученая степень (NULL - нет)
    'Доцент'         -- Должность
);

-- Успешная вставка преподавателя с ученой степенью
INSERT INTO Teacher
VALUES 
(
    21,               -- Код преподавателя
    'Александр',     -- Имя
    'Сидоров',       -- Фамилия
    'Алексеевич',    -- Отчество
    1,                -- Код кафедры
    'Кандидат наук', -- Ученая степень
    'Доцент'         -- Должность
);


--- Заведующим кафедры может быть только сотрудник указанной кафедры.

 -- Создаем функцию для проверки, является ли заведующий кафедры сотрудником этой кафедры
CREATE OR REPLACE FUNCTION check_department_manager()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем, является ли teacherCode (заведующий кафедрой)
    -- сотрудником кафедры (teacherDepartment)
    IF EXISTS (
        SELECT 1
        FROM Teacher
        WHERE teacher = NEW.depManager
          AND department = NEW.depCode
    ) THEN
        -- Если заведующий кафедры соответствует условиям, продолжаем
        RETURN NEW;
    ELSE
        -- Если не соответствует, генерируем ошибку
        RAISE EXCEPTION 'Заведующий кафедры (teacherCode: %) не принадлежит данной кафедре (depCode: %)', NEW.depManager, NEW.depCode;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер, который будет срабатывать перед вставкой или обновлением таблицы Department
CREATE TRIGGER trg_check_department_manager
BEFORE INSERT OR UPDATE ON Department
FOR EACH ROW
EXECUTE FUNCTION check_department_manager();

-- Пример использования
UPDATE Department
SET manager = 3  -- Преподаватель
WHERE code = 1;  -- Кафедра
