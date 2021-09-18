
        // DATFMT USED TO ENSURE THAT USA IS THE DEFAULT FOR ALL DATA FIELDS
        Ctl-Opt NoMain DATFMT (*USA);

      // COPY THE PROTOTYPE HERE
      /COPY LAB10,DAYPROTO

       // declare procedure
       Dcl-Proc DayNumName  EXPORT;
         // Declare procedure interface
         Dcl-Pi *N CHAR(9) ;
           Number  Packed(1);
         End-PI;

         DCL-DS DAYDATA;
           *N CHAR(9) INZ('Monday');
           *N CHAR(9) INZ('Tuesday');
           *N CHAR(9) INZ('Wednesday');
           *N CHAR(9) INZ('Thursday');
           *N CHAR(9) INZ('Friday');
           *N CHAR(9) INZ('Saturday');
           *N CHAR(9) INZ('Sunday');

           DAYARRAY CHAR(9) DIM(7) POS(1);
         END-DS;

         RETURN DAYARRAY(NUMBER);

          // Local variable (stand alone field)
      //  DCL-s DayName Char(9);
      //
      //         SELECT;
      //             WHEN NUMBER = 1;
      //             DAYNAME = 'Monday';
      //             WHEN NUMBER = 2;
      //             DAYNAME = 'Tuesday';
      //             WHEN NUMBER = 3;
      //             DAYNAME = 'Wednesday';
      //             WHEN NUMBER = 4;
      //             DAYNAME = 'Thursday';
      //             WHEN NUMBER = 5;
      //             DAYNAME = 'FRIDAY';
      //             WHEN NUMBER = 6;
      //             DAYNAME = 'Saturday';
      //             WHEN NUMBER = 7;
      //             DAYNAME = 'Sunday';
      //             OTHER;
      //             DAYNAME = 'Unknown';
      //         ENDSL;
      //
      //         Return Dayname;
        End-Proc; 