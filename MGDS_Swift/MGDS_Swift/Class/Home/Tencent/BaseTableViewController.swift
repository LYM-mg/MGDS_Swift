//
//  BaseTableViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/18.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

enum VideoSidType: Int {
    case tencent = 0
    case sina    = 1
    case netease = 2
}

class BaseTableViewController: UITableViewController {
    public var videoSid: VideoSidType = VideoSidType(rawValue: 0)!
    var page = 10
    lazy var dataArr = [VideoList]()
    lazy var playerView: ZFPlayerView = {
        let playerView = ZFPlayerView()
        playerView.delegate = self
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        playerView.cellPlayerOnCenter = true
        /** 静音（默认为NO）*/
        playerView.mute = false
        // 当cell划出屏幕的时候停止播放
        playerView.stopPlayWhileCellNotVisable = false
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        playerView.playerLayerGravity = .resizeAspect

        return playerView
    }()
    lazy var controlView: ZFPlayerControlView = ZFPlayerControlView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 350.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 设置分割线从最左开始
        if tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        if tableView.responds(to: #selector(setter: UIView.layoutMargins)) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        setUpRefresh()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.resetPlayer()
    }
}

// MARK: - 加载数据
extension BaseTableViewController {
    func setUpRefresh() {
        weak var weakSelf = self
        // MARK: 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            let strongSelf = weakSelf
            if KAppDelegate.sidArray.count > strongSelf!.videoSid.rawValue {
                if KAppDelegate.sidArray.isEmpty && KAppDelegate.sidArray.count == 0 {
                    strongSelf?.tableView.mj_header.endRefreshing()
                    return
                }
                let sidModel = KAppDelegate.sidArray[strongSelf!.videoSid.rawValue]
                self.dataArr.removeAll()
                strongSelf!.page = 10
                let index = Int(arc4random_uniform(10))
                strongSelf?.loadData(urlStr: "http://c.3g.163.com/nc/video/list/\(sidModel.sid!)/y/\(index)-15.html", sidModel: sidModel)
            }
        })
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        
        
        // MARK: 上拉刷新
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            let strongSelf = weakSelf
            let sidModel = KAppDelegate.sidArray[strongSelf!.videoSid.rawValue]
            strongSelf!.page += 10
            let urlStr = "http://c.3g.163.com/nc/video/list/\(sidModel.sid!)/y/\(self.page-10)-\(self.page).html"
            weakSelf?.loadData(urlStr: urlStr, sidModel: sidModel)
            
        })
        
        self.tableView.mj_footer.isAutomaticallyHidden = true
        self.tableView.mj_header.beginRefreshing()
    }
    
    func loadData(urlStr: String,sidModel: VideoSidList) {
        weak var weakSelf = self
        SysNetWorkTools.share.progressTitle("正在加载数据...").getVideoList(withURLString: urlStr, listID: sidModel.sid, success: { (listArray, _) in
            weakSelf?.dataArr += listArray as! [VideoList]
            DispatchQueue.main.async {
                weakSelf?.tableView.reloadData()
                weakSelf?.tableView.mj_header.endRefreshing()
                weakSelf?.tableView.mj_footer.endRefreshing()
            }
            }, failure: { (err) in
                weakSelf?.showHint(hint: "数据请求失败")
                weakSelf?.tableView.mj_header.endRefreshing()
                weakSelf?.tableView.mj_footer.endRefreshing()
        })
        
        // 1.显示指示器
        dataArr = KAppDelegate.videosArray
        self.tableView.reloadData()
        
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
    }
}



// MARK: - 数据源
extension BaseTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KTencentCellID", for: indexPath) as! TencentCell
        
        cell.model = self.dataArr[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell.separatorInset = .zero
        }
        
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))){
            cell.layoutMargins = .zero
        }
    }
}

// MARK: - TableViewCellProtocol
extension BaseTableViewController: TencentCellProtocol {
    /// 点击播放
    func playBtnClick(cell: TencentCell ,model: VideoList) {
        // 分辨率字典（key:分辨率名称，value：分辨率url)
        
        
        let playerModel = ZFPlayerModel()
        playerModel.title            = model.title;
        playerModel.videoURL         = URL(string: model.mp4_url)
        playerModel.placeholderImageURLString = model.topicImg
        playerModel.tableView        = self.tableView;
        playerModel.indexPath        = tableView.indexPath(for: cell)
        
        // player的父视图
        playerModel.fatherView       = cell.playImageV;
        
        // 设置播放控制层和model
        playerView.playerControlView(self.controlView, playerModel: playerModel)
        // 下载功能
        playerView.hasDownload = false
        // 自动播放
        playerView.autoPlayTheVideo()
    }
}

// MARK: - TableViewCellProtocol
extension BaseTableViewController: ZFPlayerDelegate {
    func zf_playerDownload(_ url: String!) {
        // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
        let name = (url as NSString).lastPathComponent
        print(name)
    }
}
