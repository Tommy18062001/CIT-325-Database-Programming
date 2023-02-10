/* Lab 5 -- Tommy Sylver */

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SPOOL apply_plsql_lab5.txt

ALTER TABLE item ADD rating_agency_id NUMBER;

CREATE SEQUENCE rating_agency_s START WITH 1001;

CREATE TABLE rating_agency AS
SELECT rating_agency_s.NEXTVAL AS rating_agency_id
,      il.item_rating AS rating
,      il.item_rating_agency AS rating_agency
FROM  (SELECT DISTINCT
              i.item_rating
       ,      i.item_rating_agency
       FROM   item i) il;
       
SELECT * FROM rating_agency;

SET NULL ''
COLUMN table_name   FORMAT A18
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

-- create the object
CREATE OR REPLACE
  TYPE agency IS OBJECT(
    rating_agency_id NUMBER,
    rating VARCHAR2(10),
    rating_agency VARCHAR2(4));    
/

-- initiate the collection tab
CREATE OR REPLACE
  TYPE rating_agency_tab IS TABLE OF agency
/

DECLARE
    lv_rating_agency_id NUMBER;
    lv_rating VARCHAR2(10);
    lv_rating_agency VARCHAR2(4);
    -- cursor that will contain everything from the rating agency table
    CURSOR c IS SELECT * FROM rating_agency;

    lv_rating_agency_c rating_agency_tab := rating_agency_tab();

BEGIN
    FOR i IN c LOOP
        lv_rating_agency_c.EXTEND;
        lv_rating_agency_c(lv_rating_agency_c.LAST) := agency(i.rating_agency_id, i.rating, i.rating_agency);
        
        UPDATE item
        SET rating_agency_id = i.rating_agency_id
        WHERE item_rating = i.rating AND item_rating_agency = i.rating_agency;
    END LOOP;
    COMMIT;
    
END;
/

SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;

SPOOL OFF
QUIT;
