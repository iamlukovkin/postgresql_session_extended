-- правило для оценок mark в таблице session между 2 и 5
CREATE OR REPLACE RULE correct_mark AS
    ON INSERT TO session
    WHERE mark BETWEEN 2 AND 5
    DO INSTEAD NOTHING