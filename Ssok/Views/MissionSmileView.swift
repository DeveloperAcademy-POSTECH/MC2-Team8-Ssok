//
//  SmileView.swift
//  Ssok
//
//  Created by CHANG JIN LEE on 2023/05/13.
//

import SwiftUI
import RealityKit

struct MissionSmileView: View {
    @State var title: String
    @Binding var state: Bool
    @Binding var largePearlIndex: Int

    @Environment(\.presentationMode) var mode
    @ObservedObject var arViewModel = ARViewModel()

    var body: some View {
            ZStack {
                ARViewContainer(arViewModel: arViewModel, state: $state, largePearlIndex: $largePearlIndex, title: $title)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    switch title {
                    case "smile":
                        makeArView(arStatus: !arViewModel.asyncIsSmileCount, arViewModel: arViewModel, colorStatus: arViewModel.getSmiling, state: state, largePearlIndex: largePearlIndex, guideMessage1: arViewModel.getSmiling ?
                               "한 번 더 메롱 😝" + arViewModel.calculateSmileCount() :
                               "화면을 보고 혀를 내미세요" + arViewModel.flushCount(), guideMessage2: "혀내밀기 😝")
                    case "blink":
                        makeArView(arStatus: !arViewModel.asyncIsBlinkCount, arViewModel: arViewModel, colorStatus: arViewModel.getSmiling, state: state, largePearlIndex: largePearlIndex, guideMessage1: arViewModel.getBlinking ?
                               "한 번 더 윙크!😜" + arViewModel.calculateBlinkCount() :
                               "화면을 보고 윙크하세요" + arViewModel.flushCount(), guideMessage2: "플러팅하기 😘")
                    default:
                        EmptyView()
                    }
                }
            }
    }

    private func makeArView(arStatus: Bool, arViewModel: ARViewModel, colorStatus: Bool, state: Bool, largePearlIndex: Int, guideMessage1: String, guideMessage2: String) -> some View{
        VStack{
            if arStatus {
                MissionTopView(title: "얼굴 인식", description: "미션을 성공하려면 얼굴을 인식해야해요.")
                Text(
                    guideMessage1
                )
                .padding()
                .foregroundColor(colorStatus ? .green : .red)
                .background(RoundedRectangle(cornerRadius: 20).fill(.thickMaterial))
                .font(Font.custom18semibold())
                .position(x: UIScreen.screenWidth / 2, y: UIScreen.screenHeight / 1.5)
            } else {
                MissionCompleteView(title: guideMessage2,
                                    background: Color("MissionFace"),
                                    state: $state,
                                    largePearlIndex: $largePearlIndex)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ARViewModel
    @Binding var state: Bool
    @Binding var largePearlIndex: Int
    @Binding var title: String

    func makeUIView(context: Context) -> ARView {
        arViewModel.startSessionDelegate()
        return arViewModel.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct MissionSmileView_Previews: PreviewProvider {
    static var previews: some View {
        MissionSmileView(title: "smile",
                          state: .constant(false),
                          largePearlIndex: .constant(2))
    }
}
