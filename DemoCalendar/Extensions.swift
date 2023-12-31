//
//  Extensions.swift
//  DemoCalendar
//
//  Created by Maksym Blashko on 07.10.2022.
//

import Foundation

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }

    func getDateComponentsArrayTill(_ endDateComponents: DateComponents?) -> [DateComponents] {
        guard let startDate = self.date, let endDate = endDateComponents?.date else { return [] }
        var allDatesComponents: [DateComponents] = []
        var date = startDate
        
        while date <= endDate {
            let dateCompo = Calendar(identifier: .gregorian).dateComponents([.calendar, .year, .month, .day], from: date)
            allDatesComponents.append(dateCompo)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return allDatesComponents
    }
}
