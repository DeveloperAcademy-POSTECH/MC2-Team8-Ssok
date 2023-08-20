//
//  StrawViewModel.swift
//  6Bubbles
//
//  Created by CHANG JIN LEE on 2023/05/04.
//

import Foundation
import CoreMotion

class StrawViewModel: ObservableObject {

    private let motionManger = CMMotionManager()
    private var timer: Timer?
    private var previousgravity = 0
    @Published var showWhiteRectangle = true
    @Published var nextView = false
    @Published var progress = 0.0

    var maxProgress: Double {
        return min(progress > 0.99 ? 1: progress, 1.0)
    }
    
    init() {
        startupdatingMotion()
    }
    func startupdatingMotion() {
        progress = 0.0
        if motionManger.isDeviceMotionAvailable {
            motionManger.deviceMotionUpdateInterval = 0.2
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
                self?.updateProgress()
            }
            motionManger.startDeviceMotionUpdates()}
    }
    private func updateProgress() {
        guard let motionData = motionManger.deviceMotion else { return}
        let gravityX = motionData.gravity.x
        let gravityY = motionData.gravity.y
        let gravityZ = motionData.gravity.z
        var currentGravity = 0
        if gravityX > 0.2 || gravityY > 0.2 || gravityZ > 0.2 {
            currentGravity = 1
        } else if gravityY >= -0.2 || gravityX >= -0.2 || gravityZ >= -0.2 {
            currentGravity = 0
        } else if gravityX < -0.2 || gravityY < -0.2 || gravityZ < 0.2 {
            currentGravity  = 2
        }
        if progress >= 1 {
            timer?.invalidate()
            return
        } else if currentGravity != previousgravity {
            progress += 0.1
            previousgravity = currentGravity
        }
    }
    
    func uppearlVibration() {
        let vibration = 3
        let timeintervalvibe : TimeInterval = 0.2
        for index in 0..<vibration {
               DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index) * timeintervalvibe)) {
                   HapticManager.instance.impact(style: .heavy)
               }
           }
    }
}
