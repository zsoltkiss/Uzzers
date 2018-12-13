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
    @discardableResult
    func addUser(_ newUser: User, emails: [EmailAddress]) -> Error? {
        do {
            try theRealm.write {
                theRealm.add(newUser)
                if (UIApplication.shared.delegate as! AppDelegate).isDebug {
                    print("User added: \(newUser.name)")
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
    
    /**
     Deletes a user with the given name from database.
     - Parameter name: a String, representing the name of user we want to delete
     - Returns: an Error instance in case of any problem during database operation, otherwise nil
     */
    @discardableResult
    func deleteUser(with name: String) -> Error? {
        do {
            try theRealm.write {
                let results = theRealm!.objects(User.self).filter("name = %@", name)
                theRealm.delete(results)
                if (UIApplication.shared.delegate as! AppDelegate).isDebug {
                    print("User deleted: \(name)")
                }
            }
        } catch {
            print("Error occured when deleting User object. \(error)")
            return error
        }
        
        return nil
    }
    
    /**
     Deletes an email address from database.
     - Parameter email: a String, representing the e-mail address
     - Returns: an Error instance in case of any problem during database operation, otherwise nil
     */
    @discardableResult
    func deleteEmail(_ email: String) -> Error? {
        do {
            try theRealm.write {
                let results = theRealm!.objects(EmailAddress.self).filter("email = %@", email)
                theRealm.delete(results)
                if (UIApplication.shared.delegate as! AppDelegate).isDebug {
                    print("EmailAddress deleted: \(email)")
                }
            }
        } catch {
            print("Error occured when deleting EmailAddress object. \(error)")
            return error
        }
        
        return nil
    }
}


