-- Стъпка 1: Активиране на профилиране за измерване на времето за изпълнение на заявките
SET PROFILING = 1;

-- Стъпка 2: Започваме транзакция за безопастност
START TRANSACTION;

-- Стъпка 3: Пробваме да създадем таблиците с партиции и индекси
-- Ако всичко мине успешно, ще извършим COMMIT в края

-- Ако таблицата salaries вече съществува, първо я изтриваме и създаваме отново
use employee_management;
DROP TABLE IF EXISTS salaries;

CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (emp_no, from_date)
) ENGINE=InnoDB
PARTITION BY RANGE (YEAR(from_date)) (
    PARTITION p1990 VALUES LESS THAN (1991),
    PARTITION p1991 VALUES LESS THAN (1992),
    PARTITION p1992 VALUES LESS THAN (1993),
    PARTITION p1993 VALUES LESS THAN (1994),
    PARTITION p1994 VALUES LESS THAN (1995),
    PARTITION p1995 VALUES LESS THAN (1996),
    PARTITION p1996 VALUES LESS THAN (1997),
    PARTITION p1997 VALUES LESS THAN (1998),
    PARTITION p1998 VALUES LESS THAN (1999),
    PARTITION p1999 VALUES LESS THAN (2000),
    PARTITION p2000 VALUES LESS THAN (2001),
    PARTITION p2001 VALUES LESS THAN (2002),
    PARTITION p2002 VALUES LESS THAN (2003),
    PARTITION p2003 VALUES LESS THAN (2004),
    PARTITION p2004 VALUES LESS THAN (2005),
    PARTITION p2005 VALUES LESS THAN (2006),
    PARTITION p2006 VALUES LESS THAN (2007),
    PARTITION p2007 VALUES LESS THAN (2008),
    PARTITION p2008 VALUES LESS THAN (2009)
);


-- Ако таблицата titles" вече съществува, първо я изтриваме и създаваме отново
DROP TABLE IF EXISTS titles;

CREATE TABLE titles (
    emp_no INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (emp_no, title, from_date)
) ENGINE=InnoDB
PARTITION BY RANGE (YEAR(from_date)) (
    PARTITION p1990 VALUES LESS THAN (1991),
    PARTITION p1991 VALUES LESS THAN (1992),
    PARTITION p1992 VALUES LESS THAN (1993),
    PARTITION p1993 VALUES LESS THAN (1994),
    PARTITION p1994 VALUES LESS THAN (1995),
    PARTITION p1995 VALUES LESS THAN (1996),
    PARTITION p1996 VALUES LESS THAN (1997),
    PARTITION p1997 VALUES LESS THAN (1998),
    PARTITION p1998 VALUES LESS THAN (1999),
    PARTITION p1999 VALUES LESS THAN (2000),
    PARTITION p2000 VALUES LESS THAN (2001),
    PARTITION p2001 VALUES LESS THAN (2002),
    PARTITION p2002 VALUES LESS THAN (2003),
    PARTITION p2003 VALUES LESS THAN (2004),
    PARTITION p2004 VALUES LESS THAN (2005),
    PARTITION p2005 VALUES LESS THAN (2006),
    PARTITION p2006 VALUES LESS THAN (2007),
    PARTITION p2007 VALUES LESS THAN (2008),
    PARTITION p2008 VALUES LESS THAN (2009)
);




-- Стъпка 5: Изпълняване на оптимизирана заявка

SELECT * FROM salaries WHERE from_date > '1990-12-31' AND from_date < '1991-12-31';




SELECT TIMEDIFF(@end_time, @start_time) AS time_taken;
-- Стъпка 6: Показване на резултати от профилирането
SHOW PROFILES;

-- Стъпка 7: Създаване на индекси за подобряване на производителността
CREATE INDEX idx_salaries_from_date ON salaries (from_date);
CREATE INDEX idx_titles_from_date ON titles (from_date);

/*-- Стъпка 8: Активиране на кеширане на заявки за оптимизация
SET GLOBAL query_cache_type = ON;
SET GLOBAL query_cache_size = 1048576; -- размер на кеша за заявки (1MB)
Аз съм на Mysql 8.0 ...
-- Стъпка 9: Изпълнение на заявка с кеширане
SELECT * FROM salaries WHERE from_date > '1990-12-31' AND from_date < '1991-12-31';
*/
-- Допълнителни оптимизации:

-- Пример 1: Използване на EXPLAIN за анализ на плана за изпълнение на заявката
EXPLAIN SELECT * FROM salaries WHERE from_date > '1990-12-31' AND from_date < '1991-12-31';

-- Пример 2: Избягване на SELECT * и избиране само на нужните колони
SELECT emp_no, salary, from_date, to_date
FROM salaries
WHERE from_date > '1990-12-31' AND from_date < '1991-12-31';

-- Пример 3: Създаване на индекс върху колоната from_date в  salaries
CREATE INDEX idx_salaries_from_date ON salaries (from_date);

-- Пример 4: Разделяне на големи заявки на по-малки чрез LIMIT и OFFSET
SELECT emp_no, salary, from_date, to_date
FROM salaries
WHERE from_date > '1990-12-31' AND from_date < '1991-12-31'
LIMIT 1000 OFFSET 0;

SELECT emp_no, salary, from_date, to_date
FROM salaries
WHERE from_date > '1990-12-31' AND from_date < '1991-12-31'
LIMIT 3000 OFFSET 1001;
-- Пример 5 Сортиране преди търсене:
SELECT * 
FROM salaries
ORDER BY from_date DESC;

-- ------------------------------------------------------------------------------------------------------------------
 -- Пример 1: Използване на EXPLAIN за анализ на плана за изпълнение на заявката
-- Това ще ти покаже как MySQL ще изпълни заявката, кои индекси ще се използват и колко реда ще се обработят
EXPLAIN SELECT * 
FROM titles 
WHERE from_date > '1995-01-01' AND from_date < '1996-01-01';

-- Резултатът от EXPLAIN ще съдържа информация като 'type', 'possible_keys', 'key', 'rows', която ще ти помогне да се разбере
-- дали заявката е оптимизирана, дали се използва индекс и какви оптимизации можеш да приложим.

-- Пример 2: Избягване на SELECT * и избиране само на нужните колони
-- Вместо да извличаш всички колони (SELECT *), избери само тези, които ти трябват. Това ще намали обема на данните и ще ускори заявката
SELECT emp_no, title, from_date, to_date
FROM titles
WHERE from_date > '1995-01-01' AND from_date < '1996-01-01';

-- Това е по-добре, защото селектираш само колоните, които ще използваш, което намалява I/O и подобрява ефективността на заявката.

-- Пример 3: Създаване на индекс върху колоната from_date в таблицата titles
-- Индексът върху колоната 'from_date' ще помогне на MySQL да изпълнява заявки, които търсят по дата, много по-бързо.
CREATE INDEX idx_titles_from_date ON titles (from_date);

-- След създаването на индекса, MySQL ще използва този индекс за бързо намиране на записи в даден период, вместо да сканира цялата таблица.

-- Пример 4: Разделяне на големи заявки на по-малки чрез LIMIT и OFFSET
-- Ако имаш голямо количество записи, може да разделиш заявката на по-малки части чрез LIMIT и OFFSET.
-- Това ще намали натоварването на сървъра, особено при заявки, които връщат много редове.
SELECT emp_no, title, from_date, to_date
FROM titles
WHERE from_date > '1995-01-01' AND from_date < '1996-01-01'
LIMIT 1000 OFFSET 0;

SELECT emp_no, title, from_date, to_date
FROM titles
WHERE from_date > '1995-01-01' AND from_date < '1996-01-01'
LIMIT 1000 OFFSET 1000;

-- В този пример, заявката е разделена на две части с по 1000 реда всяка. Това ще намали натоварването и ще подобри производителността.

-- Пример 5: Сортиране преди търсене (ORDER BY)
-- Ако търсиш данни в определен ред, можеш да добавиш сортиране към заявката. Ако съществува индекс върху колоната, ще се използва за по-бързо сортиране.
SELECT emp_no, title, from_date, to_date
FROM titles
WHERE from_date > '1995-01-01' AND from_date < '1996-01-01'
ORDER BY from_date DESC;

-- Важно: Ако има индекс върху 'from_date', MySQL ще използва този индекс за бързо сортиране, което ще ускори изпълнението на заявката.
-- Сортирането на данни трябва да бъде правено внимателно, за да не се натовари излишно сървърът, ако данните са много.

-- Пример 6: Използване на агрегатни функции за оптимизация на заявки
-- Ако искаш да събереш или преброиш неща в таблицата, можеш да използваш агрегатни функции като COUNT, AVG, SUM и др.
SELECT COUNT(*) 
FROM titles 
WHERE from_date > '1995-01-01' AND from_date < '1996-01-01';

-- Това ще изчисли броя на редовете за определен период без да връща всички редове, което е много по-ефективно.

-- Пример 7: Използване на JOIN вместо подзаявки
-- Ако заявката включва подзаявки, можеш да ги замениш с JOIN, което често е по-ефективно.
SELECT e.first_name, e.last_name, t.title
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE t.from_date > '1995-01-01' AND t.from_date < '1996-01-01';

-- JOIN обикновено работи по-добре от подзаявки, особено когато таблиците са индексирани правилно.



-- Стъпка 10: При успешно изпълнение, потвърждаваме транзакцията
COMMIT;

-- Ако възникне грешка, извършваме ROLLBACK, за да отменим промените
-- Например, ако таблиците не могат да бъдат създадени или данните не могат да бъдат импортирани
ROLLBACK;
SHOW INDEXES FROM salaries;

