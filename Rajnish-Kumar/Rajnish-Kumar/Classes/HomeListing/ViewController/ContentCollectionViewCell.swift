//
//  ContentCollectionViewCell.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import UIKit
import SDWebImage

class ContentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblArtist: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.layer.borderWidth = 1
    }
    
    func configureCell(with model: ContentCellModel?)  {

        if let model = model {
            self.imgView.sd_setImage(with: URL.init(string: model.imageUrl ?? ""), placeholderImage: UIImage.init(named: "placeholder"))
            lblTitle.text = model.title
            lblArtist.text = model.artist
        }
    }
}
