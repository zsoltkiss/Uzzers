//
//  String+DateUtil.swift
//  Uzzers
//
//  Created by Kiss Rudolf Zsolt on 2018. 12. 12..
//  Copyright © 2018. Kiss Rudolf Zsolt. All rights reserved.
//

import Foundation

extension String {
    func timestamp() -> TimeInterval? {
        let parts = split(separator: "-")
        guard parts.count == 3 else {
            return nil
        }
        
        let year = (parts[0] as NSString).integerValue
        let month = (parts[1] as NSString).integerValue
        let day = (parts[2] as NSString).integerValue
        
        guard year > 1900 && year < 2019 && month > 0 && month < 13 && day > 0 && day < 32 else {
            return nil
        }
        
        let cal = Calendar(identifier: .gregorian)
        let comps = DateComponents(calendar: cal, timeZone: TimeZone.current, era: nil, year: year, month: month, day: day, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return cal.date(from: comps)?.timeIntervalSince1970
    }
}
