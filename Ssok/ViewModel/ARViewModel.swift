//
//  ARViewModel.swift
//  Ssok
//
//  Created by CHANG JIN LEE on 2023/05/13.
//

import Foundation
import RealityKit
import ARKit

class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
    @Published var model = ARModel()
    @Published var ARFrame = false

    var blinkCount = 0
    var smileCount = 0
    var isBlink = false
    var isSmile = false
    var isTongueOut = false
    var asyncBlinkCount = 0
    var asyncSmileCount = 0
    var asyncIsBlinkCount = false
    var asyncIsSmileCount = false

    var arView: ARView {
        model.arView
    }

    var getSmiling: Bool {
        var tempSmile = false
        isBlink = false

        if model.tongueOut > 0.5 {
            isSmile = true
            tempSmile = true
        }

        return tempSmile
    }

    var getBlinking: Bool {
        isBlink = false

        if model.blinkLeft > 0.5 || model.blinkRight > 0.5 {
            isBlink = true
        }

        return isBlink
    }

    var setTongueOut: Bool {
        isTongueOut = false

        if model.tongueOut > 0.5 {
            isTongueOut = true
        }

        return isTongueOut
    }

    var getBlinkCount: Int {
        return blinkCount
    }

    func calculateSmileCount() -> String {
        smileCount += 1
        if smileCount > 30 {
            asyncSmileCount += 1
            smileCount = 0
        }
        if asyncSmileCount >= 2 {
            asyncSmileCount = 2
            asyncIsSmileCount = true
        }
        return ""
    }

    func calculateBlinkCount() -> String {
        blinkCount += 1
        if blinkCount > 30 {
            asyncBlinkCount += 1
            blinkCount = 0
        }
        if asyncBlinkCount >= 2 {
            asyncBlinkCount = 2
            asyncIsBlinkCount = true
        }
        return ""
    }

    func flushCount() -> String {
        smileCount = 0
        blinkCount = 0
        return ""
    }

    func startSessionDelegate() {
        model.arView.session.delegate = self
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first  as? ARFaceAnchor {
            model.update(faceAnchor: faceAnchor)
        }
    }
}
