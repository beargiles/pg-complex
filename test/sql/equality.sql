\set ECHO None
BEGIN;
\i sql/pg_complex.sql
\set ECHO all

\set c1 (1,2)::complex
\set c2 (1,1)::complex
\set c3 (3,4)::complex
\set c4 (3,8)::complex

--
-- test equality
--
select pgx_complex_eq(:c1, :c1) as a, pgx_complex_ne(:c1, :c1) as b;
select pgx_complex_eq(:c1, :c2) as a, pgx_complex_ne(:c1, :c2) as b;
select :c1 = :c1 as a, :c1 <> :c1 as b;
select :c1 = :c2 as a, :c1 <> :c2 as b;

--
-- test proximity
--
select pgx_complex_near(:c1, :c1) as a, pgx_complex_near(:c1, :c2) as b;
select :c1 ~= :c1 as a, :c1 ~= :c2 as b;

ROLLBACK;
