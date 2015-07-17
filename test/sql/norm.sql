\set ECHO None
BEGIN;
\i sql/complex.sql
\set ECHO all

--
-- check norm.
--
\set r1 (2,0)::complex
\set r2 (0,2)::complex
\set r3 (-2,0)::complex
\set r4 (0,-2)::complex

select norm(:r1) as a, norm(:r2) as b, norm(:r3) as c, norm(:r4) as d;

select :r1 = magnitude(:r1)::float8 * norm(:r1) as a,
    :r2 = magnitude(:r2)::float8 * norm(:r2) as b,
    :r3 = magnitude(:r3)::float8 * norm(:r3) as c,
    :r4 = magnitude(:r4)::float8 * norm(:r4) as d;

ROLLBACK;
