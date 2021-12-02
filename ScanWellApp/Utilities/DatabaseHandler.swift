//
//  DatabaseHandler.swift
//  ScanWellApp
//
//  Created by Alex S on 12/1/21.
//

import FMDB

/**
 Contains the unique identifiers necessary to identify a record.
 */
struct UpdateDatabaseModel {
    var deviceSerialNumber = ""
    var dateTime = ""
}

class DatabaseHandler: NSObject {
    
    static let shared = DatabaseHandler()
    private var databaseQueue: FMDatabaseQueue?
    
    // MARK: - Lifecycle Methods
    
    private override init() {
        super.init()
        
        if (self.databaseQueue == nil) {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(Constants.SQL_SCANWELL_DB)
            self.databaseQueue = FMDatabaseQueue(path: fileURL.path)
            self.createTables()
        }
    }
    
    // MARK: - Private Methods
    
    private func createTables() {
        self.databaseQueue?.inTransaction({ (database, rollback) in
            do {
                try database.executeUpdate("CREATE TABLE IF NOT EXISTS " + Constants.SQL_USER_TABLE + "(" +
                                            Constants.SQL_USER_ID + " STRING," +
                                            Constants.SQL_DISPLAY_NAME + " STRING," +
                                            Constants.SQL_STACKOVERFLOW_LINK + " STRING," +
                                            Constants.SQL_PROFILE_IMAGE_URL + " STRING," +
                                            Constants.SQL_REPUTATION_POINTS + " VARCHAR," +
                                            Constants.SQL_GOLD_BADGE_COUNT + " VARCHAR," +
                                            Constants.SQL_SILVER_BADGE_COUNT + " VARCHAR," +
                                            Constants.SQL_BRONZE_BADGE_COUNT + " DOUBLE," +
                                            Constants.SQL_ABOUT_ME + " STRING, " +
                                            Constants.SQL_CREATION_TIMESTAMP + " DATETIME," +
                                            Constants.SQL_LAST_SEEN_TIMESTAMP + " DATETIME," +
                                            "PRIMARY KEY (" + // Prevent duplicate records
                                            Constants.SQL_USER_ID + "))", values: nil)
            } catch {
                // Log exception
                rollback.pointee = true
            }
        })
    }
    
    // MARK: - Public Methods
    
    func saveUsersToLocalDb(_ userList: [StackOverflowUserModel]) {
        guard userList.count > 0 else { return }
        
        self.databaseQueue?.inTransaction({ (database, rollback) in
            for user in userList {
                do {
                    try database.executeUpdate("INSERT or REPLACE INTO " + Constants.SQL_USER_TABLE + "(" +
                                               Constants.SQL_USER_ID + "," +
                                               Constants.SQL_DISPLAY_NAME + "," +
                                               Constants.SQL_STACKOVERFLOW_LINK + "," +
                                               Constants.SQL_PROFILE_IMAGE_URL + "," +
                                               Constants.SQL_REPUTATION_POINTS + "," +
                                               Constants.SQL_GOLD_BADGE_COUNT + "," +
                                               Constants.SQL_SILVER_BADGE_COUNT + "," +
                                               Constants.SQL_BRONZE_BADGE_COUNT + "," +
                                               Constants.SQL_ABOUT_ME + "," +
                                               Constants.SQL_CREATION_TIMESTAMP + "," +
                                               Constants.SQL_LAST_SEEN_TIMESTAMP +
                                               ")VALUES(?,?,?,?,?,?,?,?,?,?,?)",
                                               values: [user.userId,
                                                        user.displayName,
                                                        user.stackOverflowLink,
                                                        user.profileImageUrl,
                                                        user.reputationPoints,
                                                        user.badgeCounts.gold,
                                                        user.badgeCounts.silver,
                                                        user.badgeCounts.bronze,
                                                        user.aboutMe,
                                                        user.creationTimestamp,
                                                        user.lastSeenTimestamp])
                    
                } catch {
                    // Log exception
                    rollback.pointee = true
                }
            }
        })
    }
    
    func getLocallySavedUsers() -> [StackOverflowUserModel] {
        var savedUserList = [StackOverflowUserModel]()
        
        self.databaseQueue?.inTransaction({ (database, rollback) in
            do {
                let resultSet: FMResultSet = try database.executeQuery("SELECT * FROM " + Constants.SQL_USER_TABLE, values: [])
  
                while resultSet.next() {
                    let userId = Int(resultSet.int(forColumn: Constants.SQL_USER_ID))
                    let reputationPoints = Int(resultSet.int(forColumn: Constants.SQL_REPUTATION_POINTS))
                    let goldBadgeCount = Int(resultSet.int(forColumn: Constants.SQL_GOLD_BADGE_COUNT))
                    let silverBadgeCount = Int(resultSet.int(forColumn: Constants.SQL_SILVER_BADGE_COUNT))
                    let bronzeBadgeCount = Int(resultSet.int(forColumn: Constants.SQL_BRONZE_BADGE_COUNT))
                    let creationTimestamp = resultSet.double(forColumn: Constants.SQL_CREATION_TIMESTAMP)
                    let lastSeenTimestamp = resultSet.double(forColumn: Constants.SQL_LAST_SEEN_TIMESTAMP)
                    
                    if let displayName = resultSet.string(forColumn: Constants.SQL_DISPLAY_NAME),
                       let stackOverflowLink = resultSet.string(forColumn: Constants.SQL_STACKOVERFLOW_LINK),
                       let profileImageUrl = resultSet.string(forColumn: Constants.SQL_PROFILE_IMAGE_URL),
                       let aboutMe = resultSet.string(forColumn: Constants.SQL_ABOUT_ME) {
                        savedUserList.append(StackOverflowUserModel(userId: userId,
                                                                    displayName: displayName,
                                                                    stackOverflowLink: stackOverflowLink,
                                                                    profileImageUrl: profileImageUrl,
                                                                    reputationPoints: reputationPoints,
                                                                    badgeCounts: BadgeCountModel(bronze: bronzeBadgeCount,
                                                                                                 silver: silverBadgeCount,
                                                                                                 gold: goldBadgeCount),
                                                                    creationTimestamp: creationTimestamp,
                                                                    lastSeenTimestamp: lastSeenTimestamp,
                                                                    aboutMe: aboutMe))
                    }
                }
            } catch {
                // Log exception
                rollback.pointee = true
            }
        })
        
        return savedUserList
    }
}
