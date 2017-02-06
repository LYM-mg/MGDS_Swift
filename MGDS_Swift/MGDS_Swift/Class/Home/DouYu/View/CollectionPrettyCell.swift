//
//  CollectionPrettyCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/2/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//


import UIKit
import Kingfisher

class CollectionPrettyCell: CollectionBaseCell {
    
    // MARK:- 控件属性
    @IBOutlet weak var cityBtn: UIButton!
    
    // MARK:- 定义模型属性
    override var anchor : AnchorModel? {
        didSet {
            // 1.将属性传递给父类
            super.anchor = anchor
            
            // 2.所在的城市
            anchor!.anchor_city = anchor!.anchor_city == "" ? "未知星球" : anchor!.anchor_city
            cityBtn.setTitle(anchor!.anchor_city, for: UIControlState())
        }
    }

}
