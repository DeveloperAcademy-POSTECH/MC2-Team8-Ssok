//
//  ContentView.swift
//  PraticeSoundcheck
//
//  Created by 235 on 2023/05/13.
//

import SwiftUI

struct MissionSpeechView: View {
    @StateObject var speechViewModel = SpeechViewModel()
    @State var missionTitle: String
    @State var answerText: String
    @State var checkTimer: Timer?
    var speechTime: Double
    @Binding var state: Bool
    @Binding var largePearlIndex: Int
    private var language : String {
        return missionTitle == "영국 신사 되기 💂🏻‍♀️" ? "English" : "Korean"
    }
    let progressTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            VStack {
                MissionTopView(title: "따라읽기",
                               description: "주어진 문장을 정확하게 따라 읽어서 인식시켜요.")
                MissionTitleView(missionTitle: missionTitle,
                                 missionColor: Color("MissionVoice"))
                makeGuideView()
                .padding(.top,UIScreen.getHeight(40))
                makeSTTView()
                .padding(.top, UIScreen.getHeight(25))
                .padding(.bottom,UIScreen.getHeight(20))
                
                if !speechViewModel.isWrong {
                    ZStack {
                        Image("imgProgress")
                            .shadow(color: Color(.black).opacity(0.25), radius: 4)
                        ProgressView(value: speechViewModel.progressTime, total: 100)
                            .tint(Color("Bg_bottom2"))
                            .background(Color("LightGray"))
                            .scaleEffect(x: 1, y: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .padding(.horizontal,UIScreen.getWidth(40))
                            .padding(.top, UIScreen.getHeight(30))
                            .padding(.bottom, UIScreen.getHeight(20))
                            .onReceive(progressTimer) { _ in
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    speechViewModel.updateProgressTime(speechTime: speechTime)
                                }
                            }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + speechTime) {
                            if (!speechViewModel.isCorrectResult(answerText: answerText)) {
                                speechViewModel.missionFail()
                            }
                        }
                    }
                    .padding(.horizontal, UIScreen.getWidth(43))
                    .padding(.bottom,UIScreen.getHeight(10))
                } else {
                    Button {
                        speechViewModel.retryBtnTap()
                        speechViewModel.startTranscribing(language: language)
                    } label: {
                        Text("다시 말하기")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical, UIScreen.getHeight(15))
                            .frame(maxWidth: .infinity)
                            .background(Color("Bg_bottom2"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal,UIScreen.getWidth(43))
                    .padding(.bottom, UIScreen.getHeight(10))
                }
            }
            if speechViewModel.isComplete {
                MissionCompleteView(title: missionTitle, background: Color("MissionVoice"),
                                    state: $state, largePearlIndex: $largePearlIndex)
            }
        }
        .onAppear {
            speechViewModel.startTranscribing(language: language)
            checkTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    if speechViewModel.isCorrectResult(answerText: answerText) {
                        checkTimer?.invalidate()
                        speechViewModel.completeMission()
                }
            }
        }
        .navigationBarHidden(true)
        .onDisappear {
            speechViewModel.recognizerReset()
        }
    }
}

extension MissionSpeechView {

    func makeGuideView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .padding(.horizontal, UIScreen.getWidth(40))
                .foregroundColor(.white)
                .shadow(color: Color(.black).opacity(0.2), radius: 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .padding(.horizontal, UIScreen.getWidth(50))
                        .foregroundColor(.white)
                        .shadow(color: Color(.black).opacity(0.2), radius: 8)
                        .offset(y: 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .padding(.horizontal,UIScreen.getWidth(60))
                                .foregroundColor(.white)
                                .shadow(color: Color(.black).opacity(0.2), radius: 8)
                                .offset(y: 22)
                        )
                )
            VStack(spacing: 20) {
                Text("따라 읽어요")
                    .font(Font.custom13semibold())
                    .padding(.horizontal, UIScreen.getWidth(9))
                    .padding(.vertical, UIScreen.getHeight(4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("Orange"), lineWidth: 1.5)
                    )
                    .foregroundColor(Color("Orange"))
                Text(answerText)
                    .font(Font.custom40heavy())
                    .minimumScaleFactor(0.1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal,UIScreen.getWidth(65))
            }
        }
    }

    func makeSTTView() -> some View {
        ZStack {
            Image("imgSpeeching")
                .resizable()
                .padding(.horizontal,UIScreen.getWidth(40))
                .shadow(color: Color("Orange").opacity(0.5), radius: 5)
            VStack {
                Text("내 발음")
                    .font(Font.custom13semibold())
                    .padding(.horizontal, UIScreen.getWidth(10))
                    .padding(.vertical, UIScreen.getHeight(4))
                    .background(Color("Orange"))
                    .cornerRadius(15)
                    .foregroundColor(.white)
                Text(speechViewModel.transcript.isEmpty ?
                     "문장을 따라 읽어주세요" : speechViewModel.transcript)
                .opacity(speechViewModel.transcript.isEmpty ? 0.25 : 1.0)
                .font(Font.custom40heavy())
                .minimumScaleFactor(0.1)
                .multilineTextAlignment(.center)
                .lineLimit(speechViewModel.transcript.isEmpty ? 1 : 2)
                .padding(.horizontal, UIScreen.getWidth(10))
                Text("❌ 제시어와 달라요 다시 읽어 주세요 ❌")
                    .font(Font.custom13semibold())
                    .padding(.vertical, UIScreen.getHeight(2))
                    .background(Color("LightRed"))
                    .foregroundColor(Color("Red"))
                    .opacity(speechViewModel.isWrong ? 1 : 0)
            }
            .padding(.top,UIScreen.getHeight(30))
            .padding(.horizontal, UIScreen.getWidth(50))
        }
    }
}
struct MissionSpeechView_Previews: PreviewProvider {
    static var previews: some View {
        MissionSpeechView(missionTitle: "test입니다",
                          answerText: "이것은test",
                          speechTime: 4.0,
                          state: .constant(false),
                          largePearlIndex: .constant(2))
    }
}
