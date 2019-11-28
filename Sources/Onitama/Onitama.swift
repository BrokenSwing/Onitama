/**
    Ce protocol représente le controlleur du jeu.
*/
protocol Onitama {

    /**
        Cette méthode crée le joueur 1 et le renvoie.

        self.creerJoueur1().estJoueur1() == true
    */
	func creerJoueur1() -> Joueur
    /**
        Cette méthode crée le joueur 2 et le renvoie.

        self.creerJoueur2().estJoueur1() == false
    */
	func creerJoueur2() -> Joueur

    /**
        Crée un pion à une position donnée, pour un joueur donné.

        - important: x appartient à [0 ; 4] et y appartient à [0 ; 4], si ce n'est pas le cas, la méthode émet une erreur

        - parameters:
            - estMaitre: true si le pion doit être un pion maitre, sinon false
            - appartientA joueur: le joueur auquel ce pion doit appartenir
            - x: la coordonnée x de la case sur laquelle doit se trouver le pion
            - y: la coordonnée y de la case sur laquelle doit se trouver le pion

        self.creerPion(estMaitre: m, appartientA: j, x: x, y: y) => creer une instance p du protocol Pion tel que :
            - p.estMaitre == m
            - p.joueur.estJoueur1() == j.estJoueur1()
            - p.pos == (x, y)
            - p est contenu dans j.pions
            - self.plateau.getPionA(x: x, y: y) est p
        
    */
	mutating func creerPion(estMaitre: Bool, appartientA joueur: inout Joueur, x: Int, y: Int)

    /**
        Crée une carte avec le nom donné et les mouvements donnés.

        - parameters:
            - nom: Le nom de la carte que l'on veut créer
            - _ mouvements: Les mouvements que la carte doit proposer

        let carte = self.creerCarte(nom: n, m1, m2, m3) => carte.nom == n && carte.mouvements == [m1, m2, m3]

        - returns: la carte nouvellement créée
    */
	func creerCarte(nom: String, _ mouvements : (Int, Int) ... ) -> Carte

    /**
        Indique quelle carte est actuellement la carte flottante, c'est à dire la seule des cinq cartes du jeu qui ne soit
        pas en possession d'un des deux joueurs.

        Lors de l'appel de get on s'attend à recevoir la carte donnée précédemment via un appel de set.
        Si set n'a jamais été appelé et qu'on appelle get, alors on émet une erreur.

        - returns: la carte flottante de la partie
    */
	var carteFlottante: Carte { get set }

    /**
        Tire 5 cartes au hasard parmi les cartes données.

        - parameters:
            - parmi cartes: Une liste de cartes parmi lesquelles les 5 cartes doivent être choisies
        
        Si la liste de carte donnée en paramètre possède moins de 5 cartes, alors cette méthode émet une erreur.

        - returns: une liste de 5 cartes tirées au hasard parmi les cartes données
    */
	func tirer5Carte(parmi cartes: [Carte]) -> [Carte]

    /**
        Indique si la partie est terminée.

        La partie est terminée si tout le pion maître d'un joueur est mort ou si n'importe que pion d'un joueur
        est arrivé sur la case temple de l'autre joueur.
        La case temple du joueur1 se trouve en (2, 4) et la case temple du joueur2 se trouve en (2, 0).

        - returns: true si la partie est terminée, sinon false
    */
	func estTermine() -> Bool

    /**
        Cette propriété est le tableau sur lequel se déroule la partie.
    */
	var plateau: Plateau { get }
}