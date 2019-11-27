protocol Onitama {
	func creerJoueur1() -> Joueur
	func creerJoueur2() -> Joueur
	mutating func creerPion(estMaitre: Bool, appartientA joueur: inout Joueur, x: Int, y: Int)
	func creerCarte(nom: String, _ mouvements : (Int, Int) ... ) -> Carte
	var carteFlottante: Carte { get set } // Si set n'a jamais été appelé, alors get produit une erreur fatale, sinon get renvoie la carte donnée précédemment via set
	// Tableau de 16 cartes en entrée, tableau de 5 cartes en sortie
	func tirer5Carte(parmi cartes: [Carte]) -> [Carte]
	func estTermine() -> Bool
	var plateau: Plateau { get }
}