//
//  CollectionHeaderView.swift
//  MGDYZB
//
//  Created by ming on 16/10/26.
//  Copyright © 2016年 ming. All rights reserved.

//  简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
//  github:  https://github.com/LYM-mg
//

import UIKit

class HistoryHeaderView: UICollectionReusableView {
    // MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    var moreBtnClcikOperation: (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        moreBtn.addTarget(self, action: #selector(HistoryHeaderView.moreBtnClick), for: UIControlEvents.touchUpInside)
        frame = CGRect(x: 0, y: 0, width: MGScreenW, height: 35)
    }
    
    @objc fileprivate func moreBtnClick() {
        if moreBtnClcikOperation != nil {
            moreBtnClcikOperation!()
        }
    }
}

// MARK:- 从Xib中快速创建的类方法
extension HistoryHeaderView {
    class func collectionHeaderView() -> CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
}
