import Foundation

class AddMemberViewModel: ObservableObject {

    @Published var memberName = ""
    @Published var isSubmitFailAlertShowing = false // 이름체크
    @Published var isCountLimitAlertShowing = false
    @Published var members = [Member]()
    var isMemberCountLimitOver: Bool {
        return members.count >= 6 ? true : false
    }

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
        if isMemberCountLimitOver {
            isCountLimitAlertShowing = true
        } else {
            appendMembers(memberName)
        }
    }

    func isMemberNameInvalid() -> Bool {
        guard !memberName.isEmpty,
              !members.contains(where: { $0.name == memberName }),
              memberName.isKorean else { return true }
        return false
    }

    func submitTextField() {
        if isMemberNameInvalid() {
            isSubmitFailAlertShowing = true
        } else {
            plusButtonDidTap()
        }
    }
}
