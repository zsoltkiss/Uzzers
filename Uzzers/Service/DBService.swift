//
//  DBService.swift
//  Uzzers
//
//  Created by Kiss Rudolf Zsolt on 2018. 12. 12..
//  Copyright © 2018. Kiss Rudolf Zsolt. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Service that delegates database relating operations from UI (e.g. from view controllers) towards underlying persistence layer (e.g. a Realm database).
 */
final class DBService {
    
    /**
    Singleton instance of the service.
    */
    static let shared = DBService()
    
    private var theRealm: Realm!
    
    private init() {
        theRealm = try! Realm()
        if (UIApplication.shared.delegate as! AppDelegate).isDebug {
            print("Realm file: \(String(describing: theRealm.configuration.fileURL))")
        }
    }
    
    /**
     Fetches and return User objects persisted in database
     - Returns: a list of User objects or an empty list.
    */
    func fetchUsers() -> Results<User> {
        return theRealm.objects(User.self)
    }
    
    /**
     Persists a User object and his/her email addresses into database.
     - Parameter newUser: a User object to persist
     - Parameter emails: an array of EmalAddress objects that belongs to newUser
     - Returns: nil in the case of operation success otherwise an Error instance
    */
    func addUser(_ newUser: User, emails: [EmailAddress]) -> Error? {
        do {
            try theRealm.write {
                theRealm.add(newUser)
                if (UIApplication.shared.delegate as! AppDelegate).isDebug {
                    print("User added.")
                }
                theRealm.add(emails)
                if (UIApplication.shared.delegate as! AppDelegate).isDebug {
                    print("User's email addresses added.")
                }
            }
            
        } catch {
            print("Error occured when persisting User object. \(error)")
            return error
        }
        
        return nil
    }
    
    /**
     Checks whether a User object exist in database with the given name.
     - Parameter name: a String, representing the name we want to search for
     - Returns: true when a User found with the given name, otherwise false
    */
    func isNameExist(name: String) -> Bool {
        let results = theRealm!.objects(User.self).filter("name = %@", name)
        return results.count > 0
    }
    
}


