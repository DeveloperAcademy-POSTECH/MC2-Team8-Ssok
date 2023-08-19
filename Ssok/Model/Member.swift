//
//  Member.swift
//  6Bubbles
//
//  Created by 235 on 2023/05/06.
//

import Foundation

struct Member: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
}
