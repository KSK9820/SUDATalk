//
//  String+.swift
//  SUDATalk
//
//  Created by 박다현 on 11/7/24.
//

import Foundation

extension String {
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringDateFormat.iso.rawValue
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
}
