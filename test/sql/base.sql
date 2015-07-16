\set ECHO 0
BEGIN;
\i sql/pg_complex.sql
\set ECHO all

-- You should write your tests

SELECT pg_complex('test');

ROLLBACK;
