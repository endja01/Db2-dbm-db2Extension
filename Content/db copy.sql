SELECT  CURRENT SERVER AS SUBSYSTEM, DBNAME , TSNAME           
        , SUBSTR ( NAME , 1 , 18) AS TBNAME        
        , SUBSTR ( CREATOR , 1 , 8 ) AS CREATOR    
   FROM SYSIBM.SYSTABLES                           
  WHERE CREATOR = 'INT001'                         
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
  AND A.TBCREATOR = 'INT001'                    
  AND A.TBNAME = 'ORDERLINES'                   
ORDER BY A.COLNO WITH CS                        
;