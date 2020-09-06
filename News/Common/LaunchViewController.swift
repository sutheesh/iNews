//
//  LaunchViewController.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/27/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit
import Kingfisher

enum FlowType {
    case language, category, profile
}

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var selectdLanguages: UILabel!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var flowType: FlowType = .profile
    @IBOutlet weak var loadingView: UIView!
    
    var isFirstTime: Bool {
        !UserDefaults.standard.bool(forKey: "firstTimeUser")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        fetchConfig()
    }

    func setUpNavigation() {
        guard flowType != .profile, isFirstTime else { return }
        let rightBarButton = UIBarButtonItem(title: (flowType == .language ) ? "Next" : "Done", style: .done, target: self, action: #selector(nextButtonTap))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func updateTitle() {
        title = (flowType == .language ) ? "Language" : (flowType == .category ) ? "Area of interest" : "Profile"
    }
    
    @objc func nextButtonTap() {
        if flowType == .language {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "categoryView") as? LaunchViewController else { return }
            vc.flowType = .category
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.moveToHome()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstTime {
            reloadData()
        }
    }
    
    func fetchConfig() {
        guard let _ = sharedModel.shared.config else {
            NewsDataManager().fetchConfiguration { (config, error) in
                guard config != nil else { return }
                DispatchQueue.main.async {
                    sharedModel.shared.config = config?.first
                    if self.isFirstTime {
                        self.flowType = .language
                        self.reloadData()
                    } else {
                        self.moveToHome()
                    }
                }
            }
            return
        }
        reloadData()
    }
    
    func reloadData() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if self.flowType == .language {
            loadingView.isHidden = true
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        } else {
            collectionView.delegate = self
            collectionView.dataSource = self
            self.collectionView.reloadData()
            languageView.isHidden = (flowType == .category)
            if flowType == .profile {
                let langs = LaunchViewController.getSelecteLang().compactMap { (item) -> String? in
                    return item.text
                }
                selectdLanguages.text = langs.joined(separator: ",")
                let gesture = UITapGestureRecognizer(target: self, action:#selector(chooseLanguage(_:)))
                languageView.addGestureRecognizer(gesture)
            }
        }
        updateTitle()
        setUpNavigation()
        updateNextButton()
    }
    
    @objc func chooseLanguage(_ sender:UITapGestureRecognizer){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageController") as? LaunchViewController else { return }
        vc.flowType = .language
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func getSelecteLang() -> [SupportedItem] {
        guard let configModel = sharedModel.shared.config else { return [] }
        let supportedLang = configModel.supportedLanguages.filter({UserDefaults.standard.bool(forKey: "newsLang_" + $0.id)})
        return supportedLang
    }
    
    var availableCategories: [SupportedItem] = {
        let tags = getSelecteLang().compactMap { (item) -> [SupportedItem]? in
            return item.tags
        }
        return tags.flatMap { $0 }
    }()
    
    var selectedCategories: [SupportedItem] {
        return availableCategories.filter({UserDefaults.standard.bool(forKey: "newsCategory_" + $0.id)})
    }
    
    func getSelecteCategory() -> [SupportedItem] {
        guard let configModel = sharedModel.shared.config else { return [] }
        let supportedLang = configModel.supportedCategories.filter({UserDefaults.standard.bool(forKey: "newsCategory_" + $0.id)})
        return supportedLang
    }
    
    func updateNextButton() {
        if self.flowType == .language {
            self.navigationItem.rightBarButtonItem?.isEnabled = (LaunchViewController.getSelecteLang().count > 0)
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = (selectedCategories.count > 0)
        }
    }
    
    func moveToHome() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as? UITabBarController else { return }
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
    
    func updateSelection(index: Int) -> Bool {
        guard let configModel = sharedModel.shared.config else { return false }
        let model = (flowType == .language) ? configModel.supportedLanguages[index] : availableCategories[index]
        let id = ((flowType == .language) ? "newsLang_" : "newsCategory_") + model.id
        var isSelected = true
        if UserDefaults.standard.bool(forKey: id) {
            isSelected = false
        }
        UserDefaults.standard.set(isSelected, forKey: id)
        UserDefaults.standard.synchronize()
        return isSelected
        
    }
    
}

extension LaunchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = updateSelection(index: indexPath.row) ? .checkmark : .none
        updateNextButton()
    }
    
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
        let id = "newsLang_" + (lang?.id ?? "")
        cell.accessoryType = UserDefaults.standard.bool(forKey: id) ? .checkmark : .none
        return cell
    }
    
}

extension LaunchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableCategories.count //sharedModel.shared.config?.supportedCategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as? CategoryViewCell else { return UICollectionViewCell() }
        let category = availableCategories[indexPath.row]
        cell.categoryLabel.text = category.text
        cell.contentView.layer.cornerRadius = 3
        if let image = category.image, let imageUrl = URL(string: image) {
            cell.imageView.kf.setImage(with: imageUrl)
        }
        
        let id = "newsCategory_" + category.id
        cell.checkMarkImageView.image = UserDefaults.standard.bool(forKey: id) ? UIImage(named: "check") : nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width / 2 - 4)
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else { return }
        cell.checkMarkImageView.image = updateSelection(index: indexPath.row) ? UIImage(named: "check") : nil
        updateNextButton()
    }
}
