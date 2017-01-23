//
//  TencentCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/18.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import Kingfisher

@objc
protocol TencentCellProtocol: NSObjectProtocol{
    @objc func playBtnClick(cell: TencentCell,model: VideoList)
}

class TencentCell: UITableViewCell {

    // MARK: - 属性
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!         // 视频描述
    @IBOutlet weak var playImageV: UIImageView!           // 播放背景
    @IBOutlet weak var timeDurationLabel: UILabel!        // 视频时长
    @IBOutlet weak var countLabel: UILabel!               // 播放按钮

    
    weak  var delegate: TencentCellProtocol?
    lazy var playBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    var model: VideoList? {
        didSet {
            self.titleLabel?.text = model?.title
            self.descriptionLabel.text = model?.topicDesc
            self.playImageV.kf.setImage(with: URL(string: (model?.cover)!)!, placeholder: UIImage(named: "10"))
            // length代替playCount，因为playCount都是0不好看
            self.countLabel.text = "播放: \(model!.length!)次"
            self.timeDurationLabel.text = (model!.ptime! as NSString).substring(with: NSRange(location: 12, length: 4))
        }
    }
    
    @objc func playBtnClick(_ sender: UIButton) {
        if (delegate?.responds(to: #selector(TencentCellProtocol.playBtnClick)))! {
            delegate?.playBtnClick(cell: self, model: model!)
        }
    }
    
    // MARK: - 系统方法
    override func awakeFromNib() {
        super.awakeFromNib()
        // 代码添加playerBtn到imageView上
        self.playBtn.setImage(UIImage(named: "video_play_btn_bg")!, for: .normal)
        self.playBtn.addTarget(self, action: #selector(self.playBtnClick(_:)), for: .touchUpInside)
        self.playImageV.addSubview(self.playBtn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playBtn.center = CGPoint(x: MGScreenW/2, y: playImageV.frame.size.height/2)
    }
}
