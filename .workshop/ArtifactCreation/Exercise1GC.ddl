

   SET CURRENT SQLID = USER;


CREATE DATABASE DEVOPSWS    
        BUFFERPOOL BP1       
        INDEXBP    BP2       
        STOGROUP SYSDEFLT    
        CCSID EBCDIC;        

CREATE  TABLESPACE TS02EX2
        IN DEVOPSWS
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

CREATE  TABLE DEVOPSWS.EXERCISE2
        (   SERVER       CHAR(08) NOT NULL WITH DEFAULT
           ,WELCOME_TEXT CHAR(50) NOT NULL WITH DEFAULT
        )
        IN DEVOPSWS.TS02EX2
   CCSID         EBCDIC
   ;

GRANT SELECT ON TABLE DEVOPSWS.EXERCISE2 TO PUBLIC;