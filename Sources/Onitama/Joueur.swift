/**
	Ce protocol représente un joueur de la partie. Un joueur possède deux cartes et
	un ensemble de pions.
*/
public protocol Joueur {

	/**
		Crée un joueur.

		- parameters:
			- estJoueur1: `true` si ce joueur est le joueur 1, sinon `false`

		Suite à l'appel `init(estJoueur1: estJoueur1)` on a :

			self.estJoueur1 == estJoueur1
			// l'accès à self.cartes émet une erreur fatale
	*/
	init(estJoueur1: Bool)

	/**
		Indique si ce joueur est le joueur 1.

		`estJoueur1() == true` si self représente le joueur 1

		`estJoueur1() == false` si self représente le joueur 2

		- returns: true si ce joueur est le joueur 1, sinon false
	*/
	func estJoueur1() -> Bool

	/**
		Indiques quelles cartes ce joueur possède.

		Dans le cas d'utilisation du get, on s'attend à ce que le retour soit égal à au tuple donné précédemment
		lors de l'appel du set.
		Dans le cas où set n'a pas été appelé, alors get émet une erreur fatale.

		- returns: un tuple de deux cartes qui sont les deux cartes que possède ce joueur à ce moment de la partie
	*/
	var cartes: (Carte, Carte) { get set }

}