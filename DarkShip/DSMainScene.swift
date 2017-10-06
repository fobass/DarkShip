//
//  GameScene.swift
//  DarkShip
//
//  Created by ernist on 27/09/2017.
//  Copyright © 2017 ernist. All rights reserved.
//

import SpriteKit
import GameplayKit
class DSMainScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var EnemyShip: UInt32 = 0x1 << 1
    private var IsLeftTurn = false
    private var IsRightTurn = false
    private var velocity : CGFloat = 1.0
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var btnTurnLeft : SKSpriteNode?
    private var btnTurnRight : SKSpriteNode?
    private var DSMainShip : SKSpriteNode?
    private var btnVelocity : SKSpriteNode?
    private var boardCamera : SKCameraNode?
    //private var radarLeft : SKSpriteNode?
    //private var radarRight : SKSpriteNode?
    private var DSRadiusNode : SKSpriteNode?
    private var DSActionTurn : SKAction?
    private var DSLeftEffect : SKEmitterNode?
    //private var fierEffect : SKEmitterNode?
    private var actionFier : SKAction?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        self.DSMainShip = self.childNode(withName: "//DSMainShip") as? SKSpriteNode
        self.btnTurnLeft = self.childNode(withName: "//btnTurnLeft") as? SKSpriteNode
        self.btnTurnRight = self.childNode(withName: "//btnTurnRight") as? SKSpriteNode
        self.btnVelocity = self.childNode(withName: "//btnVelocity") as? SKSpriteNode
        self.boardCamera = self.childNode(withName: "//boardCamera") as? SKCameraNode
        //self.fierEffect = self.childNode(withName: "fierEffect.sks") as? SKEmitterNode
        //self.radarLeft = self.childNode(withName: "//radarLeft") as? SKSpriteNode
        //self.radarRight = self.childNode(withName: "//radarRight") as? SKSpriteNode
        self.DSLeftEffect = SKEmitterNode(fileNamed: "leftEffect.sks")
        self.DSRadiusNode = self.childNode(withName: "//DSRadius") as? SKSpriteNode
        //addChild(particles!)
    }

    func moveNodes(angel: Int, durat: Double){
            self.boardCamera?.position = (self.DSMainShip?.position)!
            DSActionTurn = SKAction.moveTo(y:(btnTurnLeft?.position.y)! + CGFloat(angel), duration: durat)
            self.btnTurnLeft?.run(DSActionTurn!)
            self.btnTurnRight?.run(DSActionTurn!)
        
    }
   
    func doShoot(){
        var val1 = [30, 5, -15, -30, -40, -60]
        var val2 = [70, 40, 0, -40, -70, -120]
        var val3 = [0, 10, 15, 5, 10, 10]
        var p1 = -2
        var s = -1

        var actions = [SKAction]()
        let waitRightAction = SKAction.wait(forDuration: 0.05)
        let waitLeftAction = SKAction.wait(forDuration: 0.05)
        for i in 0..<val1.count{
            let addNodeRightAction = SKAction.run {
                let DSBullet = SKSpriteNode(imageNamed: "bullet")
                DSBullet.setScale(0.5)
                DSBullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bullet"), size: CGSize(width: DSBullet.size.width, height: DSBullet.size.height))
                DSBullet.physicsBody?.categoryBitMask = UInt32(self.EnemyShip)
                DSBullet.physicsBody?.isDynamic = true
                //DSBullet.physicsBody?.contactTestBitMask = UInt32(obstacleCategory)
                DSBullet.physicsBody?.usesPreciseCollisionDetection = true
                DSBullet.zPosition = 3
                DSBullet.zRotation = 0
                DSBullet.alpha = 1
                self.DSRadiusNode?.addChild(DSBullet)

                p1 = Int(arc4random_uniform(UInt32(val1.count)))
                if p1 == s {
                while (s == p1){
                  p1 = Int(arc4random_uniform(UInt32(val1.count)))
                    NSLog("S1: \(p1)")
                    }
                }
                s = p1

                DSBullet.position =  CGPoint(x: (self.DSRadiusNode!.position.x / 2) + 60, y: self.DSRadiusNode!.position.y + CGFloat(val1[p1]))
                DSBullet.isHidden = false
                DSBullet.removeAllActions()
                let location : CGPoint = CGPoint(x: (self.DSRadiusNode!.size.width / 2) + 10  ,  y: self.DSRadiusNode!.position.y + CGFloat(val2[p1]))
                let p2 = Int(arc4random_uniform(UInt32(val3.count)))
                self.actionFier = SKAction.move(to: location, duration: 0.7)
                if let fierEffect = SKEmitterNode(fileNamed: "fierEffect.sks"){
                    fierEffect.position = CGPoint(x: (self.DSRadiusNode!.position.x / 2) + 60 + CGFloat(val3[p2]), y: self.DSRadiusNode!.position.y + CGFloat(val1[p1]))
                    self.DSRadiusNode?.addChild(fierEffect)
                    self.run(SKAction.wait(forDuration: 0.2), completion: {  fierEffect.removeFromParent() })
                }
                DSBullet.run(self.actionFier!)
                self.run(SKAction.wait(forDuration: 0.7), completion: { if ((DSBullet.position.x ) >=  (self.DSRadiusNode!.size.width / 2) ) {DSBullet.removeFromParent() }})

            }
            actions.append(waitRightAction)
            actions.append(addNodeRightAction)
            
            let addNodeLeftAction = SKAction.run {
                let DSBullet = SKSpriteNode(imageNamed: "bullet")
                DSBullet.setScale(0.5)
                DSBullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bullet"), size: CGSize(width: DSBullet.size.width, height: DSBullet.size.height))
                DSBullet.physicsBody?.categoryBitMask = UInt32(self.EnemyShip)
                DSBullet.physicsBody?.isDynamic = true
                //DSBullet.physicsBody?.contactTestBitMask = UInt32(obstacleCategory)
                DSBullet.physicsBody?.usesPreciseCollisionDetection = true
                DSBullet.zPosition = 3
                DSBullet.zRotation = 0
                DSBullet.alpha = 1
                self.DSRadiusNode?.addChild(DSBullet)
                
                p1 = Int(arc4random_uniform(UInt32(val1.count)))
                if p1 == s {
                    while (s == p1){
                        p1 = Int(arc4random_uniform(UInt32(val1.count)))
                        NSLog("S1: \(p1)")
                    }
                }
                s = p1
                
                DSBullet.position =  CGPoint(x: (self.DSRadiusNode!.position.x / 2) - 60, y: self.DSRadiusNode!.position.y + CGFloat(val1[p1]))
                DSBullet.isHidden = false
                DSBullet.removeAllActions()
                let location : CGPoint = CGPoint(x: (self.DSRadiusNode!.position.x) - (self.DSRadiusNode!.size.width / 2), y: CGFloat(val2[p1]))
                let p2 = Int(arc4random_uniform(UInt32(val3.count)))
                NSLog("BX: \((self.DSRadiusNode!.position.x) - (self.DSRadiusNode!.size.width / 2))")
                NSLog("SX: \(self.DSRadiusNode!.size.width / 2)")
                self.actionFier = SKAction.move(to: location, duration: 0.7)
                if let fierEffect = SKEmitterNode(fileNamed: "fierEffect.sks"){
                    fierEffect.position = CGPoint(x: (self.DSRadiusNode!.position.x / 2) - 60 - CGFloat(val3[p2]), y: self.DSRadiusNode!.position.y - CGFloat(val1[p1]))
                    self.DSRadiusNode?.addChild(fierEffect)
                    self.run(SKAction.wait(forDuration: 0.2), completion: {  fierEffect.removeFromParent() })
                }
                DSBullet.run(self.actionFier!)
                self.run(SKAction.wait(forDuration: 0.7), completion: { if (((self.DSRadiusNode!.position.x) - self.DSRadiusNode!.size.width ) <=  (self.DSRadiusNode!.size.width / 2) ) {DSBullet.removeFromParent() }})
                
            }
            actions.append(waitLeftAction)
            actions.append(addNodeLeftAction)
        }

        
        
        let sequenceAction = SKAction.sequence(actions)
        run(sequenceAction)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches){
            let loaction = touch.location(in: self)
            let nodes = self.nodes(at: loaction)
            for node in nodes {
                if node.name == "btnTurnLeft"{
                    self.IsLeftTurn = true
                    node.alpha = 0.7
                }
                if node.name == "btnTurnRight"{
                    self.IsRightTurn = true
                    node.alpha = 0.7
                }
                if node.name == "btnVelocity"{
                    if velocity > 2.0{
                        self.velocity = 2.0
                        node.alpha = 1
                    }
                    else
                    {
                        self.velocity = 3.0
                        node.alpha = 0.7
                    }
                }
                if node.name == "btnFier"{
                    doShoot()
                 
                    node.alpha = 0.7
                }
                
                
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches){
            let loaction = touch.location(in: self)
            let nodes = self.nodes(at: loaction)
            for node in nodes {
                if node.name == "btnTurnLeft"{
                    removeAction(forKey: "DSActionTurn")
                    self.IsLeftTurn = false
                    node.alpha = 1
                }
                if node.name == "btnTurnRight"{
                    removeAction(forKey: "DSActionTurn")
                    self.IsRightTurn = false
                    node.alpha = 1
                }
                if node.name == "btnVelocity"{
                    //isFier = true
                    
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches){
            let loaction = touch.location(in: self)
            self.IsLeftTurn = false
            self.IsRightTurn = false
            
            let nodes = self.nodes(at: loaction)
            for node in nodes {
                if node.name == "btnTurnLeft"{
                    self.IsLeftTurn = true
                    node.alpha = 1
                }
                if node.name == "btnTurnRight"{
                    self.IsRightTurn = true
                    node.alpha = 1
                }
                if node.name == "btnVelocity"{
                    if velocity > 2.0{
                        self.velocity = 2.0
                        node.alpha = 1
                    }
                    else
                    {
                        self.velocity = 3.0
                        node.alpha = 0.7
                    }
                }
                
            }
            
            
        }
    }
    
   
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches){
            let loaction = touch.location(in: self)
            let nodes = self.nodes(at: loaction)
            for node in nodes {
                if node.name == "btnTurnLeft"{
                    removeAction(forKey: "DSActionTurn")
                    self.IsLeftTurn = false
                    node.alpha = 1
                }
                if node.name == "btnTurnRight"{
                    removeAction(forKey: "DSActionTurn")
                    self.IsRightTurn = false
                    node.alpha = 1
                }
                if node.name == "btnVelocity"{
                    //isFier = true
                    
                }
            }
        }
    }
    
    func turnShip(x: CGFloat){
        DSActionTurn = SKAction.rotate(byAngle: x, duration: 0.1)
        self.DSMainShip?.run(DSActionTurn!)
        
    }
    override func update(_ currentTime: TimeInterval) {
        let radianFactor : CGFloat = 0.0174532925;
        let rotationInDegrees : CGFloat = (self.DSMainShip!.zRotation) / radianFactor;
        let newRotationDegrees : CGFloat = rotationInDegrees + 90;
        let newRotationRadians : CGFloat = newRotationDegrees * radianFactor;

        let dx: CGFloat = velocity * cos(newRotationRadians);
        let dy: CGFloat = velocity * sin(newRotationRadians);

        let move = SKAction.moveBy(x: dx, y: dy, duration: 0.01)
        self.DSMainShip?.run(move)
       
        
        //NSLog("self.radarRight!.position.y: \(self.radarRight!.position.y)")
        if let LeftEffect = SKEmitterNode(fileNamed: "leftEffect.sks"){
            LeftEffect.position = CGPoint(x: ((self.DSRadiusNode?.size.width)! / 2), y: (DSRadiusNode?.position.x)!)
            addChild(LeftEffect)
            self.run(SKAction.wait(forDuration: 5), completion: {  LeftEffect.removeFromParent() })
            
        }
        self.boardCamera?.position = (self.DSMainShip?.position)!
        if  self.IsLeftTurn == true {
            turnShip(x: 0.01)
        }
        if  self.IsRightTurn == true {
            turnShip(x: -0.01)
        }
        if let bullet = self.childNode(withName: "DSRadius"){
            if ((bullet.position.x) >  self.DSRadiusNode!.size.width ) {bullet.removeFromParent()}
        }
        //self.run(SKAction.wait(forDuration: 2), completion: { if ((DSBullet.position.x) >  self.radarRight!.size.width) {DSBullet.removeFromParent() }})

    }
}
