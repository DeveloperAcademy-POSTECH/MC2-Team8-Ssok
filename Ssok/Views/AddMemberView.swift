//
//  ContentView.swift
//  Soda
//
//  Created by 김민 on 2023/05/03.
//
// AddMemberView
// 004

import SwiftUI

struct AddMemberView: View {

    @StateObject private var viewModel  = AddMemberViewModel()
    @FocusState private var isFocused: Bool
    @EnvironmentObject var random: RandomContents
    @Binding var path: NavigationPath
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {

        ZStack {
            VStack {
                VStack(spacing: 0) {
                    TextField("한글로 닉네임을 입력해주세요.", text: $viewModel.memberName)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        .focused($isFocused)
                        .padding(.vertical, UIScreen.getHeight(7))
                }
                .overlay {
                    RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                        .stroke(lineWidth: 0.5)
                        .stroke(Color(.systemGray6))
                }
                .accentColor(.orange)
                .onSubmit {
                    viewModel.textFieldSubmit()
                }
                .alert("입력하는 이름을 다시 한번 확인해주세요.", isPresented: $viewModel.isSubmitFail) {
                    Button("OK") {
                        viewModel.isSubmitFail = false
                    }
                } message: {
                    Text("입력하신 이름을확인해주세요.\n이름은 한글만 가능합니다.")
                }
                .alert("인원은 최대 6명까지 가능합니다.", isPresented: $viewModel.isTotalAlertShowing) {
                    Button("OK") {
                        viewModel.isTotalAlertShowing = false
                        isFocused = false
                    }
                } message: {
                    Text("인원은 최대 6명까지만\n선택 가능합니다")
                }
                .padding(.horizontal, UIScreen.getWidth(20))
                .padding(.top, UIScreen.getHeight(15))
                List {
                    if !$viewModel.members.isEmpty {
                        Section {
                            ForEach(viewModel.members) { member in
                                HStack {
                                    Text("🧋")
                                    Text(member.name)
                                }
                            }
                            .onDelete(perform: viewModel.removeMembers)
                        } header: {
                            Text("같이 할 사람들")
                                .font(.system(size: UIScreen.getHeight(13)))
                                .foregroundColor(Color(.darkGray))
                        } footer: {
                            Text("인원은 최대 6명까지 가능합니다.")
                                .font(.system(size: UIScreen.getHeight(13)))
                                .foregroundColor(Color(.darkGray))
                        }
                    }
                }
                .listStyle(.inset)
                .scrollDisabled(true)
                Spacer()
                Button {
                    path.append(ViewType.strawView)
                    random.members = viewModel.members
                } label: {
                    Text("다음")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, UIScreen.getHeight(15))
                        .background(Color("Bg_bottom2"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, UIScreen.getWidth(20))
                .padding(.bottom, UIScreen.getHeight(10))
                .offset(y: -keyboardHeight)
                .disabled(viewModel.isNextButtonDisabled)
            }
            .navigationTitle("같이 할 사람들")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .ignoresSafeArea(.keyboard)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
                    .foregroundColor(Color("Bg_bottom2"))
            }
        }
        .onAppear {
            viewModel.setMemberData()
            viewModel.setNextButtonState()
        }
        .onReceive(NotificationCenter.default.publisher(for:
                                                            UIResponder
            .keyboardWillChangeFrameNotification)) { notification in
            guard let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                    as? CGRect else { return }
            let keyboardHeight = UIScreen.screenHeight - keyboardRect.origin.y
            self.keyboardHeight = max(0, keyboardHeight)
        }
    }
}
