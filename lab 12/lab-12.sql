/* Tommy Sylver Lab 12 */

C@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

/*------------------------------------STEP 1 -------------------------------------------*/
-- Create the item_obj object type

CREATE OR REPLACE TYPE item_obj IS OBJECT
( title VARCHAR2(60)
, subtitle VARCHAR2(60)
, rating VARCHAR2(8)
, release_date DATE );
/

DESC item_obj

-- Create the item_tab collection object type
CREATE OR REPLACE TYPE item_tab IS TABLE OF item_obj;
/

DESC item_tab

-- Create a item_list function

CREATE OR REPLACE FUNCTION item_list

    -- Assign TRUNC(SYSDATE) + 1 as the DEFAULT value of the pv_end_date parameter
( pv_start_date DATE
, pv_end_date DATE DEFAULT TRUNC(SYSDATE + 1) ) RETURN item_tab IS

    -- Create an item_rec record type that mirrors the item_obj object type.
    TYPE item_rec IS RECORD
    ( title VARCHAR2(60)
    , subtitle VARCHAR2(60)
    , rating VARCHAR2(8)
    , release_date DATE );
    
    -- Create an item_cur system reference cursor that is weakly typed cursor.
    item_cur SYS_REFCURSOR;
    
    -- Create an item_row variable of the item_rec data type.
    item_row ITEM_REC;
    
    -- Create an item_set variable of the item_tab collection type, and create an empty instance of the item_tab collection.
    item_set ITEM_TAB := item_tab();
    
    stmt  VARCHAR2(2000);

    
BEGIN
    
    stmt := 'SELECT item_title AS title, item_subtitle AS subtitle, item_rating AS rating, item_release_date AS release_date '
         || 'FROM   item '
         || 'WHERE  item_rating_agency = ''MPAA'''
         || 'AND  item_release_date > :start_date AND item_release_date < :end_date';
         
    OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;
    LOOP
        
    LOOP
        FETCH item_cur INTO item_row;
        EXIT WHEN item_cur%NOTFOUND;
        
        item_set.EXTEND;
        item_set(item_set.COUNT) := item_obj
            ( title => item_row.title
            , subtitle => item_row.subtitle
            , rating => item_row.rating
            , release_date => item_row.release_date);
    END LOOP;
    
    RETURN item_set;
END item_list;
/

DESC item_list;


-- test case
COL title   FORMAT A60 HEADING "TITLE"
COL rating  FORMAT A12 HEADING "RATING"
SELECT   il.title
,        il.rating
FROM     TABLE(item_list(pv_start_date => '01-JAN-2000')) il;
/