-- lab 3

CREATE OR REPLACE
  FUNCTION verify_date
  ( pv_date_in  VARCHAR2) RETURN DATE IS
  /* Local return variable. */
  lv_date  DATE;
BEGIN
  /* Check for a DD-MON-RR or DD-MON-YYYY string. */
  IF REGEXP_LIKE(pv_date_in,'^[0-9]{2,2}-[ADFJMNOS][ACEOPU][BCGLNPRTVY]-([0-9]{2,2}|[0-9]{4,4})$') THEN
    /* Case statement checks for 28 or 29, 30, or 31 day month. */
    CASE
      /* Valid 31 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('JAN','MAR','MAY','JUL','AUG','OCT','DEC') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 31 THEN
        lv_date := pv_date_in;
      /* Valid 30 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('APR','JUN','SEP','NOV') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 30 THEN
        lv_date := pv_date_in;
      /* Valid 28 or 29 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) = 'FEB' THEN
        /* Verify 2-digit or 4-digit year. */
        IF (LENGTH(pv_date_in) = 9 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,2)) + 2000,4) = 0 OR
            LENGTH(pv_date_in) = 11 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,4)),4) = 0) AND
            TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 29 THEN
          lv_date := pv_date_in;
        ELSE /* Not a leap year. */
          IF TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 28 THEN
            lv_date := pv_date_in;
          ELSE
            lv_date := NULL;
          END IF;
        END IF;
      ELSE
        /* Assign a default date. */
        lv_date := NULL;
    END CASE;
  ELSE
    /* Assign a default date. */
    lv_date := NULL;
  END IF;
  /* Return date. */
  RETURN lv_date;
END;
/



DECLARE

TYPE list IS TABLE OF VARCHAR2(100);
TYPE three_type IS RECORD
    (xnum NUMBER,
    xdate DATE,
    xstring VARCHAR2(20));
    
info THREE_TYPE;
lv_strings LIST;

BEGIN
 lv_strings := list('&1', '&2', '&3');
 FOR i IN 1..lv_strings.COUNT LOOP
    -- verify what type is the info entered by the user
    IF REGEXP_LIKE(lv_strings(i), '^[[:digit:]]*$') THEN
        info.xnum := TO_NUMBER(lv_strings(i));
    ELSIF REGEXP_LIKE(lv_strings(i), '^[[:alnum:]]*$') THEN 
        info.xstring := lv_strings(i);
    ELSIF verify_date(lv_strings(i)) IS NOT NULL THEN 
        info.xdate := lv_strings(i);
    END IF;
 END LOOP;
 
 -- output
 dbms_output.put_line('Record '||'[' ||info.xnum|| '] [' ||info.xstring|| '] [' ||info.xdate|| ']');

END;
/



