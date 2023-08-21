//
//  SpeechViewTestCode.swift
//  SsokTests
//
//  Created by 235 on 2023/08/19.
//

import XCTest
@testable import Ssok
import Speech

final class SpeechViewTestCode: XCTestCase {
    private var speechViewModel: SpeechViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        speechViewModel = SpeechViewModel()
    }

    override func tearDown() {
        speechViewModel = nil
        super.tearDown()
    }

    func testUpdateProgressTime() {
        speechViewModel.updateProgressTime(speechTime: 10)
        XCTAssertEqual(speechViewModel.progressTime, 99)
    }
    
    func testCorrectResult() {
        speechViewModel.transcript = "선호는 천재야"
        XCTAssertTrue(speechViewModel.isCorrectResult(answerText: "선호는 천재야"))
    }

    func testFaultResult() {
        speechViewModel.transcript = "김민은 천재야"
        XCTAssertFalse(speechViewModel.isCorrectResult(answerText: "김민은 모야"))
    }

    func testCompleteMission() {
         XCTAssertFalse(speechViewModel.isComplete)
         speechViewModel.completeMission()
         XCTAssertTrue(speechViewModel.isComplete)
     }

    func testRetryBtnTap() {
        speechViewModel.isWrong = true
        speechViewModel.progressTime = 50.0
        speechViewModel.transcript = "아무이야기"
        speechViewModel.retryBtnTap()
        XCTAssertFalse(speechViewModel.isWrong)
        XCTAssertEqual(speechViewModel.progressTime, 100.0)
        XCTAssertEqual(speechViewModel.transcript, "")
    }
    
    func testRecognzierReset() {
        speechViewModel.recognizerReset()
        XCTAssertNil(speechViewModel.audioEngine)
        XCTAssertNil(speechViewModel.task)
        XCTAssertNil(speechViewModel.request)
    }

    func testMissionFail() {
        speechViewModel.missionFail()
        XCTAssertTrue(speechViewModel.isWrong)
    }

}
