/* 當每次visit都沒有少的時候, 用transpose直轉橫比較快 */
proc transpose prefix=dat1 data=q out=q1;
  by id;
  var dat1;
run;

proc sort data=iCD_&y. ;by icd ;/*依icd排序*/
proc transpose data=iCD_&y. out=icd_&y.t prefix=season;/*轉置後變項名稱*/
var n;/*需轉置變項*/
by icd;/*依icd分組*/
id season;/*依season分組轉置*/
run;


/* 當visit有欠缺時, 用以下程式data直轉橫 */
data q1;
set q;
retain date1 date2 date3 date4 date5;

id1=id;

  if id=id1 then do;
        if visit='1' then do;
                date1=dat1;
                date2='        ';
                date3='        ';
                date4='        ';
                date5='        ';
         end;
        if visit='2' then do;
                date2=dat1;
                date3='        ';
                date4='        ';
                date5='        ';
         end;
        if visit='3' then do;
                date3=dat1;
                date4='        ';
                date5='        ';
         end;
        if visit='4' then do;
                date4=dat1;
                date5='        ';
         end;
        if visit='5' then do;
                date5=dat1;
         end;
  output;
  end;
  else do;
      id1=id;
  end;
  keep id date1 date2 date3 date4 date5;
run;
