/**
	Ce protocol représente un joueur de la partie. Un joueur possède deux cartes et
	un ensemble de pions.
*/
protocol Joueur {

	/**
		Indique si ce joueur est le joueur 1.

		estJoueur1() == true si self représente le joueur 1
		estJoueur1() == false si self représente le joueur 2

		- returns: true si ce joueur est le joueur 1, sinon false
	*/
	func estJoueur1() -> Bool

	/**
		Indiques quelles cartes ce joueur possède.

		Dans le cas d'utilisation du get, on s'attend à ce que le retour soit égal à au tuple donné précédemment
		lors de l'appel du set.
		Dans le cas où set n'a pas été appelé, alors get émet une erreur.

		- returns: un tuple de deux cartes qui sont les deux cartes que possède ce joueur à ce moment de la partie
	*/
	var cartes: (Carte, Carte) { get set }

	/**
		Indiques quels pions sont possédés par le joueur.
		Si self.ajouterPion n'a jamais été appelé, alors self.pions retourne un tableau vide.

		Pour tout p dans self.pions:
			p.joueur.estJoueur1() == self.estJoueur1()

		- returns: un tableau de pions possédés par le joueur.
	*/
	var pions: [Pion] { get }

	/**
		Ajoute un pion possédé par ce joueur.

		Pre-condition: pion.joueur.estJoueur1() == self.estJoueur1()

		- parameters:
			- pion: Le pion à ajouter à la collection des pions possédés par le joueur
		
		self.ajouterPion(pion: p) => self.pions contient p
	*/
	mutating func ajouterPion(pion: Pion)

}