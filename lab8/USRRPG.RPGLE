         DCL-F USRDSP WORKSTN;

         DCL-F SHIFTRATES DISK(*EXT) USAGE(*INPUT)
           RENAME(SHIFTRATES:SHIFTRATER);
         DCL-F EMPLOYEEP DISK(*EXT)  KEYED USAGE(*UPDATE : *OUTPUT : *DELETE);
         DCL-F WORKWEEKP DISK(*EXT)  KEYED USAGE(*UPDATE : *OUTPUT : *DELETE);

         DCL-S HOURSOVER PACKED(3);
         DCL-S HOURLYRATE PACKED(5:2);
         DCL-S TPAYGRADE CHAR (1);

           EXFMT HEAD;

           READ SHIFTRATER;

           DOW NOT(*IN03);
             READ     EMPLOYEEP;
             READ     WORKWEEKP;

             CHAIN EMPNUMIN WORKWEEKP;
               IF NOT %FOUND;
                 ERRORMSG = 'No matching record found in WORKWEEK';
                 EXFMT HEAD;
                 EMPNUM = 0;
                 ERRORMSG = ' ';
                 ITER;
               ENDIF;

             CHAIN EMPNUMIN EMPLOYEEP;
               IF NOT %FOUND;
                 ERRORMSG = 'No matching record found in EMPLOYEE';
                 EXFMT HEAD;
                 ERRORMSG = ' ';
                 ITER;
               ENDIF;

             PAYGRADEIN = PAYGRADE;
             TPAYGRADE = PAYGRADE;

             SELECT;
               WHEN WORKSHIFT = 'A';
                 SFTTIM = 'AFTERNOONS';
               WHEN WORKSHIFT = 'D';
                 SFTTIM = 'MORNINGS';
               WHEN WORKSHIFT = 'N';
                 SFTTIM = 'NIGHTS';
             ENDSL;

             EXSR PAYSR;
             SFTPAY = REGULARPAY + OVERPAY;

             *IN31 = *ON;
             WRITE HEAD;
             EXFMT BODY;
             *IN31 = *OFF;

             IF *IN06;
               IF PAYGRADEIN = PAYGRADE;
                 YTDPAY = SFTPAY;
                 EXSR UPDREC;

               ELSE;
               PAYGRADE = PAYGRADEIN;
               EXSR PAYSR;
               YTDPAY = REGULARPAY + OVERPAY;
               EXSR UPDREC;
               ENDIF;

             ENDIF;

             IF NOT *IN03;
               EMPNUMIN = 0;
               EXFMT HEAD;
             ENDIF;

             READ     EMPLOYEEP;
             READ     WORKWEEKP;

           ENDDO;

           *INLR = *ON;
           RETURN;

         BEGSR PAYSR;
           SELECT;
             WHEN WORKSHIFT = 'D';
               HOURLYRATE = DAYHRS;
             WHEN WORKSHIFT = 'A';
               HOURLYRATE = AFTHRS;
             WHEN WORKSHIFT = 'N';
               HOURLYRATE = NIGHTHRS;
           ENDSL;

           SELECT;
             WHEN PAYGRADE =  '1' ;
               EVAL(H) HOURLYRATE = HOURLYRATE * 1.094;
             WHEN PAYGRADE =  '2' ;
               EVAL(H) HOURLYRATE = HOURLYRATE * 1.062;
             WHEN PAYGRADE =  '3' ;
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
         ENDSR;

         BEGSR  UPDREC;
           //PAYGRADE = PAYGRADEIN;
           UPDATE    EMPLOYEE;
           DELETE    WORKWEEK1;
         ENDSR; 