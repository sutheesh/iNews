//
//  SharedModel.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/27/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import Foundation
class sharedModel: NSObject {
    private override init() {}
    static let shared = sharedModel()
    var config: ConfigModel?
}
