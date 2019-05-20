//
//  TrackTableViewCell.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import UIKit
import SDWebImage

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblSrNumber: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnPlayPause: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.isHidden = true
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
               imgView.isHidden = false
                btnPlayPause.isSelected = true
                lblDuration.isHidden = true
            }
            else
            {
                imgView.isHidden = true
                btnPlayPause.isSelected = false
                lblDuration.isHidden = false
            }
        }
    }

    func configureCell(with  model: TrackDataModel ) {
        
        lblTitle.text = model.title
        lblArtist.text = model.artist
        lblSrNumber.text = String(model.trackNumber ?? 0)
        lblDuration.text = model.duration?.msToSeconds.minuteSecondMS
        
        if model.hasPreview {
            lblTitle.textColor = .black
            btnPlayPause.isHidden = false
        }else{
            lblTitle.textColor = .lightGray
            btnPlayPause.isHidden = true
        }
        
        let url = Bundle.main.url(forResource: "play", withExtension: "gif")
        DispatchQueue.main.async {
            self.imgView.sd_setImage(with: url!)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
