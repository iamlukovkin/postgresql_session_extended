DO LANGUAGE plpgsql $print_department_name$
BEGIN
    RAISE NOTICE 'Hello, PostgreSQL!';      -- Вывод без параметров
    RAISE NOTICE 'Hello, %!', 'PostgreSQL'; -- Вывод с параметром
END;
$print_department_name$;