SELECT  CURRENT SERVER AS SUBSYSTEM, DBNAME , TSNAME           
        , SUBSTR ( NAME , 1 , 18) AS TBNAME        
        , SUBSTR ( CREATOR , 1 , 8 ) AS CREATOR    
   FROM SYSIBM.SYSTABLES                           
  WHERE CREATOR = 'DEV016'                         
    AND NAME = 'ORDERLINES'                        
  ORDER BY NAME , CREATOR WITH CS          
;
SELECT A.COLNO   
      , A.NAME AS COLNAME                        
      , A.COLTYPE                               
      , A.LENGTH                                
 FROM SYSIBM.SYSCOLUMNS A , SYSIBM.SYSTABLES B  
WHERE ( A.TBCREATOR = B.CREATOR                 
  AND A.TBNAME = B.NAME )                       
  AND A.TBCREATOR = 'DEV016'                    
  AND A.TBNAME = 'ORDERLINES'                   
ORDER BY A.COLNO WITH CS                        
;
SELECT SUBSTR ( NAME , 1 , 18) AS IXNAME        
      , SUBSTR ( CREATOR , 1 , 8 ) AS IXCREATOR  
      , SUBSTR (TBNAME, 1, 18) AS TBNAME
      , COLCOUNT
      , UNIQUERULE 
   FROM SYSIBM.SYSINDEXES                           
  WHERE CREATOR = 'DEV016'                         
    AND NAME = 'ORDERLINES_IX1'                       
  ORDER BY NAME , CREATOR WITH CS  