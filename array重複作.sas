/*array*/


data v1; set viag_3;
array x{75} edu marry job Q2_1 Q2_3 Q2_4 Q3_1 Q3_4 Q3_41 Q3_5 Q3_6
            Q4_1-Q4_5 Q5_1 Q5_111-Q5_118 Q5_121-Q5_126 Q6_1-Q6_11
            Q7_1 Q7_11-Q7_19 Q8_10-Q8_19 Q8_110 Q8_21-Q8_26 Q8_261-Q8_263
            Q8_3 Q8_32 Q8_32a;
  do i=1 to 75;
   if x{i}='9' then x{i}=''; 
  end;

drop i;
run;


/*橫變直*/
data ex;
set ex1;
array x{75} x1-x75;
do i=1 to 75;
  test=x{i};
  output;
end;
drop x1-x75;
run;
/*or*/
data ex;
set ex1;
array x{75} x1-x75;
do time=1 to 75;
  test=x{time};
  output;
end;
drop x1-x75;
run;


DATA OPD;
     SET DEP.&DATA1;
     WHERE "&S_DATE"<=YYMM<="&E_DATE";
     LENGTH YY $4 M1 $2 YM $6;
     YY=substr(YYMM,1,4);
     M1=substr(YYMM,5,2);
             IF '01'<=M1<='03' THEN MM='Q1';
        ELSE IF '04'<=M1<='06' THEN MM='Q2';
        ELSE IF '07'<=M1<='09' THEN MM='Q3';
        ELSE IF '10'<=M1<='12' THEN MM='Q4';
    YM=YY||MM;/*歷年每一季*/
DATA DATA2;
     SET DATA1;
     ARRAY X[2] QTY MEDFEE;
     DO I=1 TO 2;
        FEE=X[I];
        T=I;
        KEEP YM T FEE;
        OUTPUT;
     END;

PROC FORMAT;
     VALUE FEE 1='案件數  '/*QTY*/
               2='醫療費用';/*MEDFEE*/
RUN;


***** 計算歷年每一季案件數與醫療費用 *****;
PROC MEANS DATA=DATA2 NOPRINT NWAY;
     CLASS YM T;
     VAR FEE;
     OUTPUT OUT=OPD1 SUM=FEE;
RUN;



/*區分月中、月初、月底三群*/
/*先設矩陣*/
DATA YMD;
     S_YEAR=SUBSTR("199503",1,4);
     E_YEAR=SUBSTR("200312",1,4);
     ARRAY MD[12,3] $5
        ('01JAN'    '15JAN'   '31JAN'
         '01FEB'    '15FEB'   '28FEB'
         '01MAR'    '15MAR'   '31MAR'
         '01APR'    '15APR'   '30APR'
         '01MAY'    '15MAY'   '31MAY'
         '01JUN'    '15JUN'   '30JUN'
         '01JUL'    '15JUL'   '31JUL'
         '01AUG'    '15AUG'   '31AUG'
         '01SEP'    '15SEP'   '30SEP'
         '01OCT'    '15OCT'   '31OCT'
         '01NOV'    '15NOV'   '30NOV'
         '01DEC'    '15DEC'   '31DEC');
		 /*月初*/   /*月中*/  /*月底*/
     DO Y=S_YEAR TO E_YEAR;
        IF Y=E_YEAR THEN E_MOTH=SUBSTR("199503",5,2);
           ELSE E_MOTH='12';
        IF Y=S_YEAR THEN S_MOTH=SUBSTR("200312",5,2);
           ELSE S_MOTH='01';
        DO M=S_MOTH TO E_MOTH;
           LENGTH YEAR $4;
           YEAR=Y;
           S_YM0=MD[M,1]||YEAR;
           M_YM0=MD[M,2]||YEAR;
           E_YM0=MD[M,3]||YEAR;
		   HOSPNO='0000000000';
           S_YYMM=INPUT(PUT(S_YM0,$9.),DATE9.);
           M_YYMM=INPUT(PUT(M_YM0,$9.),DATE9.);
           E_YYMM=INPUT(PUT(E_YM0,$9.),DATE9.);
           KEEP HOSPNO S_YYMM M_YYMM E_YYMM;
		   FORMAT S_YYMM M_YYMM E_YYMM DATE9.;
           OUTPUT;
        END;
     END;
RUN;
/*最終目的：S_YYMM=01JAN、01FEB...
            M_YYMM=15JAN、15FEB...
            E_YYMM=31JAN、28FEB...*/

/*先設3個矩陣，分別為月中、月初、月底*/
DATA PERSON;
     SET YMD(IN=K) DATA1(IN=T);	 
     ARRAY DT[1995:2010,12];
     ARRAY DT_S[1995:2010,12];
	 ARRAY DT_E[1995:2010,12];
     LENGTH S_YEAR $4 E_YEAR $4 S_MOTH $2 E_MOTH $2 YYMM $6 YEAR $4 MOTH $2;
     S_YEAR=SUBSTR("199503",1,4);
     E_YEAR=SUBSTR("200312",1,4);
     RETAIN DT 0 ;
	 RETAIN DT_S 0 ;
	 RETAIN DT_E 0 ;
     IF K=1 THEN DO;/*在矩陣內填入數值(M_YYMM、S_YYMM、E_YYMM)*/
         DT[YEAR(S_YYMM),MONTH(S_YYMM)]=M_YYMM;/*月中*/ 
	     DT_S[YEAR(S_YYMM),MONTH(S_YYMM)]=S_YYMM;/*月初*/ 
		 DT_E[YEAR(S_YYMM),MONTH(S_YYMM)]=E_YYMM;/*月底*/ 
     END;
     IF T=1 THEN DO;
           DO Y=S_YEAR TO E_YEAR;
              IF Y=E_YEAR THEN E_MOTH=SUBSTR("199503",5,2);
                 ELSE E_MOTH='12';
              IF Y=S_YEAR THEN S_MOTH=SUBSTR("200312",5,2);
                 ELSE S_MOTH='01';
              DO M=S_MOTH TO E_MOTH;
                 YEAR=Y;
                 MOTH=M;
                 YYMM=TRANSLATE(YEAR||MOTH,'0',' ');
				 IF TYPE IN ('A','B','C') and S_DATE<=DT[Y,M]<=E_DATE THEN DO;
				    M_FLG='M';/*月中*/
                    KEEP HOSPNO ID TYPE YYMM M_FLG BAU;
					OUTPUT;					
				 END;
                 ELSE IF TYPE IN ('A','B','C') and S_DATE<=DT_S[Y,M]<=E_DATE THEN DO;
				    M_FLG='S';/*月初*/
                    KEEP HOSPNO ID TYPE YYMM M_FLG BAU;
                    OUTPUT;					
				 END;
				 ELSE IF TYPE IN ('A','B','C') and S_DATE<=DT_E[Y,M]<=E_DATE THEN DO;
				    M_FLG='E';/*月底 */
                    KEEP HOSPNO ID TYPE YYMM M_FLG BAU;
                    OUTPUT;					
				 END;
              END;
           END;	   
       END;
	   RUN;





/*另一種array*/
data x;
input id 1 pt29 2 pt30 3 pt31 4 pt32 5 pt33 6 sele1 7 sele2 $8-11;
cards;
1101112pt31
2000101pt32
3011002pt31
4101013pt33
;
run;

data x1; set x;
array x{5} pt29 pt30 pt31 pt32 pt33;
  do i=1 to 5;
  if x{i}=1 then do; y=i;/*若任何一個變項為1，則y就是該變項*/
  end;
  end;
run;
