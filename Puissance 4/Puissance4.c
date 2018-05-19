#include <stdio.h>
#include "main.h"

void afficherCase(int couleur)
{
        switch(couleur)
        {
                case VIDE:
                        printf("%s", CHAR_VIDE);
                        break;
                case ROUGE:
                        printf("%s", CHAR_ROUGE);
                        break;
                case JAUNE:
                        printf("%s", CHAR_JAUNE);
                        break;
        }
}

void afficherGrille()
{
        int i;
        int j;

        for (j = NBLIGNE-1; j >= 0; j--)
        {
                for (i = 0; i < NBCOLONNE; i++)
                {
                        afficherCase(puissance4[i][j]);
                        printf("%s", " ");
                }
                printf("%s", "\n");
        }
}

int demanderCouleurDeLaCaseXY(int absVue, int OrdVue)
{
        return puissance4[absVue][OrdVue];
}

int nbDeJetonsColonne(int numColonne)
{
        return nbjetonscolonne[numColonne];
}

void ajouterJeton(int choixJoueur)
{
        if (nbcoupjoue%2 == 0)
        {
                puissance4[choixJoueur][nbDeJetonsColonne(choixJoueur)] = 1;
        }
        else
        {
                puissance4[choixJoueur][nbDeJetonsColonne(choixJoueur)] = -1;
        }
        nbjetonscolonne[choixJoueur]++;
        nbcoupjoue++;
}

int estCoupInvalide(int colonneJouee)
{
        if (nbDeJetonsColonne(colonneJouee) == NBLIGNE || colonneJouee < 0 || colonneJouee > NBCOLONNE-1)
        {
                return 0;
        }
        else
        {
                return 1;
        }
}

int jouerCoupPuissance4()
{
        int boolean = 0;
        int choixJoueur;

        afficherGrille();
        printf(NUMEROTATION);
        printf("\n");
        if (nbcoupjoue%2 == 0)
        {
                printf("%s\n", MSG_JAUNE);
                while (boolean == 0)
                {
                        scanf("%d", &choixJoueur);
                        if (choixJoueur == -1) /* STOPER LE JEU*/
                        {
                                stop = 1;
                                return 0;
                        }
                        boolean = estCoupInvalide(choixJoueur);
                        if (boolean == 0)
                        {
                                printf("ERREUR %s\n", MSG_JAUNE);
                        }
                }
        }
        else
        {
                printf("%s\n", MSG_ROUGE);
                while (boolean == 0)
                {
                        scanf("%d", &choixJoueur);
                        if (choixJoueur == -1) /* STOPER LE JEU*/
                        {
                                stop = 1;
                                return 0;
                        }
                        boolean = estCoupInvalide(choixJoueur);
                        if (boolean == 0)
                        {
                                printf("ERREUR %s\n", MSG_ROUGE);
                        }
                }
        }
        ajouterJeton(choixJoueur);
        return choixJoueur;
}

int estCoupGagnantdiag(int choixJoueur)
{
        int hauteur = nbDeJetonsColonne(choixJoueur)-1;
        int couleur = demanderCouleurDeLaCaseXY(choixJoueur,hauteur);
        if (hauteur < NBLIGNE-3 && choixJoueur > 2)
        {
                if (puissance4[choixJoueur-1][hauteur+1] == couleur && puissance4[choixJoueur-2][hauteur+2] == couleur && puissance4[choixJoueur-3][hauteur+3] == couleur)
                {
                        return 1;
                }
        }
        if (hauteur < NBLIGNE-2 && choixJoueur > 1 && hauteur > 0 && choixJoueur < NBCOLONNE-1)
        {
                if (puissance4[choixJoueur-1][hauteur+1] == couleur && puissance4[choixJoueur-2][hauteur+2] == couleur && puissance4[choixJoueur+1][hauteur-1] == couleur)
                {
                        return 1;
                }
        }  
        if (hauteur < NBLIGNE-1 && choixJoueur > 0 && hauteur > 1 && choixJoueur < NBCOLONNE-2)
        {
                if (puissance4[choixJoueur-1][hauteur+1] == couleur && puissance4[choixJoueur+1][hauteur-1] == couleur && puissance4[choixJoueur+2][hauteur-2] == couleur)
                {
                        return 1;
                }
        }  
        if (hauteur > 2 && choixJoueur < NBCOLONNE-3)
        {
                if (puissance4[choixJoueur+1][hauteur-1] == couleur && puissance4[choixJoueur+2][hauteur-2] == couleur && puissance4[choixJoueur+3][hauteur-3] == couleur)
                {
                        return 1;
                }
        }
        if (hauteur < NBLIGNE-3 && choixJoueur < NBCOLONNE-3)
        {
                if (puissance4[choixJoueur+1][hauteur+1] == couleur && puissance4[choixJoueur+2][hauteur+2] == couleur && puissance4[choixJoueur+3][hauteur+3] == couleur)
                {
                        return 1;
                }
        }
        if (hauteur < NBLIGNE-2 && choixJoueur < NBCOLONNE-2 && hauteur > 0 && choixJoueur > 0)
        {
                if (puissance4[choixJoueur+1][hauteur+1] == couleur && puissance4[choixJoueur+2][hauteur+2] == couleur && puissance4[choixJoueur-1][hauteur-1] == couleur)
                {
                        return 1;
                }
        }
        if (hauteur < NBLIGNE-1 && choixJoueur < NBCOLONNE-1 && hauteur > 1 && choixJoueur > 1)
        {
                if (puissance4[choixJoueur+1][hauteur+1] == couleur && puissance4[choixJoueur-1][hauteur-1] == couleur && puissance4[choixJoueur-2][hauteur-2] == couleur)
                {
                        return 1;
                }
        }
        if (hauteur > 2 && choixJoueur > 2)
        {
                if (puissance4[choixJoueur-1][hauteur-1] == couleur && puissance4[choixJoueur-2][hauteur-2] == couleur && puissance4[choixJoueur-3][hauteur-3] == couleur)
                {
                        return 1;
                }
        }
        return 0;
}

int estCoupGagnanthori(int choixJoueur)
{
        int hauteur = nbDeJetonsColonne(choixJoueur)-1;
        int couleur = demanderCouleurDeLaCaseXY(choixJoueur,hauteur);
        
        if (choixJoueur > 2)
        {
                if (puissance4[choixJoueur-1][hauteur] == couleur && puissance4[choixJoueur-2][hauteur] == couleur && puissance4[choixJoueur-3][hauteur] == couleur)
                {
                        return 1;
                }
        }
        if (choixJoueur > 1 && choixJoueur < NBCOLONNE-1)
        {
                if (puissance4[choixJoueur-1][hauteur] == couleur && puissance4[choixJoueur-2][hauteur] == couleur && puissance4[choixJoueur+1][hauteur] == couleur)
                {
                        return 1;
                }
        }
        if (choixJoueur > 0 && choixJoueur < NBCOLONNE-2)
        {
                if (puissance4[choixJoueur-1][hauteur] == couleur && puissance4[choixJoueur+1][hauteur] == couleur && puissance4[choixJoueur+2][hauteur] == couleur)
                {
                        return 1;
                }
        }
        if (choixJoueur < NBCOLONNE-3)
        {
                if (puissance4[choixJoueur+1][hauteur] == couleur && puissance4[choixJoueur+2][hauteur] == couleur && puissance4[choixJoueur+3][hauteur] == couleur)
                {
                        return 1;
                }
        }
        return 0;
}

int estCoupGagnantvert(int choixJoueur)
{
        int hauteur = nbDeJetonsColonne(choixJoueur)-1;
        int couleur = demanderCouleurDeLaCaseXY(choixJoueur,hauteur);

        if (hauteur > 2)
        {
                if (puissance4[choixJoueur][hauteur-1] == couleur && puissance4[choixJoueur][hauteur-2] == couleur && puissance4[choixJoueur][hauteur-3] == couleur)
                {
                        return 1;
                }
        }
        return 0;
}

int estCoupGagnant(int choixJoueur)
{
        if (estCoupGagnantdiag(choixJoueur))
        {
                return 1;
        }
        if (estCoupGagnanthori(choixJoueur))
        {
                return 1;
        }
        if (estCoupGagnantvert(choixJoueur))
        {
                return 1;
        }
        return 0;
}

int jouerPartiePuissance4()
{
        printf("%s\n", MSG_STOP);
        while (nbcoupjoue < NBCASE)
        {
                if (stop)
                {
                        return 0;
                }
                if (estCoupGagnant(jouerCoupPuissance4()) == 1 && stop == 0)
                {
                    	afficherGrille();
                        if (nbcoupjoue%2)
                        {
                                printf("%s\n", WIN_JAUNE);
                        }
                        else
                        {
                                printf("%s\n", WIN_ROUGE);
                        }
                        printf("%s\n", FIN_PARTIE);
                        return 0;
                }
        }
        afficherGrille();
        printf("%s\n", MATCH_NUL);
        printf("%s\n", FIN_PARTIE);
        return 0;
}