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
%token NEWLINE
%token ERROR
%token CRA_LS CRA_QUIT CRA_PS CRA_IFCONFIG CRA_TOUCH CRA_MKDIR CRA_RMDIR CRA_START CRA_KILL

%start ini

%type <sval> cmd

%%

ini: 	NEWLINE {
			showPath();
		}
    | 	cmd NEWLINE {
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