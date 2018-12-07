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
    
    @objc dynamic private(set) var name: String = ""
    @objc dynamic private(set) var tsBirthday: TimeInterval = 0.0
    var emails = List<EmailAddress>()
    
    override static func primaryKey() -> String? {
        return User.pkField
    }
    
    private static let pkField = "name"
    
}
