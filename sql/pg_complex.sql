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

CREATE OR REPLACE FUNCTION pgx_complex_from_int(int) RETURNS complex AS $$
   SELECT ROW($1::float8, 0)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_from_numeric(numeric) RETURNS complex AS $$
   SELECT ROW($1::float8, 0)::complex;
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

CREATE OR REPLACE FUNCTION pgx_complex_add(numeric, complex) RETURNS complex AS $$
   SELECT ROW($1 + $2.re, $2.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_add(complex, numeric) RETURNS complex AS $$
   SELECT ROW($1.re + $2, $1.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_subtract(complex, complex) RETURNS complex AS $$
   SELECT ROW($1.re - $2.re, $1.im - $2.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_subtract(numeric, complex) RETURNS complex AS $$
   SELECT ROW($1 - $2.re, -$2.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_subtract(complex, numeric) RETURNS complex AS $$
   SELECT ROW($1.re - $2, $1.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_multiply(complex, complex) RETURNS complex AS $$
   SELECT ROW($1.re * $2.re - $1.im * $2.im, $1.re * $2.im + $1.im * $2.re)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_multiply(numeric, complex) RETURNS complex AS $$
   SELECT ROW($1 * $2.re, $1 * $2.im)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_multiply(complex, numeric) RETURNS complex AS $$
   SELECT ROW($1.re * $2, $1.im * $2)::complex;
$$ LANGUAGE SQL IMMUTABLE STRICT;

--
-- create functions implemented in C.
--
CREATE OR REPLACE FUNCTION pgx_complex_eq(complex, complex)
RETURNS bool
AS 'pg_complex', 'pgx_complex_eq'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_near(complex, complex)
RETURNS bool
AS 'pg_complex', 'pgx_complex_near'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pgx_complex_divide(complex, complex)
RETURNS complex
AS 'pg_complex', 'pgx_complex_divide'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION magnitude(complex)
RETURNS float8
AS 'pg_complex', 'pgx_complex_magnitude'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION norm(complex)
RETURNS complex
AS 'pg_complex', 'pgx_complex_norm'
LANGUAGE C IMMUTABLE STRICT;

--
-- create casts
--
CREATE CAST (float8 AS complex)
WITH FUNCTION pgx_complex_from_float8(float8)
AS ASSIGNMENT;

CREATE CAST (int AS complex)
WITH FUNCTION pgx_complex_from_int(int)
AS ASSIGNMENT;

CREATE CAST (numeric AS complex)
WITH FUNCTION pgx_complex_from_numeric(numeric)
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

CREATE OPERATOR ~ (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_near
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
   LEFTARG = numeric,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_add
);

CREATE OPERATOR + (
   LEFTARG = complex,
   RIGHTARG = numeric,
   PROCEDURE = pgx_complex_add
);

CREATE OPERATOR - (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_subtract
);

CREATE OPERATOR - (
   LEFTARG = numeric,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_subtract
);

CREATE OPERATOR - (
   LEFTARG = complex,
   RIGHTARG = numeric,
   PROCEDURE = pgx_complex_subtract
);

CREATE OPERATOR * (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_multiply
);

CREATE OPERATOR * (
   LEFTARG = numeric,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_multiply
);

CREATE OPERATOR * (
   LEFTARG = complex,
   RIGHTARG = numeric,
   PROCEDURE = pgx_complex_multiply
);

CREATE OPERATOR / (
   LEFTARG = complex,
   RIGHTARG = complex,
   PROCEDURE = pgx_complex_divide
);
