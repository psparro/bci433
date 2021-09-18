          DCL-f DayDsp Workstn;
          Dcl-PI  Main  extPgm('DAYSRPG');
             Solution   char(15);
         End-PI;
      // COPY THE PROTOTYPE HERE
      // LAB10 IS A SOURCE FILE NAME AND DAYPROTO IS THE MAMBER NAME
      /COPY LAB10,DAYPROTO

           EXFMT INPUT;
           DOW NOT(*IN03);
             // *DAYIN COMES FROM WORKSTATION FILE*
              DayName = DayNumName(DayIn);
              *in99 = *on;
               WRITE INPUT;
               EXFMT OUTPUT;
              *in99 = *off;
               IF *IN03 = '0';
                 DayIn = 0;
                 EXFMT INPUT ;
               ENDIF;
            ENDDO;
            *INLR = *ON;
            RETURN;

 