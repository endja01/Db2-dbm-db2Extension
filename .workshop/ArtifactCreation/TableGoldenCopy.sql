-- **************************************************************
-- *                                                            *
-- * TO BE CREATED IN PROD DB2: D10C                            *
-- *                                                            *
-- **************************************************************
-- THIS IS THE GOLDEN COPY


CREATE DATABASE DEVOPSGC    
        BUFFERPOOL BP1       
        INDEXBP    BP2       
        STOGROUP SYSDEFLT    
        CCSID EBCDIC;  

CREATE  TABLESPACE TS01EX4
        IN DEVOPSGC
        USING STOGROUP SYSDEFLT
           ERASE NO
           FREEPAGE 0
           PCTFREE 5
           MAXPARTITIONS    1
           BUFFERPOOL BP2
           LOCKSIZE ANY
           CLOSE YES
           SEGSIZE 4
           LOCKMAX SYSTEM
           CCSID EBCDIC
    ;

-- **************************************************************
-- *                                                            *
-- * TABLE CREATE AND ALTER STATEMENTS                          *
-- *  to be created as CUST001 - CUST030                        *
-- **************************************************************
-- THIS IS THE GOLDEN COPY


CREATE  TABLE DEVOPSWS.ORDERLINES
        (  
            ORDER        INTEGER      NOT NULL WITH DEFAULT
           ,ORDER_LINE   SMALLINT     NOT NULL WITH DEFAULT
           ,AMOUNT       INTEGER      NOT NULL WITH DEFAULT
        )
        IN DEVOPSGC.TS01EX4
   CCSID         EBCDIC
   ;


-- to get the test data..do something LOCKSIZE
-- unload from DEVOPSWS.ORDERLINES where TESTCASE_ID = $DEMOUSERID
-- load into user created instance of DEVOPSWS.ORDERLINES
