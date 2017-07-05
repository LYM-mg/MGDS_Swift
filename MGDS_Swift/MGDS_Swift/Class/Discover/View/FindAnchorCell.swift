//
//  FindAnchorCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class FindAnchorCell: UICollectionViewCell {

    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var liveImageView: UIImageView!
    
    var anchor : MoreModel?  {
        didSet {
            guard let anchor = anchor else { return }
            
            onlineLabel.text = "\(anchor.focus)人观看"
            nickNameLabel.text = anchor.name
            iconImageView.kf.setImage(with: URL(string: anchor.pic51), placeholder : UIImage(named: "10"))
            liveImageView.isHidden = anchor.live == 0
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
