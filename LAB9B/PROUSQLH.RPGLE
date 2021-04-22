       //**************************************************************************
       //* THIS PROGRAM USES A CURSOR TO LOAD A TEMPORARY RESULT TABLE FROM 3
       //* SEPARATE TABLES, ONTARIO, QUEBEC AND MANITOBA. A NUMBER IS PASSED
       //* TO THE PROGRAM TO DETERMINE WHICH RECORDS ARE INLCUDED FROM THE 3 TABLES
       //**************************************************************************
           DCL-F PROVREPORT PRINTER OFLIND(*IN01) ;
           DCL-S ProvinceH    Char(10);
           DCL-S EndOfFile    IND;
           DCL-S TotalRecords PACKED(5:0) ;

             // LowLimit is passed to the program
           DCL-PI MAIN EXTPGM('PROVSQLH');
             LOWLIMITIN PACKED(15:5);
           END-PI;

             // All Host Variables available under a single name

           DCL-DS CUSTOMERRECORD;
             CUSTID CHAR(6);
             FULLNAME CHAR(31);
             CITY     CHAR(20);
             PURCHASE PACKED(7:2);
             PDATE    DATE;
             PROVINCE CHAR(10);
           END-DS CUSTOMERRECORD;
     C/EJECT
     C**************************************************************************
     C*                        ***   M A I N   R O U T I N E   ***
     C**************************************************************************
      /FREE
                LOWLIMIT = LOWLIMITIN;
                EXSR PrepareFiles;
                Write ReportHdg;
                Write RColumns;
                EXSR GetRow;
                Write NewProv;
                ProvinceH = Province;
                DOW NOT EndOfFile;
                    IF *IN01 = *ON;
                        Write ReportHdg;
                        Write RColumns;
                       *IN01 = *OFF;
                    ENDIF;
                    // Province may change
                    IF PROVINCEH = PROVINCE;
                      WRITE DETAIL;
                    ELSE;
                      PROVINCEH = PROVINCE;
                      WRITE TOTALS;
                      TOTALPURCH = 0;
                      WRITE NEWPROV;
                      WRITE DETAIL;
                    ENDIF;










                    TotalPurch     = TotalPurch     + Purchase;
                    TotalRecords= TotalRecords + 1;
                    EXSR GetRow;
                ENDDO;
                Write Totals;
                EXSR   WRAPUP;
                Write UnderLimit;
                *INLR = *ON;
                RETURN;
        //**********************************************************************
        // O P E N F I L E S   S U B R O U T I N E
        //**********************************************************************
         BEGSR  PrepareFiles;
        // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  STRUCTURE

         EXEC SQL
           DECLARE ALLPROVCURSOR CURSOR
             FOR
               SELECT CUSTID, TRIM (FNAME) || ' ' || LNAME,
                      CITY, PURCHASE, PDATE,
                      'ONTARIO' AS PROVINCE
               FROM BCI433LIB/ONTARIO
               WHERE PURCHASE > :LOWLIMITIN

               UNION ALL
               SELECT CUSTID, TRIM (FNAME) || ' ' || LNAME,
                      CITY, PURCHASE, PDATE,
                      'ONTARIO' AS PROVINCE
               FROM BCI433LIB/ONTARIO
               WHERE PURCHASE > :LOWLIMITIN
               UNION ALL
               SELECT CUSTID, TRIM (FNAME) || ' ' || LNAME,
                      CITY, PURCHASE, PDATE,
                      'ONTARIO' AS PROVINCE
               FROM BCI433LIB/ONTARIO
               WHERE PURCHASE > :LOWLIMITIN
               FOR READ ONLY;

        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D

              EXEC SQL
                OPEN ALLPROVCURSOR;

              IF SQLCODE <> 0 OR SQLWN0 = 'W';
                ENDOFFILE = *ON;
              ENDIF;

            ENDSR;

        //**********************************************************************
        //   G E T     R O W    S U B R O U T I N E
        //**********************************************************************
            BEGSR     GETROW;
              EXEC SQL
                FETCH NEXT
                  FROM ALLPROVCURSOR
                  INTO :CUSTOMERRECORD;

              IF SQLCODE <> 0 OR SQLWN0 = 'W';
                ENDOFFILE = *ON;
              ENDIF;


             ENDSR;
        //**********************************************************************
        // W R A P U P     S U B R O U T I N E
        //**********************************************************************
           BEGSR WRAPUP;
             EXEC SQL
               CLOSE ALLPROVCURSOR;

             IF SQLCODE <> 0 OR SQLWN0 = 'W';
               ENDOFFILE = *ON;
            ENDIF;

            EXEC SQL
              SELECT COUNT(*) INTO :ONTTOTAL
                FROM BCI433LIB/ONTARIO
                WHERE PURCHASE <= :LOWLIMITIN;

              If SQLCODE <> 0 OR SQLWN0 = 'W';
                ONTTOTAL = -999;
             ENDIF;

             EXEC SQL
             SELECT COUNT(*) INTO :QUETOTAL
             From   BCI433LIB/QUEBEC
             Where  PURCHASE <= :LOWLIMITIN;

             If SQLCODE <> 0 OR SQLWN0 = 'W';
                QUETOTAL = -999;
             ENDIF;

        EXEC SQL
             SELECT COUNT(*) INTO :MANTOTAL
             From   BCI433LIB/MANITOBA
             Where  PURCHASE <= :LOWLIMITIN;

             If SQLCODE <> 0 OR SQLWN0 = 'W';
                MANTOTAL = -999;
             ENDIF;

          ENDSR;














 