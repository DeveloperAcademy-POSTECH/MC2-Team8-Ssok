//
//  BallView.swift
//  MC2
//
//  Created by 김용주 on 2023/05/07.
//

import SwiftUI

struct BallView: View {
    
    @Binding var getCurrentBall: Bool
    @Binding var getNextBall: Bool
    @State var contents: String
    @State var pearlImage: String = "Back_pearl1"
    
    @State var wid: CGFloat = UIScreen.main.bounds.width
    @State var hei: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        if getCurrentBall {
            Text(contents)
                .font(.system(size: 80, weight: .bold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.1)
                .frame(width: wid / 1.8, height: wid / 1.8)
                .foregroundColor(.white)
                .background(
                    Image(pearlImage)
                        .foregroundColor(.yellow)
                        .frame(width: wid / 1.5, height: wid / 1.5)
                )
                .transition(.asymmetric(insertion: .offset(y: -hei), removal: .offset(y: hei)))
                .zIndex(1)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        getCurrentBall = false
                        getNextBall = true
                    }
                }
        }
    }
}


