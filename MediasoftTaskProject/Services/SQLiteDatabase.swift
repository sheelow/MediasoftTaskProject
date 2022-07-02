//
//  Database.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 30.06.2022.
//

import Foundation
import SQLite

class SQLiteDatabase {
    
    static let shared = SQLiteDatabase()
    
    var database: Connection?
    
    init() {
        connectToDatabase()
    }
    
    func createTable() {
        SQLiteCommands.createTable()
    }
    
    private func connectToDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("contactList").appendingPathExtension("sqlite3")
            database = try Connection(fileUrl.path)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
