//
//  NewsModel.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import Foundation
class NewsModel: Codable {
    let objectId: String
    let identifier: String
    let title: String
    let text: String
    let image_url: String
    let url: String
    let publish_date: publishDate
    let author: String
    let source: String
    let tags: [String]
    let createdAt: String
    let updatedAt: String
}

class publishDate: Codable {
    let __type: String
    let iso: String
}
