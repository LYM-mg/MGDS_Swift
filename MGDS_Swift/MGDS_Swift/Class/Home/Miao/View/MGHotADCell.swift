//
//  MGHotADCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit


class MGHotADCell: UITableViewCell {
    
    // MARK: - lazy属性
    fileprivate lazy var carouselView: XRCarouselView = { [weak self] in
        let carouselView = XRCarouselView()
        carouselView.time = 2.0
        carouselView.pagePosition = PositionBottomCenter
        carouselView.delegate = self
        carouselView.setPageImage(#imageLiteral(resourceName: "other"), andCurrentImage: #imageLiteral(resourceName: "current"))
        return carouselView
    }()
    fileprivate lazy var imageUrls = [String]()
    
    /// 回调
    var imageClickBlock: ((_ hotAD: MGHotAD) -> ())?
    
    // MARK: - 模型数组
    var hotADS:[MGHotAD]? {
        didSet {
            guard let hotADS = hotADS else { return }
            imageUrls.removeAll()
            for hotAD in hotADS {
                imageUrls.append(hotAD.imageUrl)
            }
            self.carouselView.imageArray = self.imageUrls
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier) 
        setUpUI()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        carouselView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 初始化UI
extension MGHotADCell {
    fileprivate func setUpUI() {
        addSubview(carouselView)
    }
}


// MARK: - XRCarouselViewDelegate
extension MGHotADCell: XRCarouselViewDelegate {
    func carouselView(_ carouselView: XRCarouselView!, didClickImage index: Int) {
        if imageClickBlock != nil {
            imageClickBlock!((self.hotADS![index]))
        }
    }
}
