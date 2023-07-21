//
//  Character.swift
//  Ssok
//
//  Created by 235 on 2023/07/01.
//

import Foundation
extension String {
    var isKorean: Bool {
        for character in self {
            let unicodeScalar = character.unicodeScalars.first!
            let characterSet = CharacterSet(charactersIn: "가"..."힣")
            if !characterSet.contains(unicodeScalar) {
                return false
            }
        }
        return true
    }
}
