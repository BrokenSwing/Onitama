protocol Pion {
	var estMaitre: Bool { get }
	var joueur: Joueur { get }
	var enVie: Bool { get }
	var position: (Int, Int) { get set }
	mutating func tuer()
}