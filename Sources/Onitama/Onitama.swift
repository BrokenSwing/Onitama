/**
    Ce protocol représente le controlleur du jeu.
*/
public protocol Onitama {

    /**
        Crée un controlleur pour le jeu Onitama.

        Suite à `init()` on a :

            // L'accès à self.carteFlottante renvoie une erreur fatale
            // L'état de self.plateau est le même que celui suivant l'initialisation du protocol Plateau
            self.joueur1.estJoueur1() == true
            self.joueur2.estJoueur1() == false

    */
    init()

    /**
        Cette propriété représente le joueur 1.

        L’appel du get renvoie le joueur 1 c’est à dire le joueur tel que self.joueur1.estJoueur1() == true
        Le set n’est ici que pour satisfaire la mutabilité du joueur.
    */
    var joueur1: Joueur { get set }

    /**
        Cette propriété représente le joueur 2.

        L’appel du get renvoie le joueur 2 c’est à dire le joueur tel que self.joueur2.estJoueur1() == false
        Le set n’est ici que pour satisfaire la mutabilité du joueur.
    */
    var joueur2: Joueur { get set }

    /**
        Indique quelle carte est actuellement la carte flottante, c'est à dire la seule des cinq cartes du jeu qui ne soit
        pas en possession d'un des deux joueurs.

        Lors de l'appel de get on s'attend à recevoir la carte donnée précédemment via un appel de set.
        Si set n'a jamais été appelé et qu'on appelle get, alors on émet une erreur fatale.

        - returns: la carte flottante de la partie
    */
	var carteFlottante: Carte { get set }

    /**
        Tire 5 cartes au hasard parmi les cartes données.

        - parameters:
            - cartes: Une liste de cartes parmi lesquelles les 5 cartes doivent être choisies
        
        Si la liste de carte donnée en paramètre possède moins de 5 cartes, alors cette méthode émet une erreur fatale.

        - returns: une liste de 5 cartes tirées au hasard parmi les cartes données
    */
	func tirer5Carte(parmi cartes: [Carte]) -> [Carte]

    /**
        Indique si la partie est terminée.

        La partie est terminée si le pion maître d'un joueur est mort ou si le pion maître d'un joueur
        est arrivé sur la case temple de l'autre joueur.
        La case temple du joueur1 se trouve en (2, 4) et la case temple du joueur2 se trouve en (2, 0).

        - returns: true si la partie est terminée, sinon false
    */
	func estTermine() -> Bool

    /**
        Cette propriété est le tableau sur lequel se déroule la partie.
        Cette propriété doit être initialisée lors de l'initilisation de ce type.
        Le set n’est ici que pour satisfaire la mutabilité du plateau.
    */
	var plateau: Plateau { get set }
}