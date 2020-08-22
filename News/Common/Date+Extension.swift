//
//  Data+Extension.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import Foundation

extension Date {
    static func dateString(from date: String?)-> String? {
        guard let date = date else { return nil }
        let dateFormatterIn = DateFormatter()
        dateFormatterIn.dateFormat = NewsConstants.inputDateFormat
        guard let outDate = dateFormatterIn.date(from: date) else { return nil }
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = NewsConstants.outputDateFormat
        return dateFormatterOut.string(from: outDate)
    }
}
