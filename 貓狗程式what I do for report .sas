option nocenter;

PROC IMPORT OUT= WORK.a
            DATAFILE= "C:\Documents and Settings\taipei.dbf" 
            DBMS=DBF REPLACE;
     GETDELETED=NO;
RUN;



/*
1.area�a�ϥN�X�令ano2
2.�a���i10��(�t)�H�W������,
   �a�ϥN�X�令13 (������)*/
data aa;
set a;
ano2=area;
if d>=10 then ano2='13';
run;

/*
�a�Ϥ��դ������C�����ưϰ�
���������k���G��*/
data a1;
set aa;
if ano2 in('08','09','10','11','12') then m='1';
if ano2 in('01','02','03','04','05','06','07') then m='2';
if q9 in('1','2') then q9_1='1';
if q9 in('4','5') then q9_1='2';
if q9 in('3') then q9_1='';
run;



/**********************/
/*�ϹL�Ӭy����vs���C��*/
/**********************/

/*�C������*/
proc SQL noprint;
create table b1 as 
select q5 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q5;
quit;
/*��������*/
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
title '���C��vs�y����';
run;

/**********************/
/*�ϹL�Ӭy����vs���C��*/
/**********************/

/*�C������*/
proc SQL noprint;
create table b1 as 
select q6 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q6;
quit;
/*��������*/
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
title '���C��vs�y����';
run;

/**********************/
/*�ϹL�Ӿi��vs���C��*/
/**********************/

/*�C������*/
proc SQL noprint;
create table b1 as 
select q2 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q2;
quit;
/*��������*/
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
title '���C��vs�i��';
run;

/**********************/
/*�ϹL�Ӿi��vs���C��*/
/**********************/

/*�C������*/
proc SQL noprint;
create table b1 as 
select q3 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q3;
quit;
/*��������*/
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
title '���C��vs�i��';
run;

/**********************/
/*�ϹL�Ӿi��Lvs���C��*/
/**********************/

/*�C������*/
proc SQL noprint;
create table b1 as 
select q4 as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q4;
quit;
/*��������*/
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
title '���C��vs�i��L';
run;

/**********************/
/*�ϹL��QQvs���C��*/
/**********************/
%macro x(x1);
/*�C������*/
proc SQL noprint;
create table b1 as 
select q&x1. as vv1,count(m) as ma,'1' as civilization
from a1
where m contains '1'
group by q&x1.;
quit;
/*��������*/
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
title '���C��vsq'&x1.;
run;
%mend;%x(2);%x(3);%x(4);%x(5);%x(6);%x(7);%x(8);%x(9_1);%x(10);

data e;
set c1 c2 c3 c4 c5 c6 c7 c8 c9_1 c10;
run;

PROC EXPORT DATA= WORK.e 
            OUTFILE= "C:\Documents and Settings\taipei.xls" 
            DBMS=EXCEL2000 REPLACE;
RUN;


