//
//  ForYouController.swift
//  News
//
//  Created by Sutheesh Sukumaran on 8/21/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class ForYouController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = ForYouViewModel(dataManager: NewsDataManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        viewModel.fetchNews {
            self.tableView.reloadData()
        }
    }
}

extension ForYouController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.cells[indexPath.section]
        switch section {
        case .briefing:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BriefingCell", for: indexPath) as? BriefingCell else { return UITableViewCell()}
            return cell
        case .news:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewViewCell", for: indexPath) as? NewViewCell else { return UITableViewCell()}
            cell.configure(data: viewModel.news[indexPath.row])
            return cell
        }
    }
    
    
}

extension ForYouController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = viewModel.cells[indexPath.section]
        switch section {
        case .news:
            let data = viewModel.news[indexPath.row]
            guard let controller = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailsController") as? NewsDetailsController else { return }
            controller.data = data
            self.navigationController?.pushViewController(controller, animated: true)
        default: break
        }
    }
}
