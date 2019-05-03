//
//  GameScene.swift
//  Flappy Brock
//
//  Created by LOGAN FUHLER on 4/24/19.
//  Copyright © 2019 clc.fuhler. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCatagory {
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var Ground = SKSpriteNode()
    var Ghost = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        //Ground
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height)
        self.addChild(Ground)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        print("Hi")
        
        //Ghost
        Ghost = SKSpriteNode(imageNamed: "Ghost")
        Ghost.size = CGSize(width: 60, height: 70)
        //Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)
        Ghost.position = CGPoint(x: 100, y: 200)
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.affectedByGravity = true
        Ghost.physicsBody?.isDynamic = true
        
        self.addChild(Ghost)
        
        createWalls()
        
}
    func createWalls(){
        let wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 350)
        btmWall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 350)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        topWall.zRotation = CGFloat(M_PI)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask =  PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground
        
        self.addChild(wallPair)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched")
        Ghost.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
        Ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
    

}
    func createOb(){
        //For John
    }
}

