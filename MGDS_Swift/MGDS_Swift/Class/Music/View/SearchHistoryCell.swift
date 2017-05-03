//
//  SearchHistoryCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/4/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class SearchHistoryCell: UICollectionViewCell {
    
    lazy var historyLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setUpUI() {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "search_history")
        addSubview(iv)
        historyLabel.tintColor = UIColor.white
        addSubview(historyLabel)
        
        iv.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        historyLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(iv.snp.right).offset(5)
        }
    }
}
