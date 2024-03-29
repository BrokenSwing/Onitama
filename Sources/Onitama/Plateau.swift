/**
	Ce protocol représente le plateau de jeu, c'est à dire une grille de 5x5 cases. Sur chaque case de
	cette grille on peut ou pas trouver un pion.

	On désigne la case tout en haut à gauche comme (0, 0).
	On désigne la case tout en haut à droite comme (4, 0).
	On désigne la case tout en bas à gauche comme (0, 4).
	On désigne la case tout en bas à droite comme (4, 4).

	Les positions sont des couples (x, y) appartenant à [0, 4]*[0, 4].

*/
public protocol Plateau {

	/**
		Créer un plateau initialisé avec les pions placés sur leur case de départ.

		C'est à dire que pour tout (x, y) appartenant à [0, 4]*[1, 3] on a :

			caseOccupe(x: x, y: y) == false

		Et pour tout x appartenant à {0, 1, 3, 4}:

			caseOccupe(x: x, y: 0) == true && 
			getPionA(x: x, y: 0).joueur.estJoueur1() == false &&
			getPionA(x: x, y: 0).estMaitre == false
			
		Et :

			caseOccupe(x: 2, y: 0) == true &&
			getPionA(x: 2, y: 0).joueur.estJoueur1() == false &&
			getPionA(x: 2, y: 0).estMaitre == true

		Et pour tout x appartenant à {0, 1, 3, 4}:

			caseOccupe(x: x, y: 4) == true && 
			getPionA(x: x, y: 4).joueur.estJoueur1() == true &&
			getPionA(x: x, y: 4).estMaitre == false
			
		Et :

			caseOccupe(x: 2, y: 4) == true &&
			getPionA(x: 2, y: 4).joueur.estJoueur1() == true &&
			getPionA(x: 2, y: 4).estMaitre == true	
		
		- parameters:
			- joueur1: Un joueur tel que `joueur1.estJoueur1() == true`
			- joueur2: Un joueur tel que `joueur2.estJoueur1() == false`

	*/
	init(joueur1: Joueur, joueur2: Joueur)

	/**
		Indique quel pion se trouve à la position (x, y).

		- important: x appartient à [0 ; 4] et y appartient à [0 ; 4], si ce n'est pas le cas, la méthode émet une erreur fatale.
		- important: s'il n'y a pas de pion à la position (x, y) alors cette méthode émet une erreur fatale.
		- important: s'il y a un pion `p` à la position (x, y) et `p.enVie == false` alors cette méthode émet une erreur fatale.

		- parameters:
			- x: La coordonnée x du pion que l'on souhaite récupérer
			- y: La coordonnée y du pion que l'on souhaite récupérer

		- returns: le pion `p` se trouvant à la position (x, y) sur le plateau tel que `p.enVie == true`
	*/
	func getPionA(x: Int, y: Int) -> Pion

	/**
		Indique s'il y a un pion à la position (x, y).

		- important: x appartient à [0 ; 4] et y appartient à [0 ; 4], si ce n'est pas le cas, la méthode émet une erreur fatale.

		De plus :

			self.caseOccupe(x: x, y: y) == true => self.getPionA(x: x, y: y) renvoie un pion
			self.caseOccupe(x: x, y: y) == false => self.getPionA(x: x, y: y) émet une erreur fatale.

		- parameters:
			- x: La coordonnée x de la case sur laquelle on veut savoir s'il y a un pion
			- y: La coordonnée y de la case sur laquelle on veut savoir s'il y a un pion

		- returns: `true` si un pion se situe à la position (x, y), sinon `false`
	*/
	func caseOccupe(x: Int, y: Int) -> Bool

	/**
		Bouge le pion donné vers la position donnée.

		Lors de l'appel: `self.bougerPion(pion: pion, x: x, y: y)`

		* Si le pion n'est pas autorisé à bouger:
		
		C'est à dire que la position donnée est hors du plateau : 

			x < 0 || x > 4 || y < 0 || y > 4)
		
		ou que la case vers laquelle on veut bouger le pion est occupée et que le pion appartient au même joueur :
		
			self.caseOccupe(x: x, y: y) && self.getPionA(x: x, y: y).joueur.estJoueur1() == pion.joueur.estJoueur1()
		
		ou que le pion est mort:
		
			pion.enVie == false
		
		Alors cette méthode émet une erreur fatale.

		* Si le pion est autorisé à bouger:
				
		C'est à dire vers la position donnée est une case vide:
		
			self.caseOccupe(x: x, y: y) == false
		
		ou que la case est occupée par un pion adverse:

			self.caseOccupe(x: x, y: y) && self.getPionA(x: x, y: y).joueur.estJoueur1() != pion.joueur.estJoueur1()
		
		Alors en considérant :

			let (ancienX, ancienY) = pion.position

		On a suite à l'appel de `self.bougerPion(pion: pion, x: x, y: y)` :

			pion.position == (x, y)
			self.caseOccupe(x: ancienX, y: ancienY) == false
			self.caseOccupe(x: x, y: y) == true
			self.getPionA(x: x, y: y) === pion
			self.getPionA(x: x, y: y).joueur.estJoueur1() == pion.joueur.estJoueur1()

		Et si la case était occupée par un pion `p` adverse :

			self.caseOccupe(x: x, y: y) && self.getPionA(x: x, y: y).joueur.estJoueur1() != pion.joueur.estJoueur1()

		Alors on a aussi, suite à l'appel de `self.bougerPion(pion: pion, x: x, y: y)` :

			p.estVie == false

	*/
	mutating func bougerPion(pion: inout Pion, x: Int, y: Int)

	/**
		Indiques quels mouvements sont permis par le joueur donné en utilisant la carte donnée.

		C'est à dire que cette méthode vérifie pour chaque mouvement permis par la carte s'il existe
		au moins un pion du joueur qui soit encore en vie et qui puisse se déplacer en utilisant ce mouvement.

		Un pion peut se déplacer selon un mouvement si se mouvement ne l'emmène pas en dehors du plateau de jeu
		ou que le mouvement ne l'emmène pas sur la case d'un pion allié.

		Un mouvement est considéré emmenant en dehors du plateau si pour un pion `p` et un mouvement `m` :

			let (x, y) = pion.position
			let (dx, dy) = m
			0 <= (x + dx) <= 4
			0 <= (y - dy) <= 4

		Un mouvement est considéré emmenant sur la case d'un pion allié si pour un pion `p` et un mouvement `m` :

			// Le mouvement n'emmène pas en dehors du plateau ET
			let (x, y) = pion.position
			let (dx, dy) = m
			self.caseOccupe(x: x + dx, y: y - dy) && self.getPionA(x: x + dx, y: y - dy).estJoueur1() == joueur.estJoueur1()

		- parameters:
			- joueur: Le joueur qui veut utiliser la carte
			- carte: La carte que veut utiliser le joueur

		- returns: une liste contenant les mouvements proposés par la carte qui sont réalisables par au moins un pion du joueur passé en paramètre
	*/
	func mouvementsPermis(par joueur: Joueur, enUtilisant carte: Carte) -> [(Int, Int)]

	/**
		Indiques quels mouvement sont permis par le pion donné en utilisant la carte donnée.

		Pour savoir ce qu'est un mouvement valide pour un pion, référez vous à la méthode `mouvementsPermis`.

		- parameters:
			- pion: Le pion pour lequel on veut récupérer les mouvements permis avec la carte donnée
			- carte: La carte avec laquelle on veut déplacer le pion

		- returns: une liste de mouvements possibles pour le pion donné en utilisant la carte donnée
	*/
	func mouvementsPermisPion(par pion: Pion, enUtilisant carte: Carte) -> [(Int, Int)]

}