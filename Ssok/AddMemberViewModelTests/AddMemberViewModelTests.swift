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

    override func setUpWithError() throws {
        addMemberViewModel = AddMemberViewModel()
    }

    override func tearDownWithError() throws {
        addMemberViewModel = nil
    }
}
