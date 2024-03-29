/**
    Ce protocol représente un pion du jeu. Un pion appartient à un joueur, se situe à une certaine position
    sur le plateau et est en vie ou pas.
*/
public protocol Pion {

    /**
        Crée un pion.

        - important: x appartient à [0 ; 4] et y appartient à [0 ; 4], si ce n'est pas le cas, la méthode émet une erreur fatale

        - parameters:
            - estMaitre: `true` si le pion est un maître, sinon `false`
            - joueur: Le joueur auquel appartient ce pion
            - position: La position du pion sur le plateau

        Suite à l'appel `init(estMaitre: estMaitre, joueur: joueur, position: position)` on a :

            self.estMaitre == estMaitre
            self.joueur.estJoueur1() == joueur.estJoueur1()
            self.position == position
            self.enVie == true
    */
    init(estMaitre: Bool, joueur: Joueur, position: (Int, Int)) 

    /**
        Indique si le pion est un maître.

        - returns: `true` si le pion est un maitre, sinon `false`
    */
	var estMaitre: Bool { get }

    /**
        Indique à quel joueur appartient le pion.

        - returns: le joueur auquel appartient ce pion
    */
	var joueur: Joueur { get }

    /**
        Indique si pion est toujours en vie. C'est à dire qu'il ne s'est pas encore
        fait manger par un autre pion.

        - returns: `true` si le pion est en vie, sinon `false`
    */
	var enVie: Bool { get }

    /**
        Indique la position du pion sur le plateau.

        Dans le cas d'utilisation du set, le tuple donné est de la forme (x, y) avec x appartenant à [0 ; 4] et y
        appartenant à [0 ; 4]. Si x ou y ne respectent pas ces conditions, alors on doit déclencher une erreur fatale.

        Lors de l'utilisation du get, on s'attend à ce que le retour soit égal à la position donnée précédemment
        lors de l'utilisation du set.

        - important: La position est un tuple de la forme (x, y) avec x appartenant à [0 ; 4] et y appartenant à [0 ; 4]

        - returns: un tuple d'entier, le premier élément du tuple est la position x et le second élement du tuple est y
    */
	var position: (Int, Int) { get set }

    /**
        Tue le pion.
        Si le pion n'est pas en vie (`self.enVie == false`), alors cette méthode ne fait rien.
        Si le pion est en vie (`self.enVie == true`), alors cette méthode fait le nécessaire pour que les
        appels suivant à `self.enVie` renvoient `false`.

        - important: `self.tuer() => self.enVie == false`
    */
	mutating func tuer()

}