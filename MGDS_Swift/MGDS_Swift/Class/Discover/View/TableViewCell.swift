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

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var videoDescription: UILabel!
    @IBOutlet weak var picView: UIImageView!
    lazy var playBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    weak  var delegate: TableViewCellProtocol?
    var model: MGVideoModel? {
        didSet{
            self.picView.kf.setImage(with: URL(string: (model?.coverForFeed)!)!, placeholder: UIImage(named: "10"))
            self.titleLabel.text = model?.title ?? "MG明明就是你"
            self.videoDescription.text = model?.videoDescription ?? "你是小傻瓜"
            timeLabel.text = timeStamp(timeStr:  Double(model!.date!))
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
        self.playBtn.center = CGPoint(x: MGScreenW/2, y: picView.frame.size.height/2)
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
    
    // MARK: - Date的扩展
    /**
     时间戳转化为字符串
     time:时间戳字符串
     */
    func timeStamp(timeStr: Double) -> String {
//        let time = Double(timeStr)!  + 28800  //因为时差问题要加8小时 == 28800 sec
        
//        let time: TimeInterval = 1000
        let detaildate = Date(timeIntervalSince1970: timeStr/1000.0)
        
        //实例化一个NSDateFormatter对象
        let dateFormatter = DateFormatter()
        
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd HH:MM:ss"
        
        let currentDateStr = dateFormatter.string(from: detaildate)
        return currentDateStr
    }
    
    
    
    func getDateString(withTimeInterval timeInterval: String, dataFormatterString: String) -> String {
        let dateString: String
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = dataFormatterString
        let interval: TimeInterval = TimeInterval(timeInterval)! / 1000.0
        let date = Date(timeIntervalSince1970: interval)
        dateString = dataFormatter.string(from: date)
        return dateString
    }

}



   
