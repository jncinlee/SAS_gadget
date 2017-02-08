/* ��C��visit���S���֪��ɭ�, ��transpose��������� */
proc transpose prefix=dat1 data=q out=q1;
  by id;
  var dat1;
run;

proc sort data=iCD_&y. ;by icd ;/*��icd�Ƨ�*/
proc transpose data=iCD_&y. out=icd_&y.t prefix=season;/*��m���ܶ��W��*/
var n;/*����m�ܶ�*/
by icd;/*��icd����*/
id season;/*��season������m*/
run;


/* ��visit����ʮ�, �ΥH�U�{��data����� */
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
