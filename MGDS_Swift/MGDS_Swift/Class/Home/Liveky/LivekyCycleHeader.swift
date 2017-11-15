//
//  LivekyCycleHeader.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/23.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

enum LivekyTopicType {
    case top
    case search
    case find
}

class CarouselModel: BaseModel {
    var name : String = ""
    var picUrl : String = ""
    var linkUrl : String = ""
}

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
    
    // find 的模型数组
    fileprivate lazy var carousels : [CarouselModel] = [CarouselModel]()
    /// 图片回调
    var carouselsClickBlock: ((_ carouselModel: CarouselModel) -> ())?
    
    // MARK: - 系统方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 把首页的模型传递过来
    convenience required init(frame: CGRect,type: LivekyTopicType) {
        self.init(frame: frame)
        self.type = type
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
       if self.type == .find  {
            NetWorkTools.requestData(type:.get, urlString: "http://qf.56.com/home/v4/getBanners.ios", succeed: { [unowned self] (result, err) in
                // 1.转成字典
                guard let resultDict = result as? [String : Any] else { return }
                // 2.根据message取出数据
                guard let msgDict = resultDict["message"] as? [String : Any] else { return }
                // 3.根据banners取出数据
                guard let banners = msgDict["banners"] as? [[String : Any]] else { return }
                // 4.转成模型对象
                var imageUrls = [String]()
                var titleArr = [String]()
                for dict in banners {
                    let carouselModel = CarouselModel(dict: dict)
                    imageUrls.append(carouselModel.picUrl)
                    titleArr.append(carouselModel.name)
                    self.carousels.append(carouselModel)
                }
                
                self.carouselView.imageArray = imageUrls
                self.carouselView.describeArray = titleArr
                
            }) { (err) in
                print(err)
            }
       }else {
            let urlStr = "http://api.m.panda.tv/ajax_rmd_ads_get?__version=2.0.3.1352&__plat=ios&__channel=appstore"
            NetWorkTools.requestData(type: .get, urlString: urlStr, succeed: {[unowned self] (result, err) in
                guard let resultDict = result as? [String: Any] else { return }
                guard let resultArr = resultDict["data"]  as? [[String: Any]] else { return }
                
                
                self.cycleHeaderModels.removeAll()
                var imageUrls = [String]()
                var titleArr = [String]()
                for dict in resultArr {
                    let model = CycleHeaderModel(dict: dict)
                    self.cycleHeaderModels.append(model)
                    self.type == .top ? imageUrls.append((model.picture=="" ? model.picture : model.newimg)) : imageUrls.append(model.newimg)
                    self.type == .top ? titleArr.append(model.name ?? "你相信易风吗？快来给他✨吧") : titleArr.append(model.nickname ?? "MG明明就是你")
                }
                
                self.carouselView.imageArray = imageUrls
                self.carouselView.describeArray = titleArr
                
            }) { (err) in
                print(err)
            }

        }
    }
}

// MARK: - XRCarouselViewDelegate
extension LivekyCycleHeader: XRCarouselViewDelegate {
    internal func carouselView(_ carouselView: XRCarouselView!, didClickImage index: Int) {
        if self.type == .find {
            if carouselsClickBlock != nil {
                carouselsClickBlock!((self.carousels[index]))
            }
        }else {
            if imageClickBlock != nil {
                imageClickBlock!((self.cycleHeaderModels[index]))
            }
        }
    }
}
