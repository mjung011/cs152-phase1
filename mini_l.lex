%{
	int currPos = 0;
	int currLine = 1;
	static const char* reserved_words[] = {"function", "beginparams", "endparams", "beginlocals", 
"endlocals", "beginbody", "endbody", "integer", "array", "enum", "of", "if", "then", "endif", "else", "while", "do", "beginloop", "endloop", "continue", "read", "write", "and", "or", "not", "true", "false", "return"};
	static const char* reserved_words_token[] = {"FUNCTION", "BEGIN_PARAMS", "END_PARAMS", "BEGIN_LOCALS", "END_LOCALS", "BEGIN_BODY", "END_BODY", "INTEGER", "ARRAY", "ENUM", "OF", "IF", "THEN", "ENDIF", "ELSE", "WHILE", "DO", "BEGINLOOP", "ENDLOOP", "CONTINUE", "READ", "WRITE", "AND", "OR", "NOT", "TRUE", "FALSE", "RETURN"};
	const int num_reserved_words = sizeof(reserved_words)/sizeof(reserved_words[0]);
%}

DIGIT [0-9]
DIGIT_WITH_UNDERSCORE [0-9_]
LETTERS [a-zA-Z]
LETTERS_WITH_UNDERSCORE [a-zA-Z_]
CHAR [0-9a-zA-Z]
CHAR_WITH_UNDERSCORE [0-9a-zA-Z_]

%%



"-" 	{printf("SUB\n"); 	currPos += yyleng;}
"+"	{printf("ADD\n"); 	currPos += yyleng;}
"*"	{printf("MULT\n"); 	currPos += yyleng;}
"/"	{printf("DIV\n");	currPos += yyleng;}
"%"	{printf("MOD\n");	currPos += yyleng;}



"=="	{printf("EQ\n");	currPos += yyleng;}
"<>"	{printf("NEQ\n");	currPos += yyleng;}
"<"	{printf("LT\n");	currPos += yyleng;}
">"	{printf("GT\n");	currPos += yyleng;}
"<="	{printf("LTE\n");	currPos += yyleng;}
">="	{printf("GTE\n");	currPos += yyleng;}


{LETTERS}({CHAR_WITH_UNDERSCORE}*{CHAR}+)? 	{
	char in_reserved = 0; //0 = false
	int i = 0;
	for (; i < num_reserved_words; i++){
		if(strcmp(yytext, reserved_words[i])/*outputs ` when false*/ == 0){
			printf("%s\n", reserved_words_token[i]);
			in_reserved = 1;
		}
	}
	
	if(in_reserved == 0){
		printf("IDENT %s\n", yytext);
	}
	currPos += yyleng;
}
{DIGIT}+	{printf("NUMBER %s\n", yytext); currPos += yyleng;}

";"	{printf("SEMICOLON\n");		currPos += yyleng;}
":"	{printf("COLON\n");		currPos += yyleng;}
","	{printf("COMMA\n");		currPos += yyleng;}
"("	{printf("L_PAREN\n");		currPos += yyleng;}
")"	{printf("R_PAREN\n");		currPos += yyleng;}
"["	{printf("L_SQUARE_BRACKET\n");	currPos += yyleng;}
"]"	{printf("R_SQUARE_BRACKET\n");	currPos += yyleng;}
":="	{printf("ASSIGN\n");		currPos += yyleng;}

"##".*"\n"	{currPos = 0;	currLine ++;}
"\n"		{currPos = 0; 	currLine ++;}
[ \t]+		{/*ignore spaces*/ currPos += yyleng;}

({DIGIT}+{LETTERS_WITH_UNDERSCORE}{CHAR_WITH_UNDERSCORE}*)|("_"{CHAR_WITH_UNDERSCORE}+) {
	printf("Error at line %d, column %d: identifier \"%s\" must begin with a  letter\n", currLine, currPos, yytext);
	exit(0);
}
{LETTERS}({CHAR_WITH_UNDERSCORE}*{CHAR}+)?"_" {
	printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext);
	exit(0);
}
. {printf("Error at line %d, colunm %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext);	exit(0);}

%%

int main(int argc, char* argv[]){
	if(argc == 2){
		yyin = fopen(argv[1], "r");
		if(yyin == NULL) {
			yyin = stdin;
		}
	}
	else {
		yyin = stdin;
	}
	
	if(sizeof(reserved_words) != sizeof(reserved_words_token)){
		printf("error\n");
		exit(0);
	}

	yylex();
	
}
