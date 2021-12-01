//
//  Constants.swift
//  ScanWellApp
//
//  Created by Alex S on 12/1/21.
//

import Foundation

struct Constants {
    
    // API URLs
    static let listStackOverflowUsersURL = "https://api.stackexchange.com/2.2/users?site=stackoverflow&filter=!bYRbxNMs)q)VkY"
    
    // ViewControllers
    static let userDetailsVC = "UserDetailsController"
    
    // Custom Table Cells
    static let stackOverflowUserCell = "StackOverflowUserCell"
    
    // Strings
    static let memberFor = " Member for "
    static let lastSeen = " Last seen %@"
    static let secondsAgo = "seconds ago"
    static let minutesAgo = "minutes ago"
    static let hoursAgo = "hours ago"
    static let daysAgo = "days ago"
    static let weeksAgo = "weeks ago"
    static let monthsAgo = "months ago"
    static let yearsAgo = "years ago"
    static let days = "years"
    static let months = "months"
    static let years = "years"
    static let stackOverflowUsers = "Stack Overflow Users"
    static let userProfileCacheKey = "user_profile_image_%@"
    
    // SQL Keys
    static let SQL_SCANWELL_DB = "scanwell_db"
    static let SQL_USER_TABLE = "users"
    static let SQL_USER_ID = "user_id"
    static let SQL_DISPLAY_NAME = "display_name"
    static let SQL_STACKOVERFLOW_LINK = "stackoverflow_link"
    static let SQL_PROFILE_IMAGE_URL = "profile_image_url"
    static let SQL_REPUTATION_POINTS = "reputation_points"
    static let SQL_GOLD_BADGE_COUNT = "gold_badge_count"
    static let SQL_SILVER_BADGE_COUNT = "silver_badge_count"
    static let SQL_BRONZE_BADGE_COUNT = "bronze_badge_count"
    static let SQL_CREATION_TIMESTAMP = "creation_timestamp"
    static let SQL_LAST_SEEN_TIMESTAMP = "last_seen_timestamp"
    static let SQL_ABOUT_ME = "about_me"
}
