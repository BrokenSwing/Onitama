/**
	Ce protocol représente une carte de mouvement.
*/
public protocol Carte {

	/**
		Crée une carte.

		- parameters:
			- nom: Le nom de la carte
			- mouvements: Les mouvements que la carte met à disposition
			- estCouleurJoueur1: `true` si cette carte est de la même couleur que le joueur 1, sinon `false`

		Suite à l'initialisation `init(nom: nom, mouvemements: mouvements, estCouleurJoueur1: estCouleurJoueur1)` on a :

			self.nom == nom
			self.mouvemements == mouvements
			self.estCouleurJoueur1 == estCouleurJoueur1
		
	*/
	init(nom: String, mouvements: [(Int, Int)], estCouleurJoueur1: Bool)

	/**
		Indique le nom de la carte.

		- returns: un String contenant le nom de la carte
	*/
	var nom: String { get }

	/**
		Indiques quels mouvements cette carte met à disposition.

		Un mouvement est représenté par une position relative au pion sur
		lequel on va l'appliquer. Un mouvement est donc un tuple de deux entiers
		(x, y) tels que x appartient à [-2 ; 2] et y appartient à [-2 ; 2].

		- returns: une liste de mouvements
	*/
	var mouvements: [(Int, Int)] { get }

	/**
		Indique si la couleur de la carte correspond à la couleur du joueur 1.
		Cette méthode sert pour savoir qui commence la partie, en effet, c'est le joueur
		dont la couleur correspond à la carte flottante qui commence la partie.
	*/
	var estCouleurJoueur1: Bool { get }

}