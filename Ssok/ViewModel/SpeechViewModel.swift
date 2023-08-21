/*
 See LICENSE folder for this sample’s licensing information.
 */

import AVFoundation
import Speech
import SwiftUI

class SpeechViewModel: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    private var checkTimer : Timer?
    var audioEngine: AVAudioEngine?
    var request: SFSpeechAudioBufferRecognitionRequest?
    var task: SFSpeechRecognitionTask?
    var language: String?
    var currentLocaleIdentifier: String {
        return (language == "English") ? "en-US" : "ko-KR"
    }
    var recognizer: SFSpeechRecognizer? {
        return SFSpeechRecognizer(locale: Locale(identifier: currentLocaleIdentifier))
    }

    @Published var isComplete = false
    @Published var isWrong = false
    @Published var progressTime = 100.0
    @Published var transcript = ""

    init() {
        Task {
            do {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                showErrorText(error)
            }
        }
    }

    func startTranscribing(language: String) {
        Task {
            try await transcribe(language: language)
        }
    }

    func retryBtnTap() {
        self.isWrong = false
        self.progressTime = 100.0
        self.transcript = ""
    }
    
    func missionFail() {
        self.isWrong = true
        recognizerReset()
    }

    func completeMission() {
        self.isComplete = true
    }

    func isCorrectResult(answerText : String) -> Bool {
        let cleanedTranscript = transcript
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: "")
        if answerText
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: "") == cleanedTranscript {
            return true
        }
        return false
    }

    func updateProgressTime(speechTime: Double) {
        if progressTime > 0 {
            progressTime -= 0.1 * (100 / speechTime)
        }
    }
    private func transcribe(language: String) async throws {
        guard let recognizer = recognizer else {
            showErrorText(RecognizerError.nilRecognizer)
            return
        }
        guard recognizer.isAvailable else {
            self.showErrorText(RecognizerError.recognizerIsUnavailable)
            return
        }
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(
                with: request,
                resultHandler: { [weak self] result, error in
                    self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
                })
        } catch {
            self.recognizerReset()
            self.showErrorText(error)
        }
    }

    func recognizerReset() {
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }

    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode
            .installTap(onBus: 0,
                        bufferSize: 1024,
                        format: recordingFormat) {(buffer: AVAudioPCMBuffer, _: AVAudioTime) in
                request.append(buffer)
            }
        audioEngine.prepare()
        try audioEngine.start()
        return (audioEngine, request)
    }

    private func recognitionHandler(audioEngine: AVAudioEngine,
                                    result: SFSpeechRecognitionResult?,
                                    error: Error?) {
        if error != nil {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        if let result {
            transcript = result.bestTranscription.formattedString
        }
    }

    private func showErrorText(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "<< \(errorMessage) >>"
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
