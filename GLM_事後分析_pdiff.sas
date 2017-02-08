/*可計算lsmeans、means*/
proc glm data=hcy1;
class qua sex;
model plaquescore=qua age sex  ;
lsmeans qua/pdiff stderr om cl;/*lsmeans為：計算adjust qua age sex變項後的mean*/
means qua;/*means為:最原始的mean*/
run;
/*以GLM做 liner reg時，看 Type III SS 的結果
  以GLM做ANOVA 時，看 Type I SS 的結果*/




/*事後分析*/
data aa;
set aids.final180;
if risk=1 then risk1=1;
else if risk=2 then risk1=2;
else  risk1=3;
ods listing close;
ods listing;
ods html body="D:\mh\aa.html";
proc glm data=aa;
class occupat tb1 risk1;
model age=risk1 occupat tb1 ;
lsmeans risk1/pdiff stderr om cl;/*t test */
run;


proc glm data=aa;
class occupat tb1 risk1;
model age=risk1 occupat tb1 ;
lsmeans risk1/pdiff=control stderr om cl;
run;


proc glm data=aa;
class occupat tb1 risk1;
model age=risk1 occupat tb1 ;
lsmeans risk1/pdiff=control('3') stderr om cl;
run;
ods html close;








/*t test 與 Turkey HSD Test *//*結果差一些*/
proc glm data=aa;
class occupat tb1 risk1;
model age=risk1 occupat tb1 ;
lsmeans risk1/pdiff stderr om cl;/*t test */
run;


proc glm data=aa;
class occupat tb1 risk1;
model age=risk1 occupat tb1 ;
lsmeans risk1/pdiff=all stderr om cl;/*(Turkey HSD Test)*/
run;



proc glm data=aa;
class  occupat tb1 risk1;
model age=risk1 occupat tb1 ;
means risk1/tukey;
run;




/*scheffe test*/
proc glm data=aa;
class  occupat tb1 risk1;
model age=risk1 occupat tb1 ;
means risk1/scheffe;
run;



