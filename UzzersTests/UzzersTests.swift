//
//  UzzersTests.swift
//  UzzersTests
//
//  Created by Kiss Rudolf Zsolt on 2018. 12. 12..
//  Copyright © 2018. Kiss Rudolf Zsolt. All rights reserved.
//

import XCTest
@testable import Uzzers
import Foundation

class UzzersTests: XCTestCase {
    
    private static let predefinedUser1 = User(name: "Teszt Elek", timestamp: "2001-11-11".timestamp()!)
    private static let predefinedUser2 = User(name: "Kala Pál", timestamp: "1947-02-17".timestamp()!)
    

    override class func setUp() {
        if !DBService.shared.isNameExist(name: "Teszt Elek") {
            DBService.shared.addUser(UzzersTests.predefinedUser1, emails: [EmailAddress(email: "teszt.elek@uzzers.com", user: UzzersTests.predefinedUser1)])
        }
        
        if !DBService.shared.isNameExist(name: "Kala Pál") {
            DBService.shared.addUser(UzzersTests.predefinedUser2, emails: [EmailAddress(email: "kala.paal@uzzers.com", user: UzzersTests.predefinedUser2)])
        }
    }

    override class func tearDown() {
        DBService.shared.deleteEmail("teszt.elek@uzzers.com")
        DBService.shared.deleteEmail("kala.paal@uzzers.com")
        DBService.shared.deleteUser(with: "Teszt Elek")
        DBService.shared.deleteUser(with: "Kala Pál")
    }
    
    func testExists() {
        let exists = DBService.shared.isNameExist(name: "Kala Pál")
        XCTAssertTrue(exists, "User 'Kala Pál' is expected but not found'")
    }
    
    func testNotExists() {
        let exists = DBService.shared.isNameExist(name: "Jane Doe")
        XCTAssertFalse(exists, "User 'Jane Doe' is not expected but found'")
    }
    
    func testFetching() {
        let result = DBService.shared.fetchUsers()
        XCTAssertTrue(result.count == 2, "Users count in database not equal to 2")
    }
    
    func testAddNewUser() {
        let newUser = User(name: "John Doe", timestamp: "1980-01-01".timestamp()!)
        
        var error: Error? = nil
        if !DBService.shared.isNameExist(name: "John Doe") {
            error = DBService.shared.addUser(newUser, emails: [EmailAddress(email: "john.doe@uzzers.com", user: newUser)])
        }
        
        XCTAssertNil(error, "Error is NOT nil after adding a user")
        
        addTeardownBlock {
            DBService.shared.deleteEmail("john.doe@uzzers.com")
            DBService.shared.deleteUser(with: "John Doe")
        }
    }
    
    private func timestamp(from string: String) -> TimeInterval? {
        let parts = string.split(separator: "-")
        guard parts.count == 3 else {
            return nil
        }
        
        let cal = Calendar(identifier: .gregorian)
        let comps = DateComponents(calendar: cal, timeZone: TimeZone.current, era: nil, year: (parts[0] as NSString).integerValue, month: (parts[1] as NSString).integerValue, day: (parts[2] as NSString).integerValue, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return cal.date(from: comps)?.timeIntervalSince1970
    }

}
