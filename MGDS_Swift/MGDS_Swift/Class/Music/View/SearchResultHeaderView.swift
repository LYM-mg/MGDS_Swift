//
//  SearchResultHeaderView.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/4/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class SearchResultHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.randomColor()
        self.backgroundColor = UIColor.clear
    }

}
