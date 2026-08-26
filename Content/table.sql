SELECT COLNO
      ,SUBSTR(name,1,15)            AS COLNAME
      ,COLTYPE                      AS COLTYPE
      ,LENGTH                       AS LENGTH
  FROM SYSIBM.SYSCOLUMNS
 WHERE TBCREATOR = 'INT001'
   AND TBNAME    = 'ORDERLINES' 
 ORDER BY COLNO  ;          

 