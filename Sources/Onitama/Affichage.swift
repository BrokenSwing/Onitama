class Affichage {

	private var onitama: Onitama
	private var joueur1: Joueur
	private var joueur2: Joueur
	private var joueurActuel: Joueur
	private var carteFlottante: Carte

	/**
		Crée une interface utilisateur pour le controlleur donné.

		- parameters:
			- onitama: Le controlleur du jeu
	*/
	init(onitama: Onitama) {
		self.onitama = onitama
		self.joueur1 = onitama.creerJoueur1()
		self.joueur2 = onitama.creerJoueur2()
		self.joueurActuel = self.joueur1

		for i in [0, 1, 3, 4] {
			self.onitama.creerPion(estMaitre: false, appartientA: &self.joueur1, x: i, y: 4)
			self.onitama.creerPion(estMaitre: false, appartientA: &self.joueur2, x: i, y: 0)
		}
		self.onitama.creerPion(estMaitre: true, appartientA: &self.joueur1, x: 2, y: 4)
		self.onitama.creerPion(estMaitre: true, appartientA: &self.joueur2, x: 2, y: 0)

		var cartes : [Carte] = []
		cartes.append(self.onitama.creerCarte(nom: "Lapin", (-1, -1), (1, 1), (2, 0)))
		cartes.append(self.onitama.creerCarte(nom: "Boeuf", (0, 1), (1, 0), (0, -1)))
		cartes.append(self.onitama.creerCarte(nom: "Elephant", (-1, 0), (1, 0), (-1, 1), (1, 1)))
		cartes.append(self.onitama.creerCarte(nom: "Cobra", (-1, 0), (1, 1), (1, -1)))
		cartes.append(self.onitama.creerCarte(nom: "Dragon", (-1, -1), (1, -1), (-2, 1), (2, 1)))
		cartes.append(self.onitama.creerCarte(nom: "Tigre", (0, 2), (0, -1)))

		cartes = self.onitama.tirer5Carte(parmi: cartes)
		self.joueur1.cartes = (cartes[0], cartes[1])
		self.joueur2.cartes = (cartes[2], cartes[3])
		self.carteFlottante = cartes[4]
	}

	/**
		Lance la partie.
		Ceci lance la boucle principale du jeu qui va tourner tant que le jeu ne sera pas terminée.
	*/
	func lancerPartie() {
		while !self.onitama.estTermine() {

			if self.joueurActuel.estJoueur1() {
				print("C'est le tour du JOUEUR 1")
			} else {
				print("C'est le tour du JOUEUR 2")
			}

			var numCarteChoisie: Int = self.faireChoixCarte()
			var (carte1, carte2) = self.joueurActuel.cartes

			let mvtCarte1 = self.onitama.plateau.mouvementsPermis(par: self.joueurActuel, enUtilisant: carte1)
			let mvtCarte2 = self.onitama.plateau.mouvementsPermis(par: self.joueurActuel, enUtilisant: carte2)

			// Le joueur peut bouger un pion
			if !mvtCarte1.isEmpty || !mvtCarte2.isEmpty {
				var choixPion: Pion? = nil
				while choixPion == nil {
					choixPion = self.faireChoixPion(carte: numCarteChoisie == 1 ? carte1 : carte2)
				}

				var choixMouvement = self.faireChoixMouvement(carte: numCarteChoisie == 1 ? carte1 : carte2, pion: choixPion!)

				let (px, py) = choixPion!.position
				let (dx, dy) = choixMouvement
				let nx = px + dx
				let ny = px + dy

				if self.onitama.plateau.caseOccupe(x: nx,  y: ny) {
					self.onitama.plateau.getPionA(x: nx, y: ny).tuer()
				}
				self.onitama.plateau.bougerPion(pion: choixPion!, x: nx, y: ny)
			}

			let carteFlot = self.onitama.carteFlottante
			self.onitama.carteFlottante = numCarteChoisie == 1 ? carte1 : carte2
			self.joueurActuel.cartes = (numCarteChoisie == 1 ? carte2 : carte1, carteFlot)

			self.changerDeJoueur()
		}

		self.afficherPlateau()
	}

	private func faireChoixMouvement(carte: Carte, pion: Pion) -> (Int, Int) {
		var mvtPossibles = self.onitama.plateau.mouvementsPermisPion(par: pion, enUtilisant: carte)

		for (index, el) in 1 ..< mvtPossibles.enumerated() {
			let (x, y) = el
			print("\(index). \(x)/\(y)")
		}
		print("Choisissez le mouvement que vous voulez opérer :")

		guard let choixMoveStr = readLine() else {
			return faireChoixMouvement(carte: carte, pion: Pion)
		}

		guard let choixMove: Int = Int(choixMoveStr) else {
			print("Ceci n'est pas entier. Ré-essayez !")
			return faireChoixMouvement(carte: carte, pion: Pion)
		}

		if choixMove < 0 || choixMove > mvtPossibles.count {
			print("Ceci n'est pas un choix valide. Ré-essayez !")
			return faireChoixMouvement(carte: carte, pion: Pion)
		}

		return mvtPossibles[choixMove]
	}

	private func faireChoixPion(carte: Carte) -> Pion? {
		print("Le plateau :")
		self.afficherPlateau()

		print("Entrez la coordonnée x du pion que vous voulez bouger :")

		guard let choixXStr = readLine() else {
			return nil
		}

		guard let choixX: Int = Int(choixXStr) else {
			print("Ceci n'est pas un entier.")
			return nil
		}

		print("Entrez la coordonnée y du pion que vous voulez bouger :")

		guard let choixYStr = readLine() else {
			return nil
		}

		guard let choixY: Int = Int(choixYStr) else {
			print("Ceci n'est pas un entier.")
			return nil
		}

		if choixX < 0 || choixX > 4 || choixY < 0 || choixY > 4 {
			print("Ces coordonnées sont en dehors du plateau")
			return nil
		}

		if !self.plateau.caseOccupe(x: choixX, y: choixY) {
			print("Il n'y a pas de pion à cette position")
			return nil
		}

		var pion = self.plateau.getPionA(x: choixX, y: choixY)
		
		if pion.joueur.estJoueur1() != self.joueurActuel.estJoueur1() {
			print("Ce pion n'est pas à vous. Choisissez un autre pion")
			return nil
		}

		var mvtPossibles = self.onitama.plateau.mouvementsPermisPion(par: Pion, enUtilisant: carte)
		if mvtPossibles.isEmpty {
			print("Vous ne pouvez pas effectuer de mouvements avec ce pion. Ré-essayez avec un autre pion")
			return nil
		}

		return pion

	}

	private func faireChoixCarte() -> Int {

		print("La carte flottante :")
		self.afficherCarte(self.onitama.carteFlottante)

		print("Vos cartes :")
		let (carte1, carte2) = self.joueurActuel.cartes

		let mvtCarte1 = self.onitama.plateau.mouvementsPermis(par: self.joueurActuel, enUtilisant: carte1)
		let mvtCarte2 = self.onitama.plateau.mouvementsPermis(par: self.joueurActuel, enUtilisant: carte2)
		let aucunMvtPossible = mvtCarte1.isEmpty && mvtCarte2.isEmpty

		if (aucunMvtPossible) {
			self.afficherCarte(carte: carte1)
			self.afficherCarte(carte: carte2)
		} else {
			if !mvtCarte1.isEmpty {
				print("Carte 1")
				self.afficherCarte(carte: carte1)
			}
			if !mvtCarte1.isEmpty {
				print("Carte 2")
				self.afficherCarte(carte: carte2)
			}
		}

		if aucunMvtPossible {
			print("Vous ne pouvez pas vous déplacer en utilisant vos cartes. Vous devez forcément échanger avec une de vos carte.")
		}
		print("Choisissez votre carte (1 ou 2): ")

		guard let choixCarteStr: String = readLine() else {
			fatalError("Pas d'entrée utilisateur reçu")
		}

		guard let choixCarte: Int = Int(choixCarteStr) else {
			print("Le choix donné n'est pas un entier. Ré-essayez !")
			return faireChoixCarte()
		}

		if choixCarte == 1 && (aucunMvtPossible || !mvtCarte1.isEmpty) {
			print("Vous avez choisi la carte \(carte1.nom)")
			return 1
		}

		if choixCarte == 2 && (aucunMvtPossible || !mvtCarte2.isEmpty) {
			print("Vous avez choisi la carte \(carte2.nom)")
			return 2
		}

		print("Vous devez indiquer 1 ou 2. Le choix \(choixCarte) n'est pas un choix valide.")
		return faireChoixCarte()
	}

	private func changerDeJoueur() {
		if self.joueurActuel.estJoueur1() {
			self.joueurActuel = self.joueur2
		} else {
			self.joueurActuel = joueur1
		}
	}

	private func afficherCarte(carte: Carte) {
		var matriceAffichage = Array(repeating: Array(repeating: "-", count: 5), count: 5)
		matriceAffichage[2][2] = "\u{1B}[93mo\u{1B}[0m"

		for mouvement in carte.mouvements {
			let (dx, dy) = mouvement
			matriceAffichage[2 - dy][2 + dx] = "\u{1B}[92mx\u{1B}[0m"
		}

		var message = ""
		for i in 0 ..< 5 {
			for j in 0 ..< 5 {
				message += matriceAffichage[i][j] + " "
			}
			message += "\r\n"
		}
		print("\(carte.nom) :")
		print(message)
	}

	private func afficherPlateau() {
		var message = ""
		let plateau = self.onitama.plateau
		for y in 0 ..< 5 {
			for x  in 0 ..< 5 {
				if plateau.caseOccupe(x: x, y: y) {
					let pion = plateau.getPionA(x: x, y: y)
					let sigle = pion.estMaitre ? "O" : "o"
					if pion.joueur.estJoueur1() {
						message += "\u{1B}[96m\(sigle)\u{1B}[0m "
					} else {
						message += "\u{1B}[95m\(sigle)\u{1B}[0m "
					}
				} else {
					message += "- "
				}
			}
			message += "\n"
		}
		print(message)
	}

}
