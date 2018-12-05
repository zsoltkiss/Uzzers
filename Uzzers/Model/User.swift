//
//  User.swift
//  Uzzers
//
//  Created by Kiss Rudolf Zsolt on 2018. 12. 05..
//  Copyright © 2018. Kiss Rudolf Zsolt. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    convenience init(name: String, timestamp: TimeInterval) {
        self.init()
        self.name = name
        self.tsBirthday = timestamp
    }
    
    private(set) var name: String = ""
    private(set) var tsBirthday: TimeInterval = 0.0
    private(set) var emails = [EmailAddress]()
    
    var isEmailProvided: Bool {
        return emails.count > 0
    }
    
    func addEmailAddress(email: String) -> Bool {
        let emailStrings = emails.map { $0.email }
        
        guard !emailStrings.contains(email) else {
            return false
        }
        
        emails.append(EmailAddress(email: email))
        return true
    }
    
}
