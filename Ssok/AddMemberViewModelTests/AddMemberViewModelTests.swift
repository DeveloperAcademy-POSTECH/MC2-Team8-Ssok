//
//  AddMemberViewModelTests.swift
//  SsokTests
//
//  Created by 김민 on 2023/08/19.
//

import XCTest
@testable import Ssok

final class AddMemberViewModelTests: XCTestCase {

    private var addMemberViewModel: AddMemberViewModel!

    override func setUp() {
        super.setUp()
        addMemberViewModel = AddMemberViewModel()
    }

    override func tearDown() {
        addMemberViewModel = nil
        super.tearDown()
    }

    func testIsMemberCountOverLimit() {
        for memberNumber in 0...6 {
            addMemberViewModel.appendMember("member\(memberNumber)")
        }

        let isOverLimit = addMemberViewModel.isMemberCountOverLimit
        XCTAssertEqual(isOverLimit, true)
    }

    func testAppendMember() {
        addMemberViewModel.appendMember("소다")

        XCTAssertTrue(!addMemberViewModel.members.isEmpty)
        XCTAssertTrue(addMemberViewModel.members.contains { $0.name == "소다" })
    }

    func testRemoveMember() {
        let firstMember = Member(name: "소다")
        let secondMember = Member(name: "지니")
        addMemberViewModel.members = [firstMember, secondMember]
        let originalCount = addMemberViewModel.members.count

        addMemberViewModel.removeMember(at: IndexSet(integer: 0))

        XCTAssertEqual(addMemberViewModel.members.count, originalCount-1)
        XCTAssertFalse(addMemberViewModel.members.contains { $0.name == firstMember.name })
    }

    func testSaveMembers() {
        let members = [Member(name: "소다"), Member(name: "지니")]
        addMemberViewModel.members = members

        let savedMembers = addMemberViewModel.getMembers()

        XCTAssertEqual(members, savedMembers)
    }

    func testIsMemberNameInvalid() {
        addMemberViewModel.appendMember("소다")

        addMemberViewModel.memberName = ""
        XCTAssertTrue(addMemberViewModel.isMemberNameInvalid())

        addMemberViewModel.memberName = "소다"
        XCTAssertTrue(addMemberViewModel.isMemberNameInvalid())

        addMemberViewModel.memberName = "Soda"
        XCTAssertTrue(addMemberViewModel.isMemberNameInvalid())
    }

    func testSetTextFieldSubmissionState() {
        for memberNumber in 0..<6 {
            addMemberViewModel.appendMember("member\(memberNumber)")
        }
        addMemberViewModel.memberName = "소다"

        XCTAssertTrue(addMemberViewModel.isMemberCountOverLimit)
        XCTAssertEqual(addMemberViewModel.setTextFieldSubmissionState(),
                       TextFieldSubmissionState.overMemberCountLimit)

        addMemberViewModel.memberName = "Soda"
        addMemberViewModel.members.removeAll()

        XCTAssertTrue(addMemberViewModel.isMemberNameInvalid())
        XCTAssertEqual(addMemberViewModel.setTextFieldSubmissionState(), .invalidName)

        addMemberViewModel.memberName = "지니"

        XCTAssertFalse(addMemberViewModel.isMemberCountOverLimit)
        XCTAssertFalse(addMemberViewModel.isMemberNameInvalid())
        XCTAssertEqual(addMemberViewModel.setTextFieldSubmissionState(), .success)
    }

    func testSubmitTextField() {
        for memberNumber in 0..<6 {
            addMemberViewModel.appendMember("member\(memberNumber)")
        }
        addMemberViewModel.memberName = "소다"
        addMemberViewModel.submitTextField()
        XCTAssertTrue(addMemberViewModel.isMemberCountOverLimit)

        addMemberViewModel.memberName = "Soda"
        addMemberViewModel.members.removeAll()
        addMemberViewModel.submitTextField()
        XCTAssertTrue(addMemberViewModel.isInvalidNameAlertShowing)

        addMemberViewModel.memberName = "지니"
        addMemberViewModel.submitTextField()
        XCTAssertFalse(addMemberViewModel.members.isEmpty)
        XCTAssertTrue(addMemberViewModel.members.contains { $0.name == "지니" })
    }
}
