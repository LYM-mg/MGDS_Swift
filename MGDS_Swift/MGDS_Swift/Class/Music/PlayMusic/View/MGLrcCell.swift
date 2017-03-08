//
//  MGLrcCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/4.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGLrcCell: UITableViewCell {

    fileprivate var lrcLabel: MGLrcLabel!
    
    /** 歌词内容*/
    var lrcText: String? {
        didSet {
            self.lrcLabel.text = lrcText!
        }
    }
    
    /** 进度 */
    var progress: Double? {
        didSet {
            self.lrcLabel.progress = progress!
        }
    }
    
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func cellWithTableView(tableView: UITableView,reuseIdentifier: String?,indexPath: IndexPath) -> MGLrcCell { /// , for: indexPath
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier!) as? MGLrcCell
        if (cell == nil) {
            cell = MGLrcCell(style: .default, reuseIdentifier: reuseIdentifier)
            cell!.backgroundColor = UIColor.clear
            cell!.contentView.backgroundColor = UIColor.clear
//            cell!.selectionStyle = .none
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        lrcLabel = MGLrcLabel(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: 44))
        lrcLabel.isUserInteractionEnabled = true
        lrcLabel.tag = 199
        lrcLabel.textColor = UIColor.white
        lrcLabel.textAlignment = .center
        lrcLabel.sizeToFit()
        lrcLabel.center = self.center
        self.contentView.addSubview(lrcLabel)
        
        lrcLabel!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().offset(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
