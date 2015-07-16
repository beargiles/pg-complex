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
CREATE OR REPLACE FUNCTION pgx_complex_from_float8(float8) RETURNS complex AS $$
   SELECT ROW($1, 0)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_negate(complex) RETURNS complex AS $$
   SELECT ROW(-$1.re, -$1.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_conjugate(complex) RETURNS complex AS $$
   SELECT ROW($1.re, -$1.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_add(complex, complex) RETURNS complex AS $$
   SELECT ROW($1.re + $2.re, $1.im + $2.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_sub(complex, complex) RETURNS complex AS $$
   SELECT ROW($1.re - $2.re, $1.im - $2.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_multiply(complex, complex) RETURNS complex AS $$
   SELECT ROW($1.re * $2.re - $1.im * $2.im, $1.re * $2.im + $1.im * $2.re)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

--
-- create functions implemented in C.
--
CREATE OR REPLACE FUNCTION eq(complex, complex)
RETURNS bool
AS 'pgx_complex_eq'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION near(complex, complex)
RETURNS bool
AS 'pgx_complex_near'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION divide(complex, complex)
RETURNS complex
AS 'pgx_complex_divide'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION magnitude(complex)
RETURNS float8
AS 'pgx_complex_magnitude'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION norm(complex)
RETURNS complex
AS 'pgx_complex_norm'
LANGUAGE C IMMUTABLE STRICT;

--
-- create casts
--
CREATE CAST (float8 AS complex)
WITH FUNCTION from_float8(float8)
AS ASSIGNMENT;

--
-- create operators
--
CREATE OPERATOR = (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = eq,
   NEGATOR = <>,
   HASHES,
   MERGES
);

CREATE OPERATOR ~ (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = near
);

CREATE OPERATOR - (
   RIGHT_ARG = complex,
   PROCEDURE = pgx_complex_negate,
   NEGATOR = -
);

CREATE OPERATOR ~ (
   RIGHT_ARG = complex,
   PROCEDURE = pgx_complex_conjugate,
   NEGATOR = ~
);

CREATE OPERATOR + (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = pgx_complex_add
);

CREATE OPERATOR - (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = pgx_complex_subtract
);

CREATE OPERATOR * (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = pgx_complex_multiply
);

CREATE OPERATOR / (
   LEFT_ARG = complex,
   RIGHT_ARG = float8,
   PROCEDURE = divide
);
