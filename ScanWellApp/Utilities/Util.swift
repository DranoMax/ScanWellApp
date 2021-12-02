//
//  Util.swift
//  ScanWellApp
//
//  Created by Alex S on 12/1/21.
//

import Foundation

class Util {
    static func addSIfNeeded(_ str: String, count: Int) -> String {
        if count != 1 {
            return String(format: str, "s")
        }
        
        return String(format: str, "")
    }
}
