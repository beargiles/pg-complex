-- drop operators
DROP OPERATOR IF EXISTS = (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS <> (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS ~= (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS ~<> (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS - (NONE, complex) CASCADE;
DROP OPERATOR IF EXISTS ~ (NONE, complex) CASCADE;
DROP OPERATOR IF EXISTS + (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS + (complex, float8) CASCADE;
DROP OPERATOR IF EXISTS + (float8, complex) CASCADE;
DROP OPERATOR IF EXISTS - (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS - (complex, float8) CASCADE;
DROP OPERATOR IF EXISTS - (float8, complex) CASCADE;
DROP OPERATOR IF EXISTS * (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS * (complex, float8) CASCADE;
DROP OPERATOR IF EXISTS * (float8, complex) CASCADE;
DROP OPERATOR IF EXISTS / (complex, complex) CASCADE;

-- drop casts
DROP CAST IF EXISTS (int AS complex) CASCADE;
DROP CAST IF EXISTS (bigint AS complex) CASCADE;
DROP CAST IF EXISTS (numeric AS complex) CASCADE;
DROP CAST IF EXISTS (float8 AS complex) CASCADE;

DROP FUNCTION pgx_complex_from_int(int) CASCADE;
DROP FUNCTION pgx_complex_from_int(bigint) CASCADE;
DROP FUNCTION pgx_complex_from_int(numeric) CASCADE;
DROP FUNCTION pgx_complex_from_int(float8) CASCADE;

-- drop functions
DROP FUNCTION pgx_complex_eq(complex, complex) CASCADE;
DROP FUNCTION pgx_complex_ne(complex, complex) CASCADE;
DROP FUNCTION pgx_complex_near(complex, complex) CASCADE;
DROP FUNCTION pgx_complex_not_near(complex, complex) CASCADE;
DROP FUNCTION pgx_complex_negate(complex) CASCADE;
DROP FUNCTION pgx_complex_conjugate(complex) CASCADE;
DROP FUNCTION pgx_complex_add(complex, complex) CASCADE;
DROP FUNCTION pgx_complex_add_f8(complex, float8) CASCADE;
DROP FUNCTION pgx_complex_add_f8(float8, complex) CASCADE;
DROP FUNCTION pgx_complex_subtract(complex, complex) CASCADE;
DROP FUNCTION pgx_complex_subtract_f8(complex, float8) CASCADE;
DROP FUNCTION pgx_complex_subtract_f8(float8, complex) CASCADE;
DROP FUNCTION pgx_complex_multiply(complex, complex) CASCADE;
DROP FUNCTION pgx_complex_multiply_f8(complex, float8) CASCADE;
DROP FUNCTION pgx_complex_multiply_f8(float8, complex) CASCADE;
DROP FUNCTION pgx_complex_divide(complex, complex) CASCADE;
DROP FUNCTION pgx_complex_divide_f8(complex, float8) CASCADE;
DROP FUNCTION pgx_complex_divide_f8(float8, complex) CASCADE;
DROP FUNCTION magnitude(complex) CASCADE;
DROP FUNCTION norm CASCADE;

-- drop type
DROP TYPE IF EXISTS complex CASCADE;
