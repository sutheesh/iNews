//
//  NewsDataManager.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import Foundation
protocol NewsDataManaging {
    func fetchNews(url: URL, completion: @escaping (_ data: [NewsModel]?, _ error: Error?) -> Void)
}

class NewsDataManager: NewsDataManaging {
    
    func fetchNews(url: URL, completion: @escaping (_ data: [NewsModel]?, _ error: Error?) -> Void) {
        if NewsConstants.useLocalNews {
            getDataFromFileWithSuccess(success: completion)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 30
        sessionConfig.httpMaximumConnectionsPerHost = 1
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.setValue("newsOne", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        let json: [String: Any] = ["title": "ABC",
                                   "dict": ["1":"First", "2":"Second"]]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        
        let loadDataTask = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(nil, nil)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            guard let jsonDictionary = try? JSONDecoder().decode([String: [NewsModel]].self, from: data), let news = jsonDictionary["results"] else {
                completion(nil, nil)
                return
            }
            
            completion(news, nil)
        }
        
        loadDataTask.resume()
    }
    
    func getDataFromFileWithSuccess(success: @escaping (_ data: [NewsModel]?, _ error: Error?) -> Void) {
        guard let filePathURL = Bundle.main.url(forResource: "news", withExtension: "json") else {
            success(nil, nil)
            return
        }
        
        do {
            let data = try Data(contentsOf: filePathURL, options: .uncached)
            guard let jsonDictionary = try? JSONDecoder().decode([String: [NewsModel]].self, from: data), let news = jsonDictionary["results"] else {
                success(nil, nil)
                return
            }
            
            success(news, nil)
        } catch {
            fatalError()
        }
    }
}

