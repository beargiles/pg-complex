pg_complex
==========

Synopsis
--------

This is a C-language extension that implements a user-defined type (UDT)
for complex numbers.

Description
-----------

This extension defines a new composite type, _complex_, that consists
of two _float8_ values representing the real and imaginary components
of the complex number.


Usage
-----

You can use the type _complex_ as any other type. A value can be initialized
with a single value (intepreted as the real component of the complex
number) or a pair of values (interpreted as the real and imaginary components
of a complex number.)

Several operators and functions have been defined that work with this type.

'-' (negation)
Returns the negation of a complex number.

'~' (complex conjugate)
Returns the complex conjugate of a complex number.

'+' (addition)
Returns the addition of a complex number with another complex number or 
a real number.

'-' (subtraction)
Returns the subtraction of a complex number or a real number from another complex number or real number.

'*' (multiplication)
Returns the product of complex number with another complex number or a 
real number.

'/' (division)
Returns the division of complex number with a real number.

_magnitude_(x)
Returns the magnitude of a complex number. This is identical to the
square root of the product of a complex number with its complex conjugate.

_norm_(x)
Returns the complex number that is normalized to the unit circle. This
means that _x = magnitude(x) * norm(x)_ and _magnitude(norm(x)) = 1_. This
method will return null if x = 0.

_.re_

Returns the real component of the complex number.

_.im_

Returns the imaginary component of the complex number.


Support
-------

The most recent version of this project can be found at 
http://github.com/beargiles/pg_complex.


Author
------

[Bear Giles <bgiles@coyotesong.com>]

Copyright and License
---------------------

Copyright (c) 2015 Bear Giles <bgiles@coyotesong.com>.

