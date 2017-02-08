option nocenter nodate;
data aa;
set tmp1.data940826;
run;

/*對年齡世代分組有連續age或是分組ageg的對象*/
data a1;
set aa;
if age<=30 then ageg=1;
if 30<age<=40 then ageg=2;
if 40<age<=50 then ageg=3;
if 50<age<=60 then ageg=4;
if 60<age then ageg=5;
/*空白的值都改成0*/
%macro x(x1);
if &x1.='.' then &x1.=0;
%mend;%x(q6_1);%x(q6_2);%x(q6_3);%x(q6_4);%x(q6_5);%x(q6_6);%x(q6_7);%x(q6_8);%x(q6_9);%x(q6_10);
%x(q7_1);%x(q7_2);%x(q7_3);%x(q7_4);%x(q7_5);%x(q7_6);%x(q7_7);
%x(q8_1);%x(q8_2);%x(q8_3);%x(q8_4);%x(q8_5);%x(q8_6);%x(q8_7);
%x(q9_1);%x(q9_2);%x(q9_3);%x(q9_4);%x(q9_5);%x(q9_6);
%x(q11_1);%x(q11_2);%x(q11_3);%x(q11_4);%x(q11_5);%x(q11_6);%x(q11_7);%x(q11_8);%x(q11_9);%x(q11_10);%x(q11_11);%x(q11_12);%x(q11_13);%x(q11_14);%x(q11_15);%x(q11_16);%x(q11_17);%x(q11_18);%x(q11_19);%x(q11_20);%x(q11_21);%x(q11_22);%x(q11_23);
%x(q12_1);%x(q12_2);%x(q12_3);%x(q12_4);%x(q12_5);
%x(care_1);%x(care_2);%x(care_3);%x(care_4);%x(care_5);%x(care_6);%x(care_7);%x(care_8);%x(care_9);%x(care_10);%x(care_11);%x(care_12);%x(care_13);%x(care_14);%x(care_15);%x(care_16);%x(care_17);%x(care_18);%x(care_19);%x(care_20);%x(care_21);%x(care_22);%x(care_23);%x(care_24);%x(care_25);%x(care_26);
%x(m9);%x(m10);%x(m11);%x(m12);%x(m13);%x(m14);%x(m15);%x(m16);
%x(m17);%x(m18);%x(m19);%x(m20);%x(m21);%x(m22);%x(m23);%x(m24);
/*q6q7q8q9q11q12中的否=2改成否=0*/
%macro x(d1);
if &d1.=2 then &d1.=0;
%mend;
%x(q7_1);%x(q7_2);%x(q7_3);%x(q7_4);%x(q7_5);%x(q7_6);%x(q7_7);
%x(q8_1);%x(q8_2);%x(q8_3);%x(q8_4);%x(q8_5);%x(q8_6);%x(q8_7);
%x(q9_1);%x(q9_2);%x(q9_3);%x(q9_4);%x(q9_5);%x(q9_6);
%x(q11_1);%x(q11_2);%x(q11_3);%x(q11_4);%x(q11_5);%x(q11_6);%x(q11_7);%x(q11_8);%x(q11_9);%x(q11_10);%x(q11_11);%x(q11_12);%x(q11_13);%x(q11_14);%x(q11_15);%x(q11_16);%x(q11_17);%x(q11_18);%x(q11_19);%x(q11_20);%x(q11_21);%x(q11_22);%x(q11_23);
%x(q12_1);%x(q12_2);%x(q12_3);%x(q12_4);%x(q12_5);
/*把q6q7q8q9q11q12care和，score與行為應呈反向*/
q6=q6_1+q6_2+q6_3+q6_4+q6_5+q6_6+q6_7+q6_8+q6_9+q6_10;
q7=q7_1+q7_2+q7_3+q7_4+q7_5+q7_6+q7_7;
q8=q8_1+q8_2+q8_3+q8_4+q8_5+q8_6+q8_7;
q9=q9_1+q9_2+q9_3+q9_4+q9_5+q9_6;
q11=q11_1+q11_2+q11_3+q11_4+q11_5+q11_6+q11_7+q11_8+q11_9+q11_10+q11_11+q11_12+q11_13+q11_14+q11_15+q11_16+q11_17+q11_18+q11_19+q11_20+q11_21+q11_22+q11_23;
q12=q12_1+q12_2+q12_3+q12_4+q12_5;
care=care_1+care_2+care_3+care_4+care_5+care_6+care_7+care_8+care_9+care_10+care_11+care_12+care_13+care_14+care_15+care_16+care_17+care_18+care_19+care_20+care_21+care_22+care_23+care_24+care_25+care_26;/*正向*/
pps=m9+m10+m11+m12+m13+m14+m15+m16;/*正向*/
mms=m17+m18+m19+m20+m21+m22+m23+m24;/*正向*/
*keep ageg tbirth bage1 bsex1 bhelp1 barea1 hope special q6 q7 q8 q9 q10 q11 q12 q13 care q4_3 mwork1 mhealth1 q4_7 m_work1 m_hea1 pps mms edu1 work1 live1 se1 grank1;
run;

ods rtf file ="C:\Documents and Settings\Administrator\桌面\報告跑第三次最簡單的.doc"; 

/*先都只管第一胎，對全部變項的總和，篩選變項*/
*proc freq;
*table ageg*(bage1 bsex1 bhelp1 barea1 hope special q6 q7 q8 q9 q10 q11 q12 q13 care q4_3 mwork1 mhealth1 q4_7 m_work1 m_hea1 pps mms edu1 work1 live1 se1 grank1)/chisq;
*run;

/*卡方檢定對這幾個做有顯著*/
proc freq;
table ageg*(hope q10 q12 mhealth1 work1 se1)/chisq;run;

/*q6 q9內部的一致性*/
proc corr data=a1 alpha nomiss PEARSON;
  var q9_1 q9_2 q9_3 q9_4 q9_5 ;/*q9_6有missing就不管了*/
  *var q6_1 q6_2 q6_3 q6_4 q6_5 q6_6 q6_7 q6_8 q6_9 ;
  *var q11_1 q11_2 q11_3 q11_4 q11_5 q11_6 q11_7 q11_8 q11_9 q11_10 q11_11 q11_12 q11_13 q11_14 q11_15 q11_16 q11_17 q11_18 q11_19 q11_20 q11_21 q11_22 q11_23;
  *var care_1 care_2 care_3 care_4 care_5 care_6 care_7 care_8 care_9 care_10 care_11 care_12 care_13 care_14 care_15 care_16 care_17 care_18 care_19 care_20 care_21 care_22 care_23 care_24 care_25 care_26;/*正向*/
  *var m9 m10 m11 m12 m13 m14 m15 m16;
run;

/*age group分別q6幾個項的相關性
proc corr data=a1 PEARSON;
  var q6_1 q6_2 q6_3 q6_4 q6_5 q6_6 q6_7 q6_8 q6_9;
  with ageg;
run; */

/*age group分別q9的相關性*/
proc corr data=a1 PEARSON;
  var q9_1 q9_2 q9_3 q9_4 q9_5;
  with ageg;
run; 

/*兩兩做分層的two sample ttest*/
proc ttest cochran;
class special;
*var ageg;
/*var q6;
var q7;
var q8;*/
var q9;
*var q10;
run;

/*ageg有五組anova
proc glm data=a1;
class ageg;
model q6=ageg;
means ageg /scheffe; 事後檢定: scheffe test
run;*/
proc glm data=a1;
class ageg;
model q9=ageg;
means ageg /scheffe; 
run;

/*畫表格*/
proc tabulate data=a1 noseps;
class ageg;
var q9_1 q9_2 q9_3 q9_4 q9_5 q9_6 q9_7 q9_8 q9_9;
table ageg,(q9_1 q9_2 q9_3 q9_4 q9_5 q9_6 q9_7 q9_8 q9_9)*(n*f=comma7.  mean*f=7.2 std='sd'*f=7.2 );
run;

*proc univariate;var hope special q10;run;

/*y變項分類高低齡*/
data a2;
set a1;
if age<42 then agegg=0;
if age>=42 then agegg=1;
q9_q12=q9*q12;
/*hopeq10設dummy*/
hope_1=0;hope_2=0;hope_3=0;
if hope=2 then hope_1=1;
if hope=3 then hope_2=1;
if hope=4 then hope_3=1;
hope12=hope_1*hope_2;
hope13=hope_1*hope_3;
hope23=hope_2*hope_3;
q10_1=0;q10_2=0;q10_3=0;
if q10=2 then q10_1=1;
if q10=3 then q10_2=1;
if q10=4 then q10_3=1;
q1012=q10_1*q10_2;
q1013=q10_1*q10_3;
q1023=q10_2*q10_3;
special_=0;
if special=2 then special_=1;
hq11=hope_1*q10_1;
hq12=hope_1*q10_2;
hq13=hope_1*q10_3;
hq21=hope_2*q10_1;
hq22=hope_2*q10_2;
hq23=hope_2*q10_3;
hq31=hope_3*q10_1;
hq32=hope_3*q10_2;
hq33=hope_3*q10_3;
run;

/*簡單線性回歸*/
proc reg data=a2;
  model age=q6;
  LABEL  q6="吃東西次數和";
run;
proc reg data=a2;
  model age=q9;
  LABEL  q9="照顧事項";
run;

/*multi*/
proc reg data=a2;
model age=q6 q7 q8 q9 q11 q12/*selection=stepwise*/;
run;
/*只用q6q12加入interaction*/
proc reg data=a2;
model age=q9 q12 q9_q12/* vif tol selection=stepwise*/;
run;

proc reg data=a2;
model ageg=q10_1 q10_2 q10_3 hope_1 hope_2 hope_3 hq11 hq12 hq13 hq21 hq22 hq23 hq31 hq32 hq33/selection=stepwise;
run;

/*用genmod來做（ML）*/
proc genmod data=a2 order=internal;
 class hope special q10 ;
 model age      =hope special q10                  hope*special hope*q10 special*q10 
/dist=normal link=identity /*p r*/;
title "各變項之多元迴歸模式";
run;

/*先挑11可進而以
proc freq; table special_*(q6 q7 q8 q9 q10 q11 q12 q13)/chisq;run;*/
/*logistic都沒有顯著的我最喜歡沒有顯著的*/
proc logistic data=a2 descending;
model special_= q11/rl cl scale=none aggregate ;
run;
/*先挑6791可進而以
proc freq; table special*(q11_1 q11_2 q11_3 q11_4 q11_5 q11_6 q11_7 q11_8 q11_9 q11_10 q11_11 q11_12 q11_13 q11_14 q11_15 q11_16 q11_17 q11_18 q11_19 q11_20 q11_21 q11_22 q11_23)/chisq;run;*/
/*log要做二項的y有stepwise的畫作不出來都進不去也都沒有顯祝*/
proc logistic data=a2 descending;
class q11_1(descending ref='1') q11_6(descending ref='1') q11_7(descending ref='1') q11_9(descending ref='1');
model special_=q11_1 q11_6 q11_7 q11_9 /rl selection=stepwise lackfit;
title'沒有交互項';
run;
/*interactionnnnnnnnnnnnnnnnnnnnnlog要做二項的y有stepwise的畫作不出來都進不去也都沒有顯祝*/
proc logistic data=a2 descending;
class q11_1(descending ref='1') q11_6(descending ref='1') q11_7(descending ref='1') q11_9(descending ref='1');
model special_=q11_1 q11_6 q11_7 q11_9 
                             q11_1*q11_6 q11_1*q11_7 q11_1*q11_9 
                                                      q11_6*q11_7 q11_6*q11_9 
                                                                               q11_7*q11_9 /rl  lackfit;
title'加入交互項';
run;
/*先挑********************************************整個不好1268101211可進而以
proc freq; table special*( care_1 care_2 care_3 care_4 care_5 care_6 care_7 care_8 care_9 care_10 care_11 care_12 care_13 care_14 care_15 care_16 care_17 care_18 care_19 care_20 care_21 care_22 care_23 care_24 care_25 care_26)/chisq;run;
proc logistic data=a2 descending;
class care_1 (descending ref='1') care_2 (descending ref='1') care_6 (descending ref='1') care_8 (descending ref='1') care_10 (descending ref='1') care_11 (descending ref='1') care_12 (descending ref='1') ;
model special_=care_1 care_2 care_6 care_8 care_10 care_11 care_12 /rl  lackfit;
run;*/

ods rtf close;

*genmod
catmod







還是算了?

