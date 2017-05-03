//
//  MGAnchorCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class MGAnchorCell: UICollectionViewCell {
    /** 背景图片 */
    var coverImageView: UIImageView!
    /** 是否新人 */
    var fresnImageView: UIImageView!
    /** 地区 */
    var locationBtn: UIButton!
    /** 主播名字 */
    var nickNameLabel: UILabel!
    /** 等级 */
    var star: UIImageView!
    
    var user: MGAnchor? {
        didSet {
            // 设置封面头像
            
            coverImageView.kf.setImage(with: URL(string: user!.photo!), placeholder: UIImage(named: "dzq"))
            
            // 是否是新主播
            self.fresnImageView.isHidden = !(user!.newStar != nil);
            // 地址
            locationBtn.setTitle(user!.position ?? "你的位置", for: .normal)
             // 主播名
            nickNameLabel.text = user!.nickname ?? "喵喵"
            
            // 等级
            self.star.isHidden = (user!.starlevel! == 0)
            if (user?.starlevel == 1) {
                self.star.image = UIImage(named: "girl_star1_40x19")
            }else if (user?.starlevel == 2){
                self.star.image = UIImage(named: "girl_star2_40x19")
            } else if(user?.starlevel == 3){
                self.star.image = UIImage(named: "girl_star3_40x19")
            }  else if(user?.starlevel == 4){
                self.star.image = UIImage(named: "girl_star4_40x19")
            }  else if(user?.starlevel == 5){
                self.star.image = UIImage(named: "girl_star5_40x19")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension MGAnchorCell {
    fileprivate func  setUpMainView() {
        // 1.添加控件
        coverImageView = UIImageView()
        coverImageView.cornerRadius = 5
        self.contentView.addSubview(coverImageView)

        locationBtn = UIButton(type: .custom)
        locationBtn.tintColor = UIColor.white
        locationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        locationBtn.backgroundColor = .clear
        self.contentView.addSubview(locationBtn)
        
        
        fresnImageView = UIImageView()
        fresnImageView.image = UIImage(named: "flag_new_33x17_")
        fresnImageView.contentMode = UIViewContentMode.scaleAspectFit;
        self.contentView.addSubview(fresnImageView)
        
        star = UIImageView()
        star.contentMode = UIViewContentMode.scaleAspectFit;
        self.contentView.addSubview(star)
        
        nickNameLabel = UILabel()
        nickNameLabel.textColor = .white
        nickNameLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(nickNameLabel)
        
        // 2.设置布局
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        locationBtn.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(1)
            make.size.equalTo(CGSize(width: 66, height: 20))
        }
        fresnImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(-1)
            make.size.equalTo(CGSize(width: 25, height: 20))
        }
        nickNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-1)
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        star.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-1)
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 25, height: 20))
        }
    }
}
