# MYSQL-big-data-project

A MySQL 8 script (`SCRIPT.sql`, comments in Bulgarian) where I try out ways to speed up queries on large tables: range partitioning, secondary indexes, and checking the effect with the query profiler and `EXPLAIN`.

## What the script does

- Recreates two InnoDB tables in the `employee_management` database, `salaries (emp_no, salary, from_date, to_date)` and `titles (emp_no, title, from_date, to_date)`, both with composite primary keys.
- Partitions both by `RANGE (YEAR(from_date))`, one partition per year from 1990 to 2008 (`p1990` also holds everything older).
- Turns on `SET PROFILING = 1` and uses `SHOW PROFILES` to compare execution times.
- Runs one-year date-range queries. Since each range falls inside a single year, MySQL only has to read one partition, and `EXPLAIN` shows which one.
- Adds indexes on `from_date` in both tables and checks them with `EXPLAIN` and `SHOW INDEXES`.
- Tries different query styles on the same range: `SELECT *` vs. named columns, paging with `LIMIT` / `OFFSET`, `ORDER BY from_date`, `COUNT(*)` instead of returning rows, and a `JOIN` with `employees`.
- Keeps a commented-out query cache experiment, with a note that the query cache no longer exists in MySQL 8.0.

## Running it

1. MySQL 8.0 and a database called `employee_management` with an `employees` table.
2. The column layout matches MySQL's [employees sample database](https://github.com/datacharmer/test_db), so that is the easiest data source. The script drops and recreates `salaries` and `titles`, so load their rows after the `CREATE TABLE` statements and before the queries.
3. Run it step by step (for example in MySQL Workbench) rather than as one batch.

## Notes

- Both `CREATE INDEX` statements appear twice, so a full batch run stops at "Duplicate key name".
- `START TRANSACTION` / `ROLLBACK` don't undo the `DROP` / `CREATE TABLE` statements, because DDL commits implicitly in MySQL.
- There is no `MAXVALUE` partition, so rows with a `from_date` in 2009 or later would be rejected.
