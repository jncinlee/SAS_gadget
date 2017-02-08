/*�i�p��lsmeans�Bmeans*/
proc glm data=hcy1;
class qua sex;
model plaquescore=qua age sex  ;
lsmeans qua/pdiff stderr om cl;/*lsmeans���G�p��adjust qua age sex�ܶ��᪺mean*/
means qua;/*means��:�̭�l��mean*/
run;
/*�HGLM�� liner reg�ɡA�� Type III SS �����G
  �HGLM��ANOVA �ɡA�� Type I SS �����G*/




/*�ƫ���R*/
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








/*t test �P Turkey HSD Test *//*���G�t�@��*/
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



