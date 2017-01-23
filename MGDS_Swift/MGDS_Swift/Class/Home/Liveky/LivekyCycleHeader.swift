//
//  LivekyCycleHeader.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/23.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class LivekyCycleHeader: UIView {
    var type: LivekyTopicType = .top

    // MARK: - lazy属性
    fileprivate lazy var carouselView: XRCarouselView = { [weak self] in
        let carouselView = XRCarouselView()
        carouselView.time = 2.0
        carouselView.pagePosition = PositionBottomCenter
        carouselView.delegate = self
        return carouselView
    }()
 
    // 模型数组
    fileprivate lazy var cycleHeaderModels = [CycleHeaderModel]()
    
    /// 图片回调
    var imageClickBlock: ((_ cycleHeaderModel: CycleHeaderModel) -> ())?
    
    // MARK: - 系统方法
    override init(frame: CGRect) {
        super.init(frame: frame)
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

// MARK: - 初始化UI 和请求数据
extension LivekyCycleHeader {
    fileprivate func setUpUI() {
        addSubview(carouselView)
        
        loadData()
    }
    
    /// 内部请求，不外部封装（要想看外部封装请看Miao文件下的 MGHotADCell）
    open func loadData() {
        let urlStr = "http://api.m.panda.tv/ajax_rmd_ads_get?__version=2.0.3.1352&__plat=ios&__channel=appstore"
        NetWorkTools.requestData(type: .get, urlString: urlStr, succeed: {[unowned self] (result, err) in
            guard let resultDict = result as? [String: Any] else { return }
            guard let resultArr = resultDict["data"]  as? [[String: Any]] else { return }
            
            
            self.cycleHeaderModels.removeAll()
            for dict in resultArr {
                let model = CycleHeaderModel(dict: dict)
                self.cycleHeaderModels.append(model)
            }
            
            var imageUrls = [String]()
            var titleArr = [String]()
            for cycleHeaderModel in self.cycleHeaderModels {
                
                self.type == .top ? imageUrls.append(cycleHeaderModel.picture) : imageUrls.append(cycleHeaderModel.newimg)
                self.type == .top ? titleArr.append(cycleHeaderModel.name) : titleArr.append(cycleHeaderModel.notice)
//                if self.type == .top {
//                    self.imageUrls.append(cycleHeaderModel.picture)
//                    titleArr.append(cycleHeaderModel.name)
//                }else {
//                    self.imageUrls.append(cycleHeaderModel.newimg)
//                    titleArr.append(cycleHeaderModel.notice)
//                }
            }
            self.carouselView.imageArray = imageUrls
            self.carouselView.describeArray = titleArr
            
        }) { (err) in
           print(err)
        }
    }
}


// MARK: - XRCarouselViewDelegate
extension LivekyCycleHeader: XRCarouselViewDelegate {
    internal func carouselView(_ carouselView: XRCarouselView!, didClickImage index: Int) {
        if imageClickBlock != nil {
            imageClickBlock!((self.cycleHeaderModels[index]))
        }
    }
}
