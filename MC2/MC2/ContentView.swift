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
    
    @State var progress: CGFloat = 0.7
    @State var startAnimation: CGFloat = 0
    @State var watertop: CGFloat = 0
    @State var moneDropping: CGFloat = -270
    @State var rotateMoney: CGFloat = 0
    
    @State var showingBall = false
    

    var scene = Scene1(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var body: some View {
        ZStack{
            GeometryReader{proxy in
                let size = proxy.size

                ZStack{
                    //wave effect
                    WaterWave(progress: progress, waveHeight: 0.03, offset: startAnimation)
                        .fill(Color("Blue"))
                }
                .mask {
                    Rectangle().frame(width: 250, height: 450)
//                      Image(systemName: "rectangle.roundedbottom.fill")
//                        .resizable()
//                        .aspectRatio (contentMode: .fit)
//                        .padding (20)
                }.onAppear {
                    // Lopping Animation
                    withAnimation(
                        .linear(duration: 2)
                        .repeatForever(autoreverses: false)){
                            // If you set value less than the rect width it will not finish completely
                            startAnimation = size.width
                        }
                }
            }
            
            SpriteView(scene: scene, options: [.allowsTransparency], shouldRender: {_ in return true}).ignoresSafeArea().frame(width: 250, height: 450).aspectRatio(contentMode: .fit)
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
        
        self.backgroundColor = .clear
        view.allowsTransparency = true
        
        
        
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
                circle.fillColor = .black
                circle.strokeColor = .clear
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

//    func notification(type: UINotificationFeedbackGenerator.FeedbackType){
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(type)
//    }

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}



struct WaterWave: Shape{
    var progress: CGFloat
    var waveHeight: CGFloat
    
    var offset: CGFloat
    // Enabling Animation
    var animatableData: CGFloat {
        get{offset}
        set{offset = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            
            path.move(to: .zero)
            
            // MARK: Drawing Waves using
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            for value in stride(from: 0, to: rect.width, by: 2){
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                path.addLine (to: CGPoint (x: x, y: y))
            }
            
            // Bottom Portion
            path.addLine (to: CGPoint (x: rect.width, y: rect.height))
            path.addLine (to: CGPoint (x: 0, y: rect.height))
        }
    }
}
