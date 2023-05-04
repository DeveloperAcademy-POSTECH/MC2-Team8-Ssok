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
    
    @State var progress: CGFloat = 0.7
    @State var startAnimation: CGFloat = 0
    @State var watertop: CGFloat = 0
    @State var moneDropping: CGFloat = -270
    @State var rotateMoney: CGFloat = 0
    
    @State var showingBall = false
    
    @State var isAnimation: Bool = false
    
    var scene = Scene1(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    @State var wid = UIScreen.main.bounds.width
    @State var hei = UIScreen.main.bounds.height
    
    
    var body: some View {
        ZStack{
            Image("Background")
//            GeometryReader{proxy in
//                let size = proxy.size
//                ZStack{
//                    Rectangle()
//                    //wave effect
//                    WaterWave(progress: progress, waveHeight: 0.03, offset: startAnimation)
//                        .fill(Color("Blue"))
//                }
//                .mask {
//                    Rectangle().frame(width: wid, height: hei)
//                }.onAppear {
//                    // Lopping Animation
//                    withAnimation(
//                        .linear(duration: 3)
//                        .repeatForever(autoreverses: false)){
//                            // If you set value less than the rect width it will not finish completely
//                            startAnimation = size.width
//                        }
//                }
//            }
            
            SpriteView(scene: scene, options: [.allowsTransparency], shouldRender: {_ in return true}).ignoresSafeArea().frame(width: wid, height: hei).aspectRatio(contentMode: .fit)
            
            Rectangle()
                .fill(Color.red)
                .opacity(0.5)
                .frame(width: 32, height: 400)
                .offset(y: isAnimation ? 0 : -hei)
                .animation(.easeInOut(duration: 1.5), value: isAnimation)
        }.edgesIgnoringSafeArea(.all)
        .onTapGesture {
            if isAnimation == false {
                isAnimation.toggle()
            }
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
    
    let leftborder = SKShapeNode()
    let leftbottom = SKShapeNode()
    let rightborder = SKShapeNode()
    let rightbottom = SKShapeNode()
    override func didMove(to view: SKView) {

        self.backgroundColor = .clear
        view.allowsTransparency = true
        
        physicsWorld.contactDelegate = self
        
        let Cup = SKSpriteNode(imageNamed: "cupanddrinks")
        
        Cup.position = CGPoint(x: frame.midX, y: 303)

        addChild(Cup)
        
        let Vector = SKSpriteNode(imageNamed: "Vector 7")
        Vector.alpha = 0
        Vector.physicsBody = SKPhysicsBody(edgeLoopFrom: Vector.frame)
        
        Vector.position = CGPoint(x: frame.midX, y: 283)
        
        Vector.physicsBody?.affectedByGravity = false
        Vector.physicsBody?.categoryBitMask = ColliderType.wall
        Vector.physicsBody?.collisionBitMask = ColliderType.ball
        Vector.physicsBody?.contactTestBitMask = ColliderType.ball
        Vector.physicsBody?.isDynamic = false
        
        addChild(Vector)
        
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
        
        
        

        let pearlRadius = 12.0

        for i in stride(from: 200, to: 300, by: pearlRadius) {
            for j in stride(from: 150, to: 200, by: pearlRadius){

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

        let Cuphead = SKSpriteNode(imageNamed: "Cuphead")
        Cuphead.position = CGPoint(x: frame.midX, y:frame.maxY-303)
        Cuphead.anchorPoint = CGPoint(x: 0.5, y: 1)
        addChild(Cuphead)
        
        let Drink = SKSpriteNode(imageNamed: "onlydrinks")
        Drink.alpha = 0.7
        Drink.position = CGPoint(x: frame.midX, y:frame.maxY-308)
        Drink.anchorPoint = CGPoint(x: 0.5, y: 1)
        addChild(Drink)

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
