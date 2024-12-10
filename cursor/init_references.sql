DO
$cursor_examples$
    DECLARE
        data_row record; -- Строка данных для реализации итераций в запросе
        student_id integer; -- Идентификатор студента
        reference_cursor refcursor; -- Объявление ссылки на курсор
        cursor_without_parameter CURSOR FOR
            SELECT *
            FROM session_results; -- Открытие курсора без параметров
        cursor_with_parameter CURSOR (key integer) FOR
            SELECT *
            FROM session_results
            WHERE session_results.student = key; -- Открытие курсора с параметром
        cursor_with_parameter_of_variable CURSOR FOR
            SELECT *
            FROM session_results
            WHERE session_results.student = student_id;
        cursor_for_fetching CURSOR FOR
            SELECT *
            FROM session_results;
    BEGIN
        student_id := 1; -- Задание идентификатора студента
        OPEN reference_cursor FOR
            SELECT *
            FROM session_results
            WHERE session_results.student = student_id; -- Открытие курсора, объявленного ссылкой
        FETCH FIRST
            FROM reference_cursor
            INTO data_row; -- Получение первой строки из курсора
        <<raw_cursor_iteration>>
        LOOP
            -- Использование цикла без условия выхода
            EXIT WHEN NOT FOUND; -- Задание условия для выхода из цикла
            RAISE NOTICE '%', data_row; -- Вывод данных
            FETCH NEXT FROM reference_cursor INTO data_row; -- Получение следующей строки из курсора
        END LOOP;
        CLOSE reference_cursor; -- Закрытие курсора

        <<cursor_without_parameter_iteration>>
        -- При использовании цикла FOR открытие курсора не требуется
            FOR data_row IN cursor_without_parameter -- Использование цикла без параметров
            LOOP
                IF data_row.student != student_id THEN CONTINUE; END IF; -- Проверка соответствия студента
                RAISE NOTICE '%', data_row;
            END LOOP;

        OPEN cursor_with_parameter(student_id); -- Открытие курсора с параметром и установка значения параметра
        FETCH FIRST FROM cursor_with_parameter INTO data_row; -- Получение первой строки из курсора
        <<cursor_with_parameter_iteration>>
        WHILE FOUND -- Использование цикла с условием выхода: "Пока строки найдены"
            LOOP
                RAISE NOTICE '%', data_row;
                FETCH NEXT FROM cursor_with_parameter INTO data_row; -- Получение следующей строки из курсора
            END LOOP;
        CLOSE cursor_with_parameter; -- Закрытие курсора

        <<cursor_with_parameter_of_variable_iteration>>
        FOR data_row IN cursor_with_parameter_of_variable
            LOOP
                RAISE NOTICE '%', data_row;
            END LOOP;

        OPEN cursor_for_fetching; -- Открытие курсора

        FETCH FIRST FROM cursor_for_fetching INTO data_row; -- Получение первой строки из курсора
        RAISE NOTICE '%', data_row;

        FETCH NEXT FROM cursor_for_fetching INTO data_row; -- Получение следующей строки из курсора
        RAISE NOTICE '%', data_row;

        FETCH PRIOR FROM cursor_for_fetching INTO data_row; -- Получение предыдущей строки из курсора
        RAISE NOTICE '%', data_row;

        FETCH LAST FROM cursor_for_fetching INTO data_row; -- Получение последней строки из курсора
        RAISE NOTICE '%', data_row;

        FETCH ABSOLUTE 1 FROM cursor_for_fetching INTO data_row; -- Получение первой строки из курсора
        RAISE NOTICE '%', data_row;

        FETCH RELATIVE 2 FROM cursor_for_fetching INTO data_row; -- Получение следующей строки из курсора
        RAISE NOTICE '%', data_row;

        FETCH FORWARD FROM cursor_for_fetching INTO data_row; -- Получение предыдущей строки из курсора
        RAISE NOTICE '%', data_row;

        FETCH BACKWARD FROM cursor_for_fetching INTO data_row; -- Получение последней строки из курсора
        RAISE NOTICE '%', data_row;

        MOVE FIRST FROM cursor_for_fetching;
        RAISE NOTICE '%', data_row;

        MOVE RELATIVE -1 FROM cursor_for_fetching;
        RAISE NOTICE '%', data_row;

        DELETE FROM student WHERE CURRENT OF cursor_for_fetching;

        CLOSE cursor_for_fetching; -- Закрытие курсора

    END;
$cursor_examples$ LANGUAGE plpgsql;