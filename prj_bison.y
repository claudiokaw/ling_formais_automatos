%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
 
void yyerror(const char *s);
void showPath();
void showErro();
%}

%union {
	int ival;
	float fval;
	char cval;
	char *sval;
}

%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING
%token <sval> CRA_BACK
%token NEWLINE
%token ERROR
%token CRA_LS CRA_QUIT CRA_PS CRA_IFCONFIG CRA_TOUCH CRA_MKDIR CRA_RMDIR CRA_START CRA_KILL CRA_CLEAR CRA_CD 
%token CRA_PLUS CRA_MINUS CRA_MULTIPLY CRA_DIVIDE CRA_LEFT CRA_RIGHT
%left CRA_PLUS CRA_MINUS
%left CRA_MULTIPLY CRA_DIVIDE


%start ini

%type<ival> exp
%type<fval> mixed_exp
%type <sval> cmd

%%

ini: 	NEWLINE {
			showPath();
		}
    | 	cmd NEWLINE {
    		showPath();
    	}
    | 	exp NEWLINE {
    		printf("Resposta: %d \n", $1);
    		showPath();
    	}
    | 	mixed_exp NEWLINE {
    		printf("Resposta: %f \n", $1);
    		showPath();
    	}
    | 	ERROR {
    		showErro();
    	}
	| ini ini
;

cmd:	CRA_LS {
			system("ls");
		}
	| 	CRA_QUIT {
			printf("ProjectShell finalizado com sucesso!\n"); exit(0);
		}
	| 	CRA_PS {
			system("ps");
		}
	| 	CRA_IFCONFIG {
			system("ifconfig");
		}
	| 	CRA_TOUCH STRING { 	
			char cmd[100] = "touch ";
			system(strcat(cmd,$2));
			printf("Arquivo %s criado! \n", $2);
		}
						
	| 	CRA_MKDIR STRING {	
			char cmd[100] = "mkdir ";
			system(strcat(cmd,$2));
			printf("Pasta %s criada! \n", $2);
		}

	| 	CRA_RMDIR STRING {
			char cmd[100] = "rmdir ";
			system(strcat(cmd,$2));
			printf("Pasta %s deletada! \n", $2);
		}

	| 	CRA_START STRING {
			char cmd[100] = "open -a ";
			system(strcat(cmd,$2));
			printf("Programa %s iniciado! \n", $2);
		}

	| 	CRA_KILL INT {
			char str[100] = "kill %d";
			char cmd[100];
		   	sprintf(cmd, str, $2);
		   	puts(cmd);
		   	system(cmd);
			printf("Programa %d finalizado! \n", $2);
		}
	| 	CRA_CLEAR {
			system("clear");
		}
	| 	CRA_CD CRA_BACK {
			chdir($2);
		}
	| 	CRA_CD STRING{
			chdir($2);
		}
;

mixed_exp: FLOAT						{ $$ = $1; }
	| mixed_exp CRA_PLUS mixed_exp		{ $$ = $1 + $3; }
	| mixed_exp CRA_MINUS mixed_exp	 	{ $$ = $1 - $3; }
	| mixed_exp CRA_MULTIPLY mixed_exp 	{ $$ = $1 * $3; }
	| mixed_exp CRA_DIVIDE mixed_exp	{ $$ = $1 / $3; }
	| CRA_LEFT mixed_exp CRA_RIGHT		{ $$ = $2; }
	| exp CRA_PLUS mixed_exp	 	 	{ $$ = $1 + $3; }
	| exp CRA_MINUS mixed_exp	 	 	{ $$ = $1 - $3; }
	| exp CRA_MULTIPLY mixed_exp 	 	{ $$ = $1 * $3; }
	| exp CRA_DIVIDE mixed_exp	 		{ $$ = $1 / $3; }
	| mixed_exp CRA_PLUS exp	 	 	{ $$ = $1 + $3; }
	| mixed_exp CRA_MINUS exp	 	 	{ $$ = $1 - $3; }
	| mixed_exp CRA_MULTIPLY exp 	 	{ $$ = $1 * $3; }
	| mixed_exp CRA_DIVIDE exp	 		{ $$ = $1 / $3; }
	| exp CRA_DIVIDE exp		 		{ $$ = $1 / (float)$3; }
;

exp: INT								{ $$ = $1; }
	| exp CRA_PLUS exp					{ $$ = $1 + $3; }
	| exp CRA_MINUS exp					{ $$ = $1 - $3; }
	| exp CRA_MULTIPLY exp				{ $$ = $1 * $3; }
	| CRA_LEFT exp CRA_RIGHT			{ $$ = $2; }
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while (!feof(yyin));
	return 0;
}

void yyerror(const char* s) {
	showErro();
}

void showErro() {
	printf("Comando invalido \n");
}

void showPath(){
	char projectName[4096] = "ProjectShell:";
	char path[2048];
	getcwd(path, sizeof(path));
	strcat(projectName, path);
	printf("%s>> ",projectName); 
}