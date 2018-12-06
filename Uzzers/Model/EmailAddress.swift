//
//  EmailAddress.swift
//  Uzzers
//
//  Created by Kiss Rudolf Zsolt on 2018. 12. 05..
//  Copyright © 2018. Kiss Rudolf Zsolt. All rights reserved.
//

import Foundation
import RealmSwift

class EmailAddress: Object {
    
    convenience init(email: String, user: User) {
        self.init()
        self.email = email
        self.owner = user
    }
    
    @objc dynamic var email: String = ""
    @objc dynamic var owner: User?
    
    override static func primaryKey() -> String? {
        return EmailAddress.pkField
    }
    
    private static let pkField = "email"
    
}
