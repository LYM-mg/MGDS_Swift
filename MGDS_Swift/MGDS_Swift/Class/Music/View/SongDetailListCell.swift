//
//  SongDetailListCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/1.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class SongDetailListCell: UITableViewCell {
     // MARK: - 属性
    fileprivate lazy var iconImageView = UIImageView()
    fileprivate lazy var songNameLabel = UILabel()
    fileprivate lazy var singerLabel = UILabel()
    
    var model: SongDetail? {
        didSet {
            self.iconImageView.setImageWithURLString(model?.pic_small, placeholder: #imageLiteral(resourceName: "mybk1"))
            self.songNameLabel.text = model!.title;
            self.singerLabel.text = model!.author + "  " + model!.album_title
        }
    }
    
    
    // MARK: - 生命周期
    /**
     *  快速创建cell
     */
    static func cellWithTableView(tabView: UITableView) -> SongDetailListCell {
        let musicID = "music";
        // 1.从缓存池中取得cell
        var cell = tabView.dequeueReusableCell(withIdentifier: musicID) as? SongDetailListCell
        // 2.从缓存池中cell为空，从Xib中加载cell
        if (cell == nil) {
            cell = SongDetailListCell(style: .default, reuseIdentifier: musicID)
            // 设置一些cell的属性(清除系统默认选中样式)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none;
        }
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.backgroundColor = UIColor.clear
        // 3.设置cell的动画效果
//        cell?.addAnimation()

        // 4.返回cell
        return cell!
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        self.layoutIfNeeded()
        self.iconImageView.layer.cornerRadius = iconImageView.mg_width * 0.5;
        self.iconImageView.layer.masksToBounds = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /**
     *   添加cell滚动的动画
     */
    fileprivate func addAnimation() {
        // 防止重复添加动画
        layer.removeAnimation(forKey: "music")
        
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.y")
        keyframeAnimation.values = [(-2),(-1),(1),(2)];
        keyframeAnimation.duration = 0.3
        layer.add(keyframeAnimation, forKey: "music")
    }
}

 // MARK: - UI和布局
extension SongDetailListCell {
    fileprivate func setUpUI() {
        addSubview(iconImageView)
        addSubview(songNameLabel)
        addSubview(singerLabel)
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(70)
            make.width.equalTo(iconImageView.snp.height)
        }
        
        songNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.top.equalTo(iconImageView).offset(3)
            make.right.equalToSuperview().offset(-15)
        }
        singerLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(songNameLabel)
            make.bottom.equalTo(iconImageView).offset(-3)
        }
    }
}
