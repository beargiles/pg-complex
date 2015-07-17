\set ECHO None
BEGIN;
\i sql/pg_complex.sql
\set ECHO all
   
--
-- check aggregates
--
-- FIXME
--

ROLLBACK;
