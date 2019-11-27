protocol Joueur {
	func estJoueur1() -> Bool
	var cartes: (Carte, Carte) { get set }
	var pions: [Pion] { get }
	mutating func ajouterPion(pion: Pion)
}