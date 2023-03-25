/* Tommy Sylver Lab 10 */


/*------------------------------------STEP 1 -------------------------------------------*/
CREATE OR REPLACE TYPE base_t IS OBJECT
( oname VARCHAR2(30)
, name VARCHAR2(30)
, CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT
, CONSTRUCTOR FUNCTION base_t
  ( oname VARCHAR2
  , name VARCHAR2) RETURN SELF AS RESULT
, MEMBER FUNCTION get_name RETURN VARCHAR2
, MEMBER FUNCTION get_oname RETURN VARCHAR2
, MEMBER PROCEDURE set_oname
  ( oname VARCHAR2)
, MEMBER FUNCTION to_string RETURN VARCHAR2)
INSTANTIABLE NOT FINAL;
/

DESC base_t

CREATE TABLE logger
( logger_id NUMBER
, log_text BASE_T);

CREATE SEQUENCE logger_s;

DESC logger

-- Implement the object_t body
CREATE OR REPLACE TYPE BODY base_t IS
    CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
    BEGIN
        self.oname := 'BASE_T';
        RETURN;
    END;
    
    CONSTRUCTOR FUNCTION base_t
    ( oname VARCHAR2
    , name VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        self.oname := oname;
        IF name IS NOT NULL AND name IN ('NEW', 'OLD') THEN
            self.name := name;
        END IF;
        RETURN;
    END;
    
    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
        RETURN self.name;
    END get_name;
    
    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
    BEGIN
        RETURN self.oname;
    END get_oname;
    
    MEMBER PROCEDURE set_oname ( oname VARCHAR2) IS
    BEGIN
        self.oname := oname;
    END set_oname;
    
    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
        RETURN '['||self.oname||']';
    END to_string;
END;

-- TEST CASE 
DECLARE
  /* Create a default instance of the object type. */
  lv_instance  BASE_T := base_t();
BEGIN
  /* Print the default value of the oname attribute. */
  dbms_output.put_line('Default  : ['||lv_instance.get_oname()||']');

  /* Set the oname value to a new value. */
  lv_instance.set_oname('SUBSTITUTE');

  /* Print the default value of the oname attribute. */
  dbms_output.put_line('Override : ['||lv_instance.get_oname()||']');
END;
/

-- insert a base_t object instance with the default no parameter constructor
INSERT INTO logger
VALUES (logger_s.NEXTVAL, base_t());

-- insert a base_t object instance with the a parameter-driven constructor
DECLARE
  /* Declare a variable of the UDT type. */
  lv_base  BASE_T;
BEGIN
  /* Assign an instance of the variable. */
  lv_base := base_t(
      oname => 'BASE_T'
    , name => 'NEW' );

    /* Insert instance of the base_t object type into table. */
    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_base);

    /* Commit the record. */
    COMMIT;
END;
/

COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      NVL(t.log.get_name(),'Unset') AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname = 'BASE_T';


/*------------------------------------STEP 2 -------------------------------------------*/

-- create the item_t subtype of base_t
CREATE OR REPLACE TYPE item_t UNDER base_t
( item_id NUMBER
, item_barcode VARCHAR2(20)
, item_type NUMBER
, item_title VARCHAR2(60)
, item_subtitle VARCHAR2(60)
, item_rating VARCHAR2(8)
, item_rating_agency VARCHAR2(4)
, item_release_date DATE
, created_by NUMBER
, creation_date DATE
, last_updated_by NUMBER
, last_update_date DATE
, CONSTRUCTOR FUNCTION item_t
  ( oname VARCHAR2
  , name VARCHAR2
  , item_id NUMBER
  , item_barcode VARCHAR2
  , item_type NUMBER
  , item_title VARCHAR2
  , item_subtitle VARCHAR2
  , item_rating VARCHAR2
  , item_rating_agency VARCHAR2
  , item_release_date DATE
  , created_by NUMBER
  , creation_date DATE
  , last_updated_by NUMBER
  , last_update_date DATE) RETURN SELF AS RESULT
, OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
INSTANTIABLE NOT FINAL;
/

DESC item_t

-- implement item_t body
CREATE OR REPLACE TYPE BODY item_t IS
    CONSTRUCTOR FUNCTION item_t
    ( oname VARCHAR2
    , name VARCHAR2
    , item_id NUMBER
    , item_barcode VARCHAR2
    , item_type NUMBER
    , item_title VARCHAR2
    , item_subtitle VARCHAR2
    , item_rating VARCHAR2
    , item_rating_agency VARCHAR2
    , item_release_date DATE
    , created_by NUMBER
    , creation_date DATE
    , last_updated_by NUMBER
    , last_update_date DATE) RETURN SELF AS RESULT IS
--        CURSOR c IS
--        SELECT *
--        FROM item;
    BEGIN
        self.oname := oname;
        IF name IS NOT NULL AND name IN ('NEW', 'OLD') THEN
            self.name := name;
        END IF;
        
--        FOR i in c LOOP
            self.item_id := item_id;
            self.item_barcode := item_barcode;
            self.item_type := item_type;
            self.item_title := item_title;
            self.item_subtitle := item_subtitle;
            self.item_rating := item_rating;
            self.item_rating_agency := item_rating_agency;
            self.item_release_date := item_release_date;
            self.created_by := created_by;
            self.creation_date := creation_date;
            self.last_updated_by := last_updated_by;
            self.last_update_date := last_update_date;
--        END LOOP;
        
        RETURN;
    END;
    
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
        RETURN (self AS base_t).get_name();
    END get_name;
    
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
        RETURN (self AS base_t).to_string()||'.['||self.name||']';
    END to_string;
END;
/

-- Create contact_t a subtype of base_t
CREATE OR REPLACE TYPE contact_t UNDER base_t
( contact_id NUMBER
, member_id NUMBER
, contact_type NUMBER
, first_name VARCHAR2(60)
, middle_name VARCHAR2(60)
, last_name VARCHAR2(60)
, created_by NUMBER
, creation_date DATE
, last_updated_by NUMBER
, last_update_date DATE
, CONSTRUCTOR FUNCTION contact_t
  ( oname VARCHAR2
  , name VARCHAR2
  , contact_id NUMBER
  , member_id NUMBER
  , contact_type NUMBER
  , first_name VARCHAR2
  , middle_name VARCHAR2
  , last_name VARCHAR2
  , created_by NUMBER
  , creation_date DATE
  , last_updated_by NUMBER
  , last_update_date DATE) RETURN SELF AS RESULT
, OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
, OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
INSTANTIABLE NOT FINAL;
/

DESC contact_t;

-- Implementing a contact_t object body
CREATE OR REPLACE TYPE BODY contact_t IS
    CONSTRUCTOR FUNCTION contact_t
    ( oname VARCHAR2
    , name VARCHAR2
    , contact_id NUMBER
    , member_id NUMBER
    , contact_type NUMBER
    , first_name VARCHAR2
    , middle_name VARCHAR2
    , last_name VARCHAR2
    , created_by NUMBER
    , creation_date DATE
    , last_updated_by NUMBER
    , last_update_date DATE) RETURN SELF AS RESULT IS
--        CURSOR c IS
--        SELECT *
--        FROM contact;
    BEGIN
        self.oname := oname;
        IF name IS NOT NULL AND name IN ('NEW', 'OLD') THEN
            self.name := name;
        END IF;
        
--        FOR i in c LOOP
            self.contact_id := contact_id;
            self.member_id := member_id;
            self.contact_type := contact_type;
            self.first_name := first_name;
            self.middle_name := middle_name;
            self.last_name := last_name;
            self.created_by := created_by;
            self.creation_date := creation_date;
            self.last_updated_by := last_updated_by;
            self.last_update_date := last_update_date;
--        END LOOP;
        
        RETURN;
    END;
    
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
        RETURN (self AS base_t).get_name();
    END get_name;
    
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
        RETURN (self AS base_t).to_string()||'.['||self.name||']';
    END to_string;
END;
/

-- insert a row into the logger table with a item_t object instance 
INSERT INTO logger
VALUES
( logger_s.NEXTVAL
, item_t
  ( oname => 'ITEM_T'
  , name => 'NEW'
  , item_id => 1000
  , item_barcode => '9736-05349-6'
  , item_type => 1018
  , item_title => 'Miss Peregrines''s Home for Peculiar Children'
  , item_subtitle => ''
  , item_rating => 'T'
  , item_rating_agency => 'MPAA'
  , item_release_date => '7-JUN-2011'
  , created_by => 1001
  , creation_date => SYSDATE
  , last_updated_by => 1001
  , last_update_date => SYSDATE));
  
-- insert a row into the logger table with contact_t object instance.
INSERT INTO logger
VALUES
( logger_s.NEXTVAL
, contact_t
  ( oname => 'CONTACT_T'
  , name => 'NEW'
  , contact_id => 1000
  , member_id => 1000
  , contact_type => 1003
  , first_name => 'Anastasia'
  , middle_name => 'D'
  , last_name => 'Yazvins'
  , created_by => 1001
  , creation_date => SYSDATE
  , last_updated_by => 1001
  , last_update_date => SYSDATE));
  
-- TEST CASE
COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      t.log.get_name() AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname IN ('CONTACT_T','ITEM_T');

