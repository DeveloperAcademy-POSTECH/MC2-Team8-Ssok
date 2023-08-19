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
        addMemberViewModel.members = [
            Member(name: "소다"),
            Member(name: "지니"),
            Member(name: "스낵"),
            Member(name: "씨제이"),
            Member(name: "핀"),
            Member(name: "선데이"),
            Member(name: "워니")
        ]

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
        let members = [
            Member(name: "소다"),
            Member(name: "지니")
        ]

        addMemberViewModel.members = members

        let savedMembers = addMemberViewModel.getMembers()

        XCTAssertEqual(members, savedMembers)
    }

    func testIsMemberNameNotKorean() {
        addMemberViewModel.memberName = "ㅇㄴㄹ"
        let isInvalid = addMemberViewModel.isMemberNameInvalid()

        XCTAssertTrue(isInvalid)
    }

    func testIsMemberNameEmpty() {
        addMemberViewModel.memberName = ""
        let isInvalid = addMemberViewModel.isMemberNameInvalid()

        XCTAssertTrue(isInvalid)
    }

    func testIsMemberNameOverlapped() {
        addMemberViewModel.members = [Member(name: "소다")]
        addMemberViewModel.memberName = "소다"
        let isInvalid = addMemberViewModel.isMemberNameInvalid()

        XCTAssertTrue(isInvalid)
    }
}
