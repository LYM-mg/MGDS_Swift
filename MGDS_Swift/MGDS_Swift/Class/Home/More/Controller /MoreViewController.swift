//
//  MoreViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

private let kTitlesViewH : CGFloat = 40

class MoreViewController: UIViewController {
    fileprivate lazy var moreTypies: [MoreType] = [MoreType]()
    // MARK: - lazy
    fileprivate lazy var moreTitlesView: MoreTitlesView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: MGNavHeight, width: MGScreenW, height: kTitlesViewH)
        let titles = self?.moreTypies.map({ $0.title })
        let tsView = MoreTitlesView(frame: titleFrame, titles: titles!)
        tsView.delegate = self
        return tsView
    }()
    fileprivate lazy var moreContentView: MoreContentView = { [weak self] in
        // 0.确定内容的frame
        let contentH = MGScreenH - MGNavHeight - kTitlesViewH
        let contentFrame = CGRect(x: 0, y: MGNavHeight+kTitlesViewH, width: MGScreenW, height: contentH)
        
        // 2.确定所有的子控制器
        var childVcs = [MAnchorViewController]()
        for type in (self?.moreTypies)! {
            let anchorVc = MAnchorViewController(type: type)
            childVcs.append(anchorVc)
        }

        let contentView: MoreContentView = MoreContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
            contentView.delegate = self
            return contentView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "更多"
        moreTypies = loadTypesData()
        
        // 1.创建UI
        setUpMainView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        let isfirst = SaveTools.mg_getLocalData(key: "isFirstOpen") as? String
        return (isfirst == "false") ? false : true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func loadTypesData() -> [MoreType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [MoreType]()
        for dict in dataArray {
            tempArray.append(MoreType(dict: dict))
        }
        return tempArray
    }
}

// MARK: - 初始化UI
extension MoreViewController {
    fileprivate func setUpMainView() {
        view.addSubview(moreTitlesView)
        view.addSubview(moreContentView)
    }
}

// MARK:- 遵守 MoreTitlesViewDelegate 协议
extension MoreViewController : MoreTitlesViewDelegate {
    func MoreTitlesViewDidSetlected(moreTitlesView: MoreTitlesView, selectedIndex: Int) {
        moreContentView.setCurrentIndex(currentIndex: selectedIndex)
    }
}


// MARK:- 遵守 MoreContentViewDelegate 协议
extension MoreViewController : MoreContentViewDelegate {
    func MoreContentViewDidScroll(contentView: MoreContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        moreTitlesView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    func contentViewEndScroll(_ contentView: MoreContentView) {
        moreTitlesView.contentViewDidEndScroll()
    }
}

// MARK: - 类型
class MoreType: BaseModel {
    var title : String = ""
    var type : Int = 0
}
