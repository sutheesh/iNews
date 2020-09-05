//
//  ConfigModel.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/27/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import Foundation
class ConfigModel: Codable {
    let supportedLanguages: [SupportedItem]
    let supportedCategories: [SupportedItem]
}

class SupportedItem: Codable {
    let id: String
    let text: String
    let image: String?
    let tags: [SupportedItem]?
}
