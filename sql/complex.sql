/*
 * Author: Bear Giles <bgiles@coyotesong.com>
 * Created at: 2015-07-15 13:50:18 -0600
 */

--
-- create type
--
CREATE TYPE complex AS (re float8, im float8);

--
-- create functions implemented in SQL.
--
CREATE OR REPLACE FUNCTION pgx_complex_from_int(int) RETURNS complex AS $$
   SELECT ROW($1::float8, 0)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_from_bigint(bigint) RETURNS complex AS $$
   SELECT ROW($1::float8, 0)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_from_numeric(numeric) RETURNS complex AS $$
   SELECT ROW($1::float8, 0)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_from_float8(float8) RETURNS complex AS $$
   SELECT ROW($1, 0)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_eq(complex, complex) RETURNS bool AS $$
   SELECT $1.re = $2.re AND $1.im = $2.im;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_ne(complex, complex) RETURNS bool AS $$
   SELECT $1.re <> $2.re OR $1.im <> $2.im;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_negate(complex) RETURNS complex AS $$
   SELECT ROW(-$1.re, -$1.im)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_conjugate(complex) RETURNS complex AS $$
   SELECT ROW($1.re, -$1.im)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_add(complex, complex) RETURNS complex AS $$
   SELECT ROW($1.re + $2.re, $1.im + $2.im)::complex;
$$ LANGUAGE SQL STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_add_f8(float8, complex) RETURNS complex AS $$
   SELECT ROW($1 + $2.re, $2.im)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_add_f8(complex, float8) RETURNS complex AS $$
   SELECT ROW($1.re + $2, $1.im)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_subtract(complex, complex) RETURNS complex AS $$
   SELECT ROW($1.re - $2.re, $1.im - $2.im)::complex;
$$ LANGUAGE SQL STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_subtract_f8(float8, complex) RETURNS complex AS $$
   SELECT ROW($1 - $2.re, -$2.im)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_subtract_f8(complex, float8) RETURNS complex AS $$
   SELECT ROW($1.re - $2, $1.im)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_multiply(complex, complex) RETURNS complex AS $$
   SELECT ROW($1.re * $2.re - $1.im * $2.im, $1.re * $2.im + $1.im * $2.re)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_multiply_f8(float8, complex) RETURNS complex AS $$
   SELECT ROW($1 * $2.re, $1 * $2.im)::complex;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_multiply_f8(complex, float8) RETURNS complex AS $$
   SELECT pgx_complex_multiply_f8($2, $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION magnitude(complex) RETURNS float8 AS $$
   SELECT sqrt($1.re * $1.re + $1.im * $1.im);
$$ LANGUAGE SQL;

--
-- create functions implemented in C.
--
CREATE OR REPLACE FUNCTION pgx_complex_near(complex, complex)
RETURNS bool
AS 'complex', 'pgx_complex_near'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_not_near(complex, complex) RETURNS bool AS $$
   SELECT NOT pgx_complex_near($1, $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION pgx_complex_divide(complex, complex)
RETURNS complex
AS 'complex', 'pgx_complex_divide'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_divide_f8(complex, float8) RETURNS complex AS $$
   SELECT ROW($1.re/$2, $1.im/$2)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_divide_f8(float8, complex) RETURNS complex AS $$
   SELECT pgx_complex_divide(ROW($1,0)::complex, $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION norm(complex)
RETURNS complex
AS 'complex', 'pgx_complex_norm'
LANGUAGE C IMMUTABLE STRICT;

--
-- create casts
--
CREATE CAST (int AS complex)
WITH FUNCTION pgx_complex_from_int(int)
AS ASSIGNMENT;

CREATE CAST (bigint AS complex)
WITH FUNCTION pgx_complex_from_bigint(bigint)
AS ASSIGNMENT;

CREATE CAST (numeric AS complex)
WITH FUNCTION pgx_complex_from_numeric(numeric)
AS ASSIGNMENT;

CREATE CAST (float8 AS complex)
WITH FUNCTION pgx_complex_from_float8(float8)
AS ASSIGNMENT;

--
-- create operators
--
CREATE OPERATOR = (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_eq,
   NEGATOR = <>,
   HASHES,
   MERGES
);

CREATE OPERATOR <> (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_ne,
   NEGATOR = =,
   HASHES,
   MERGES
);

CREATE OPERATOR ~= (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_near
);

CREATE OPERATOR ~<> (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_not_near
);

CREATE OPERATOR - (
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_negate
);

CREATE OPERATOR ~ (
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_conjugate
);

CREATE OPERATOR + (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_add
);

CREATE OPERATOR + (
   LEFTARG = float8,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_add_f8,
   COMMUTATOR = +
);

CREATE OPERATOR + (
   LEFTARG = complex,
   RIGHTARG = float8,
   PROCEDURE = pgx_complex_add_f8,
   COMMUTATOR = +
);

CREATE OPERATOR - (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_subtract
);

CREATE OPERATOR - (
   LEFTARG = float8,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_subtract_f8
);

CREATE OPERATOR - (
   LEFTARG = complex,
   RIGHTARG = float8,
   PROCEDURE = pgx_complex_subtract_f8
);

CREATE OPERATOR * (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_multiply
);

CREATE OPERATOR * (
   LEFTARG = float8,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_multiply_f8,
   COMMUTATOR = *
);

CREATE OPERATOR * (
   LEFTARG = complex,
   RIGHTARG = float8,
   PROCEDURE = pgx_complex_multiply_f8,
   COMMUTATOR = *
);

CREATE OPERATOR / (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_divide
);

CREATE OPERATOR / (
   LEFTARG = complex,
   RIGHTARG = float8,
   PROCEDURE = pgx_complex_divide_f8
);

CREATE OPERATOR / (
   LEFTARG = float8,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_divide_f8
);

-- -------------------------------------------------------------------------------------------
-- Advanced functions: aggregates
-- -------------------------------------------------------------------------------------------

CREATE TYPE COMPLEX_ACCUM AS (
   cnt  int,
   sum  complex,
   sofs complex
);

--
-- accumulator function is similar to float8_accum. Question: should product be
-- product of p * p or product of p * ~p ?
--
CREATE OR REPLACE FUNCTION pgx_complex_accum(complex_accum, complex) RETURNS complex_accum AS $$
   SELECT CASE WHEN $1 IS NULL THEN 1 ELSE $1.cnt + 1 END,
          CASE WHEN $1 IS NULL THEN $2 ELSE $1.sum + $2 END,
          CASE WHEN $1 IS NULL THEN $2 * ~$2 ELSE $1.sofs + $2 * ~$2 END;
$$ LANGUAGE SQL;

--
-- disaccumulator(?) function is similar to pgx_complex_accum. It is required in order
-- to implement windowing functions.
--
CREATE OR REPLACE FUNCTION pgx_complex_disaccum(complex_accum, complex) RETURNS complex_accum AS $$
   SELECT pgx_complex_accum($1, -$2);
$$ LANGUAGE SQL;

--
-- average function returns quotient of sum over count.
--
CREATE OR REPLACE FUNCTION pgx_complex_avg(complex_accum) RETURNS complex AS $$
   SELECT CASE WHEN $1 IS NULL THEN NULL
               WHEN $1.cnt = 0 THEN (0,0)::complex
               ELSE $1.sum / $1.cnt END;
$$ LANGUAGE SQL;

--
-- create aggregate functions. Moving average aggregates are NOT implemented
-- due to the well-known issues with reversing floating point math. (Add 1 and
-- 1e20, then subtract 1e20. Do you have 0 or 1?)
--
CREATE AGGREGATE sum(complex) (
   SFUNC = pgx_complex_add,
   STYPE = complex,
   INITCOND = '(0, 0)'
   -- MSFUNC = pgx_complex_add,
   -- MINVFUNC = pgx_complex_subtract,
   -- MSTYPE = complex,
   -- MINITCOND = '(0, 0)'
);

CREATE AGGREGATE avg(complex) (
   SFUNC = pgx_complex_accum,
   STYPE = complex_accum,
   -- MSFUNC = pgx_complex_accum,
   -- MINVFUNC = pgx_complex_disaccum,
   -- MSTYPE = complex_accum,
   FINALFUNC = pgx_complex_avg
);