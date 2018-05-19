#define VIDE 0
#define ROUGE -1
#define JAUNE 1
#define NBCOLONNE 7
#define NBLIGNE 6
#define NBCASE NBCOLONNE*NBLIGNE
#define MSG_STOP "Pour arreter de jouer, entrer -1"
#define CHAR_VIDE "[ ]"
#define CHAR_ROUGE "[\e[1;31m+\e[0m]"
#define CHAR_JAUNE "[\e[1;33m*\e[0m]"
#define MSG_JAUNE "C'est au tour du joueur JAUNE de jouer"
#define MSG_ROUGE "C'est au tour du joueur ROUGE de jouer"
#define WIN_JAUNE "Le joueur JAUNE a gagné"
#define WIN_ROUGE "Le joueur ROUGE a gagné"
#define FIN_PARTIE "FIN de la PARTIE"
#define MATCH_NUL "MATCH NUL"
#define NUMEROTATION " 0   1   2   3   4   5   6"

extern int nbcoupjoue;
extern int puissance4[NBCOLONNE][NBLIGNE];
extern int nbjetonscolonne[NBCOLONNE];
extern int stop;
extern int jouerPartiePuissance4();