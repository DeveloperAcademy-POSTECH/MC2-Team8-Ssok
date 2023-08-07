//
//  ARViewModelTests.swift
//  ARViewModelTests
//
//  Created by CHANG JIN LEE on 2023/08/08.
//

import XCTest
import ARKit
@testable import Ssok // Replace with your app's module name

class ARViewModelTests: XCTestCase {

    private var arViewModel: ARViewModel!

    override func setUpWithError() throws {
        arViewModel = ARViewModel()
    }

    override func tearDownWithError() throws {
        arViewModel = nil
    }

    func testGetSmiling() {
        // MARK: getSmiling 프로퍼티를 테스트합니다.
        // MARK: model의 값을 지정합니다.tongueOut, model.blinkLeft, model.blinkRight 가 필요해요.
        arViewModel.model.tongueOut = 0.6
        arViewModel.model.blinkLeft = 0.3
        arViewModel.model.blinkRight = 0.8

        XCTAssertTrue(arViewModel.getSmiling)

        // TODO: 더 많은 시나리오도 생각해봐야 함.
    }

    func testGetBlinking() {
        // MARK: getBlinking 프로퍼티를 테스트합니다.
        // MARK: model의 값을 지정합니다. model.blinkLeft, model.blinkRight 가 필요해요.
        arViewModel.model.blinkLeft = 0.8
        arViewModel.model.blinkRight = 0.2

        XCTAssertTrue(arViewModel.getBlinking)

        // TODO: 더 많은 시나리오도 생각해봐야 함.
    }

    func testSetTongueOut() {
        // MARK: setTongueOut 프로퍼티를 테스트합니다.
        // MARK: model의 값을 지정합니다. model.tongueOut 가 필요해요.
        arViewModel.model.tongueOut = 0.7

        XCTAssertTrue(arViewModel.setTongueOut)

        // TODO: 더 많은 시나리오도 생각해봐야 함.
    }

    func testCalculateSmileCount() {
        // MARK: calculateSmileCount는 매 초마다 더하기 연산을 하도록 되어 있는데 이러면 UI test에서 코드를 짜야하는 건가
        XCTAssertEqual(arViewModel.calculateSmileCount(), "")
        XCTAssertEqual(arViewModel.calculateSmileCount(), "")
    }

    func testCalculateBlinkCount() {
        XCTAssertEqual(arViewModel.calculateBlinkCount(), "")
        XCTAssertEqual(arViewModel.calculateBlinkCount(), "")
    }

    func testFlushCount() {
        // MARK: count 초기화 메소드를 부르고 smileCount, blinkCount 프로퍼티가 0으로 리셋이 되는지 확인.
        arViewModel.smileCount = 10
        arViewModel.blinkCount = 20

        XCTAssertEqual(arViewModel.flushCount(), "")
        XCTAssertEqual(arViewModel.smileCount, 0)
        XCTAssertEqual(arViewModel.blinkCount, 0)

        // TODO: 더 많은 시나리오도 생각해봐야 함.
    }
}
