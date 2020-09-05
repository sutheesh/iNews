//
//  NewViewCell.swift
//  News
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class NewViewCell: UITableViewCell {
    @IBOutlet weak var newAuther: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var autherView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 7
        newsImageView.layer.masksToBounds = true
        autherView.layer.cornerRadius = autherView.frame.height/2
    }
    
    override func prepareForReuse() {
        newsImageView.image = nil
    }
    
    func configure(data: NewsModel) {
        newAuther.text = data.author
        newsDescription.text = data.title
        timeLabel.text = Date.dateString(from: data.publish_date.iso)
        
        ImageLoader.sharedLoader.imageForUrl(urlString: data.image_url) { image, _ in
            DispatchQueue.main.async { [weak self] in
                guard let image = image else { return }
                self?.newsImageView.image = image
            }
        }
    }

}
