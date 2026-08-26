SELECT DBNAME                     AS DBNAME
      ,TSNAME                     AS TSNAME
      ,SUBSTR(CREATOR,1,8)        AS CREATOR
      ,SUBSTR(NAME,1,18)          AS TBNAME
  FROM SYSIBM.SYSTABLES
 WHERE CREATOR = 'CUSTxxx'
   AND NAME    = 'ORDERLINES' ;

 SELECT COLNO
      ,SUBSTR(name,1,15)            AS COLNAME
      ,COLTYPE                      AS COLTYPE
      ,LENGTH                       AS LENGTH
  FROM SYSIBM.SYSCOLUMNS
 WHERE TBCREATOR = 'CUSTxxx'
   AND TBNAME    = 'ORDERLINES' 
 ORDER BY COLNO  ;          