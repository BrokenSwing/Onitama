protocol Pion {
	var estMaitre: Bool { get }
	var joueur: Joueur { get }
	var enVie: Bool { get }
	var position: (Int, Int) { get set }
	mutating func tuer()
}

protocol Plateau {
	// Pre: 0 <= x <= 5
	// Pre: 0 <= y <= 5
	// Renvoie le pion à la position donnée s'il y en a un, sinon émet une erreur fatale.
	// Si les préconditions ne sont pas respectées, le programme émet une erreur fatale
	func getPionA(x: Int, y: Int) -> Pion
	func caseOccupe(x: Int, y: Int) -> Bool
	mutating func setPionA(x: Int, y: Int, pion: inout Pion)
}

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

//////////////////////////////////////////////
////////////// IMPLEMENTATION ////////////////
//////////////////////////////////////////////

struct LeOnitama : Onitama {

	private var _carteFlottante: Carte?
	private var _plateau: Plateau

	init() {
		self._carteFlottante = nil
		self._plateau = LePlateau()
	}

	func creerJoueur1() -> Joueur {
		return LeJoueur(estJoueur1: true)
	}

	func creerJoueur2() -> Joueur {
		return LeJoueur(estJoueur1: false)
	}

	mutating func creerPion(estMaitre: Bool, appartientA joueur: inout Joueur, x: Int, y: Int) {
		var pion: Pion = LePion(estMaitre: estMaitre, joueur: joueur, pos: (x, y))
		joueur.ajouterPion(pion: pion)
		self._plateau.setPionA(x: x, y: y, pion: &pion)
	}

	func creerCarte(nom: String, _ mouvements : (Int, Int) ... ) -> Carte {
		var carte = LaCarte(nom: nom)
		for (x, y) in mouvements {
			carte.ajouterMouvement(x: x, y: y)
		}
		return carte
	}

	var carteFlottante: Carte {

		get {
			guard let carte: Carte = self._carteFlottante else {
				fatalError("Pas de carte flottante")
			}
			return carte
		} 

		set(value) {
			self._carteFlottante = value
		} 
	}

	func tirer5Carte(parmi cartes: [Carte]) -> [Carte] {
		var ret: [Carte] = []
		for i in 0..<5 {
			ret.append(cartes[i])
		}
		return ret
	}

	func estTermine() -> Bool {
		return false
	}

	var plateau: Plateau { return self._plateau }

}

class LePion : Pion {

	private var _enVie: Bool
	
	init(estMaitre: Bool, joueur: Joueur, pos: (Int, Int)) {
		self.estMaitre = estMaitre
		self.joueur = joueur
		self._enVie = true
		self.position = pos
	}
	
	let estMaitre: Bool
	
	let joueur: Joueur
	
	var enVie: Bool { return self._enVie }
	
	var position: (Int, Int)
	
	func tuer() {
		self._enVie = false
	}
}

class LeJoueur : Joueur {

	private var _cartes: (Carte, Carte)?
	private var _pions: [Pion]
	private var joueur1: Bool

	init(estJoueur1: Bool) {
		self._cartes = nil
		self._pions = []
		self.joueur1 = estJoueur1
	}

	var cartes: (Carte, Carte) { 

		get {
			guard let cs: (Carte, Carte) = self._cartes else {
				fatalError("Le joueur n'a pas de cartes")
			}
			return cs
		} 

		set(value) {
			self._cartes = value
		} 
	}
	
	var pions: [Pion] { return self._pions }
	
	func ajouterPion(pion: Pion) {
		self._pions.append(pion)
	}

	func estJoueur1() -> Bool {
		return self.joueur1
	}

}

struct LaCarte : Carte {

	private var _nom: String;
	private var _mouvements: [(Int, Int)]

	init(nom: String) {
		self._nom = nom
		self._mouvements = []
	}

	var nom: String { return self._nom }

	mutating func ajouterMouvement(x: Int, y: Int) {
		self._mouvements.append((x, y))
	}

	var mouvements: [(Int, Int)] { return self._mouvements }
}

class LePlateau : Plateau {

	private var plateau: [[Pion?]]

	init() {
		self.plateau = Array(repeating: Array(repeating: nil, count: 5), count: 5)
	}

	func getPionA(x: Int, y: Int) -> Pion {
		guard let pion = self.plateau[y][x] else {
			fatalError("Pas de pion dans cette case")
		}
		return pion
	}

	func setPionA(x: Int, y: Int, pion: inout Pion) {
		pion.position = (x, y)
		self.plateau[y][x] = pion
	}

	func caseOccupe(x: Int, y: Int) -> Bool {
		return self.plateau[y][x] != nil
	}

	func caseTemple(x: Int, y: Int) -> Bool {
		return true
	}

}

//////////////////////////////////////////////
///////////// FIN IMPLEMENTATION /////////////
//////////////////////////////////////////////

//////////////////////////////////////////////
/////////// PROGRAMME PRINCIPAL //////////////
//////////////////////////////////////////////

class Affichage {

	private var onitama: Onitama
	private var joueur1: Joueur
	private var joueur2: Joueur
	private var joueurActuel: Joueur
	private var carteFlottante: Carte

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

	func lancerPartie() {
		while !self.onitama.estTermine() {

			let carteChoisie = self.faireChoixCarte()
			self.afficherPlateau()

			self.changerDeJoueur()
		}
	}

	private func faireChoixCarte() -> Carte {
		let (carte1, carte2) = self.joueurActuel.cartes
		print("Choix de carte 1 :")
		self.afficherCarte(carte: carte1)
		print("Choix de carte 2 :")
		self.afficherCarte(carte: carte2)

		guard let choixCarteStr: String = readLine() else {
			fatalError("Pas d'entrée utilisateur reçu")
		}

		guard let choixCarte: Int = Int(choixCarteStr) else {
			print("Le choix donné n'est pas un entier. Ré-essayez !")
			return faireChoixCarte()
		}

		if choixCarte == 1 {
			print("Vous avez choisi la carte 1")
			return carte1
		}

		if choixCarte == 2 {
			print("Vous avez choisi la carte 2")
			return carte2
		}

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

let display = Affichage(onitama: LeOnitama())
display.lancerPartie()

/*

let onitama = Onitama()
let j1 = onitama.creerJoueur1()
let j2 = onitama.creerJoueur2()

// initialiser le plateau

let cartes = // Créer un tableau en swift
// Remplir de cartes

let cartesTirees: [Carte](5) = onitama.tirer5Carte(parmi: cartes)
j1.cartes = (cartesTirees[0], cartesTirees[1])
j2.cartes = (cartesTirees[2], cartesTirees[3])
onitama.carteFlottante = cartesTirees[4]

var joueurActuel = j1

while !onitama.estTermine() {

	print(onitama.plateau)
	print(joueurActuel.cartes)

	guard let choixCarte: String = readLine() else {
		fatalError("Oups.")
	}

	guard let choixCarte: Int = Int(choixCarte) else {
		print("Ceci n'est pas un numéro de carte, petit malin. Nice try !")
		continue
	}

	if choixCarte > 2 || choixCarte < 1 {
		print("Ceci n'est pas un choix correct")
		continue
	}

	let carteChoisie = 
	// Changement de joueur
	if joueurActuel === j1 {
		joueurActuel = j2
	} else {
		joueurActuel = j1
	}
}

*/
