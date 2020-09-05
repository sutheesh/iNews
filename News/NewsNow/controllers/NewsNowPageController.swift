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
        tabItems = controllers()
//        option.tabWidth = view.frame.width / CGFloat(tabItems.count)
        super.viewDidLoad()
    }
    
    func controllers() -> [(UIViewController, String)] {
        guard let categories = sharedModel.shared.config?.supportedCategories else { return []}
        var controllers: [(UIViewController, String)] = []
        for catagory in categories {
            let vc = ForYouController.controller
            let model = ForYouViewModel(dataManager: NewsDataManager(), category: catagory.id)
            vc.viewModel = model
            controllers.append((vc, catagory.text))
        }
        return controllers
    }
}

