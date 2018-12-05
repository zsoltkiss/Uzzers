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
    
    convenience init(email: String) {
        self.init()
        self.email = email
    }
    
    @objc dynamic var email: String = ""
    @objc dynamic var id = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return EmailAddress.pkField
    }
    
    private static let pkField = "id"
    
}
