/**
	Ce protocol représente une carte de mouvement.
*/
protocol Carte {

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
}