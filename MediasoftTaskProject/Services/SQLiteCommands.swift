//
//  DatabaseCommands.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 30.06.2022.
//

import Foundation
import SQLite
import SQLite3

//MARK: - SQLiteCommands
class SQLiteCommands {
    
    //MARK: - Static Properties
    static var table = Table("databaseModel")
    
    static let id = Expression<String>("id")
    static let firstName = Expression<String>("firstName")
    static let lastName = Expression<String>("lastName")
    static let photo = Expression<Data>("photo")
    
    //MARK: - createTable
    static func createTable() {
        
        guard let database = SQLiteDatabase.shared.database else { return }
        
        do {
            try database.run(table.create(ifNotExists: true) { table in
                table.column(id)
                table.column(firstName)
                table.column(lastName)
                table.column(photo)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    //MARK: - insertRow
    static func insertRow(_ profileValues: DatabaseModel) -> Bool? {
        
        guard let database = SQLiteDatabase.shared.database else { return nil }
        
        do {
            try database.run(table.insert(id <- profileValues.id,
                                          firstName <- profileValues.firstName,
                                          lastName <- profileValues.lastName,
                                          photo <- profileValues.photo))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error.localizedDescription)")
            return false
        }
    }
    
    //MARK: - presentRows
    static func presentRows() -> [DatabaseModel]? {
        guard let database = SQLiteDatabase.shared.database else { return nil }
        
        var profileArray = [DatabaseModel]()
        
        table = table.order(id.desc)
        
        do {
            for profile in try database.prepare(table) {
                
                let idValue = profile[id]
                let firstNameValue = profile[firstName]
                let firstLastValue = profile[lastName]
                let photoValue = profile[photo]
                
                let profileObject = DatabaseModel(id: idValue, firstName: firstNameValue, lastName: firstLastValue, photo: photoValue)
                
                profileArray.append(profileObject)
            }
            
        } catch {
            print("Present row error: \(error.localizedDescription)")
        }
        return profileArray
    }
    
    //MARK: - deleteRow
    static func deleteRow(profileId: String) {
        guard let database = SQLiteDatabase.shared.database else { return }
        
        do {
            let profile = table.filter(id == profileId).limit(1)
            try database.run(profile.delete())
        } catch {
            print("Delete row error: \(error.localizedDescription)")
        }
    }
}
