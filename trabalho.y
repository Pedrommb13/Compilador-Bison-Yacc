%{
#include <stdio.h>
#include <math.h>
#include <string.h>
#include "lex.yy.h"
int yyerror(char *s);
int yylex();
int x=1,y=1,dr=0,p=0,dp=0,ox=0,oy=0,px=1,py=2,picked=0;

    /*dr = direções do robot*/
    /*0  = Norte(+yy)*/
    /*1  = Este(+xx)*/
    /*2  = Sul(-yy)*/
    /*3  = Oeste(-xx)*/
    
void printd(int dr);

void printa(int n);

void printp(int _p);

void printr(int g);

void calcr(int g);

void initobj(int X,int Y);

void calcp();
%}

%union {
char *id;
int inteiro;
}

%token <id> BGIN END LBRACE RBRACE COMMA ESQUERDA DIREITA B_A E_A B_P I_P E_P B_R E_R B_I E_I ERROR
%token <inteiro> I_A I_R I_I 
%start inicio
%%
inicio: BGIN LBRACE INIT_COMMAND RBRACE END{return 0;}
        | ERROR inicio;

INIT_COMMAND: B_I I_I COMMA I_I E_I{initobj($2,$4);} COMMA COMMANDS
            | COMMANDS;

COMMANDS: COMMANDS COMMA COMMAND
        | COMMAND
        | ;

COMMAND: ESQUERDA{
            dr--; 
            dp=dp-90; 
            if(dp < 0) dp = dp + 360;
            if(dr==-1) dr=3; 
            printd(dr);
            // calcp(); 
            }
        | DIREITA{
            dr++; 
            dp=dp+90; 
            if(dp >= 360) dp = dp - 360;
            if(dr==4) dr=0; 
            printd(dr); 
            // calcp(); 
            }
        | B_A I_A E_A{ 
            int x=$2;
            printa(x);}
        | B_P I_P E_P{
            int _p=p;
            //printf("%s",$2);
            if(strlen($2) == 6) _p=1;
            else _p=0;
            printp(_p);}
        | B_R I_R E_R{
            int x=$2;
            calcr(x); 
        };

%%
void main(int argc,char** argv)
{
    yyin = fopen(argv[1], "r");
	yyparse();
    printf("\nPosição Final:\n");
    printa(0);
    printd(dr);
    printr(dp);
    if( p==1 ) printf("Pinça aberta\n");
    else printf("Pinça fechada\n");
    fclose(yyin);
}

int yyerror(char *s){
    printf("erro sintatico/semantico: \"%s\"\n",s);
    //fprintf (stderr, "%s\n", s);
}

void printd(int dr){
    switch(dr){
        case 0:
            printf("O robot ficou virado para Norte(+yy)\n");
            break;
        case 1:
            printf("O robot ficou virado para Este(+xx)\n");
            break;
        case 2:
            printf("O robot ficou virado para Sul(-yy)\n");
            break;
        case 3:
        printf("O robot ficou virado para Oeste(-xx)\n");
        break;
    }
}

void printa(int n){
    int _x = x, _y = y;
    if ( dr == 2 || dr == 3) n=-n;
    if ( dr == 0 || dr == 2) y=y+n;
    else x=x+n;
    if (x < 0 || x >100 || y < 0 || y > 100){
        printf("O robo ficou na posição (%d,%d) que é invalida, returnando à possição anterior(%d,%d)\n",x,y,_x,_y);
        x = _x; y = _y;
    } 
    else printf("O robo ficou na posição (%d,%d)\n",x,y);    
}

void printp(int _p){
    if(p==_p) printf("A pinça já estava na posição que inseriu\n");
    else if( _p==1 ){
        printf("Pinça aberta\n");
        if(picked==1){
            picked=0;
            calcp();
            initobj(px,py);
        }
        } 
        else{
            printf("Pinça fechada\n");
            calcp();
            if(px==ox && py==oy){
                picked=1;
                printf("Objeto em x:%d y:%d apanhado\n",ox,oy);
            }
        }
    p=_p;
}

void printr(int g){
    switch(dp) {
        case 0: 
            printf("0º Norte(+yy)\n");
            break;
        case 45: 
            printf("45º Nordeste(+xy)\n");
            break;
        case 90: 
            printf("90º Este(+xx)\n");
            break;
        case 135: 
            printf("135º Sudeste(+x-y)\n");
            break;
        case 180: 
            printf("180º Sul(-yy)\n");
            break;
        case 225: 
            printf("225º Sudoeste(-xy)\n");
            break;
        case 270: 
            printf("270º Oeste(-xx)\n");
            break;
        case 315: 
            printf("315º Noroeste(-x+y)\n");
            break;
    }
}

void calcr(int g){
    if(g==0 || g==360 || g==-360) printf("movimento invalido\n");
    else { 
        dp = dp + g;
        if(dp < 0) dp = dp + 360;
        if(dp >= 360) dp = dp - 360;
        printr(g);
    }
}

void initobj(int X,int Y){
    ox=X;
    oy=Y;
    printf("Obejto introduzido em x:%d y:%d\n",ox,oy);
}

void calcp(){
    switch(dp){
        case 0:
        px=x;
        py=y+1;
        break;
        case 45:
        px=x+1;
        py=y+1;
        break;
        case 90:
        px=x+1;
        py=y;
        break;
        case 135:
        px=x+1;
        py=y-1;
        break;
        case 180:
        px=x;
        py=y-1;
        break;
        case 225:
        px=x-1;
        py=y-1;
        break;
        case 270:
        px=x-1;
        py=y;
        break;
        case 315:
        px=x-1;
        py=y+1;
        break;
    }
} 