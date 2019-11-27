protocol Plateau {
	// Pre: 0 <= x <= 5
	// Pre: 0 <= y <= 5
	// Renvoie le pion à la position donnée s'il y en a un, sinon émet une erreur fatale.
	// Si les préconditions ne sont pas respectées, le programme émet une erreur fatale
	func getPionA(x: Int, y: Int) -> Pion
	func caseOccupe(x: Int, y: Int) -> Bool
	mutating func setPionA(x: Int, y: Int, pion: inout Pion)
}