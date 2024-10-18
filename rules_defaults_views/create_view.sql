CREATE OR REPLACE VIEW student_results AS
    SELECT
        s.studlastname
            || ' ' || SUBSTRING(s.studfirstname, 1, 1)
            || '. ' || SUBSTRING(s.studsurname, 1, 1) || '.' AS student,
        c.classcode AS class,
        sub.subname AS subject,
        t.teacherlastname
            || ' ' || SUBSTRING(t.teacherfirstname, 1, 1)
            || '. ' || SUBSTRING(t.teachersurname, 1, 1) || '.' AS teacher,
        session.mark
    FROM
        session
            JOIN student s on s.studcode = session.student
            JOIN m2mstudentclass m2m on s.studcode = m2m.student
                JOIN class c on c.classcode = m2m.class
            JOIN subject sub on sub.subcode = session.subject
            JOIN teacher t on t.teachercode = session.teacher
    ORDER BY class, student