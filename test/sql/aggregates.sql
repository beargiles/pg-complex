\set ECHO None
BEGIN;
\i sql/complex.sql
\set ECHO all
   
--
-- check aggregates
--
-- FIXME
--

ROLLBACK;
