//
//  ContentView.swift
//  PraticeSoundcheck
//
//  Created by 235 on 2023/05/13.
//

import SwiftUI

struct MissionSpeechView: View {
    
    @ObservedObject var speechRecognizer = SpeechRecognizer()
    @State var isSpeech: Bool = false
    @State var isWrong: Bool = false
    @State var isComplete: Bool = false
    
    @State var missionTitle: String
    @State var missionTip: String
    @State var missionColor: Color
    @State var answerText: String
    @State var speechTime: Double
    @State var progressTime: Double = 0.0
    @State var checktimer : Timer?
    
    let progressTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                MissionTopView(title: "따라읽기", description: "주어진 문장을 정확하게 따라 읽어서 인식시켜요.")
                Spacer()
                // 버튼 & 프로그레스
                if isSpeech {
                    Image("progress")
                        .shadow(color: Color(.black).opacity(0.25),radius: 4)
                        .overlay(
                            ProgressView(value: progressTime, total: 100)
                                .tint(Color("Orange_Progress"))
                                .padding(.horizontal, 40)
                                .padding(.top, 8)
                                .scaleEffect(y: 2)
                                .onReceive(progressTimer) { _ in
                                    withAnimation(.linear(duration: 1)) {
                                        if progressTime > 0 {
                                            progressTime -= 100/speechTime
                                        }
                                    }
                                }
                        )
                        .frame(height: 50)
                        .onAppear {
                            speechRecognizer.stopTranscript() //혹시라도 켜있으면 껏다다시키게
                            if(missionTitle == "영국 신사 되기 💂🏻‍♀️"){
                                speechRecognizer.englishTranscribing()
                            }else{
                                speechRecognizer.startTranscribing()}
                            let timer = Timer.scheduledTimer(withTimeInterval: speechTime, repeats: false){
                                timer in
       
                                let cleanedTranscript = speechRecognizer.transcript.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
                                //영소문자 바꾸는 거 해야함.
                                
                                if(answerText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "") != cleanedTranscript){
                                    speechRecognizer.stopTranscript() //혹시라도 켜있으면 껏다다시키게
                                    isWrong = true
                                    isSpeech = false
                   
            
                                    
                                }
                            }
                            checktimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){
                                timer in
                                print("켜짐")
                                let cleanedTranscript = speechRecognizer.transcript.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
                                //영소문자 바꾸는 거 해야함.
                                
                                if(answerText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "") == cleanedTranscript) {
                                    timer.invalidate()
                                    isComplete = true
                                    speechRecognizer.stopTranscript()
                                    print("정답")
                                }}
                            RunLoop.main.add(checktimer!, forMode: .common)
                            RunLoop.main.add(timer, forMode: .common)
                        }
                   
                } else {
                    Button {
                        isSpeech = true
                        speechRecognizer.transcript = ""
                        progressTime = 100
                        isWrong = false
                    } label: {
                        Text("눌러서 말하기")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: 350, alignment: .center)
                            .frame(height: 50)
                            .background(Color("Bg_bottom2"))
                            .cornerRadius(12)
                    }
                }
            }
            VStack(spacing: 40) {
                MissionTitleView(missionTitle: missionTitle, backgroundColor: missionColor.opacity(0.3), borderColor: missionColor.opacity(0.71))
                // 카드 둘
                VStack(spacing: 44) {
                    // 제시어 카드
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 307, height: 175)
                            .foregroundColor(.white)
                            .shadow(color: Color(.black).opacity(0.2),radius: 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 284, height: 175)
                                    .foregroundColor(.white)
                                    .shadow(color: Color(.black).opacity(0.2),radius: 8)
                                    .offset(y: 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 268, height: 175)
                                            .foregroundColor(.white)
                                            .shadow(color: Color(.black).opacity(0.2),radius: 8)
                                            .offset(y: 22)
                                    )
                            )
                        VStack(spacing: 20) {
                            Text("따라 읽어요")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 9)
                                .padding(.vertical, 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("Orange"), lineWidth: 1.5)
                                )
                                .foregroundColor(Color("Orange"))
                            Text(answerText)
                                .font(.system(size: 48, weight: .heavy))
                                .frame(width: 240, height: 64)
                                .minimumScaleFactor(0.1)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                    }
                    // 제시어 말하기
                    ZStack {
                        Image("Speeching")
                            .shadow(color: Color("Orange").opacity(0.5), radius: 5)
                        VStack {
                            Text("내 발음")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 9)
                                .padding(.vertical, 4)
                                .background(Color("Orange"))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                            if speechRecognizer.transcript == "" {
                                Text("버튼을 눌러 말해주세요")
                                    .opacity(0.25)
                                    .font(.system(size: 48, weight: .heavy))
                                    .frame(width: 240, height: 64)
                                    .minimumScaleFactor(0.1)
                                    .lineLimit(1)
                            } else {
                                Text(speechRecognizer.transcript)
                                    .font(.system(size: 48, weight: .heavy))
                                    .frame(width: 240, height: 64)
                                    .minimumScaleFactor(0.1)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            if isWrong {
                                Text("❌ 제시어와 달라요 다시 읽어 주세요 ❌")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.vertical, 2)
                                .background(Color("LightRed"))
                                .foregroundColor(Color("Red"))
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.top, 3)
                }
            }
            .padding(.top, 40)
            if isComplete {
                MissionCompleteView(Title: missionTitle, background: missionColor)
            }
        }
        .navigationBarHidden(true)
        .onDisappear{
            speechRecognizer.stopTranscript()
            checktimer?.invalidate()
            checktimer = nil
    
        }
    }
}

struct MissionSpeechView_Previews: PreviewProvider {
    static var previews: some View {
        MissionSpeechView(missionTitle: "바보 되기 🤪", missionTip: "장소로 이동해서 미션하기 버튼을 누르고 나는 바보다 라고 말할 준비가 되면 말하기 버튼을 누르고 크게 외쳐주세요!", missionColor: .blue, answerText: "나는 바보다", speechTime: 5.0)
    }
}
