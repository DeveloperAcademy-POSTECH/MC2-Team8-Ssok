//
//  IntroView.swift
//  MC2
//
//  Created by 김용주 on 2023/05/06.
//

import SwiftUI
import SpriteKit

struct IntroView: View {
    init() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(1)
        }
    
    let bottle = Bottle(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let bottle2 = Bottle(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    
    
    var body: some View {
        GeometryReader{ proxy in
            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [ Color("Bg_bottom"), Color("Bg_top")]), startPoint: .top, endPoint: .bottom)).ignoresSafeArea()
            VStack(spacing: 38) {
                TabView() {
                    ZStack{
                        SpriteView(scene: bottle, options: [.allowsTransparency], shouldRender: {_ in return true}).ignoresSafeArea().frame(width: proxy.size.width, height: proxy.size.height).offset(y:-66)
                        
                        Text("팀원들끼리 리프레쉬하세요").offset(y: -250).font(.system(.title))
                    }
                    
                    ZStack{
                        SpriteView(scene: bottle2, options: [.allowsTransparency], shouldRender: {_ in return true}).ignoresSafeArea().frame(width: proxy.size.width, height: proxy.size.height).offset(y:-66)
                        
                        Text("미션을 뽑아서 다같이 완수하세요").offset(y: -250).font(.system(.title))
                    }
                    
                    ZStack{
                        Text("Welcome")
                    }
                }
                .tabViewStyle(.page)
                
                Button("시작하기") {
                    
                }.foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: 350, maxHeight: 50, alignment: .center)
                    .background(Color("Button"))
                    .cornerRadius(12)
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
