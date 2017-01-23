//
//  LiveTableViewCell.swift
//  Liveyktest1
//
//  Created by yons on 16/9/19.
//  Copyright © 2016年 xiaobo. All rights reserved.
//

import UIKit

class LiveTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPortrait: UIImageView!
    
    @IBOutlet weak var labelAddr: UILabel!
    @IBOutlet weak var labelNick: UILabel!
    
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var labelViewers: UILabel!
    
    override func awakeFromNib() {
                super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
