//
//  TableViewCell.swift
//  视频播放测试
//
//  Created by i-Techsys.com on 16/12/29.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit
import Kingfisher

@objc
protocol TableViewCellProtocol: NSObjectProtocol{
    @objc func playBtnClick(cell: TableViewCell,model: MGVideoModel)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picView: UIImageView!
    lazy var playBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
   weak  var delegate: TableViewCellProtocol?
    var model: MGVideoModel? {
        didSet{
            self.picView.kf.setImage(with: URL(string: (model?.coverForFeed)!)!)
            self.titleLabel.text = model?.title
            self.avatarImageView.kf.setImage(with: URL(string: (model?.coverForFeed)!)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .blue
        self.layoutIfNeeded()
        self.picView.tag = 101
        // 代码添加playerBtn到imageView上
        self.playBtn.setImage(UIImage(named: "video_list_cell_big_icon")!, for: .normal)
        self.playBtn.addTarget(self, action: #selector(self.play), for: .touchUpInside)
        self.picView.addSubview(self.playBtn)
        
        contentView.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playBtn.center = CGPoint(x: (MGScreenW-playBtn.frame.size.width)/2, y: (picView.frame.size.height-playBtn.frame.size.height)/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func play(sender: UIButton) {
        if (delegate?.responds(to: #selector(TableViewCellProtocol.playBtnClick)))! {
            delegate?.playBtnClick(cell: self, model: model!)
        }
    }
    
}
