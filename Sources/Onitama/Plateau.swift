/**
	Ce protocol représente le plateau de jeu, c'est à dire une grille de 5x5 cases. Sur chaque case de
	cette grille on peut ou pas trouver un pion.
	On désigne la case tout en haut à gauche comme (0,0).
	On désigne la case tout en bas à droite comme (4, 4).

	On peut se représenter les positions sur le plateau de la manière suivante :
	
	y\x 0  1  2  3  4
	0   -  -  -  -  -
	1   -  -  -  -  -
	2   -  -  -  -  -
	3   -  -  -  -  -
	4   -  -  -  -  -

*/
protocol Plateau {

	/**
		Indique quel pion se trouve à la position (x, y).

		- important: x appartient à [0 ; 4] et y appartient à [0 ; 4], si ce n'est pas le cas, la méthode émet une erreur
		- important: s'il n'y a pas de pion à la position (x, y) alors cette méthode émet une erreur

		- parameters:
			- x: La coordonnée x du pion que l'on souhaite récupérer
			- y: La coordonnée y du pion que l'on souhaite récupérer

		- returns: le pion se trouvant à la position (x, y) sur le plateau.
	*/
	func getPionA(x: Int, y: Int) -> Pion

	/**
		Indique s'il y a un pion à la position (x, y).

		- important: x appartient à [0 ; 4] et y appartient à [0 ; 4], si ce n'est pas le cas, la méthode émet une erreur

		self.caseOccupe(x: x, y: y) == true => self.getPionA(x: x, y: y) renvoie un pion
		self.caseOccupe(x: x, y: y) == false => self.getPionA(x: x, y: y) émet une erreur
		
		Si self.setPionA(x: x, y: y, pion: pion) n'a jamais été appelé, alors self.caseOccupe(x: x, y: y) == false

		- parameters:
			- x: La coordonnée x de la case sur laquelle on veut savoir s'il y a un pion
			- y: La coordonnée y de la case sur laquelle on veut savoir s'il y a un pion

		- returns: true si un pion se situe à la position (x, y), sinon false
	*/
	func caseOccupe(x: Int, y: Int) -> Bool

	/**
		Place un pion à la position donnée (x, y).

		- important: x appartient à [0 ; 4] et y appartient à [0 ; 4], si ce n'est pas le cas, la méthode émet une erreur

		- parameters:
			- x: la coordonnée x de la case sur laquelle on veut placer le pion
			- y: la coordonnée y de la case sur laquelle on veut placer le pion
			- pion: le pion que l'on veut placer sur la case (x, y)

		Si setPionA(x: x, y: y, pion: pion) n'a jamais été appelé, alors self.caseOccupe(x: x, y: y) == false
		
		self.setPionA(x: x, y: y, pion: pion) => self.caseOccupe(x: x, y: y) == true
		self.setPionA(x: x, y: y, pion: pion) => pion.position == (x, y)
	*/
	mutating func setPionA(x: Int, y: Int, pion: inout Pion)

}