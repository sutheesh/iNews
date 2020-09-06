//
//  FavNewsViewController.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 9/6/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class FavNewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var favNews: [NewsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favNews = retrieveFromJsonFile()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshNewsData(_:)), for: .valueChanged)
        title = "Favorite"
    }
    
    func retrieveFromJsonFile() -> [NewsModel] {
        
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Persons.json")

        do {
            let data = try Data(contentsOf: fileUrl, options: .uncached)
            
            guard let jsonDictionary = try? JSONDecoder().decode([String: [NewsModel]].self, from: data) else { return [] }
            return jsonDictionary["data"] ?? []
        } catch {
        }
        return []
    }
    
    @objc private func refreshNewsData(_ sender: Any) {
        favNews = retrieveFromJsonFile()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

}

extension FavNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewViewCell", for: indexPath) as? NewViewCell else { return UITableViewCell()}
        cell.configure(data: favNews[indexPath.row])
        return cell
    }
    
    
}

extension FavNewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = favNews[indexPath.row]
        guard let controller = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailsController") as? NewsDetailsController else { return }
        controller.data = data
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
