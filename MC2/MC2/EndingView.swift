//
//  EndingView.swift
//  MC2
//
//  Created by 김용주 on 2023/05/05.
//

import SwiftUI
import CoreMotion
import SpriteKit

struct EndingView: View {
    
    @State var progress: CGFloat = 0.85
    @State var startAnimation: CGFloat = 0
    @State var watertop: CGFloat = 0
    @State var moneDropping: CGFloat = -270
    @State var rotateMoney: CGFloat = 0
    @State var showingBall = false
    @State var isAnimation: Bool = false
    
    var ending = Ending_Pearl(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    @State var wid = UIScreen.main.bounds.width
    @State var hei = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack{
            GeometryReader{proxy in
                let size = proxy.size
                ZStack{
                    Rectangle().fill(.white)
                    //wave effect
                    WaterWave(progress: progress, waveHeight: 0.03, offset: startAnimation)
                        .fill(LinearGradient(gradient: Gradient(colors: [ Color("Bg_bottom"), Color("Bg_top")]), startPoint: .top, endPoint: .bottom))
                }.onAppear {
                    // Lopping Animation
                    withAnimation(
                        .linear(duration: 3)
                        .repeatForever(autoreverses: false)){
                            // If you set value less than the rect width it will not finish completely
                            startAnimation = size.width
                        }
                }
            }
            //Long straw image
            Image("Long_straw")
            //Big Pearls
            SpriteView(scene: ending, options: [.allowsTransparency], shouldRender: {_ in return true}).ignoresSafeArea().frame(width: wid, height: hei).aspectRatio(contentMode: .fit)
        }.ignoresSafeArea(.all)
    }
}

struct EndingView_Previews: PreviewProvider {
    static var previews: some View {
        EndingView()
    }
}


//Declaration Pearls ( SKSpriteNode )
class Big_Pearls : SKSpriteNode {}

class Ending_Pearl: SKScene, SKPhysicsContactDelegate {

    var motionstate = 0
    //Declare CoreMotion
    var motionmanager : CMMotionManager?
    
    //Pearls image name
    var big_pearls = ["Big_Pearl1","Big_Pearl2"]

    override func didMove(to view: SKView) {

        //background Transparency
        self.backgroundColor = .clear
        view.allowsTransparency = true
        
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        //Random Pearl
        let pearlRadius = 40.0

        for i in stride(from: frame.minX, to: 200, by: pearlRadius) {
            for j in stride(from: frame.minY, to: 100, by: pearlRadius){

                let Big_pearlType = big_pearls.randomElement()!
                let big_pearl = Big_Pearls(imageNamed: Big_pearlType)
                big_pearl.position = CGPoint(x: i, y: j)
                big_pearl.name = "ball"
                big_pearl.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                big_pearl.physicsBody = SKPhysicsBody(circleOfRadius: pearlRadius)
                big_pearl.physicsBody?.allowsRotation = true
                big_pearl.physicsBody?.restitution = 0.3
                big_pearl.physicsBody?.categoryBitMask = ColType.ball
                big_pearl.physicsBody?.collisionBitMask = ColType.wall | ColType.ball
                big_pearl.physicsBody?.contactTestBitMask = ColType.wall | ColType.ball


                addChild(big_pearl)

            }
        }

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
            for value in stride(from: 0, to: rect.width+2, by: 2){
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
