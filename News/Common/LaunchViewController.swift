//
//  LaunchViewController.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/27/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var isFirstTime: Bool {
        !UserDefaults.standard.bool(forKey: "firstTimeUser")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchConfig()
    }

    func fetchConfig() {
        NewsDataManager().fetchConfiguration { (config, error) in
            guard config != nil else { return }
            DispatchQueue.main.async {
                sharedModel.shared.config = config?.first
                if self.isFirstTime {
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    self.tableViewHeight.constant = CGFloat((62 * (config?.first?.supportedLanguages.count ?? 0) + 110))
                } else {
                    self.moveToHome()
                }
            }
        }
    }
    
    func moveToHome() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as? UITabBarController else { return }
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
    
}

extension LaunchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pick your languages"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedModel.shared.config?.supportedLanguages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as? LanguageCell else { return UITableViewCell() }
        let lang = sharedModel.shared.config?.supportedLanguages[indexPath.row]
        cell.languageLabel.text = lang?.text
        return cell
    }
    
}

extension LaunchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sharedModel.shared.config?.supportedCategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as? CategoryViewCell else { return UICollectionViewCell() }
        let category = sharedModel.shared.config?.supportedCategories[indexPath.row]
        cell.categoryLabel.text = category?.text
        cell.contentView.layer.cornerRadius = 3
        if let image = category?.image, let imageUrl = URL(string: image) {
            cell.imageView.downloadImage(from: imageUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width / 2 - 4)
        return CGSize(width: width, height: 200)
    }
    
}
