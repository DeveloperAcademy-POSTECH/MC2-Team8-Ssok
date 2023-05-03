//
//  Home.swift
//  mc2
//
//  Created by CHANG JIN LEE on 2023/05/01.
//

import SwiftUI

struct HI: View {
    
    @State var progress: CGFloat = 0.5
    @State var startAnimation: CGFloat = 0
    @State var watertop: CGFloat = 0
    @State var moneDropping: CGFloat = -270
    @State var rotateMoney: CGFloat = 0
    
    @State var showingBall = false
    
    
    var body: some View {
        ZStack {
            
            VStack{
                                    
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame (width: 120, height: 120)
                        .clipShape(Circle ())
                        .padding (10)
                        .background( .white, in: Circle())
                    
                    
                    Text("SODA")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                
//                    Text("\(watertop) \(moneDropping)")
//                        .fontWeight(.semibold)
//                        .foregroundColor(.gray)
//                        .padding(.bottom, 5)
                    
                    GeometryReader{proxy in
                        let size = proxy.size
                        ZStack{
                            // MARK: Water Drop
                            Image (systemName: "rectangle.roundedbottom.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode:.fit)
                                .foregroundColor(.white)
                                .frame(width: size.width / 1.2)
                                .scaleEffect(x: 1.1, y: 1)
                            
                            //wave effect
                            WaterWave(progress: progress, waveHeight: 0.05, offset: startAnimation)
                                .fill(Color("Blue"))
                            // drop water
                                .overlay (content: {
                                    ZStack{
                                        
                                        Circle()
                                            .fill(.white.opacity (0.1))
                                            .frame (width: 15, height: 15) .offset (x: -20)
                                        
                                        Circle()
                                            .fill(.white.opacity (0.1))
                                            .frame (width: 15, height: 15)
                                            .offset (x: 40, y: 30)
                                        
                                        Circle()
                                            .fill(.white.opacity (0.1))
                                            .frame (width: 25, height: 25)
                                            .offset (x: -30, y: 80)
                                        
                                        Circle()
                                            .fill(.white.opacity (0.1))
                                            .frame (width: 25, height: 25)
                                            .offset (x: 50, y: 70)
                                        
                                        Circle()
                                            .fill(.white.opacity (0.1))
                                            .frame (width: 10, height: 10)
                                            .offset (x: 40, y: 100)
                                        
                                        Circle()
                                            .fill(.white.opacity (0.1))
                                            .frame (width: 10, height: 10)
                                            .offset (x: -40, y: 50)
                                    }
                                })
                            // masking into drop shape
                                .mask {
                                    Image(systemName: "rectangle.roundedbottom.fill")
                                        .resizable()
                                        .aspectRatio (contentMode: .fit)
                                        .padding (20)
                                }
                            // Add Button
                                .overlay (alignment: .bottom) {
                                    Button {
                                        self.showingBall.toggle()
                                        watertop = 80 - (1 - progress) * size.height
                                    } label: {
                                        Image (systemName: "plus")
                                            .font (.system(size: 35, weight: .black))
                                            .foregroundColor (Color ("Blue"))
                                            .shadow(radius: 2)
                                            .padding (18)
                                            .background (.white, in: Circle())
                                    }
                                    .offset (y: -20)
                                }
                        }
                        .frame (width: size.width, height: size.height,
                                alignment: .center)
                        .onAppear {
                            // Lopping Animation
                            withAnimation(
                                .linear(duration: 2)
                                .repeatForever(autoreverses: false)){
                                    // If you set value less than the rect width it will not finish completely
                                    startAnimation = size.width
                                }
                        }
                    }
                    .frame (height: 350)
                    
                    Slider(value: $progress)
                        .padding(5)
                }
                .padding()
                .frame (maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color ("BG"))
            
            if( self.showingBall == true){
                Circle()
                    .trim(from: 0, to: 0)
                    .stroke()
                    .frame( width: 120, height: 120, alignment: .center)
                    .overlay(Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame (width: 110, height: 110)
                        .clipShape(Circle ()))
                    .rotationEffect( .degrees (Double(rotateMoney)))
                //                        .rotation3DEffect ( .degrees (10),
                //                                            axis: (x: 10, y: 0.0, z: 0.0))
                    .foregroundColor(.orange)
                    .offset (y: moneDropping)
                    .onAppear{
                        withAnimation(
                            .linear(duration: 1.5)
                            .repeatForever(autoreverses: false)){
                                moneDropping = 80
                                rotateMoney = 720
                                // Act when aniamtion completed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    self.showingBall=false
                                    moneDropping = -270
                                    rotateMoney = 0
                                    progress += 0.05
                                    
                                }
                            }
                    }
            }
            
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HI()
    }
}

