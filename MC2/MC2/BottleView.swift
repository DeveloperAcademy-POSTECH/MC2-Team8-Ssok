//
//  ContentView.swift
//  Practice_ball
//
//  Created by 김용주 on 2023/05/02.
//

import SwiftUI
import SpriteKit
import CoreMotion


//Bottle View
struct BottleView: View {
    
    var scene = Bottle(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    @State var wid = UIScreen.main.bounds.width
    @State var hei = UIScreen.main.bounds.height
    
    
    var body: some View {
        ZStack{
            Image("Background")
            
            SpriteView(scene: scene, options: [.allowsTransparency], shouldRender: {_ in return true}).ignoresSafeArea().frame(width: wid, height: hei).aspectRatio(contentMode: .fit)
            
        }.ignoresSafeArea(.all)
        
    }
}

//Preview
struct BottleView_Previews: PreviewProvider {
    static var previews: some View {
        BottleView()
    }
}


//Collider Type
struct ColType {
    static let ball: UInt32 = 0x1 << 0
    static let wall: UInt32 = 0x1 << 1
}

//Declaration Pearls ( SKSpriteNode )
class Pearls : SKSpriteNode {}

class Bottle: SKScene, SKPhysicsContactDelegate {

    var motionstate = 0
    //Declare CoreMotion
    var motionmanager : CMMotionManager?
    
    //Pearls image name
    var pearls = ["Pearl1","Pearl2"]
    
    //Declare cup inner area
    let leftborder = SKShapeNode()
    let leftbottom = SKShapeNode()
    let rightborder = SKShapeNode()
    let rightbottom = SKShapeNode()
    override func didMove(to view: SKView) {

        //background Transparency
        self.backgroundColor = .clear
        view.allowsTransparency = true
        
        physicsWorld.contactDelegate = self
        
        //Cup appearance Implementation
        let Cup = SKSpriteNode(imageNamed: "cupanddrinks")
        
        Cup.position = CGPoint(x: frame.midX, y: 303)

        addChild(Cup)
        
        //Cup inner area collision Implementation
        let Vector = SKSpriteNode(imageNamed: "Vector 7")
        Vector.alpha = 0
        Vector.physicsBody = SKPhysicsBody(edgeLoopFrom: Vector.frame)
        
        Vector.position = CGPoint(x: frame.midX, y: 283)
        
        Vector.physicsBody?.affectedByGravity = false
        Vector.physicsBody?.categoryBitMask = ColType.wall
        Vector.physicsBody?.collisionBitMask = ColType.ball
        Vector.physicsBody?.contactTestBitMask = ColType.ball
        Vector.physicsBody?.isDynamic = false
        
        addChild(Vector)
        
        //Implementation of cup interior details
        leftborder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: frame.height))
        leftborder.physicsBody?.affectedByGravity = false
        leftborder.zRotation = .pi/50
        leftborder.position = CGPoint(x: frame.midX/2.9, y: frame.midY)
        leftborder.physicsBody?.isDynamic = false
        
        addChild(leftborder)
        
        leftbottom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: frame.height))
        leftbottom.physicsBody?.affectedByGravity = false
        leftbottom.zRotation = .pi/3.1
        leftbottom.position = CGPoint(x: frame.midX, y: frame.height/15)
        leftbottom.physicsBody?.isDynamic = false
        
        addChild(leftbottom)
        
        rightborder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: frame.height))
        rightborder.physicsBody?.affectedByGravity = false
        rightborder.zRotation = -.pi/40
        rightborder.position = CGPoint(x:( frame.maxX-frame.midX/3), y: frame.midY)
        rightborder.physicsBody?.isDynamic = false
        
        addChild(rightborder)
        
        rightbottom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: frame.height))
        rightbottom.physicsBody?.affectedByGravity = false
        rightbottom.zRotation = -.pi/3.1
        rightbottom.position = CGPoint(x:( frame.maxX-frame.midX), y: frame.height/15)
        rightbottom.physicsBody?.isDynamic = false
        
        addChild(rightbottom)
        
        
        //Random Pearl
        let pearlRadius = 20.0

        for i in stride(from: 200, to: 300, by: pearlRadius) {
            for j in stride(from: 150, to: 200, by: pearlRadius){

                let pearlType = pearls.randomElement()!
                let pearl = Pearls(imageNamed: pearlType)
                pearl.position = CGPoint(x: i, y: j)
                pearl.name = "ball"
                pearl.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                pearl.physicsBody = SKPhysicsBody(circleOfRadius: pearlRadius)
                pearl.physicsBody?.allowsRotation = true
                pearl.physicsBody?.restitution = 0.3
                pearl.physicsBody?.categoryBitMask = ColType.ball
                pearl.physicsBody?.collisionBitMask = ColType.wall | ColType.ball
                pearl.physicsBody?.contactTestBitMask = ColType.wall | ColType.ball


                addChild(pearl)

            }
        }

        //Cuphead appearance
        let Cuphead = SKSpriteNode(imageNamed: "Cuphead")
        Cuphead.position = CGPoint(x: frame.midX, y:frame.maxY-303)
        Cuphead.anchorPoint = CGPoint(x: 0.5, y: 1)
        addChild(Cuphead)
        
        let Drink = SKSpriteNode(imageNamed: "onlydrinks")
        Drink.alpha = 0.5
        Drink.position = CGPoint(x: frame.midX, y:frame.maxY-308)
        Drink.anchorPoint = CGPoint(x: 0.5, y: 1)
        addChild(Drink)

        //Use CoreMotion
        motionmanager = CMMotionManager()
        motionmanager?.startAccelerometerUpdates()
    }

    //Update part
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionmanager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 30 , dy: accelerometerData.acceleration.y * 30)

            if accelerometerData.acceleration.x > 0.5 || accelerometerData.acceleration.x < -0.5 {
                motionstate = 1

            } else {
                motionstate = 0
                
            }
        }

    }
    
    //Run on collision
    func didBegin(_ contact: SKPhysicsContact){

        if contact.bodyA.node?.name == "ball" {
            if motionstate == 1{
                HapticManager.instance.impact(style: .light)
            }
        }
    }
}

//Haptic
class HapticManager {
    static let instance = HapticManager()
    private init() {}

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
