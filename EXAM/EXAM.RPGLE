       DCL-F INSCSTUPD WORKSTN;
       DCL-F CUSTOMER (*EXT)  KEYED USAGE(*UPDATE : *OUTPUT : *DELETE);
       // CUSTRFMT IS THE RECORD FMT

       DCL-S BRATE PACKED(2:2); 

       EXFMT GETUPDNUM;

       READ CUSTOMER;

       DOW NOT (*IN03);
            READ CUSTOMER;

            CHAIN CUSTNUMIN CUSTOMER;
                IF NOT %FOUND;
                  *IN03 = *ON; // wrong
                  *IN84 = *ON;
                  EXFMT GETUPDNUM;
                  CUSTNUMIN = 0;
                  *IN84 = *OFF;
                  ITER;
                ENDIF;  

            FULLNAME = FNAME + LNAME;
            AGE = %DIFF(%DATE():BIRTHDATE:*Y);

            EXSR DETERMINEGENDER;
             //write
            EXFMT AALOWUPD;

            IF *IN04;
               UPDATE CUSTRFMT; 
            ENDIF;

            IF *IN09;
               DELETE CUSTRFMT; 
            ENDIF;

            
       ENDDO
//INLR
       BEGSR DeterminePremM;
            COVERAMT = COVERAGE * 20000;

            SELECT;
            WHEN AGE >= 75 AND AGE <= 999;
              BRATE = 0;
              COMMENT = 'AGE OUT OF COVERAGE RANGE';
            WHEN AGE >= 60 AND SMOKER = 'N';
              BRATE = 38.06;
            WHEN AGE >= 60 AND SMOKER = 'Y';
              BRATE = 50.73;
            WHEN AGE >= 45 AND SMOKER = 'N';
              BRATE = 26.58;
              WHEN AGE >= 45 AND SMOKER = 'Y';
              BRATE = 32.72;
            WHEN AGE >= 30 AND SMOKER = 'N';
              BRATE = 15.20;
             WHEN AGE >= 30 AND SMOKER = 'Y';
              BRATE = 21.19;
            WHEN AGE >= 18 AND SMOKER = 'N';
              BRATE = 7.83;
            WHEN AGE >= 18 AND SMOKER = 'Y';
              BRATE = 5.53;
            WHEN AGE >= 0;
              BRATE = 0;
              COMMENT = 'AGE OUT OF COVERAGE RANGE';
          ENDSL;

          MPREMIUM = BRATE * COVERAMT;

       ENDSR;

       BEGSR DETERMINEGENDER;
            SELECT;
            WHEN GENDER = 'M';
                EXSR DeterminePremM;

            WHEN GENDER = 'F';
                EXSR DeterminePremF;
            //ENDSL;
       ENDSR;