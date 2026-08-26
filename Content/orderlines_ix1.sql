 CREATE INDEX DBDEV01.ORDERLINES_IX1
        ON DBDEV01.ORDERLINES       
       ("ORDER_ITEM" ASC                 
       )                            
        NOT CLUSTER                 
        DEFINE YES                  
        COMPRESS NO                 
        BUFFERPOOL BP0              
        CLOSE YES                   
        DEFER NO                    
        USING STOGROUP SYSDEFLT     
            PRIQTY -1               
            SECQTY -1               
            ERASE NO                
        FREEPAGE 0                  
        PCTFREE 10                  
        GBPCACHE CHANGED ;          