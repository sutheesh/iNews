//
//  NewsNowPageController.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/23/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class NewsNowPageController: TabPageViewController {

    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.white
        let vc2 = UIViewController()
        vc1.view.backgroundColor = UIColor.green
        tabItems = [(vc2, "Second"),(vc1, "First")]
        option.tabWidth = view.frame.width / CGFloat(tabItems.count)
        super.viewDidLoad()
    }
}

