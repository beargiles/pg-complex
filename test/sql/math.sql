\set ECHO None
BEGIN;
\i sql/pg_complex.sql
\set ECHO all

select 1::complex as a, (1::int8)::complex as b, 1.0::complex as c;

select (1,2)::complex as a, -(1,2)::complex as b, ~(1,2)::complex as c;

select (1,2)::complex + (3,4)::complex as a,
  3 + (1,2)::complex as b, (1,2)::complex + 3 as c;

select (1,2)::complex - (3,6)::complex as a,
  3 - (1,2)::complex as b, (1,2)::complex - 3 as c;

select (1,2)::complex * (3,5)::complex as a,
  3 * (1,2)::complex as b, (1,2)::complex * 3 as c;

select (3,8)::complex / (1,2)::complex as c;

select magnitude((1, 1)::complex) as magnitude;

--
-- check norm.
--
select norm((1,0)::complex) as norm;

select norm((0,1)::complex) as norm;

select norm((-1, 0)::complex) as norm;

select norm((0, -1)::complex) as norm;

select norm((0, 0)::complex) as norm;

select magnitude(norm((1, 1)::complex)) as magnitude;

--
-- test equality
--
select (1,2)::complex = (1,2)::complex as b;

select (1,2)::complex = (2,1)::complex as b;

--
-- test proximity
--
select (1,2)::complex ~ (1,2)::complex as b;

select (1,2)::complex ~ (2,1)::complex as b;

ROLLBACK;
