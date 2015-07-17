\set ECHO None
BEGIN;
\i sql/complex.sql
\set ECHO all

-- do trigger

ROLLBACK;
