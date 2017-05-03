//
//  UserHeaderView.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/8.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import Kingfisher

class UserHeaderView: UIView {

    // MARK: - 属性
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var user: User? {
        didSet {
            userName.text = user?.nickName ?? "明明就是你"
            if user?.headImage != "" {
                let url = URL(string: user?.headImage ?? "")!  // , placeholder: #imageLiteral(resourceName: "default-user") 
                userIcon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "default-user"))
            }
        }
    }
}
