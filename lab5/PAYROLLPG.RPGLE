                                                                                          
         DCL-F SHIFTWEEK KEYED USAGE(*INPUT) RENAME(SHIFTWEEK:SHIFTWEEKR);                          
         DCL-F SHIFTRATES DISK USAGE(*INPUT) RENAME(SHIFTRATES:SHIFTRATER);                         
                                                                                                    
                                                                                                    
         DCL-F PAYRP PRINTER OFLIND(*IN01);                                                         
         DCL-F PAYSUMMARY WORKSTN;                                                                  
                                                                                                    
         DCL-S HOURSOVER PACKED(3);                                                                 
                                                                                                    
                        READ SHIFTRATES;                                                            
                        WRITE TITLE;                                                                
                        WRITE COLHDG;                                                               
                        READ SHIFTWEEK;                                                             
                                                                                                    
                        DOW NOT %EOF(SHIFTWEEK);                                                    
                        EXSR PAYSR;                                                                 
                        IF *IN01;                                                                   
                        WRITE TITLE;                                                                
                        WRITE COLHDG;                                                               
                        *IN01 = *OFF;                                                               
                        ENDIF;                                                                      
                        WRITE EMPDETAIL;                                                            
                        READ SHIFTWEEK;                                                             
                        ENDDO;                                                                      
                                                                                                    
                        TOTWKPAY = TOTREGPAY + TOTOVTPAY;                                           
                        WRITE TOTALS;                                                               
                        EXFMT RECORD1;                                                              
                        *INLR = *ON;                                                                
                        RETURN;                                                                     
                                                                                                    
       BEGSR PAYSR;                                                                                 
                        SELECT;                                                                     
                        WHEN WORKSHIFT = '1';                                                       
                          HOURLYRATE = DAYHRS;                                                      
                        WHEN WORKSHIFT = '2';                                                       
                          HOURLYRATE = AFTHRS;                                                      
                        WHEN WORKSHIFT = '3';                                                       
                          HOURLYRATE = NIGHTHRS;                                                    
                        ENDSL;                                                                      
                                                                                                    
                        SELECT;                                                                     
                        WHEN PAYCLASS =  1 ;                                                        
                          EVAL(H) HOURLYRATE = HOURLYRATE * 1.094;                                  
                        WHEN PAYCLASS =  2 ;                                                        
                          EVAL(H) HOURLYRATE = HOURLYRATE * 1.062;                                  
                        WHEN PAYCLASS =  3 ;                                                        
                          EVAL(H) HOURLYRATE = HOURLYRATE * 0.957;                                  
                        ENDSL;                                                                      
                                                                                                    
                        HOURSOVER = HRSWORKED - 40;                                                 
                                                                                                    
                        SELECT;                                                                     
                        WHEN HOURSOVER > 0;                                                         
                          EVAL(H) OVERPAY = HOURLYRATE * 1.5 * HOURSOVER;                           
                          EVAL REGULARPAY = 40 * HOURLYRATE;                                        
                 OTHER;                                                                             
                          EVAL REGULARPAY = HRSWORKED * HOURLYRATE;                                 
                          OVERPAY = 0;                                                              
                        ENDSL;                                                                      
                                                                                                    
                        WEEKLYPAY = REGULARPAY + OVERPAY;                                           
                                                                                                    
                        TOTREGPAY = TOTREGPAY + REGULARPAY;                                         
                        TOTOVTPAY = TOTOVTPAY + OVERPAY;                                            
       ENDSR;                                                                                       
                                                                                                    
                                                                                                     