\set ECHO None
BEGIN;
\i sql/complex.sql
\set ECHO all
   
--
-- check aggregates
--
CREATE TABLE t (
   id serial,
   c complex
);

SELECT sum(c), avg(c) FROM t;

INSERT INTO t VALUES (1, (1,3)::complex);

SELECT sum(c), avg(c) FROM t;

INSERT INTO t VALUES (2, (2,5)::complex), (3, (3,7)::complex);

SELECT sum(c), avg(c) FROM t;

-- SELECT sum(c) OVER (ORDER BY id), avg(c) OVER (ORDER BY id) FROM t;

ROLLBACK;
