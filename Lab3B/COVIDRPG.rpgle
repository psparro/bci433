        DCL-F CovidDsp  Workstn;
        DCL-F COVIDINFO WORKSTN;

            // The EXSR operation causes the RPG subroutine named in the
            // subroutine-name operand to be processed.
            EXSR CLEAR;

            // EXFMT writes out the prompt to the screen and expects user to
            // enter an option. RiskFactor is a record format name defined in the
            // WORKSTN file and Gender is a field defined in the record.
            EXFMT RiskFactor;

            // If user enters F3 function key, indicator *IN03 is set
            // on and the do while loop is exited.
            DOW NOT(*IN03);

            // Check if gender is blank
            If Gender = ' ';
              // if it is blank we turn on the indicator 95
              *IN95 = *ON;
              // we display the record format again with message on indicator
              EXFMT RISKFACTOR;
              // we turn off the indicator so it will not show message all timr
              *IN95 = *OFF;
              // ITER skips the remaining code and go back to the begning of loop
              // and check the gender again
              ITER;

              // else if check CVDISEASSE for nulls with same logic
              ELSEIF CVDISEASSE = ' ';
                *IN96 = *ON;
                EXFMT RISKFACTOR;
                *IN96 = *OFF;
                ITER;

              // again check DIABETES for nulls with same logic
              elseif DIABETES = ' ';
                *IN97 = *ON;
                EXFMT RISKFACTOR;
                *IN97 = *OFF;
                ITER;

              // check RSPDISEASE for nulls with same logic
              ELSEIF RSPDISEASE = ' ';
                *IN98 = *ON;
                EXFMT RISKFACTOR;
                *IN98 = *OFF;
                ITER;

              // check HBPRESSURE for nulls with same logic
              ELSEIF HBPRESSURE = ' ';
                *IN99 = *ON;
                EXFMT RISKFACTOR;
                *IN99 = *OFF;
                ITER;
            ENDIF;


             // making new subroutine
             EXSR DetermineRisk;
             // we turn on IN60 befor showing first record to protect input out field
             // so that we can not type any thing while showing the output
             *IN60 = *ON;

            // The WRITE operation writes the fields in the data structure(our display file fields)
            WRITE RISKFACTOR;
            // and display the RISKASSMNT record
            EXFMT RISKASSMNT;

            IF *IN01;
              EXFMT CINFO;
            ENDIF;

            // turned off IN60 so we can type there again
            *IN60 = *OFF;

            // if user did not press the F3 key after showing RISKASSMNT record
            // we have to do all again after user press enter
            IF *IN03 = *OFF;
              // we call clear sub-rutine again
              EXSR CLEAR;
              // and reshow RISKFACTOR record
              EXFMT RISKFACTOR;
            ENDIF;
             ENDDO;



              // whenever we end our RPG program we need to do this 2 things
              // we turn on last record indicator
              *INLR = *ON;
              // RETURN control to the operating system
             RETURN;


             // we need to call subroutine after EXSR
             // It goes below return

             // working with CLEAR subroutine
             BEGSR CLEAR;
               // we cleae all fields that we used first time
               GENDER = ' ';
               CVDISEASSE = ' ';
               DIABETES = ' ';
               RSPDISEASE = ' ';
               HBPRESSURE = ' ';
             ENDSR;

             // working with DetermineRisk routine
             BEGSR DetermineRisk;
               Frate = .051;
               Age = %DIFF (%DATE(): BIRTHDATE : *YEARS);
               Cohort = 'Group 4';
               TOTALQ = TOTALQ + 1;
             ENDSR;

            BEGSR AGEFACTOR;
              SELECT;
                WHEN AGE > 79;
                  FRATE = 14.800;
                WHEN AGE > 69;
                  FRATE = 8.000;
                WHEN AGE > 59;
                  FRATE = 3.6;
                WHEN AGE > 49;
                  FRATE = 1.300;
                WHEN AGE > 39;
                  FRATE = 0.400;
                WHEN AGE > 29;
                  FRATE = 0.250;
                WHEN AGE > 19;
                  FRATE = 0.230;
                WHEN AGE > 9;
                  FRATE = 0.200;
                WHEN AGE > 0;
                  FRATE = 0.100;
              ENDSL;
            ENDSR;

 