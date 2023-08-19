import Foundation

class AddMemberViewModel: ObservableObject {

    @Published var memberName = ""
    @Published var isSubmitFailAlertShowing = false
    @Published var isCountLimitAlertShowing = false
    @Published var members: [Member] = [] {
        didSet {
            saveMembers()
        }
    }

    let memberDataKey = "members"
    var isMemberCountOverLimit: Bool {
        return members.count >= 6 ? true : false
    }

    init() {
        members = getMembers()
    }

    func getMembers() -> [Member] {
        guard
            let data = UserDefaults.standard.data(forKey: memberDataKey),
            let savedData = try? JSONDecoder().decode([Member].self, from: data) else { return [] }
        return savedData
    }

    func appendMember(_ memberName: String) {
        members.append(Member(name: memberName))
    }

    func removeMember(at offsets: IndexSet) {
        members.remove(atOffsets: offsets)
    }

    func saveMembers() {
        if let encodedData = try? JSONEncoder().encode(members) {
            UserDefaults.standard.set(encodedData, forKey: memberDataKey)
        }
    }

    func plusButtonDidTap() {
        if isMemberCountOverLimit {
            isCountLimitAlertShowing = true
        } else {
            appendMember(memberName)
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
