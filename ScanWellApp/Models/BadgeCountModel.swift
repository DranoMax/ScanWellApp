//
//  BadgeCountModel.swift
//  ScanWellApp
//
//  Created by Alex S on 11/30/21.
//

import Foundation

struct BadgeCountModel: Decodable {
    var bronze: Int
    var silver: Int
    var gold: Int
    
    enum CodingKeys: String, CodingKey {
        case bronze
        case silver
        case gold
    }
}
