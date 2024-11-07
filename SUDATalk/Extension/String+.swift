//
//  String+.swift
//  SUDATalk
//
//  Created by 박다현 on 11/7/24.
//

import Foundation

extension String {
    func formatDate() -> String {
        let stringFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        formatter.locale = Locale(identifier: "ko")

        guard let tempDate = formatter.date(from: self) else {
            return ""
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let comparisonDate = calendar.startOfDay(for: tempDate)

        let formatterForToday = DateFormatter()
        var formattedDate: String

        if comparisonDate == today {
            formatterForToday.dateFormat = "hh:mm a"
        } else {
            formatterForToday.dateFormat = "yy.MM.dd"
        }
        formattedDate = formatterForToday.string(from: tempDate)
        return formattedDate
    }
}
