//
//  ContentView.swift
//  Practice_ball
//
//  Created by 김용주 on 2023/05/02.
//

import SwiftUI
import SpriteKit
import CoreMotion

var motionstate = 0

struct ContentView: View {
    
    var scene = Scene1(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene).ignoresSafeArea().frame(width: 250, height: 450).aspectRatio(contentMode: .fit)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ColliderType {
    static let ball: UInt32 = 0x1 << 0
    static let wall: UInt32 = 0x1 << 1
}


class Scene1: SKScene, SKPhysicsContactDelegate {
    
    var motionstate = 0
    var motionmanager : CMMotionManager?
    var pearls = [".gray",".blue",".red"]
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = ColliderType.wall
        self.physicsBody?.collisionBitMask = ColliderType.ball
        self.physicsBody?.contactTestBitMask = ColliderType.ball
        self.physicsBody?.isDynamic = false
        
        let pearlRadius = 15.0
        
        for i in stride(from: pearlRadius, to: 300, by: pearlRadius) {
            for j in stride(from: pearlRadius, to: 45, by: pearlRadius){
                
                let circle = SKShapeNode(circleOfRadius: pearlRadius)
                let pearl = SKSpriteNode(texture: SKView().texture(from: circle))
                pearl.position = CGPoint(x:i, y:j)
                pearl.name = "ball"
                pearl.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                pearl.physicsBody = SKPhysicsBody(circleOfRadius: pearl.size.width/2)
                pearl.physicsBody?.allowsRotation = true
                pearl.physicsBody?.restitution = 0.3
                pearl.physicsBody?.categoryBitMask = ColliderType.ball
                pearl.physicsBody?.collisionBitMask = ColliderType.wall | ColliderType.ball
                pearl.physicsBody?.contactTestBitMask = ColliderType.wall | ColliderType.ball
                

                addChild(pearl)
                
            }
        }
        
  
        motionmanager = CMMotionManager()
        motionmanager?.startAccelerometerUpdates()
    }
    
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

    func didBegin(_ contact: SKPhysicsContact){
        
        if contact.bodyA.node?.name == "ball" {
            if motionstate == 1{
                HapticManager.instance.impact(style: .light)
            }
        }
    }

}

class HapticManager {
    static let instance = HapticManager()
    private init() {}

    func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
