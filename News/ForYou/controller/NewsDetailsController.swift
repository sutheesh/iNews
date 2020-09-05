//
//  NewsDetailsController.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class NewsDetailsController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var detailsLabel: UITextView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var twitter: UIButton!
    @IBOutlet weak var main: UIButton!
    @IBOutlet weak var share: UIButton!

    var data: NewsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyTheme()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

    }

    func setupUI() {
        ImageLoader.sharedLoader.imageForUrl(urlString: data?.image_url ) { image, _ in
            DispatchQueue.main.async { [weak self] in
                guard let image = image else { return }
                self?.imageView.image = image
            }
        }
        titleLabel.text = data?.title
        detailsLabel.text = data?.text
        publishDateLabel.text = Date.dateString(from: data?.publish_date.iso)
        authorLabel.text = data?.author
    }
    
    func applyTheme() {
        facebook.setTitleColor(.white, for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        topView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
        newsView.roundCorners(corners: [.topLeft, .topRight], radius: 50.0)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
