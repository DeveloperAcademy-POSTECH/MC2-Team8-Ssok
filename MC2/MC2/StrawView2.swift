//
//  StrawView2.swift
//  MC2
//
//  Created by 김용주 on 2023/05/07.
//

import SwiftUI

struct StrawView2: View {
    
    
    @State var st: Bool = false
    
    @State var isAnimation: Bool = false
    @State var getFirstBall: Bool = false
    @State var getSecondBall: Bool = false
    @State var getThirdBall: Bool = false
    
    @State var wid = UIScreen.main.bounds.width
    @State var hei = UIScreen.main.bounds.height
    
    @State var Where: String = "\(whereList[Int.random(in:0..<whereList.count)])"
    @State var What: String = "\(whatList[Int.random(in:0..<whatList.count)])"
    
    var body: some View {
        if !st{
            ZStack{
                ZStack {
                    BottleView()
                    VStack(spacing: 80) {
                        // 가이드
                        VStack(spacing: 24) {
                            Text("빨대를 꼽아주세요")
                                .foregroundColor(.white)
                                .font(.system(size: 28, weight: .bold))
                            Image(systemName: "arrow.down")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        }.offset(y:40)
                            .opacity(isAnimation ? 0 : 1)
                        // 컵 & 버블
                        ZStack {
                            // 버블
                            VStack {
                                Spacer()
                                Image("Pearl1")
                                    .animation(.easeOut(duration: 1.5).delay(1.0),value: isAnimation)
                                
                                Image("Pearl2")
                                    .animation(.easeOut(duration: 1.5).delay(1.0),value: isAnimation)
                                
                                Image("Pearl1")
                                    .animation(.easeOut(duration: 1.5).delay(1.0),value: isAnimation)
                            }
                            .frame(width: 28)
                            .opacity(isAnimation ? 1 : 0)
                            .offset(y: isAnimation ? -UIScreen.main.bounds.height : 0)
                            .animation(.easeInOut.delay(0.5), value: isAnimation)
                        }
                        .frame(width: UIScreen.main.bounds.width / 1.3, height:UIScreen.main.bounds.height / 1.8)
                    }
                    // 빨대
                    if isAnimation {
                        
                        Image("Straw").opacity(0.8).transition(.move(edge: .top))
                        
                    }
                    Image("cutcup").position(x: wid/2 ,y:349.05)
                    
                    Image("cutdrinks").position(x: wid/2, y: 534.6).opacity(0.4)
                    //Dim
                    Color(.white)
                        .edgesIgnoringSafeArea(.all)
                        .opacity(isAnimation ? 0.5 : 0)
                        .animation(.easeInOut(duration: 1).delay(2.5), value:isAnimation)
                    //  첫 번째 볼
                    BallView(
                        getCurrentBall: $getFirstBall,
                        getNextBall: $getSecondBall,
                        contents: "소다"
                    )
                
                    // 두 번째 볼
                    BallView(
                        getCurrentBall: $getSecondBall,
                        getNextBall: $getThirdBall,
                        contents: Where
                    )
                    
                    // 세 번째 볼
                    BallView(
                        getCurrentBall: $getThirdBall,
                        getNextBall: $getThirdBall,
                        contents: What
                    )
                    
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        isAnimation = true
                    }
                    withAnimation(.easeInOut(duration: 1).delay(3)) {
                        getFirstBall = true
                    }
                    
                }
                
                if getThirdBall == true{
                    Button(action: {st = true}) {
                        Rectangle().fill(.opacity(0))
                    }.scaledToFit()
                }
            }
        }else {
            EndingView(wheresentence : Where, whatsentence : What)
        }
        
    }
}


struct StrawView2_Previews: PreviewProvider {
    static var previews: some View {
        StrawView2()
    }
}
