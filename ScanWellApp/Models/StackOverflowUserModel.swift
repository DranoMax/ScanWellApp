//
//  StackOverflowUserModel.swift
//  ScanWellApp
//
//  Created by Alex S on 11/30/21.
//

import Foundation

struct StackOverflowUserModel: Decodable {
    var userId: Int
    var displayName: String
    var stackOverflowLink: String
    var profileImageUrl: String
    var reputationPoints: Int
    var badgeCounts: BadgeCountModel
    var creationTimestamp: TimeInterval
    var lastSeenTimestamp: TimeInterval
    var aboutMe: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case displayName = "display_name"
        case stackOverflowLink = "link"
        case profileImageUrl = "profile_image"
        case reputationPoints = "reputation"
        case badgeCounts = "badge_counts"
        case creationTimestamp = "creation_date"
        case lastSeenTimestamp = "last_access_date"
        case aboutMe = "about_me"
    }
}
