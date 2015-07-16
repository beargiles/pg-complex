/*
 * Author: Bear Giles <bgiles@coyotesong.com>
 * Created at: 2015-07-15 13:50:18 -0600
 */

--
-- create type
--
CREATE TYPE complex AS (re float8, im float8);

--
-- create functions
--
CREATE OR REPLACE FUNCTION float8_as_complex(float8)
RETURNS complex
AS 'pg_complex_from_float8'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_eq(complex, complex)
RETURNS bool
AS 'pg_complex_eq'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_negate(complex)
RETURNS complex
AS 'pg_complex_negate'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_conjugate(complex)
RETURNS complex
AS 'pg_complex_conjugate'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_add(complex, complex)
RETURNS complex
AS 'pg_complex_add_cc'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_subtract(complex, complex)
RETURNS complex
AS 'pg_complex_subtract'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_multiply(complex, complex)
RETURNS complex
AS 'pg_complex_multiply'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_divide(complex, float8)
RETURNS complex
AS 'pg_complex_divide'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_magnitude(complex)
RETURNS float8
AS 'pg_complex_magnitude'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION pg_norm(complex)
RETURNS complex
AS 'pg_complex_norm'
LANGUAGE C IMMUTABLE STRICT;

--
-- create casts
--
CREATE CAST (float8 AS complex)
WITH FUNCTION pg_complex_from_float8(float8)
AS ASSIGNMENT;

--
-- create operators
--
CREATE OPERATOR = (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = pg_complex_eq,
   NEGATOR = <>,
   HASHES,
   MERGES
);

CREATE OPERATOR - (
   RIGHT_ARG = complex,
   PROCEDURE = pg_complex_negate,
   NEGATOR = -
);

CREATE OPERATOR ~ (
   RIGHT_ARG = complex,
   PROCEDURE = pg_complex_conjugate,
   NEGATOR = ~
);

CREATE OPERATOR + (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = pg_complex_add
);

CREATE OPERATOR - (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = pg_complex_subtract
);

CREATE OPERATOR * (
   LEFT_ARG = complex,
   RIGHT_ARG = complex,
   PROCEDURE = pg_complex_multiply
);

CREATE OPERATOR / (
   LEFT_ARG = complex,
   RIGHT_ARG = float8,
   PROCEDURE = pg_complex_divide
);
