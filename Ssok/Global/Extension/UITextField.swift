//
//  UITextField.swift
//  Ssok
//
//  Created by 235 on 2023/07/22.
//

import SwiftUI
extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
