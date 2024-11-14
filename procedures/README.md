# Работа с процедурами в PostgreSQL
## Вызов процедур
```sql
DO LANGUAGE <language_name> $<procedure_name>$
DECLARE
    <variable_list>
BEGIN
    <procedure_body>
END;
$<procedure_name>$;
```
## Создание хранимой процедуры
```sql
CREATE [OR REPLACE] PROCEDURE <procedure_name> (
    <parameter_list>
) LANGUAGE <language_name> AS 
$<procedure_name>$
BEGIN
    <procedure_body>
END;
$<procedure_name>$;