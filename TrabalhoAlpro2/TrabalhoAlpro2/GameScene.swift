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
    var player1Button: SKSpriteNode?
    var player2Button: SKSpriteNode?
    var backgroundNode: SKSpriteNode?
    var cardNode: SKSpriteNode?
    var deckId = ""
    var remaining = 0
    var hand: [Card] = []
    var resp: Bool = false
    
    //MARK: - DidMove to view
    override func didMove(to view: SKView) {
        createInitialNodes()
        createDeck()
    }
    
    //MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }

        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        switch touchedNode.name {
        case "Player1Button":
            print("tapped player 1 node")
        case "Player2Button":
            print("tapped player 2 node")
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
        player1Button?.zPosition = 2
        
        player2Button = SKSpriteNode(texture: nil, color: .blue, size: CGSize(width: width * 0.9, height: height * 0.1))
        player2Button?.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - (player2Button?.size.height ?? CGFloat.zero))
        player2Button?.name = "Player2Button"
        player2Button?.zPosition = 2
        
        backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "background"), color: .clear, size: CGSize(width: width, height: height))
        backgroundNode?.position  = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        cardNode = SKSpriteNode(texture: nil, color: .black, size: CGSize(width: width * 0.6, height: height * 0.6))
        cardNode?.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        cardNode?.zPosition = 2
        
        addChild(player1Button ?? SKSpriteNode())
        addChild(player2Button ?? SKSpriteNode())
        addChild(backgroundNode ?? SKSpriteNode())
        addChild(cardNode ?? SKSpriteNode())
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
                            print(jsonArray)
                            //Now get title value
                            guard let title = jsonArray["cards"] as? [[String : Any]] else { return }
                            let title2 = title[0]
                            guard let image = title2["image"] as? String else { return }
                            guard let value = title2["value"] as? String else { return }
                            guard let suit = title2["suit"] as? String else { return }
                            guard let code = title2["code"] as? String else { return }
                            
                            self.hand.append(Card(image: image, value: value, suit: suit, code: code))
                            self.resp = true
                            
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                    }
                }
                task.resume()
            }
        }
    
    
}
