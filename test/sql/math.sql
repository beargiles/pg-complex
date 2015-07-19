\set ECHO None
BEGIN;
\i sql/complex.sql
\set ECHO all

\set c1 (1,2)::complex
\set c2 (1,1)::complex
\set c3 (3,4)::complex
\set c4 (3,8)::complex

SELECT 1::complex AS a, (1::int8)::complex AS b, 1.0::complex AS c;

SELECT (1,2)::complex AS a, -(1,2)::complex AS b, ~(1,2)::complex AS c;

SELECT :c1 + (3,4)::complex AS a, 3 + :c1 AS b, :c1 + 3 AS c;

SELECT :c1 - (3,6)::complex AS a, 3 - :c1 AS b, :c1 - 3 AS c;

SELECT :c1 * (3,5)::complex AS a, 3 * :c1 AS b, :c1 * 3 AS c;
SELECT :c1 * (3,5)::complex AS a, 3.0::double precision * :c1 AS b, :c1 * 3.0 AS c;

SELECT :c4 / :c1  AS a, (:c4 / :c1) * :c1 = :c4 AS b;
SELECT :c4 / (2,0)::complex AS a, (2,0)::complex * (:c4 / (2,0)::complex)  = :c4 AS b;
SELECT :c4 / (0,2)::complex AS a, (0,2)::complex * (:c4 / (0,2)::complex) = :c4 AS b;
SELECT :c4 / 3 AS a, 3 * (:c4 / 3) = :c4 AS b;
SELECT 3 / :c4 AS a, :c4 * (3 / :c4) = 3::complex AS b;

--
-- check magnitude
--
SELECT magnitude(:c1) AS magnitude;
SELECT magnitude(:c2) AS magnitude;
SELECT magnitude(:c3) AS magnitude;

ROLLBACK;
