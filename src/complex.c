#include <math.h>
#include "postgres.h"
#include "fmgr.h"
#include "executor/executor.h"
#include "funcapi.h"
#include "access/htup_details.h"

PG_MODULE_MAGIC;

/*
 * Test complex numbers for proximity. This avoids the problems with testing floats
 * and doubles but does not guarantee absolute equality.
 */
PG_FUNCTION_INFO_V1(pgx_complex_near);

Datum
pgx_complex_near(PG_FUNCTION_ARGS) {
    double re[2];
    double im[2];
    double p, q;
    int i;

    // unwrap values.    
    for (i = 0; i < 2; i++) {
        HeapTupleHeader t = PG_GETARG_HEAPTUPLEHEADER(i);
        bool isnull[2];

        Datum dr = GetAttributeByName(t, "re", &isnull[0]);
        Datum di = GetAttributeByName(t, "im", &isnull[1]);

        // STRICT prevents the 'complex' value from being null but does
        // not prevent its components from being null.        
        if (isnull[0] || isnull[1]) {
            PG_RETURN_NULL();
        }
        
        re[i] = DatumGetFloat8(dr);
        im[i] = DatumGetFloat8(di);
    }

    // compute distance between points, distance of points from origin.
    p = hypot(re[0] - re[1], im[0] - im[1]);
    q = hypot(re[0], im[0]) + hypot(re[1], im[1]);
    
    if (q == 0) {
        PG_RETURN_BOOL(1);
    }
    
    // we consider the points 'near' each other if the distance between them is small
    // relative to the size of them. 
    PG_RETURN_BOOL(p / q < 1e-8); 
}

/*
 * Divide complex number by another. We do this by multiplying nominator and denominator
 * by the conjugate of the denominator. The denominator then becomes the scalar square of
 * the magnitude of the number.
 */
PG_FUNCTION_INFO_V1(pgx_complex_divide);

Datum
pgx_complex_divide(PG_FUNCTION_ARGS) {
    TupleDesc tupdesc;
    HeapTuple tuple;
    double re[2];
    double im[2];
    int i;
    double q;
    Datum datum[2];
    bool isnull[2];
 
    // build a tuple descriptor for our result type 
    if (get_call_result_type(fcinfo, NULL, &tupdesc) != TYPEFUNC_COMPOSITE)
        ereport(ERROR,
                (errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
                 errmsg("function returning record called in context "
                        "that cannot accept type record")));

    // unwrap values.    
    for (i = 0; i < 2; i++) {
        HeapTupleHeader t = PG_GETARG_HEAPTUPLEHEADER(i);
        bool isnull[2];
        Datum dr, di;

        dr = GetAttributeByName(t, "re", &isnull[0]);
        di = GetAttributeByName(t, "im", &isnull[1]);

        // STRICT prevents the 'complex' value from being null but does
        // not prevent its components from being null.        
        if (isnull[0] || isnull[1]) {
            PG_RETURN_NULL();
        }
        
        re[i] = DatumGetFloat8(dr);
        im[i] = DatumGetFloat8(di);
    }

    // the denominator is the square of the magnitude of the divisor.
    q = re[1] * re[1] + im[1] * im[1];
    
    // should I throw error instead of returning null?
    if (q == 0.0) {
        PG_RETURN_NULL();
    }

    datum[0] = Float8GetDatum((re[0] * re[1] + im[0] * im[1]) / q);
    datum[1] = Float8GetDatum((im[0] * re[1] - im[1] * re[0]) / q);

    BlessTupleDesc(tupdesc);
    tuple = heap_form_tuple(tupdesc, datum, isnull);
 
    PG_RETURN_DATUM(HeapTupleGetDatum(tuple));
}

/*
 * Calculate the norm of a complex number. This is the complex number on the unit
 * circle so that magnitude(norm(x)) = 1 and magnitude(x) * norm(x) = x.
 */
PG_FUNCTION_INFO_V1(pgx_complex_norm);

Datum
pgx_complex_norm(PG_FUNCTION_ARGS) {
    HeapTupleHeader t = PG_GETARG_HEAPTUPLEHEADER(0);
    TupleDesc tupdesc;
    HeapTuple tuple;
    double re;
    double im;
    bool isnull[2];
    Datum datum[2];
    double m;
 
    // build a tuple descriptor for our result type 
    if (get_call_result_type(fcinfo, NULL, &tupdesc) != TYPEFUNC_COMPOSITE)
        ereport(ERROR,
                (errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
                 errmsg("function returning record called in context "
                        "that cannot accept type record")));
        
    // unwrap values.    
    datum[0] = GetAttributeByName(t, "re", &isnull[0]);
    datum[1] = GetAttributeByName(t, "im", &isnull[1]);

    // STRICT prevents the 'complex' value from being null but does
    // not prevent its components from being null.        
    if (isnull[0] || isnull[1]) {
        PG_RETURN_NULL();
    }
        
    re = DatumGetFloat8(datum[0]);
    im = DatumGetFloat8(datum[1]);

    m = hypot(re, im);
   
    // should I throw error instead of returning null?
    if (m == 0.0) {
        PG_RETURN_NULL();
    } 

    datum[0] = Float8GetDatum(re / m);
    datum[1] = Float8GetDatum(im / m);

    BlessTupleDesc(tupdesc);
    tuple = heap_form_tuple(tupdesc, datum, isnull);
 
    PG_RETURN_DATUM(HeapTupleGetDatum(tuple));
}

