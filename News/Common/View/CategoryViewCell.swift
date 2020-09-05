//
//  CategoryViewCell.swift
//  iNews
//
//  Created by Sutheesh Sukumaran on 9/2/20.
//  Copyright © 2020 iLabbs. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkMarkView: UIView!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkMarkView.layer.cornerRadius = 12.5
        checkMarkView.layer.masksToBounds = true
        checkMarkView.layer.borderColor = UIColor.white.cgColor
        checkMarkView.layer.borderWidth = 2
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        checkMarkImageView.image = nil
    }
}
