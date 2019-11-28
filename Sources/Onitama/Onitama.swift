/**
    Ce protocol représente le controlleur du jeu.
*/
protocol Onitama {

    /**
        Crée un controlleur pour le jeu Onitama.

        Suite à `init()` on a :

            // L'accès à self.carteFlottante renvoie une erreur fatale
            // L'état de self.plateau est le même que celui suivant l'initialisation du protocol Plateau

    */
    init()

    /**
        Cette méthode crée le joueur 1 et le renvoie.

        `self.creerJoueur1().estJoueur1() == true`
    */
	func creerJoueur1() -> Joueur

    /**
        Cette méthode crée le joueur 2 et le renvoie.

        `self.creerJoueur2().estJoueur1() == false`
    */
	func creerJoueur2() -> Joueur

    /**
        Crée un pion à une position donnée, pour un joueur donné.

        - important: x appartient à [0 ; 4] et y appartient à [0 ; 4], si ce n'est pas le cas, la méthode émet une erreur

        - parameters:
            - estMaitre: true si le pion doit être un pion maitre, sinon false
            - joueur: le joueur auquel ce pion doit appartenir
            - x: la coordonnée x de la case sur laquelle doit se trouver le pion
            - y: la coordonnée y de la case sur laquelle doit se trouver le pion

        `self.creerPion(estMaitre: m, appartientA: j, x: x, y: y)` => creer une instance `p` du protocol `Pion` telle que :

            p.estMaitre == m
            p.joueur.estJoueur1() == j.estJoueur1()
            p.pos == (x, y)
            p est contenu dans j.pions
            self.plateau.getPionA(x: x, y: y) est p
        
    */
	mutating func creerPion(estMaitre: Bool, appartientA joueur: inout Joueur, x: Int, y: Int)

    /**
        Crée une carte avec le nom donné et les mouvements donnés.

        `let carte = self.creerCarte(nom: n, estCouleurJoueur1: value, m1, m2, m3) => carte.nom == n && carte.mouvements == [m1, m2, m3] && carte.estCouleurJoueur1 == value`

        - parameters:
            - nom: Le nom de la carte que l'on veut créer
            - estCouleurJoueur1: true si la couleur de la carte correspond à la couleur du joueur 1, sinon false
            - mouvements: Les mouvements que la carte doit proposer

        - returns: la carte nouvellement créée
    */
	func creerCarte(nom: String, estCouleurJoueur1: Bool, _ mouvements : (Int, Int) ... ) -> Carte

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
    */
	var plateau: Plateau { get set }
}