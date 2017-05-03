//
//  MGHotLiveCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import Kingfisher

class MGHotLiveCell: UITableViewCell {

    /** 头像 */
    @IBOutlet weak var headImageView: UIImageView!
    /** 星级 */
    @IBOutlet weak var startView: UIImageView!
    /** 大的预览图 */
    @IBOutlet weak var bigPicView: UIImageView!
    /** 地区 */
    @IBOutlet weak var locationBtn: UIButton!
    /** 直播名 */
    @IBOutlet weak var nameLabel: UILabel!
    /** 观众 */
    @IBOutlet weak var audienceLabel: UILabel!
    
    var live: MGHotModel? {
        didSet {
            headImageView.kf.setImage(with: URL(string: live!.smallpic), placeholder: UIImage(named: "default-user"), options: nil, progressBlock: nil, completionHandler: { (image, err, cache, url) in
                let image = UIImage.circleImage(originImage: image!, borderColor: UIColor.purple, borderWidth: 1)
                self.headImageView.image = image
            })
                
            self.nameLabel.text = live!.myname
            // 如果没有地址, 给个默认的地址
            locationBtn.setTitle(live!.gps ?? "喵星", for: .normal)
            bigPicView.kf.setImage(with: URL(string: live!.bigpic), placeholder: #imageLiteral(resourceName: "profile_user_414x414"))
            self.startView.image  = live!.starImage
            self.startView.isHidden = (live!.starlevel! == 0)
            
            // 设置当前观众数量
            let fullAudience: NSString = "\(live!.allnum!)人在看" as NSString
            let range = fullAudience.range(of: "\(live!.allnum!)")
            let attr = NSMutableAttributedString(string: fullAudience as String)
            attr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 20),NSForegroundColorAttributeName: UIColor(r:216,g: 41,b: 116)], range: range)
            self.audienceLabel.attributedText = attr
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
