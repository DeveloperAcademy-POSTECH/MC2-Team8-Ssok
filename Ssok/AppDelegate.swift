//
//  AppDelegate.swift
//  Ssok
//
//  Created by CHANG JIN LEE on 2023/05/13.
//

import UIKit
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    @Binding var state: Bool
    @Binding var largePearlIndex: Int
    @Binding var title: String
    var window: UIWindow?

    init(state: Binding<Bool>, largePearlIndex: Binding<Int>, title: Binding<String>){
        self._state = state
        self._largePearlIndex = largePearlIndex
        self._title = title
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let smileView = MissionSmileView(title: title, state: $state, largePearlIndex: $largePearlIndex)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: smileView)
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}
