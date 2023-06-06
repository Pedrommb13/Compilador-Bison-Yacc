%x andar eandar pinca epinca rodar erodar init einit
%{
    #include "trabalho.tab.h"
%}
%option header-file="lex.yy.h" 
%option noyywrap
A "ANDAR"
P "PINÇA"
R "RODAR"
I "INIT-OBJETO"
N ([1-9][0-9]?)|"100"
S "ABRIR"|"FECHAR"
G (-)?(0|45|90|135|180|225|270|315|360)
B "BEGIN"
E "END"
LB "{"
RB "}"
C ","
space (" "|"\t"|"\r"|"\f")+
%%
{B} { return BGIN; }
{E} { return END; }
{LB} { return LBRACE; }
{RB} { return RBRACE; }
{C} { return COMMA; }

"VIRAR-ESQUERDA" { return ESQUERDA;
    // dr--; 
    // dp=dp-90; 
    // if(dp < 0) dp = dp + 360;
    // if(dr==-1) dr=3; 
    // printd(dr); 
}
"VIRAR-DIREITA" { return DIREITA;
    // dr++; 
    // dp=dp+90; 
    // if(dp >= 360) dp = dp - 360;
    // if(dr==4) dr=0; 
    // printd(dr); 
}

{A}\(  {BEGIN(andar); return B_A;}
<andar>{N}  {
    // printa(atoi(yytext));
    yylval.inteiro=atoi(yytext); 
    BEGIN(eandar);
    return I_A;
}
<eandar>\) {BEGIN 0; return E_A;}
<eandar>. {return ERROR;}

{P}\(  {BEGIN(pinca); return B_P; }
<pinca>{S}  {
    // int _p=p;
    // if(yyleng == 5) _p=1;
    // else _p=0;
    // printp(_p);
    yylval.id=yytext;
    BEGIN(epinca);
    return I_P;
}
<epinca>\) {BEGIN 0; return E_P;}
<epinca>. {return ERROR;}

{R}\( {BEGIN(rodar); return B_R;}
<rodar>{G} {
    // calcr(atoi(yytext)); 
    yylval.inteiro=atoi(yytext);
    BEGIN(erodar);
    return I_R;
}
<erodar>\) {BEGIN 0; return E_R;}
<erodar>. {return ERROR;}

{I}\( {BEGIN(init); return B_I;}
<init>{N} {
    yylval.inteiro=atoi(yytext);
    BEGIN(einit);
    return I_I;
}
<einit>{C} {BEGIN(init);return COMMA;}
<einit>\) {BEGIN 0; return E_I;}
<einit>. {return ERROR;}

"\n" {/*return NLINE;*/}
{space} {;}
. {return ERROR;}
<<EOF>> {/*return EF;*/}
%%