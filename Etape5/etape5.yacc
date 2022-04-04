%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    char tableau[1024];
    char etat[100][2][100];
    int pos[100][2];
    int indiceLigne = 0;

    void yyerror(char* s);
    int yylex();
    void miseEnForme(char newMiseEnForme[100]);
%}

//Emplacement Tokens (%token)
%token TXT
%token BALTIT
%token FINTIT
%token LIGVID
%token DEBLIST
%token ITEMLIST
%token FINLIST
%token ETOILE

%start fichier

%type element
%type titre
%type liste
%type suite_liste
%type texte_formatte
%type liste_textes
%type gras
%type grasitalique
%type italique

//Règles
%%
    fichier : element ;
            | element fichier ;

    element : TXT ;
            | LIGVID ;
            | titre ;
            | liste ;
            | texte_formatte ;

    titre : BALTIT TXT FINTIT ;

    liste : DEBLIST liste_textes suite_liste ;

    suite_liste : ITEMLIST liste_textes suite_liste ;
                | FINLIST ;

    texte_formatte : italique ;
                   | gras ;
                   | grasitalique ;

    liste_textes : TXT ;
                 | texte_formatte ;
                 | TXT liste_textes ;
                 | texte_formatte liste_textes ;

    italique : ETOILE TXT ETOILE
    {
        miseEnForme("italique");
    }
    gras : ETOILE ETOILE TXT ETOILE ETOILE
    {
        miseEnForme("gras");
    }
    grasitalique : ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE
    {
        miseEnForme("gras+italique");
    }
%%

int main(){

    yyparse();

    /*Calcul nombre element dans pos*/
    int taillePosEtat = 0;
    while(pos[taillePosEtat][1] != 0){
        
        taillePosEtat++;
    }


    //Affichage du tableau de symboles
    printf("talbeau de symbole = \n");
    for(int i=0; i<taillePosEtat; i++){
        printf("%-8d|%-8d|%-8s|%-8s|\n", pos[i][0], pos[i][1], etat[i][0], etat[i][1]);
    }
    printf("\n");
    
    /*Calcul nombre element dans tableau*/
    int tailletableau = 0;
    while(tableau[tailletableau] != '\0'){

        tailletableau++;
    }

    /*Enlève les \ situés avant les * dans le texte*/
    for(int i=0; i<tailletableau-1; i++){
        if(tableau[i] == '\\' && tableau[i+1] == '*'){
            for(int j=i; j<tailletableau-1; j++){
                tableau[j] = tableau[j+1];
            }
        }
    }

    //Affichage du contenu textuel du fichier source
    printf("tableau = %s\n", tableau);

    return 0;
}  

void miseEnForme(char newMiseEnForme[100]){
    //on modifie la valeur de mise en forme
        strcpy(etat[indiceLigne-1][1], newMiseEnForme);//[indiceLigne -1] car on incrémente indiceLigne (dans le lex) avant d'envoyer les infos au yacc
}

int yylex(YYSTYPE *, void *);

void yyerror(char* s){

    if (strcmp(s, "synthax error")){
        printf("\033[31;1m");
        printf("\nerreur synthaxique\n", s);
        printf("\033[31;0m");
    }
}