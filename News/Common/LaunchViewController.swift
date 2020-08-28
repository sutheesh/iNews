//
//  LaunchViewController.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/27/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    var isFirstTime: Bool {
        UserDefaults.standard.bool(forKey: "firstTimeUser")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchConfig()
    }

    func fetchConfig() {
        NewsDataManager().fetchConfiguration { (config, error) in
            guard config != nil else { return }
            sharedModel.shared.config = config?.first
            if self.isFirstTime {
                //showConfig
            }else {
                self.moveToHome()
            }
            
        }
    }
    
    func moveToHome() {
        DispatchQueue.main.async {
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as? UITabBarController else { return }
            UIApplication.shared.keyWindow?.rootViewController = controller
        }
    }
}
