//
//  UIViewController+Extension.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 9/5/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import Foundation
import UIKit

class NewsBaseController: UIViewController {
    var loadingView: UIView = UIView(frame: .zero)
    
    func showLoading() {
        loadingView = UIView(frame: self.view.frame)
        self.view.addSubview(loadingView)
        var activity = UIActivityIndicatorView(style: .gray)
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        if #available(iOS 13.0, *) {
            activity = UIActivityIndicatorView(style: .large)
            activity.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        loadingView.backgroundColor = UIColor.clear
        activity.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(activity)
        activity.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        activity.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        activity.startAnimating()
    }
    
    func hideSpinner() {
        loadingView.removeFromSuperview()
    }
}
