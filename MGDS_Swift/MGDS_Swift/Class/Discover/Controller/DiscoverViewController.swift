//
//  DiscoverViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.


class DiscoverViewController: UITableViewController {
    fileprivate lazy var dataArr = [MGVideoModel]()
    fileprivate lazy var playerView: ZFPlayerView = {
        let playerView = ZFPlayerView()
        playerView.delegate = self
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        playerView.cellPlayerOnCenter = true
        
        // 当cell划出屏幕的时候停止播放
        playerView.stopPlayWhileCellNotVisable = false
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        playerView.playerLayerGravity = .resizeAspect
        // 静音
        playerView.mute = false
        return playerView
    }()
    fileprivate lazy var controlView: ZFPlayerControlView = ZFPlayerControlView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "惊喜"
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCellID")
        
        loadData()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.resetPlayer()
    }
}

// MARK: - 数据源
extension DiscoverViewController {
    func loadData() {
        let path = Bundle.main.path(forResource: "videoData", ofType: "json")
        let data: Data = NSData(contentsOfFile: path!) as! Data
        guard let rootDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
        
        guard let videoList = rootDict?["videoList"]! as? [[String: Any]]  else { return }
        for dict in videoList {
            let model = MGVideoModel(dict: dict)
            dataArr.append(model)
        }
        self.tableView.reloadData()
    }
}


// MARK: - tableView 数据源
extension DiscoverViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID", for: indexPath) as! TableViewCell
        
        cell.model = self.dataArr[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - TableViewCellProtocol -- 播放视频
extension DiscoverViewController: TableViewCellProtocol {
    /// 点击播放
    func playBtnClick(cell: TableViewCell ,model: MGVideoModel) {
        // 分辨率字典（key:分辨率名称，value：分辨率url)
        let dic = NSMutableDictionary()
        for resolution in model.playInfo {
            dic.setValue(resolution.url, forKey: resolution.name)
        }
        // 取出字典中的第一视频URL
        let videoURL = URL(string: dic.allValues.first! as! String)!
        
        let playerModel = ZFPlayerModel()
        playerModel.title            = model.title;
        playerModel.videoURL         = videoURL;
        playerModel.placeholderImageURLString = model.coverForFeed
        playerModel.tableView        = self.tableView;
        playerModel.indexPath        = tableView.indexPath(for: cell)
        // 赋值分辨率字典
        playerModel.resolutionDic    = NSDictionary(dictionary: dic) as! [AnyHashable : Any]
        // player的父视图
        playerModel.fatherView       = cell.picView;
        
        // 设置播放控制层和model
        playerView.playerControlView(self.controlView, playerModel: playerModel)
        // 下载功能
        playerView.hasDownload = false
        // 自动播放
        playerView.autoPlayTheVideo()
    }
}

// MARK: - TableViewCellProtocol
extension DiscoverViewController: ZFPlayerDelegate {
    func zf_playerDownload(_ url: String!) {
        // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
        let name = (url as NSString).lastPathComponent
        print(name)
    }
}



