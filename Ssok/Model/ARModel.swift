//
//  ARModel.swift
//  Ssok
//
//  Created by CHANG JIN LEE on 2023/05/13.
//

import Foundation
import RealityKit
import ARKit

enum ArViewController{
    case smile
    case blink
}

struct ARModel {
    private(set) var arView: ARView
    var smileRight: Float = 0
    var smileLeft: Float = 0
    var blinkRight: Float = 0
    var blinkLeft: Float = 0
    var tongueOut: Float = 0

    init() {
        arView = ARView(frame: .zero)
        arView.session.run(ARFaceTrackingConfiguration())
    }

    mutating func update(faceAnchor: ARFaceAnchor) {
        smileRight = Float(
            truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthSmileRight})?.value ?? 0
        )
        smileLeft = Float(
            truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthSmileLeft})?.value ?? 0
        )
        blinkRight = Float(
            truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeBlinkRight})?.value ?? 0
        )
        blinkLeft = Float(
            truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeBlinkLeft})?.value ?? 0
        )
        tongueOut = Float(
            truncating: faceAnchor.blendShapes.first(where: {$0.key == .tongueOut})?.value ?? 0
        )
    }
}
