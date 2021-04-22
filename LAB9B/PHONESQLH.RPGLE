         // **************************************************************************
        //  CUSTOMER20 READ BY NATIVE LANGUAGE (ILE RPG)
        //  CONTACTS20 ROW RETRIEVED WITH EMBEDDED SQL
        //  DETAIL REPORT LINE INCLUDES INFORMATION FROM CUSTOMER20 AND CONTACTS20
        //  SUMMARRY REPORT INFORMATION RETRIEVED WITH EMBEDDED SQL STATEMENTS

           DCL-F PHNREPORT PRINTER OFLIND(*IN01) ;
           DCL-F CUSTOMER20 DISK(*EXT) KEYED USAGE(*INPUT)
                 RENAME(CUSTOMER20:CUSTR);
                      // data structure for host variables from CONTACTS20

                     // Standalone fields for indicator variables



           DCL-S Dummy  Zoned(1);

        //**************************************************************************
        //*                        ***   M A I N   R O U T I N E   ***
        //**************************************************************************

                EXSR SummaryInfo;
                WRITE NEWPAGE;
                READ CUSTOMER20;
                DOW NOT %EOF;
                    EXSR SQLSelect;
                    IF *IN01 = *ON;
                       Write NEWPAGE;
                       *IN01 = *OFF;
                    ENDIF;
                    Write RPTLINE;
                   READ CUSTOMER20;
                ENDDO;
                Write SUMMARY;
                *INLR = *ON;
                RETURN;
        //**********************************************************************
        //   S Q L S E L E C T   S U B R O U T I N E
   //   //********************************************************************
   //                  BEGSR    SQLSelect ;
   //    // A row from the contacts table that has the same customer number as t
   //    // read from the CUSTOMER20 file is retrieved to find out the last date
   //    // phone number, comments and the salesperson number.
   //
   //    //  The call back interval is added to the last date called to determin
   //    //  next date to call.  Since null values may be stored in the last dat
   //    // indicator variables are used.





















                         ENDSR ;
        //**********************************************************************
        // S U M M A R Y I N F O   S U B R O U T I N E
        //**********************************************************************
                         BEGSR  SummaryInfo;
        //  D E T E R M I N E   T O T A L S   F O R   CONTACTS20 & CUSTOMER20















        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED










        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T



















       // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A






                         ENDSR; 