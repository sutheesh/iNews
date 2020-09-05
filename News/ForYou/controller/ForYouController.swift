//
//  ForYouController.swift
//  News
//
//  Created by Sutheesh Sukumaran on 8/21/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class ForYouController: NewsBaseController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ForYouViewModel(dataManager: NewsDataManager(), isForYou: true)
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        showLoading()
        viewModel.fetchNews {
            self.hideSpinner()
            self.tableView.reloadData()
        }
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        viewModel.fetchNews {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
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
            if viewModel.isForYou {
                self.navigationController?.pushViewController(controller, animated: true)
            }else {
                if let topNavController = UIApplication.topViewController() as? UINavigationController {
                    topNavController.pushViewController(controller, animated: true)
                }
            }
        default: break
        }
    }
}

extension ForYouController {
    static var controller: ForYouController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForYouController") as? ForYouController ?? ForYouController()
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return navigationController
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
