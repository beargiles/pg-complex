#include "postgres.h"
#include "fmgr.h"

PG_MODULE_MAGIC;

/*
 * Test complex numbers for equality. Note: this has all of the usual problems with
 * testing floats and doubles for equality. Consider using ~= (near) instead.
 */
PG_FUNCTION_INFO_V1(pgx_complex_eq);

Datum
pgx_complex_eq(PG_FUNCTION_ARGS) {
	PG_RETURN_NULL();
}

/*
 * Test complex numbers for proximity. This avoids the problems with testing floats
 * and doubles but does not guarantee absolute equality.
 */
PG_FUNCTION_INFO_V1(pgx_complex_near);

Datum
pgx_complex_near(PG_FUNCTION_ARGS) {
    PG_RETURN_NULL();
}

/*
 *
 */
PG_FUNCTION_INFO_V1(pgx_complex_divide);

Datum
pgx_complex_divide(PG_FUNCTION_ARGS) {
	PG_RETURN_NULL();
}

/*
 *
 */
PG_FUNCTION_INFO_V1(pgx_complex_magnitude);

Datum
pgx_complex_magnitude(PG_FUNCTION_ARGS) {
	PG_RETURN_NULL();
}

/*
 *
 */
PG_FUNCTION_INFO_V1(pgx_complex_norm);

Datum
pgx_complex_norm(PG_FUNCTION_ARGS) {
	PG_RETURN_NULL();
}

