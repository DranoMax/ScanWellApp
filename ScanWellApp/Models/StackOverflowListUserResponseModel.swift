//
//  StackOverflowListUserResponseModel.swift
//  ScanWellApp
//
//  Created by Alex S on 11/30/21.
//

import Foundation

struct StackOverflowListUserResponseModel: Decodable {
    var results: [StackOverflowUserModel]
    
    enum CodingKeys: String, CodingKey {
        case results = "items"
    }
}
