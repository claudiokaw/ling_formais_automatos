%{
	#include <stdio.h>
	#define YY_DECL extern int yylex()
	#include "prj_bison.tab.h"  // to get the token types that we return
%}

%option noyywrap

%%
[ \t]       	 ;
"+"				{return CRA_PLUS;}
"-"				{return CRA_MINUS;}
[-]?[0-9]+          {yylval.ival = atoi(yytext); return INT;}
[-]?[0-9]+\.[0-9]+	{yylval.fval = atof(yytext); return FLOAT;}
"*"				{return CRA_MULTIPLY;}
"/"				{return CRA_DIVIDE;}
"("				{return CRA_LEFT;}
")"				{return CRA_RIGHT;}
"ls" 			{return CRA_LS;}
"quit" 			{return CRA_QUIT;}
"ps" 			{return CRA_PS;}
"touch" 		{return CRA_TOUCH;}
"ifconfig" 		{return CRA_IFCONFIG;}
"mkdir" 		{return CRA_MKDIR;}
"rmdir"			{return CRA_RMDIR;}
"start"			{return CRA_START;}
"kill"			{return CRA_KILL;}
"clear"			{return CRA_CLEAR;}
"cd"			{return CRA_CD;}
".."			{yylval.sval = strdup(yytext); return CRA_BACK;}
[a-zA-Z0-9]+    {yylval.sval = strdup(yytext); return STRING;}
\n 				{return NEWLINE;}
.				{return ERROR;}
%%