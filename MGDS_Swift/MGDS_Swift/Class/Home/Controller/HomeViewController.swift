//
//  HomeViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit


private let kTitlesViewH : CGFloat = 40

class HomeViewController: UIViewController {
    /// 是否第一次打开
    var isFirst: Bool = false


    // MARK: - lazy
    fileprivate lazy var homeTitlesView: HomeTitlesView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: MGStatusHeight + MGNavHeight, width: MGScreenW, height: kTitlesViewH)
        let titles = ["热门", "精华", "娱乐"]
        let tsView = HomeTitlesView(frame: titleFrame, titles: titles)
        tsView.deledate = self
        return tsView
    }()
    fileprivate lazy var homeContentView: HomeContentView = { [weak self] in
        // 1.确定内容的frame
        let contentH = MGScreenH - MGStatusHeight - MGNavHeight - kTitlesViewH - MGTabBarHeight
        let contentFrame = CGRect(x: 0, y: MGStatusHeight + MGNavHeight+kTitlesViewH, width: MGScreenW, height: contentH)
        
        // 2.确定所有的子控制器
        var childVcs = [UIViewController]()
        childVcs.append(VideoTableViewController())
        childVcs.append(VideoTableViewController())
        childVcs.append(VideoTableViewController())
        let contentView = HomeContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.创建UI
        setUpMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: - 初始化UI
extension HomeViewController {
    fileprivate func setUpMainView() {
//        setUpNavgationBar()
        view.addSubview(homeTitlesView)
        view.addSubview(homeContentView)
    }
    fileprivate func setUpNavgationBar() {
//        // 1.设置左侧的Item
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
//        
//        // 2.设置右侧的Item
//        let size = CGSize(width: 40, height: 40)
//        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
//        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
//        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
//        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}

// MARK:- 遵守 HomeTitlesViewDelegate 协议
extension HomeViewController : HomeTitlesViewDelegate {
    func HomeTitlesViewDidSetlected(homeTitlesView: HomeTitlesView, selectedIndex: Int) {
        homeContentView.setCurrentIndex(currentIndex: selectedIndex)
    }
}


// MARK:- 遵守 HomeContentViewDelegate 协议
extension HomeViewController : HomeContentViewDelegate {
    func HomeContentViewDidScroll(contentView: HomeContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        homeTitlesView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


