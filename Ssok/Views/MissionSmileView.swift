//
//  SmileView.swift
//  Ssok
//
//  Created by CHANG JIN LEE on 2023/05/13.
//

import SwiftUI
import RealityKit

struct MissionSmileView: View {
    @State var ARstate: String = ""
    @Binding var state: Bool

    @Environment(\.presentationMode) var mode
    @EnvironmentObject var arViewModel: ARViewModel
    @StateObject var navi = NaviObservableObject()

    var body: some View {
            ZStack {
                ARViewContainer(arViewModel: arViewModel, state: $state)
                    .edgesIgnoringSafeArea(.all)
                VStack {

                    if ARstate == "smile" {
                        if !arViewModel.asyncissmileCount {
                            MissionTopView(title: "얼굴 인식", description: "미션을 성공하려면 얼굴을 인식해야해요.")
                            Text(
                                arViewModel.isSmiling ?
                                "한 번 더 메롱 😝 \(smCount())" : "화면을 보고 혀를 내미세요" + flushCount()
                            )
                            .padding()
                            .foregroundColor(arViewModel.isSmiling ? .green : .red)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.thickMaterial))
                            .font(.system(size: 18, weight: .semibold))
                            .position(x: screenWidth / 2, y: screenHeight / 1.5)
                        } else {
                            MissionCompleteView(title: "혀내밀기 😝",
                                                      background: Color.mint,
                                                      state: $state)
                        }
                    } else if ARstate == "blink"{
                        if !arViewModel.asyncisblinkCount {
                            MissionTopView(title: "얼굴 인식", description: "미션을 성공하려면 얼굴을 인식해야해요.")
                            Text(
                                arViewModel.isBlinking ?
                                "한 번 더 윙크!😜 \(blCount())" : "화면을 보고 윙크하세요" + flushCount()
                            )
                            .padding()
                            .foregroundColor(arViewModel.isBlinking ? .green : .red)
                            .background(RoundedRectangle(cornerRadius: 20).fill(.thickMaterial))
                            .font(.system(size: 18, weight: .semibold))
                            .position(x: screenWidth / 2, y: screenHeight / 1.5)
                        } else {
                            MissionCompleteView(title: "플러팅하기 😘",
                                                      background: Color.mint,
                                                      state: $state)
                        }
                    }
                }
            }
    }

    func smCount() -> String {
        arViewModel.smileCount += 1
        if arViewModel.smileCount > 30 {
            arViewModel.asyncsmileCount += 1
            arViewModel.smileCount = 0
        }
        if arViewModel.asyncsmileCount >= 2 {
            arViewModel.asyncsmileCount = 2
            arViewModel.asyncissmileCount = true
        }
        return ""
    }

    func blCount() -> String {
        arViewModel.blinkCount += 1
        if arViewModel.blinkCount > 30 {
            arViewModel.asyncblinkCount += 1
            arViewModel.blinkCount = 0
        }
        if arViewModel.asyncblinkCount >= 2 {
            arViewModel.asyncblinkCount = 2
            arViewModel.asyncisblinkCount = true
        }
        return ""
    }

    func flushCount() -> String {
        arViewModel.smileCount = 0
        arViewModel.blinkCount = 0
        return ""
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ARViewModel
    @Binding var state: Bool

    func makeUIView(context: Context) -> ARView {
        arViewModel.startSessionDelegate()
        return arViewModel.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
