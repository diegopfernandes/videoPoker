//----------------------//----------------------
import UIKit
//----------------------//----------------------
class ViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel! //--connection pour le label que marque la combination des cards "bonne chance" au debut et apres "rien" ou le titre de la combination, si il y a une
    //---connection pour les back des cards
    @IBOutlet weak var slot_1: UIImageView!
    @IBOutlet weak var slot_2: UIImageView!
    @IBOutlet weak var slot_3: UIImageView!
    @IBOutlet weak var slot_4: UIImageView!
    @IBOutlet weak var slot_5: UIImageView!
    //---variable pour les images de "blur" (animation)
    var card_blur_1: UIImage!
    var card_blur_2: UIImage!
    var card_blur_3: UIImage!
    var card_blur_4: UIImage!
    var card_blur_5: UIImage!
    //---connection pour les slots
    @IBOutlet weak var bg_1: UIView!
    @IBOutlet weak var bg_2: UIView!
    @IBOutlet weak var bg_3: UIView!
    @IBOutlet weak var bg_4: UIView!
    @IBOutlet weak var bg_5: UIView!
    //---connection pour le label "garder"
    @IBOutlet weak var keep_1: UILabel!
    @IBOutlet weak var keep_2: UILabel!
    @IBOutlet weak var keep_3: UILabel!
    @IBOutlet weak var keep_4: UILabel!
    @IBOutlet weak var keep_5: UILabel!
    //---connetcion pour le boutton distribue et les labels de credits
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    //---cartes "blur" pour l'animation
    var arrOfCardImages: [UIImage]!
    //---tableau des images pour le slot
    var arrOfSlotImageViews: [UIImageView]!
    //---toople pour les cartes que seront montrés (intier + chaine de characteres)
    var deckOfCards = [(Int, String)]()
    //---arrier des carts
    var arrOfBackgrounds: [UIView]!
    //---label garder
    var arrOfKeepLabels: [UILabel]!
    //---seletioner les cartes, label mise et credit
    var permissionToSelectCards = false
    var bet = 0
    var credits = 2000
    //---numero de fois que le jeueur a joue
    var chances = 2
    //---class sauvegarder les scores
    let saveScore = UserDefaultsManager()
    //---class pour gerer les objects
    let pokerHands = PokerHands()
    //---toople pour verifier la combination des cartes
    var handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
    //---toople pour les cartes que sont montrées (hand)
    var theHand = [(Int, String)]()
    //----------------------/methode/----------------------
    override func viewDidLoad() {
        //---
        super.viewDidLoad()
        //---appelle le class au debut pour montrer les crédits
        if !saveScore.doesKeyExist(theKey: "credits"){
            saveScore.setKey(theValue: 2000 as AnyObject, theKey: "credits")
        }else{
            credits = saveScore.getValue(theKey: "credits") as! Int
        }
        //---choisir les cartes pour l'animation
        createCardObjectsFromImages()
        //---
        fillUpArrays()
        //---
        prepareAnimations(duration: 0.5,
                          repeating: 5,
                          cards: arrOfCardImages)
        //---
        stylizeSlotImageViews(radius: 10,
                              borderWidth: 0.5,
                              borderColor: UIColor.black.cgColor,
                              bgColor: UIColor.yellow.cgColor)
        //---
        stylizeBackgroundViews(radius: 10,
                               borderWidth: nil,
                               borderColor: UIColor.black.cgColor,
                               bgColor: nil)
        //---
        createDeckOfCards()
        //---
    }
    //----------------------/func pour la creation du deck de cartes/----------------------
    func createDeckOfCards() {
        deckOfCards = [(Int, String)]()
        for a in 0...3 {
            let suits = ["d", "h", "c", "s"]
            for b in 1...13 {
                deckOfCards.append((b, suits[a]))
            }
        }
    }
    //----------------------/style des cartes que sont selectionées/----------------------
    func stylizeSlotImageViews(radius r: CGFloat,
                               borderWidth w: CGFloat,
                               borderColor c: CGColor,
                               bgColor g: CGColor!) {
        for slotImageView in arrOfSlotImageViews {
            slotImageView.clipsToBounds = true
            slotImageView.layer.cornerRadius = r
            slotImageView.layer.borderWidth = w
            slotImageView.layer.borderColor = c
            slotImageView.layer.backgroundColor = g
        }
    }
    //----------------------/style pour le background/----------------------
    func stylizeBackgroundViews(radius r: CGFloat,
                                borderWidth w: CGFloat?,
                                borderColor c: CGColor,
                                bgColor g: CGColor?) {
        for bgView in arrOfBackgrounds {
            bgView.clipsToBounds = true
            bgView.layer.cornerRadius = r
            bgView.layer.borderWidth = w ?? 0
            bgView.layer.borderColor = c
            bgView.layer.backgroundColor = g
        }
    }
    //----------------------/selectioner les images pour les cartes/----------------------
    func fillUpArrays() {
        arrOfCardImages = [card_blur_1, card_blur_2, card_blur_3, card_blur_4,
                           card_blur_5]
        arrOfSlotImageViews = [slot_1, slot_2, slot_3, slot_4, slot_5]
        arrOfBackgrounds = [bg_1, bg_2, bg_3, bg_4, bg_5]
        arrOfKeepLabels = [keep_1, keep_2, keep_3, keep_4, keep_5]
    }
    //----------------------/func pour les cartes de l'animation/----------------------
    func createCardObjectsFromImages() {
        card_blur_1 = UIImage(named: "blur_1.png")
        card_blur_2 = UIImage(named: "blur_2.png")
        card_blur_3 = UIImage(named: "blur_3.png")
        card_blur_4 = UIImage(named: "blur_4.png")
        card_blur_5 = UIImage(named: "blur_4.png")
    }
    //----------------------/func pour determiner les parametres de l'animation/----------------------
    func prepareAnimations(duration d: Double,
                           repeating r: Int,
                           cards c: [UIImage]) {
        for slotAnimation in arrOfSlotImageViews {
            slotAnimation.animationDuration = d
            slotAnimation.animationRepeatCount = r
            slotAnimation.animationImages = returnRandomBlurCards(arrBlurCards: c)
        }
    }
    //----------------------/randomization des cartes/----------------------
    func returnRandomBlurCards(arrBlurCards: [UIImage]) -> [UIImage] {
        var arrToReturn = [UIImage]()
        var arrOriginal = arrBlurCards
        for _ in 0..<arrBlurCards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(arrOriginal.count)))
            arrToReturn.append(arrOriginal[randomIndex])
            arrOriginal.remove(at: randomIndex)
        }
        return arrToReturn
    }
    //----------------------/le boutton pour jouer les carts/----------------------
    @IBAction func play(_ sender: UIButton) {
        //---
        if chances == 0 || dealButton.alpha == 0.5 {
            return
        } else {
            chances = chances - 1
        }
        //---si touts les cartes sont selecionnées, il n'y a pas l'animation
        var allSelected = true
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                allSelected = false
                break
            }
        }
        if allSelected {
            displayRandomCards()
            return
        }
        //---border pour les cartes garders
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                slotAnimation.startAnimating()
            }
        }
        //---temps pour l'animation
        Timer.scheduledTimer(timeInterval: 2.75,
                             target: self,
                             selector: #selector(displayRandomCards),
                             userInfo: nil,
                             repeats: false)
    }
    //----------------------/randomization des cartes/----------------------
    @objc func displayRandomCards() {
        //---
        theHand = returnRandomHand()
        //---
        let arrOfCards = createCards(theHand: theHand)
        //---
        displayCards(arrOfCards: arrOfCards)
        //---
        permissionToSelectCards = true
        //---
        prepareForNextHand()
        //---
    }
    //----------------------/cette methode est pra preparer la main prochaine/----------------------
    func prepareForNextHand() {
        //---
        if chances == 0 {
            permissionToSelectCards = false
            dealButton.alpha = 0.5
            resetCards()
            createDeckOfCards()
            handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
            chances = 2
            bet = 0
            betLabel.text = "MISE : 0"
        }
        //---
    }
    //----------------------/analiser les cartes apres qu'on n'a plus de chance (2 animations/----------------------
    func displayCards(arrOfCards: [String]) {
        //---
        var counter = 0
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1 {
                if chances == 0 {
                    handToAnalyse = removeEmptySlotsAndReturnArray()
                    handToAnalyse.append(theHand[counter])
                }
                //---
                slotAnimation.image = UIImage(named: arrOfCards[counter])
            }
            counter = counter + 1
        }
        //---
        if chances == 0 {
            verifyHand(hand: handToAnalyse)
        }
        //---
    }
    //----------------------/enlever les cartes vides/----------------------
    func removeEmptySlotsAndReturnArray() -> [(Int, String)] {
        var arrToReturn = [(Int, String)]()
        for card in handToAnalyse {
            if card != (0, "") {
                arrToReturn.append(card)
            }
        }
        return arrToReturn
    }
    //----------------------/Créer les cartes/----------------------
    func createCards(theHand: [(Int, String)]) -> [String] {
        //---
        let card_1 = "\(theHand[0].0)\(theHand[0].1).png"
        let card_2 = "\(theHand[1].0)\(theHand[1].1).png"
        let card_3 = "\(theHand[2].0)\(theHand[2].1).png"
        let card_4 = "\(theHand[3].0)\(theHand[3].1).png"
        let card_5 = "\(theHand[4].0)\(theHand[4].1).png"
        return [card_1, card_2, card_3, card_4, card_5]
        //---
    }
    //----------------------/5 cartes au hasard/----------------------
    func returnRandomHand() -> [(Int, String)] {
        //---
        var arrToReturn = [(Int, String)]()
        //---
        for _ in 1...5 {
            let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
            arrToReturn.append(deckOfCards[randomIndex])
            deckOfCards.remove(at: randomIndex)
        }
        //---
        return arrToReturn
        //---
    }
    //----------------------/verifier les combinations et que se passe/----------------------
    func verifyHand(hand: [(Int, String)]) {
        if pokerHands.royalFlush(hand: hand) {
            calculateHand(times: 250, handToDisplay: "QUINTE FLUSH ROYALE")
        } else if pokerHands.straightFlush(hand: hand) {
            calculateHand(times: 50, handToDisplay: "QUINTE FLUSH")
        } else if pokerHands.fourKind(hand: hand) {
            calculateHand(times: 25, handToDisplay: "CARRÉ")
        } else if pokerHands.fullHouse(hand: hand) {
            calculateHand(times: 9, handToDisplay: "FULL")
        } else if pokerHands.flush(hand: hand) {
            calculateHand(times: 6, handToDisplay: "COULEUR")
        } else if pokerHands.straight(hand: hand) {
            calculateHand(times: 4, handToDisplay: "QUINTE")
        } else if pokerHands.threeKind(hand: hand) {
            calculateHand(times: 3, handToDisplay: "BRELAN")
        } else if pokerHands.twoPairs(hand: hand) {
            calculateHand(times: 2, handToDisplay: "DEUX PAIRES")
        } else if pokerHands.onePair(hand: hand) {
            calculateHand(times: 1, handToDisplay: "PAIRE")
        } else {
            calculateHand(times: 0, handToDisplay: "RIEN...")
        }
    }
    //----------------------/calcule pour les credits que sont gagné (ou non) apres les matches/----------------------
    func calculateHand(times: Int, handToDisplay: String) {
        credits += (times * bet)
        tempLabel.text = handToDisplay
        creditsLabel.text = "CRÉDITS: \(credits)"
    }
    //----------------------/func pour garder les cartes selectionées/----------------------
    @IBAction func cardsToHold(_ sender: UIButton) {
        //---
        if !permissionToSelectCards {
            return
        }
        //---
        if arrOfBackgrounds[sender.tag].layer.borderWidth == 0.5 {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.0
            arrOfBackgrounds[sender.tag].layer.backgroundColor = nil
            arrOfKeepLabels[sender.tag].isHidden = true
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: false)
        } else {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 1.0
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderColor = UIColor.blue.cgColor
            arrOfBackgrounds[sender.tag].layer.backgroundColor = UIColor(red: 0.0,
                                                                         green: 0.0, blue: 1.0, alpha: 0.5).cgColor
            arrOfKeepLabels[sender.tag].isHidden = false
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: true)
        }
    }
    //----------------------/analiser les cartes/----------------------
    func manageSelectedCards(theTag: Int, shouldAdd: Bool) {
        if shouldAdd {
            handToAnalyse[theTag] = theHand[theTag]
        } else {
            handToAnalyse[theTag] = (0, "")
        }
    }
    //----------------------/bouton pour faire les pariers/----------------------
    @IBAction func betButtons(_ sender: UIButton) {
        //---
        if chances <= 1 {
            return
        }
        //---
        tempLabel.text = ""
        //---
        if sender.tag == 1000 {
            bet = credits
            betLabel.text = "MISE : \(bet)"
            credits = 0
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
            resetBackOfCards()
            return
        }
        //---
        let theBet = sender.tag
        //---
        if credits >= theBet {
            bet += theBet
            credits -= theBet
            betLabel.text = "MISE : \(bet)"
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
        }
        //---
        resetBackOfCards()
        //---
    }
    //----------------------/retourner le back des cartes/----------------------
    func resetBackOfCards() {
        for back in arrOfSlotImageViews {
            back.image = UIImage(named: "back.png")
        }
    }
    //----------------------/reseter les cartes pour une nouvelle match/----------------------
    func resetCards() {
        //---
        for index in 0...4 {
            arrOfSlotImageViews[index].layer.borderWidth = 0.5
            arrOfBackgrounds[index].layer.borderWidth = 0.0
            arrOfBackgrounds[index].layer.backgroundColor = nil
            arrOfKeepLabels[index].isHidden = true
        }
        //---
        chances = 2
        //---
    }
    //------bouton pour recommencer le jeux
    @IBAction func resetGame(_ sender: UIButton) {
        if sender.tag == 99 {
            bet = 0
            betLabel.text = "MISE : \(bet)"
            credits = 2000
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
            resetBackOfCards()
            tempLabel.text = "BONNE CHANCE!"
            return
        }

    
    //----------------------//----------------------
    }
//----------------------//----------------------
}
