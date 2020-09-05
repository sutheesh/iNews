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
    
    func getSelecteLang() -> [SupportedItem] {
        guard let configModel = sharedModel.shared.config else { return [] }
        let supportedLang = configModel.supportedLanguages.filter({UserDefaults.standard.bool(forKey: "newsLang_" + $0.id)})
        return supportedLang
    }
    
    func getSelecteCategory() -> [SupportedItem] {
        guard let configModel = sharedModel.shared.config else { return [] }
        let supportedLang = configModel.supportedCategories.filter({UserDefaults.standard.bool(forKey: "newsCategory_" + $0.id)})
        return supportedLang
    }
    
    var tags: [String] {
        guard let category = self.category else {
            let selectedLang = getSelecteLang()
            let langs: [String] = selectedLang.compactMap { (item) -> String in
                return item.id
            }
            return langs
        }
        return [category]
    }
}
