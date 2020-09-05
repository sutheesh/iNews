//
//  LanguageViewModel.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 9/3/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

protocol SettingProtocol: NSObject {
    var flowType: FlowType { get }
}

class LanguageViewModel: NSObject, SettingProtocol {
    var flowType: FlowType {
        return .language
    }
}

class CategoryViewModel: NSObject, SettingProtocol {
    var flowType: FlowType {
        return .category
    }
}

class ProfileViewModel: NSObject, SettingProtocol {
    var flowType: FlowType {
        return .profile
    }
}
