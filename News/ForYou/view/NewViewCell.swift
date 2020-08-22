//
//  NewViewCell.swift
//  News
//
//  Created by Sutheesh Sukumaran on 8/22/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class NewViewCell: UITableViewCell {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 7
        newsImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        newsImageView.image = nil
    }
    
    func configure(data: NewsModel) {
        newsTitle.text = data.author
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
