//
//  GameScene.swift
//  Flappy Brock
//
//  Created by LOGAN FUHLER on 4/24/19.
//  Copyright © 2019 clc.fuhler. All rights reserved.
//

import SpriteKit
import GameplayKit

//Physics
struct PhysicsCatagory {
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    //Var's & Func's
    var Ground = SKSpriteNode()
    
    var Ghost = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var died = Bool()
    
    var restartBTN = SKSpriteNode(imageNamed: "RestartButton")
    
    //Restarts Game
    func restartSecne(){
        self.removeAllActions()
        self.removeAllChildren()
        gameStarted = false
        died = false
        createSecne()
        wallPair.physicsBody?.pinned = false
        print("Game Started")
    }
    
    //Game Music [wip]
    func gameMusic(){
        let backgroundMusic = SKAudioNode(fileNamed: "Sweden")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    //Game Secne
    func createSecne(){
        self.physicsWorld.contactDelegate = self
        
        //Ground
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        Ground.physicsBody?.allowsRotation = false
        Ground.zPosition = 3
        self.addChild(Ground)
        
        //Ghost
        Ghost = SKSpriteNode(imageNamed: "Ghost")
        Ghost.size = CGSize(width: 60, height: 70)
        Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)
        Ghost.position = CGPoint(x: 100, y: 200)
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.isDynamic = true
        Ghost.zPosition = 2
        
        self.addChild(Ghost)
    }
    
    //Starts Game -calling-
    override func didMove(to view: SKView) {
        createSecne()
        gameMusic()
    }
    
    //Create Reset Button
    func createBTN(){
        restartBTN = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 200, height: 100))
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        self.addChild(restartBTN)
        print("Button Spawned")
        }
    
    //End Game
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
       if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Ghost || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.Ghost {
        
        died = true
        createBTN()
        wallPair.physicsBody?.pinned = true
        print("Game Ended")
        }
    }
    
    //Run Game
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                if gameStarted == false{
                    gameStarted = true
                    Ghost.physicsBody?.affectedByGravity = true
                    
                    let spawn = SKAction.run ({
                        () in
                        self.createWalls()
                        print("Walls Spawned")
                    })

                    let delay = SKAction.wait(forDuration: 2)
                    let SpawnDelay = SKAction.sequence([spawn, delay])
                    let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
                    self.run(spawnDelayForever)
                    
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
        }
                else {
                    if died == true {
                    }
                    else{
                    Ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
                    }
            }
            for touch in touches{
                let location = touch.location(in: self)
                if died == true{
                    if restartBTN.contains(location){
                        restartSecne()
                    }
                }
            }
        }
    
    //Wall Spawning
    func createWalls(){
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        
            wallPair = SKNode()
            
            let topWall = SKSpriteNode(imageNamed: "Wall")
            let btmWall = SKSpriteNode(imageNamed: "Wall")
            
            topWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 350)
            btmWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 - 350)
            
            topWall.setScale(0.5)
            btmWall.setScale(0.5)
            
            topWall.zPosition = CGFloat(M_PI)
            
            wallPair.zPosition = 1
        
        wallPair.run(moveAndRemove)
    
        //Random Height
        var randomPosition = CGFloat.random(in: -200...200)
            wallPair.position.y = wallPair.position.y + randomPosition
            wallPair.addChild(topWall)
            wallPair.addChild(btmWall)
            
            topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
            topWall.physicsBody?.categoryBitMask =  PhysicsCatagory.Wall
            topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
            topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
            topWall.physicsBody?.isDynamic = true
            topWall.physicsBody?.affectedByGravity = false
            topWall.physicsBody?.allowsRotation = false
        
            btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
            btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
            btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
            btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
            btmWall.physicsBody?.isDynamic = true
            btmWall.physicsBody?.affectedByGravity = false
            btmWall.physicsBody?.allowsRotation = false
            
            self.addChild(wallPair)
        }
}
//End
