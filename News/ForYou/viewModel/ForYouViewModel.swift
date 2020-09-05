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
    let isForYou: Bool
    init(dataManager: NewsDataManaging, category: String? = nil, isForYou: Bool = false) {
        self.dataManager = dataManager
        self.category = category
        self.isForYou = isForYou
        super.init()
        self.setupCells()
    }
    
    func setupCells() {
        if !isForYou {
            cells.removeFirst()
        }
    }
    
    var news: [NewsModel] = []
    
    enum cellType {
        case briefing, news
    }
    
    var languages: [String] {
        let selectedLang = getSelecteLang()
        let langs: [String] = selectedLang.compactMap { (item) -> String in
            return item.id
        }
        return langs
    }
    
    var categories: [String] {
        let selectedCategory = availableCategories
        let category: [String] = selectedCategory.compactMap { (item) -> String in
            return item.id
        }
        return category
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
//        http://139.59.95.235/parse/classes/Article?order=-publish_date&where={"$and":[{"lang":{"$in":["Malayalam","Tamil"]}},{"tags":{"$in":["Pallakad","Abroad"]}}]}
        
        var urlString = NewsConstants.newsUrl
        if tags.count > 0 {
            urlString += "&where={\"tags\":{\"$all\": \(tags)}}"
        }else {
            urlString += "&where={\"$and\":[{\"lang\":{\"$in\":\(languages)}},{\"tags\":{\"$in\":\(categories)}}]}"
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
    
    func getSelecteLang() -> [SupportedItem] {
        guard let configModel = sharedModel.shared.config else { return [] }
        let supportedLang = configModel.supportedLanguages.filter({UserDefaults.standard.bool(forKey: "newsLang_" + $0.id)})
        return supportedLang
    }
    
    var availableCategories: [SupportedItem] {
        let tags = getSelecteLang().compactMap { (item) -> [SupportedItem]? in
            return item.tags?.filter({UserDefaults.standard.bool(forKey: "newsCategory_" + $0.id)})
            
        }
        return tags.flatMap { $0 }
    }
    
    var tags: [String] {
        guard let category = self.category else {
            return []
        }
        return [category]
    }
}
