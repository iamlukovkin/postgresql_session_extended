# Создание правил и представлений в PostgreSQL
## Синтаксис
### [Правила](create_rule.sql)
```sql
CREATE [OR REPLACE] RULE name AS ON event TO table [WHERE condition]
DO [INSTEAD] { NOTHING | command | (command ; command ...) }
```

### [Представления](create_view.sql)
```sql
CREATE [OR REPLACE] VIEW view_name AS
SELECT statement
[WITH [CASCADED | LOCAL] CHECK OPTION]
```

