//
//  ForYouViewModel.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import Foundation
class ForYouViewModel: NSObject {
    
    let dataManager: NewsDataManaging
    var news: [NewsModel] = []
    init(dataManager: NewsDataManaging) {
        self.dataManager = dataManager
    }
    
    enum cellType {
        case briefing, news
    }
    let cells: [cellType] = [.briefing, .news]
    
    var numberOfSection: Int {
        return cells.count
    }
    
    func numberOfCells(for section: Int) -> Int {
        switch cells[section] {
        case .news:
            return news.count
        default:
            return 1
        }
    }
    
    func fetchNews(callback:@escaping()->Void) {
        guard let url = URL(string: NewsConstants.urlHost) else {callback();return}
        dataManager.fetchNews(url: url) { (data, error) in
            guard error == nil else { callback(); return}
            self.news = data ?? []
            DispatchQueue.main.async {
                callback()
            }
        }
    }
}
