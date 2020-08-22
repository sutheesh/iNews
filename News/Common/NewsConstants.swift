//
//  NewsConstants.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import Foundation
struct NewsConstants {
    private init() {}
    static let useLocalNews = true
    static let urlHost = "http://139.59.95.235/parse/classes/Article?order=-publish_date"
    static let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let outputDateFormat = "MMM dd,yyyy h:mm a"
}
