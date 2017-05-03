//
//  MGSearchMusicResultVC.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/4/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

class MGSearchMusicResultVC: UITableViewController {

    var searchText: String = "" {
        didSet {
            loadSearchResultDataWithKeyWord(searchText)
        }
    }
    fileprivate lazy var dataSource = [SongDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        self.title = "歌曲列表"
        setUpRefresh()
    }
    deinit {
        debugPrint("MGSearchMusicResultVC--deinit")
    }
}


// MARK: - 加载数据
extension MGSearchMusicResultVC {
    fileprivate func setUpRefresh() {
        weak var weakSelf = self
        // 头部刷新
        self.tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            let strongSelf = weakSelf
            strongSelf?.loadSearchResultDataWithKeyWord(self.searchText)
        })
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        self.tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func loadSearchResultDataWithKeyWord(_ keyword: String) {
        // http://tingapi.ting.baidu.com/v1/restserver/ting?channel=appstore&format=json&from=ios&method=baidu.ting.search.merge&operator=1&page_no=-1&page_size=50&query=1%E5%88%861%E7%A7%92%20%281%EB%B6%84%201%EC%B4%88%29&type=-1&version=5.5.6
        // 1.显示指示器
        self.showHudInViewWithMode(view: self.view, hint: "正在查询数据", mode: .indeterminate, imageName: nil)
        let parameters = ["from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json","method":"baidu.ting.search.merge","page_size":"50","page_no":"-1","type":"-1","query":keyword]
        NetWorkTools.requestData(type: .get, urlString: "http://tingapi.ting.baidu.com/v1/restserver/ting",parameters: parameters, succeed: {[weak self] (response, err) in
            self?.hideHud()
            guard let res = response as? [String: Any] else { return }
            guard let result = res["result"] as? [String: Any] else { return }
            guard let songInfo = result["song_info"] as? [String: Any] else { return }
            guard let songList = songInfo["song_list"] as? [[String: Any]] else { return }
            for dict in songList {
                self?.dataSource.append(SongDetail(dict: dict))
            }
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
        }) { (err) in
            self.hideHud()
            self.tableView.mj_header.endRefreshing()
            self.showHint(hint: "请求数据失败", imageName: "sad_face_icon")
        }
    }
}

// MARK: - Table view data source
extension MGSearchMusicResultVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1.创建cell
        let cell = SongDetailListCell.cellWithTableView(tabView: tableView)
        
        // 2.给cell赋值
        cell.model = self.dataSource[indexPath.row]
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.dataSource[indexPath.row]
        let vc = UIStoryboard(name: "Music", bundle: nil).instantiateInitialViewController() as! MGMusicPlayViewController
        vc.setSongIdArray(musicArr: dataSource, currentIndex: indexPath.row)
        show(vc, sender: nil)
    }
}
