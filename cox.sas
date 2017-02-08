data Rats;
      label Days  ='Days from Exposure to Death';
      input Days Status Group @@;
      datalines;
   143 1 0   164 1 0   188 1 0   188 1 0
   190 1 0   192 1 0   206 1 0   209 1 0
   213 1 0   216 1 0   220 1 0   227 1 0
   230 1 0   234 1 0   246 1 0   265 1 0
   304 1 0   216 0 0   244 0 0   142 1 1
   156 1 1   163 1 1   198 1 1   205 1 1
   232 1 1   232 1 1   233 1 1   233 1 1
   233 1 1   233 1 1   239 1 1   240 1 1
   261 1 1   280 1 1   280 1 1   296 1 1
   296 1 1   323 1 1   204 0 1   344 0 1
   ;
   run;
proc phreg data=Rats;
      model Days*Status(0)=Group;
   run;
proc phreg data=Rats;
      model Days*Status(0)=Group X;
      X=Group*(log(Days) - 5.4);
   run;




data Bladder;
      keep ID TStart TStop Status Trt Number Size Visit;
      retain ID TStart 0;
      array tt T1-T4;
      infile datalines missover;
      input Trt Time Number Size T1-T4;
      ID + 1;
      TStart=0;
      do over tt;
         Visit=_i_;
         if tt = . then do;
            TStop=Time;
            Status=0;
         end;
         else do;
            TStop=tt;
            Status=1;
         end;
         output;
         TStart=TStop;
      end;
      if (TStart < Time) then do;
         TStop= Time;
         Status=0;
         Visit=5;
         output;
      end;
      datalines;
   1       0       1     1
   1       1       1     3
   1       4       2     1
   1       7       1     1
   1       10      5     1
   1       10      4     1   6
   1       14      1     1
   1       18      1     1
   1       18      1     3   5
   1       18      1     1   12  16
   1       23      3     3
   1       23      1     3   10  15
   1       23      1     1   3   16  23
   1       23      3     1   3   9   21
   1       24      2     3   7   10  16  24
   1       25      1     1   3   15  25
   1       26      1     2
   1       26      8     1   1
   1       26      1     4   2   26
   1       28      1     2   25
   1       29      1     4
   1       29      1     2
   1       29      4     1
   1       30      1     6   28  30
   1       30      1     5   2   17  22
   1       30      2     1   3   6   8   12
   1       31      1     3   12  15  24
   1       32      1     2
   1       34      2     1
   1       36      2     1
   1       36      3     1   29
   1       37      1     2
   1       40      4     1   9   17  22  24
   1       40      5     1   16  19  23  29
   1       41      1     2
   1       43      1     1   3
   1       43      2     6   6
   1       44      2     1   3   6   9
   1       45      1     1   9   11  20  26
   1       48      1     1   18
   1       49      1     3
   1       51      3     1   35
   1       53      1     7   17
   1       53      3     1   3   15  46  51
   1       59      1     1
   1       61      3     2   2   15  24  30
   1       64      1     3   5   14  19  27
   1       64      2     3   2   8   12  13
   2       1       1     3
   2       1       1     1
   2       5       8     1   5
   2       9       1     2
   2       10      1     1
   2       13      1     1
   2       14      2     6   3
   2       17      5     3   1   3   5   7
   2       18      5     1
   2       18      1     3   17
   2       19      5     1   2
   2       21      1     1   17  19
   2       22      1     1
   2       25      1     3
   2       25      1     5
   2       25      1     1
   2       26      1     1   6   12  13
   2       27      1     1   6
   2       29      2     1   2
   2       36      8     3   26  35
   2       38      1     1
   2       39      1     1   22  23  27  32
   2       39      6     1   4   16  23  27
   2       40      3     1   24  26  29  40
   2       41      3     2
   2       41      1     1
   2       43      1     1   1   27
   2       44      1     1
   2       44      6     1   2   20  23  27
   2       45      1     2
   2       46      1     4   2
   2       46      1     4
   2       49      3     3
   2       50      1     1
   2       50      4     1   4   24  47
   2       54      3     4
   2       54      2     1   38
   2       59      1     3
   ;

*title 'Andersen-Gill Multiplicative Hazards Model';
   proc phreg data=Bladder;
      model (TStart, TStop) * Status(0) = Trt Number Size;
      where TStart < TStop;
   run;


data Bladder2;
      set Bladder;
      if Visit < 5;
      Trt1= Trt * (Visit=1);
      Trt2= Trt * (Visit=2);
      Trt3= Trt * (Visit=3);
      Trt4= Trt * (Visit=4);
      Number1= Number * (Visit=1);
      Number2= Number * (Visit=2);
      Number3= Number * (Visit=3);
      Number4= Number * (Visit=4);
      Size1= Size * (Visit=1);
      Size2= Size * (Visit=2);
      Size3= Size * (Visit=3);
      Size4= Size * (Visit=4);
   run;
 *title 'Fitting Marginal Proportional Hazards Models';
   proc phreg data=Bladder2 outest=Est1;
      model TStop*Status(0)=Trt1-Trt4 Number1-Number4 Size1-Size4;
      output out=Out1 dfbeta=dt1-dt4 / order=data;
      strata Visit;
      id ID;
   run;


proc means data=Out1 noprint;
      by ID;
      var dt1-dt4;
      output out=Out2 sum=dt1-dt4;
run;








data Myeloma;
      input Time VStatus LogBUN HGB Platelet Age LogWBC Frac
            LogPBM Protein SCalc;
      label Time='Survival Time'
            VStatus='0=Alive 1=Dead';
      datalines;
    1.25  1  2.2175   9.4  1  67  3.6628  1  1.9542  12  10
    1.25  1  1.9395  12.0  1  38  3.9868  1  1.9542  20  18
    2.00  1  1.5185   9.8  1  81  3.8751  1  2.0000   2  15
    2.00  1  1.7482  11.3  0  75  3.8062  1  1.2553   0  12
    2.00  1  1.3010   5.1  0  57  3.7243  1  2.0000   3   9
    3.00  1  1.5441   6.7  1  46  4.4757  0  1.9345  12  10
    5.00  1  2.2355  10.1  1  50  4.9542  1  1.6628   4   9
    5.00  1  1.6812   6.5  1  74  3.7324  0  1.7324   5   9
    6.00  1  1.3617   9.0  1  77  3.5441  0  1.4624   1   8
    6.00  1  2.1139  10.2  0  70  3.5441  1  1.3617   1   8
    6.00  1  1.1139   9.7  1  60  3.5185  1  1.3979   0  10
    6.00  1  1.4150  10.4  1  67  3.9294  1  1.6902   0   8
    7.00  1  1.9777   9.5  1  48  3.3617  1  1.5682   5  10
    7.00  1  1.0414   5.1  0  61  3.7324  1  2.0000   1  10
    7.00  1  1.1761  11.4  1  53  3.7243  1  1.5185   1  13
    9.00  1  1.7243   8.2  1  55  3.7993  1  1.7404   0  12
   11.00  1  1.1139  14.0  1  61  3.8808  1  1.2788   0  10
   11.00  1  1.2304  12.0  1  43  3.7709  1  1.1761   1   9
   11.00  1  1.3010  13.2  1  65  3.7993  1  1.8195   1  10
   11.00  1  1.5682   7.5  1  70  3.8865  0  1.6721   0  12
   11.00  1  1.0792   9.6  1  51  3.5051  1  1.9031   0   9
   13.00  1  0.7782   5.5  0  60  3.5798  1  1.3979   2  10
   14.00  1  1.3979  14.6  1  66  3.7243  1  1.2553   2  10
   15.00  1  1.6021  10.6  1  70  3.6902  1  1.4314   0  11
   16.00  1  1.3424   9.0  1  48  3.9345  1  2.0000   0  10
   16.00  1  1.3222   8.8  1  62  3.6990  1  0.6990  17  10
   17.00  1  1.2304  10.0  1  53  3.8808  1  1.4472   4   9
   17.00  1  1.5911  11.2  1  68  3.4314  0  1.6128   1  10
   18.00  1  1.4472   7.5  1  65  3.5682  0  0.9031   7   8
   19.00  1  1.0792  14.4  1  51  3.9191  1  2.0000   6  15
   19.00  1  1.2553   7.5  0  60  3.7924  1  1.9294   5   9
   24.00  1  1.3010  14.6  1  56  4.0899  1  0.4771   0   9
   25.00  1  1.0000  12.4  1  67  3.8195  1  1.6435   0  10
   26.00  1  1.2304  11.2  1  49  3.6021  1  2.0000  27  11
   32.00  1  1.3222  10.6  1  46  3.6990  1  1.6335   1   9
   35.00  1  1.1139   7.0  0  48  3.6532  1  1.1761   4  10
   37.00  1  1.6021  11.0  1  63  3.9542  0  1.2041   7   9
   41.00  1  1.0000  10.2  1  69  3.4771  1  1.4771   6  10
   41.00  1  1.1461   5.0  1  70  3.5185  1  1.3424   0   9
   51.00  1  1.5682   7.7  0  74  3.4150  1  1.0414   4  13
   52.00  1  1.0000  10.1  1  60  3.8573  1  1.6532   4  10
   54.00  1  1.2553   9.0  1  49  3.7243  1  1.6990   2  10
   58.00  1  1.2041  12.1  1  42  3.6990  1  1.5798  22  10
   66.00  1  1.4472   6.6  1  59  3.7853  1  1.8195   0   9
   67.00  1  1.3222  12.8  1  52  3.6435  1  1.0414   1  10
   88.00  1  1.1761  10.6  1  47  3.5563  0  1.7559  21   9
   89.00  1  1.3222  14.0  1  63  3.6532  1  1.6232   1   9
   92.00  1  1.4314  11.0  1  58  4.0755  1  1.4150   4  11
    4.00  0  1.9542  10.2  1  59  4.0453  0  0.7782  12  10
    4.00  0  1.9243  10.0  1  49  3.9590  0  1.6232   0  13
    7.00  0  1.1139  12.4  1  48  3.7993  1  1.8573   0  10
    7.00  0  1.5315  10.2  1  81  3.5911  0  1.8808   0  11
    8.00  0  1.0792   9.9  1  57  3.8325  1  1.6532   0   8
   12.00  0  1.1461  11.6  1  46  3.6435  0  1.1461   0   7
   11.00  0  1.6128  14.0  1  60  3.7324  1  1.8451   3   9
   12.00  0  1.3979   8.8  1  66  3.8388  1  1.3617   0   9
   13.00  0  1.6628   4.9  0  71  3.6435  0  1.7924   0   9
   16.00  0  1.1461  13.0  1  55  3.8573  0  0.9031   0   9
   19.00  0  1.3222  13.0  1  59  3.7709  1  2.0000   1  10
   19.00  0  1.3222  10.8  1  69  3.8808  1  1.5185   0  10
   28.00  0  1.2304   7.3  1  82  3.7482  1  1.6721   0   9
   41.00  0  1.7559  12.8  1  72  3.7243  1  1.4472   1   9
   53.00  0  1.1139  12.0  1  66  3.6128  1  2.0000   1  11
   57.00  0  1.2553  12.5  1  66  3.9685  0  1.9542   0  11
   77.00  0  1.0792  14.0  1  60  3.6812  0  0.9542   0  12
   ;
proc phreg data=Myeloma;
      model Time*VStatus(0)=LogBUN HGB Platelet Age LogWBC
                            Frac LogPBM Protein SCalc
                            / selection=stepwise slentry=0.25
                              slstay=0.15 details;
   run;








/***********************求95% C.I.***********************************************/
/*連續變項*/
/*控制其他變項下，test自變項與依變項(時間)的關係*/
proc phreg data=HIV_AIDS2;
  model time*status(0)=SEXp RISKG AIDS_SICK areap AGEG GROUP
                      /ties=efron rl;  /*各組95% C.I*/
  baseline out=ci l=l u=u ;  /*每個觀察值95% C.I*/
run;



/*類別變項*/
/*求各組RR的95% 信賴區間*/
proc phreg data=HIV_AIDS1;
  model time*status(0)=sexp AGEG0 AGEG1 AGEG2 RISKG0 RISKG1 RISKG2 
                       AIDS_SICK0 AIDS_SICK1 GROUP0 GROUP1 /ties=efron rl;

ageg0=(ageg=2);
ageg1=(ageg=3);
ageg2=(ageg=4);

RISKG0=(RISKG=2);
RISKG1=(RISKG=3);
RISKG2=(RISKG=4);

AIDS_SICK0=(AIDS_SICK=2);
AIDS_SICK1=(AIDS_SICK=3);

GROUP0=(GROUP=2);
GROUP1=(GROUP=3);

run; 



/************************以Excel 畫 survuval 圖***********************************/
proc phreg data=HIV_AIDS;
  model time*status(0)=SEXp/ties=efron;
  baseline out=s survival=s;/*每個人每個時間點的存活率*/
  where SEXp=1;
run;
PROC EXPORT DATA= WORK.S 
            OUTFILE= "C:\Documents and Settings\a000105\桌面\s.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;

/*再貼至畫survival圖程式.excel：D:\mh\sas指令\SAS指令_記事本
 以圖表精靈/XY散佈圖畫圖*/



/*nELSON-aALEN*/
http://www.ats.ucla.edu/stat/sas/examples/asa/asa2_may_2006.htm


