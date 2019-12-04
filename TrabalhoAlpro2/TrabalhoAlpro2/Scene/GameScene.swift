//
//  GameScene.swift
//  TrabalhoAlpro2
//
//  Created by Marcus Vinicius Vieira Badiale on 27/11/19.
//  Copyright © 2019 Marcus Vinicius Vieira Badiale. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //API PORTAL LINK ----> http://deckofcardsapi.com/
    
    //MARK: - Variables
    var deckId = ""
    var remaining = 0
    var hand: [Card] = []
    var resp: Bool = false
    var gameCounter: Int = 0
    var handCounter: Int = 0
    var updateCounter: Int = 0
    var pile: Int = 0
    
    //
    var player1 = Player(name: "Vermelho", points: 0)
    var player2 = Player(name: "Azul", points: 0)
    
    //MARK: - Nodes
    var player1Button: SKSpriteNode?
    var player2Button: SKSpriteNode?
    var backgroundNode: SKSpriteNode?
    var cardNode: SKSpriteNode?
    var redCounterNode: SKLabelNode?
    var blueCounterNode: SKLabelNode?
    var redPointsNode: SKLabelNode?
    var bluePointsNode: SKLabelNode?
    
    //MARK: - DidMove to view
    override func didMove(to view: SKView) {
        createInitialNodes()
        createDeck()
    }
    
    //MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if resp {
            updateCounter += 1

            //90 são 1.5 segundos
            if updateCounter == 60 {
                remaining -= 1
                drawCard()

                gameCounter += 1
                let url = URL(string: hand[handCounter].image)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.cardNode?.texture = SKTexture(image: UIImage(data: data!) ?? UIImage())
                }
                redCounterNode?.text = "\(gameCounter)"
                blueCounterNode?.text = "\(gameCounter)"
                
                if remaining <= 5 {
                    if player1.points > player2.points {
                        createWinScreen(player: player1.name)
                    } else {
                        createWinScreen(player: player2.name)
                    }
                }

                handCounter += 1
                pile += 1
                if gameCounter >= 13 {
                    gameCounter = 0
                }
                updateCounter = 0
            }
        }
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var aux: Int = 0
        switch hand[handCounter-1].value {
        case "ACE":
            aux = 1
        case "JACK":
            aux = 11
        case "QUEEN":
            aux = 12
        case "KING":
            aux = 13
        default:
            aux = Int(hand[handCounter-1].value)!
        }

        guard let touch = touches.first else { return }

        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        switch touchedNode.name {
        case "Player1Button":
            if gameCounter == aux {
                print("o vermelho pegou \(pile) cartas")
                player1.points += pile
                redPointsNode?.text = "\(player1.points) pontos"
                pile = 0
            }
        case "Player2Button":
            if gameCounter == aux {
                print("o azul pegou \(pile) cartas")
                player2.points += pile
                bluePointsNode?.text = "\(player2.points) pontos"
                pile = 0
            }
        default:
            print("default")
        }
    }
    
    //MARK: - Auxiliares functions
    
    func createInitialNodes() {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        player1Button = SKSpriteNode(texture: nil, color: .red, size: CGSize(width: width * 0.9, height: height * 0.1))
        player1Button?.position = CGPoint(x: self.frame.midX, y: self.frame.minY + (player1Button?.size.height ?? CGFloat.zero))
        player1Button?.name = "Player1Button"
        //zPosition é a posicao no eixo z dos nodos, como é em 2d o Z é pra cima (Colocar nodos em cima dos outros)
        player1Button?.zPosition = 2
        
        player2Button = SKSpriteNode(texture: nil, color: .blue, size: CGSize(width: width * 0.9, height: height * 0.1))
        player2Button?.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - (player2Button?.size.height ?? CGFloat.zero))
        player2Button?.name = "Player2Button"
        player2Button?.zPosition = 2
        
        backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "background"), color: .clear, size: CGSize(width: width, height: height))
        backgroundNode?.position  = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        cardNode = SKSpriteNode(texture: nil, color: .black, size: CGSize(width: width * 0.5, height: height * 0.5))
        cardNode?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        cardNode?.zPosition = 2
        
        redCounterNode = SKLabelNode(text: "\(gameCounter)")
        redCounterNode?.position = CGPoint(x: self.frame.midX + (cardNode?.size.width ?? CGFloat.zero)*0.6 , y: self.frame.midY)
        redCounterNode?.adjustFontSizeForScreenSize(maxFontSize: 72)
        redCounterNode?.fontColor = .white
        redCounterNode?.fontName =  "system"
        redCounterNode?.zPosition = 10
        
        blueCounterNode = SKLabelNode(text: "\(gameCounter)")
        blueCounterNode?.position = CGPoint(x: self.frame.midX - (cardNode?.size.width ?? CGFloat.zero)*0.6 , y: self.frame.midY)
        blueCounterNode?.adjustFontSizeForScreenSize(maxFontSize: 72)
        blueCounterNode?.fontColor = .white
        blueCounterNode?.fontName =  "system"
        blueCounterNode?.zPosition = 10
        //zRotation é para rotacionar os nodos, e .pi é 180 graus
        blueCounterNode?.zRotation = .pi
        
        redPointsNode = SKLabelNode(text: "PONTOS")
        redPointsNode?.position = CGPoint(x: self.frame.midX, y: (player1Button?.position.y ?? CGFloat.zero) + (player1Button?.size.height ?? CGFloat.zero) * 0.6)
        redPointsNode?.adjustFontSizeForScreenSize(maxFontSize: 72)
        redPointsNode?.fontName =  "system"
        redPointsNode?.fontColor = .white
        redPointsNode?.zPosition = 10
        
        bluePointsNode = SKLabelNode(text: "PONTOS")
        bluePointsNode?.position = CGPoint(x: self.frame.midX, y: (player2Button?.position.y ?? CGFloat.zero) - (player2Button?.size.height ?? CGFloat.zero) * 0.6)
        bluePointsNode?.adjustFontSizeForScreenSize(maxFontSize: 72)
        bluePointsNode?.zRotation = .pi
        bluePointsNode?.fontName =  "system"
        bluePointsNode?.fontColor = .white
        bluePointsNode?.zPosition = 10
        
        addChild(player1Button ?? SKSpriteNode())
        addChild(player2Button ?? SKSpriteNode())
        addChild(backgroundNode ?? SKSpriteNode())
        addChild(cardNode ?? SKSpriteNode())
        addChild(redCounterNode ?? SKLabelNode())
        addChild(blueCounterNode ?? SKLabelNode())
        addChild(redPointsNode ?? SKLabelNode())
        addChild(bluePointsNode ?? SKLabelNode())
    }
    
    func createWinScreen(player: String) {
        
        resp = false
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let backgroundWinNode = SKSpriteNode(texture: nil, color: .black, size: CGSize(width: width, height: height))
        backgroundWinNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backgroundWinNode.alpha = 0.5
        backgroundWinNode.zPosition = 100
        
        let winLabel = SKLabelNode(text: "\(player) Ganhou")
        winLabel.fontName = "system"
        winLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        winLabel.adjustFontSizeForScreenSize(maxFontSize: 80)
        winLabel.zPosition = 101
        
        addChild(backgroundWinNode )
        addChild(winLabel)
    }
    
    //MARK: - Networking
    func createDeck(){
        let urlString = URL(string: "https://deckofcardsapi.com/api/deck/new/")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                } else {
                    do{
                        //here dataResponse received from a network request
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        guard let jsonArray = jsonResponse as? [String: Any] else {
                            return
                        }
                        //Now get title value
                        guard let title = jsonArray["deck_id"] as? String else { return }
                        self.deckId = title
                        guard let title2 = jsonArray["remaining"] as? Int else { return }
                        self.remaining = title2
                        self.shuffleCards()
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            task.resume()
        }
    }
    
        func shuffleCards(){
            let urlString = URL(string: "https://deckofcardsapi.com/api/deck/\(deckId)/shuffle/")
            
            if let url = urlString {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error ?? "")
                    } else {
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                            guard let jsonArray = jsonResponse as? [String: Any] else {
                                return
                            }
                            self.drawCard()
                            self.drawCard()
                            self.drawCard()
                            self.resp = true
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
                }
                task.resume()
            }
        }
        
        func drawCard() {
            
            let urlString = URL(string: "https://deckofcardsapi.com/api/deck/\(deckId)/draw/?count=1")
            
            if let url = urlString {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error ?? "")
                        
                    } else {
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                            guard let jsonArray = jsonResponse as? [String: Any] else {
                                print("teste1")
                                return
                            }
                            //Now get title value
                            guard let title = jsonArray["cards"] as? [[String : Any]] else { return }
                            let title2 = title[0]
                            guard let image = title2["image"] as? String else { return }
                            guard let value = title2["value"] as? String else { return }
                            guard let suit = title2["suit"] as? String else { return }
                            guard let code = title2["code"] as? String else { return }
                            
                            self.hand.append(Card(image: image, value: value, suit: suit, code: code))
                            
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
                }
                task.resume()
            }
        }
    
    
}
