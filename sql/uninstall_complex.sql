-- drop operators
DROP OPERATOR IF EXISTS = (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS - (NONE, complex) CASCADE;
DROP OPERATOR IF EXISTS ~ (NONE, complex) CASCADE;
DROP OPERATOR IF EXISTS + (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS - (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS * (complex, complex) CASCADE;
DROP OPERATOR IF EXISTS / (complex, float) CASCADE;

-- drop casts
DROP CAST IF EXISTS (float8 AS complex) CASCADE;

-- drop functions
DROP FUNCTION IF EXISTS pg_complex_eq(complex, complex) CASCADE;
DROP FUNCTION IF EXISTS pg_complex_negate(complex) CASCADE;
DROP FUNCTION IF EXISTS pg_complex_conjugate(complex) CASCADE;
DROP FUNCTION IF EXISTS pg_complex_add(complex, complex) CASCADE;
DROP FUNCTION IF EXISTS pg_complex_subtract(complex, complex) CASCADE;
DROP FUNCTION IF EXISTS pg_complex_multiply(complex, complex) CASCADE;
DROP FUNCTION IF EXISTS pg_complex_divide(complex, float8) CASCADE;
DROP FUNCTION IF EXISTS pg_complex_magnitude(complex) CASCADE;
DROP FUNCTION IF EXISTS pg_complex_norm(complex) CASCADE;

-- drop type
DROP TYPE IF EXISTS complex CASCADE;
