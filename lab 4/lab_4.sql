-- lab 4
CREATE OR REPLACE
  TYPE gift IS OBJECT(
    day_name VARCHAR2(8),
    gift_name VARCHAR2(24)
  );
/

DECLARE
    TYPE giftlist IS TABLE OF gift;
    -- initialize the collections of gift list
    lv_gifts GIFTLIST := giftlist(
        gift('and a', 'Partridge in a pear tree'),
        gift('Two','Turtle doves'),
        gift('Three', 'French hens'),
        gift('Four', 'Calling birds'),
        gift('Five', 'Golden rings'),
        gift('Six', 'Geese a laying'),
        gift('Seven', 'Swans a swimming'),
        gift('Eight', 'Maids a milking'),
        gift('Nine', 'Ladies dancing'),
        gift('Ten', 'Lords a leaping'),
        gift('Eleven', 'Pipers piping'),
        gift('Twelve', 'Drummers drumming'));
    
    TYPE numbers IS TABLE OF VARCHAR2(8);
    
    lv_days NUMBERS := numbers('first', 
                        'second',
                        'third',
                        'fourth',
                        'fifth',
                        'sixth',
                        'seventh',
                        'eighth',
                        'ninth',
                        'tenth',
                        'eleventh',
                        'twelfth');

BEGIN
  FOR i IN 1..lv_days.LAST LOOP
    -- add space between each loop
    dbms_output.put_line('');
    
    dbms_output.put_line(lv_days(i)|| ' day of christmas');
    
    dbms_output.put_line('My true love sent to me: ');

    FOR j IN REVERSE 1..i LOOP
    
        IF i = 1 THEN 
            dbms_output.put_line('- A ' || lv_gifts(i).gift_name );
        ELSE 
            dbms_output.put_line('- ' || lv_gifts(j).day_name || ' ' || lv_gifts(i).gift_name);
        END IF;
        
    END LOOP;
    
  END LOOP;
  
END;
/


