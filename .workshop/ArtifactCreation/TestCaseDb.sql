-- **************************************************************
-- *                                                            *
-- * TO BE CREATED IN DEVELOPMENT DB2. D10A                     *
-- *                                                            *
-- **************************************************************
SET CURRENT SQLID = USER;

CREATE DATABASE DEVOPSTC 
        BUFFERPOOL BP1       
        INDEXBP    BP2       
        STOGROUP SYSDEFLT    
        CCSID EBCDIC;  

CREATE  TABLESPACE TS01EX4
        IN DEVOPSTC
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
-- *                                                            *
-- **************************************************************



CREATE  TABLE DEVOPSWS.TEST_CASES_ORDERLINES
        (   USECASE_ID   CHAR(8)      NOT NULL 
           ,ORDER        INTEGER      NOT NULL WITH DEFAULT
           ,ORDER_LINE   SMALLINT     NOT NULL WITH DEFAULT
           ,AMOUNT       INTEGER      NOT NULL WITH DEFAULT
        )
        IN DEVOPSTC.TS01EX4
   CCSID         EBCDIC
   ;

GRANT SELECT ON TABLE DEVOPSWS.TEST_CASES_ORDERLINES TO PUBLIC
