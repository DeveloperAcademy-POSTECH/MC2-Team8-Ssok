//
//  ContentView.swift
//  Practice_ball
//
//  Created by 김용주 on 2023/05/02.
//

import SwiftUI
import SpriteKit
import CoreMotion

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
    
    var motionmanager : CMMotionManager?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = ColliderType.wall
        self.physicsBody?.collisionBitMask = ColliderType.ball
        self.physicsBody?.contactTestBitMask = ColliderType.ball
        self.physicsBody?.isDynamic = false
  
        motionmanager = CMMotionManager()
        motionmanager?.startAccelerometerUpdates()
        
        

    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//
//        let location = touch.location(in: self)
//        let circle = SKShapeNode(circleOfRadius: 30.0)
//
//
//        circle.fillColor = .gray
//        circle.strokeColor = .clear
//        let pearl = SKSpriteNode(texture: SKView().texture(from: circle))
//        pearl.name = "ball"
//        pearl.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        pearl.position = location
//        pearl.physicsBody = SKPhysicsBody(circleOfRadius: pearl.size.width/2)
//        pearl.physicsBody?.allowsRotation = true
//        pearl.physicsBody?.restitution = 0.3
//        pearl.physicsBody?.categoryBitMask = ColliderType.ball
//        pearl.physicsBody?.collisionBitMask = ColliderType.wall | ColliderType.ball
//        pearl.physicsBody?.contactTestBitMask = ColliderType.wall | ColliderType.ball
//
//        addChild(pearl)
//        }

    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionmanager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 50 , dy: accelerometerData.acceleration.y * 50)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        if contact.bodyA.node?.name == "ball" {
            HapticManager.instance.impact(style: .heavy)
        }
        else if contact.bodyA.node?.name == "wall" {
            HapticManager.instance.impact(style: .heavy)
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
