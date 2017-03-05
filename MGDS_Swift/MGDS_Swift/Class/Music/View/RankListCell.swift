//
//  RankListCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/1.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class RankListCell: UICollectionViewCell {
    fileprivate lazy var backImageView = UIImageView()
    fileprivate lazy var songLabel1 = UILabel()
    fileprivate lazy var songLabel2 = UILabel()
    fileprivate lazy var songLabel3 = UILabel()
    fileprivate lazy var songLabel4 = UILabel()
    
    
    var model: SongGroup? {
        didSet {
   
            backImageView.kf.setImage(with: URL(string: (model?.pic_s260)!), placeholder: #imageLiteral(resourceName: "mybk1"))
            
            guard let song_list = model?.song_list else { return }
            songLabel1.text = "1: " + song_list[0].title + " - " + song_list[0].author
            songLabel2.text = "2: " + song_list[1].title + " - " + song_list[1].author
            songLabel3.text = "3: " + song_list[2].title + " - " + song_list[2].author
            songLabel4.text = "4: " + song_list[3].title + " - " + song_list[3].author
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel(songLabel1)
        setUpLabel(songLabel2)
        setUpLabel(songLabel3)
        setUpLabel(songLabel4)
        setUpUI()
    }
    
    fileprivate func setUpLabel(_ lb: UILabel) {
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 17)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpUI() {
        // 1.添加UI
        addSubview(backImageView)
        addSubview(songLabel1)
        addSubview(songLabel2)
        addSubview(songLabel3)
        addSubview(songLabel4)
        
        // 2.布局UI
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        songLabel1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(songLabel2)
            make.height.equalTo(songLabel3)
            make.height.equalTo(songLabel4)
        }
        songLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(songLabel1.snp.bottom).offset(5)
            make.left.right.equalTo(songLabel1)
        }
        songLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(songLabel2.snp.bottom).offset(5)
            make.left.right.equalTo(songLabel1)
        }
        songLabel4.snp.makeConstraints { (make) in
            make.top.equalTo(songLabel3.snp.bottom).offset(5)
            make.left.right.equalTo(songLabel1)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
