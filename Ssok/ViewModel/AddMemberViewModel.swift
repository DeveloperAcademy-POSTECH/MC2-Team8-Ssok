import Foundation

class AddMemberViewModel: ObservableObject {

    @Published var memberName = ""
    @Published var isSubmitFail = false
    @Published var isTotalAlertShowing = false
    @Published var isExistAlertShowing = false
    @Published var members = [Member]()

    func setMemberData() {
        if let data = UserDefaults.standard.value(forKey: "members") as? Data {
            let decodedData = try? PropertyListDecoder().decode(Array<Member>.self, from: data)
            members = decodedData ?? []
        }
    }

    func appendMembers(_ memberName: String) {
        members.append(Member(name: memberName))
        UserDefaults.standard.set(try? PropertyListEncoder().encode(members), forKey: "members")

    }

    func removeMembers(at offsets: IndexSet) {
        members.remove(atOffsets: offsets)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(members), forKey: "members")
       
    }

    func plusButtonDidTap() {
        if members.count >= 6 {
            isTotalAlertShowing = true
        } else {
            appendMembers(memberName)
        }
        memberName = ""
    }

    func textFieldSubmit() {
        guard !memberName.isEmpty,
              !members.contains(where: { $0.name == memberName }),
              memberName.isKorean else {
            isSubmitFail = true
            return
        }
        plusButtonDidTap()
        isSubmitFail = false
    }
}
