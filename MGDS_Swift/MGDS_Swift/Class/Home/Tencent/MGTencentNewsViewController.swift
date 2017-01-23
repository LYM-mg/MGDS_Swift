//
//  MGTencentNewsViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/18.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

class MGTencentNewsViewController: BaseTableViewController {
    override func viewDidLoad() {
        self.videoSid = .tencent
        super.viewDidLoad()
        
//        self.setUpRefresh()
    }
}

// MARK: - 加载数据
extension MGTencentNewsViewController {
//    override func setUpRefresh() {
//        weak var weakSelf = self
//        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            if KAppDelegate.sidArray.count > 2 {
//                let sidModel = KAppDelegate.sidArray[2]
//                self.showHudInViewWithMode(view: (weakSelf?.view)!, hint: "加载数据中...", mode: .determinate, imageName: nil)
//                weakSelf?.loadData(urlStr: "http://c.3g.163.com/nc/video/list/\(sidModel.sid!)/y/0-10.html", sidModel: sidModel)
//            }
//        })
//        
//        // 设置自动切换透明度(在导航栏下面自动隐藏)
//        tableView.mj_header.isAutomaticallyChangeAlpha = true
//        
//        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
//            let sidModel = KAppDelegate.sidArray[2]
//            self.showHudInViewWithMode(view: (weakSelf?.view)!, hint: "加载数据中...", mode: .determinate, imageName: nil)
//            
//            let urlStr = "http://c.3g.163.com/nc/video/list/\(sidModel.sid!)/y/\((weakSelf?.dataArr.count)! - (weakSelf?.dataArr.count)! % 10)-10.html"
//            weakSelf?.loadData(urlStr: urlStr, sidModel: sidModel)
//            
//        })
//        
//        self.tableView.mj_footer.isAutomaticallyHidden = true
//        self.tableView.mj_header.beginRefreshing()
//    }
//    
//    override func loadData(urlStr: String,sidModel: VideoSidList) {
//        weak var weakSelf = self
//        SysNetWorkTools.getVideoList(withURLString: urlStr, listID: sidModel.sid, success: { (listArray, _) in
//            weakSelf?.dataArr += listArray as! [VideoList]
//            DispatchQueue.main.async {
//                weakSelf?.tableView.reloadData()
//                weakSelf?.hideHud()
//                weakSelf?.tableView.mj_header.endRefreshing()
//                weakSelf?.tableView.mj_footer.endRefreshing()
//            }
//            }, failure: { (err) in
//                self.showHint(hint: "数据请求失败")
//                weakSelf?.hideHud()
//                weakSelf?.tableView.mj_header.endRefreshing()
//                weakSelf?.tableView.mj_footer.endRefreshing()
//        })
//        
//        // 1.显示指示器
//        dataArr = KAppDelegate.videosArray
//        self.tableView.reloadData()
//        
//        self.tableView.mj_header.endRefreshing()
//        self.tableView.mj_footer.endRefreshing()
//    }
}

