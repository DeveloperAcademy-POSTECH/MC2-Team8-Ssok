//
//  SmileView.swift
//  Ssok
//
//  Created by CHANG JIN LEE on 2023/05/13.
//

import SwiftUI
import RealityKit

struct MissionSmileView: View {
    @State var arMissionType: MissionType
    @Binding var state: Bool
    @Binding var largePearlIndex: Int

    @Environment(\.presentationMode) var mode
    @ObservedObject var arViewModel = ARViewModel()

    var body: some View {
            ZStack {
                ARViewContainer(arViewModel: arViewModel, state: $state, largePearlIndex: $largePearlIndex, arMissionType: $arMissionType)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    switch arMissionType {
                    case .smile:
                        if !arViewModel.asyncIsSmileCount {
                            MissionTopView(title: "얼굴 인식", description: "미션을 성공하려면 얼굴을 인식해야해요.")
                            Text(
                                arViewModel.getSmiling ?
                                "한 번 더 메롱 😝" + arViewModel.calculateSmileCount() :
                                "화면을 보고 혀를 내미세요" + arViewModel.flushCount()
                            )
                            .padding()
                            .foregroundColor(arViewModel.getSmiling ? .green : .red)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.thickMaterial))
                            .font(Font.custom18semibold())
                            .position(x: UIScreen.screenWidth / 2, y: UIScreen.screenHeight / 1.5)
                        } else {
                            MissionCompleteView(title: "혀내밀기 😝",
                                                      background: Color("MissionFace"),
                                                      state: $state,
                                                largePearlIndex: $largePearlIndex)
                        }
                    case .blink:
                        if !arViewModel.asyncIsBlinkCount {
                            MissionTopView(title: "얼굴 인식", description: "미션을 성공하려면 얼굴을 인식해야해요.")
                            Text(
                                arViewModel.getBlinking ?
                                "한 번 더 윙크!😜" + arViewModel.calculateBlinkCount() :
                                "화면을 보고 윙크하세요" + arViewModel.flushCount()
                            )
                            .padding()
                            .foregroundColor(arViewModel.getBlinking ? .green : .red)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.thickMaterial))
                            .font(Font.custom18semibold())
                            .position(x: UIScreen.screenWidth / 2, y: UIScreen.screenHeight / 1.5)
                        } else {
                            MissionCompleteView(title: "플러팅하기 😘",
                                                      background: Color("MissionFace"),
                                                      state: $state,
                                                largePearlIndex: $largePearlIndex)
                        }
                    default:
                        EmptyView()
                    }
                }
            }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ARViewModel
    @Binding var state: Bool
    @Binding var largePearlIndex: Int
    @Binding var arMissionType: MissionType

    func makeUIView(context: Context) -> ARView {
        arViewModel.startSessionDelegate()
        return arViewModel.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct MissionSmileView_Previews: PreviewProvider {
    static var previews: some View {
        MissionSmileView(arMissionType: MissionType.smile,
                          state: .constant(false),
                          largePearlIndex: .constant(2))
    }
}
