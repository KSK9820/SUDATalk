//
//  Date+.swift
//  SUDATalk
//
//  Created by 김수경 on 11/19/24.
//

import Foundation

extension Date {
    func toString(style to: StringDateFormat) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = to.rawValue

        return dateFormatter.string(from: self)
    }
    
    func toMessageDate() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let comparisonDate = calendar.startOfDay(for: self)

        let formatterForToday = DateFormatter()
        var formattedDate: String

        if comparisonDate == today {
            formatterForToday.dateFormat = StringDateFormat.hhmma.rawValue
        } else {
            formatterForToday.dateFormat = StringDateFormat.yymmddDot.rawValue
        }
        
        formattedDate = formatterForToday.string(from: self)
        return formattedDate
    }
}
