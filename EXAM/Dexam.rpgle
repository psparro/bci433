      DCL-F MORTDSP       Workstn;
      DCL-C Prime 2.45;
 
        EXFMT GetData;   
       // LOOP UNTIL F3 IS PRESSED

       DOW NOT (*IN03);
        

        SELECT;
                     WHEN CREDSCORE > 850;
                       IF RATETYPE = 'F';
                         RATE = PRIME;
                       ELSEIF RATETYPE = 'V';
                         RATE = PRIME;
                       ENDIF;
                     WHEN CREDSCORE >= 751;
                      IF RATETYPE = 'F';
                         RATE = PRIME = 0.25;
                       ELSEIF RATETYPE = 'V';
                         RATE = PRIME = 0.1;
                       ENDIF;
                     WHEN CREDSCORE >= 651;
                       IF RATETYPE = 'F';
                         RATE = PRIME + 0.4;
                       ELSEIF RATETYPE = 'V';
                         RATE = PRIME = 0.2;
                       ENDIF;
                     WHEN CREDSCORE >= 600;
                        IF RATETYPE = 'F';
                         RATE = PRIME + 0.6;
                       ELSEIF RATETYPE = 'V';
                         RATE = PRIME = 0.45;
                       ENDIF;

                       WHEN CREDSCORE < 600;
                        *IN77 = *ON;
                     ENDSL;    




        ENDDO;
       // CHECK ELIGIBILITY FOR MORTGAGE (<600), VALIDATE FIELDS
       // CALCULATE

            INTEREST = MAMOUNT * PERIOD * RATE/100;
       // PROTECT & WRITE FIRST SCREEN, OVERLAY SECOND
       // CLEAR FIELDS
       // END LOOP
       // END PROGRAM 
