option nocenter;

PROC IMPORT OUT= WORK.a
            DATAFILE= "C:\Documents and Settings\taipei.dbf" 
            DBMS=DBF REPLACE;
     GETDELETED=NO;
RUN;



/*
1.area地區代碼改成ano2
2.家中養10隻(含)以上的狗者,
   地區代碼改成13 (不分區)*/
data aa;
set a;
ano2=area;
if d>=10 then ano2='13';
run;

/*
地區分組分為高低都市化區域
支持不支持歸類二分*/
data a1;
set aa;
if ano2 in('08','09','10','11','12') then m='1';
if ano2 in('01','02','03','04','05','06','07') then m='2';
if q9 in('1','2') then q9_1='1';
if q9 in('4','5') then q9_1='2';
if q9 in('3') then q9_1='';
run;



/**********************/
/*反過來流浪狗vs高低都*/
/**********************/

/*低都市化*/
proc SQL noprint;
create table b1 as 
select q5 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q5;
quit;
/*高都市化*/
proc SQL noprint;
create table b2 as 
select q5 as vv1,count(m) as ma,'2' as civilization
from a1
where m contains '2'
group by q5;
quit;

data c1;
set b1 b2;
run;

data d;
set c1;
if vv1='9' then delete;
run;

proc freq data=d;
tables vv1*civilization/chisq;
weight ma;
title '高低都vs流浪狗';
run;

/**********************/
/*反過來流浪貓vs高低都*/
/**********************/

/*低都市化*/
proc SQL noprint;
create table b1 as 
select q6 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q6;
quit;
/*高都市化*/
proc SQL noprint;
create table b2 as 
select q6 as vv1,count(m) as ma,'2' as civilization
from a1
where m contains '2'
group by q6;
quit;

data c1;
set b1 b2;
run;

data d;
set c1;
if vv1='9' then delete;
run;

proc freq data=d;
tables vv1*civilization/chisq;
weight ma;
title '高低都vs流浪貓';
run;

/**********************/
/*反過來養狗vs高低都*/
/**********************/

/*低都市化*/
proc SQL noprint;
create table b1 as 
select q2 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q2;
quit;
/*高都市化*/
proc SQL noprint;
create table b2 as 
select q2 as vv1,count(m) as ma,'2' as civilization
from a1
where m contains '2'
group by q2;
quit;

data c1;
set b1 b2;
run;

data d;
set c1;
if vv1='9' then delete;
run;

proc freq data=d;
tables vv1*civilization/chisq;
weight ma;
title '高低都vs養狗';
run;

/**********************/
/*反過來養貓vs高低都*/
/**********************/

/*低都市化*/
proc SQL noprint;
create table b1 as 
select q3 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q3;
quit;
/*高都市化*/
proc SQL noprint;
create table b2 as 
select q3 as vv1,count(m) as ma,'2' as civilization
from a1
where m contains '2'
group by q3;
quit;

data c1;
set b1 b2;
run;

data d;
set c1;
if vv1='9' then delete;
run;

proc freq data=d;
tables vv1*civilization/chisq;
weight ma;
title '高低都vs養貓';
run;

/**********************/
/*反過來養其他vs高低都*/
/**********************/

/*低都市化*/
proc SQL noprint;
create table b1 as 
select q4 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q4;
quit;
/*高都市化*/
proc SQL noprint;
create table b2 as 
select q4 as vv1,count(m) as ma,'2' as civilization
from a1
where m contains '2'
group by q4;
quit;

data c1;
set b1 b2;
run;

data d;
set c1;
if vv1='9' then delete;
run;

proc freq data=d;
tables vv1*civilization/chisq;
weight ma;
title '高低都vs養其他';
run;

/**********************/
/*反過來QQvs高低都*/
/**********************/
%macro x(x1);
/*低都市化*/
proc SQL noprint;
create table b1 as 
select q&x1. as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q&x1.;
quit;
/*高都市化*/
proc SQL noprint;
create table b2 as 
select q&x1. as vv1,count(m) as ma,'2' as civilization
from a1
where m contains '2'
group by q&x1.;
quit;

data c&x1.;
set b1 b2;
run;

data d;
set c&x1.;
if vv1='9' then delete;
run;

proc freq data=d;
tables vv1*civilization/chisq;
weight ma;
title '高低都vsq'&x1.;
run;
%mend;%x(2);%x(3);%x(4);%x(5);%x(6);%x(7);%x(8);%x(9_1);%x(10);

data e;
set c1 c2 c3 c4 c5 c6 c7 c8 c9_1 c10;
run;

PROC EXPORT DATA= WORK.e 
            OUTFILE= "C:\Documents and Settings\taipei.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;


