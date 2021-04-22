        DCL-F COVIDDSP WORKSTN;
        DCL-F COVIDINFO WORKSTN;

        EXSR CLEAR;
        EXFMT RISKFACTOR;

         DOW NOT(*IN03);
           IF GENDER = ' ';
             *IN95 = *ON;
             EXFMT RISKFACTOR;
             *IN95 = *OFF;
             ITER;
             ELSEIF CVDISEASE = ' ';
               *IN96 = *ON;
               EXFMT RISKFACTOR;
              *IN96 = *OFF;
              ITER;
              ELSEIF DIABETES = ' ';
                *IN97 = *ON;
                EXFMT RISKFACTOR;
                *IN97 = *OFF;
                ITER;
             ELSEIF RSPDISEASE = ' ';
                *IN98 = *ON;
                EXFMT RISKFACTOR;
                *IN98 = *OFF;
                ITER;
               ELSEIF HBPRESSURE = ' ';
                  *IN99 = *ON;
                EXFMT RISKFACTOR;
               *IN99 = *OFF;
                 ITER;
                 ELSE;
                 EXSR DETERMINERISK;
                 TOTALQ = TOTALQ + 1;
                 *IN60 = *ON;
                 WRITE RISKFACTOR;
                  EXFMT RISKASSMNT;

                   IF *IN01;
                       EXFMT CINFO;
                       ENDIF;
                   *IN60 = *OFF;

                    ENDIF;
                    IF *IN03=*OFF;
                       EXSR CLEAR;
                       EXFMT RISKFACTOR;
                       ENDIF;

                        ENDDO;

                         *INLR = *ON;
                          RETURN;

                 BEGSR CLEAR;
                   *IN95 = *OFF;
                   CLEAR GENDER;
                    *IN96 = *OFF;
                    CLEAR CVDISEASE;
                    *IN97 = *OFF;
                    CLEAR DIABETES;
                    *IN98 = *OFF;
                    CLEAR RSPDISEASE;
                    *IN99 = *OFF;
                    CLEAR HBPRESSURE;
                     *IN60 = *OFF;

                 ENDSR;


                 BEGSR DETERMINERISK;

                   AGE = %DIFF(%DATE():BIRTHDATE:*Y);

                   AGE = AGE;

                 SELECT;
                     WHEN AGE >= 80 AND AGE <= 999;
                       FRATE = 14.8;
                     WHEN AGE >= 70;
                       FRATE = 8;
                     WHEN AGE >= 60;
                       FRATE = 3.6;
                     WHEN AGE >= 50;
                       FRATE = 1.3;
                     WHEN AGE >= 40;
                       FRATE = .4;
                     WHEN AGE >= 30;
                       FRATE = .25;
                     WHEN AGE >= 20;
                       FRATE = .23;
                     WHEN AGE >= 10;
                       FRATE = .2;
                     WHEN AGE >= 0;
                       FRATE = .1;

                     ENDSL;

                  SELECT;
                     WHEN CVDISEASE = 'Y';
                       FRATE += .8;
                       ENDSL;
                       SELECT;
                         WHEN DIABETES = 'Y';
                           FRATE += .6;
                       ENDSL;
                       SELECT;
                         WHEN HBPRESSURE = 'Y';
                           FRATE += .3;
                       ENDSL;
                       SELECT;
                         WHEN RSPDISEASE = 'Y';
                           FRATE += .4;
                       ENDSL;
                       SELECT;
                         WHEN GENDER = 'F';
                           FRATE -= .05;
                       ENDSL;

                  FRATE = FRATE;

                  SELECT;
                     WHEN FRATE >= 9.5;
                        COHORT = 'Group 1';
                     WHEN FRATE >= 5.5;
                        COHORT = 'Group 2';
                     WHEN FRATE >= 3.5;
                        COHORT = 'Group 3';
                     WHEN FRATE >= 1.5;
                        COHORT = 'Group 4';
                     WHEN FRATE >= 0.0;
                        COHORT = 'Group 5';
                  ENDSL;

                  COHORT = COHORT;

                 ENDSR;