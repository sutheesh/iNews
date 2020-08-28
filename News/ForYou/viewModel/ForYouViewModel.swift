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
    let category: String?
    var cells: [cellType] = [.briefing, .news]

    init(dataManager: NewsDataManaging, category: String? = nil) {
        self.dataManager = dataManager
        self.category = category
        super.init()
        self.setupCells()
    }
    
    func setupCells() {
        if tags.count > 0 {
            cells.removeFirst()
        }
    }
    
    var news: [NewsModel] = []
    
    enum cellType {
        case briefing, news
    }
    
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
        var urlString = NewsConstants.newsUrl
        if tags.count > 0 {
            urlString += "&where={\"tags\":{\"$all\": \(tags)}}"
        }
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        dataManager.fetchNews(urlString) { (data, error) in
            guard error == nil else { callback(); return}
            self.news = data ?? []
            DispatchQueue.main.async {
                callback()
            }
        }
    }
    
    var tags: [String] {
        guard let category = self.category else {
            return []
        }
        return [category]
    }
}
