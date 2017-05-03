//
//  MGRankListDetailViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/1.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

class MGRankListDetailViewController: UITableViewController {

    var songGroup: SongGroup?
    lazy var dataSource = [SongDetail]()
    /** 记录右边边TableView是否滚动到的位置的Y坐标 */
    fileprivate lazy var lastOffsetY: CGFloat = 0
    /** 记录tableView是否向下滚动 */
    fileprivate lazy var  isScrollDown: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音乐列表"
//        tableView.estimatedRowHeight = 70
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 90
        
        setUpMainView()
        setUpRefresh()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    init(songGroup: SongGroup) {
        super.init(style: .plain)
        self.songGroup = songGroup
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpMainView() {
        let bg = UIImageView(frame: self.view.frame)
        bg.setImageWithURLString(songGroup?.pic_s444, placeholder: #imageLiteral(resourceName: "mybk1"))
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = bg.frame
        bg.addSubview(effectView)
        self.tableView.backgroundView = bg
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: MGScreenW*0.5))
        let image = UIImageView(frame: headerView.frame)
        image.setImageWithURLString(songGroup?.pic_s444, placeholder: #imageLiteral(resourceName: "mybk1"))
        let nameLable = UILabel(frame:  CGRect(x: 20, y: MGScreenW*0.42, width: MGScreenW, height: 25))
        nameLable.textColor = UIColor.white
        nameLable.text = self.songGroup?.name
        headerView.addSubview(image)
        headerView.addSubview(nameLable)
        tableView.tableHeaderView = headerView
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchClick))
    }
    
    @objc fileprivate func searchClick() {
        show(SearchMusicViewController(), sender: nil)
    }
}

// MARK: - LoadData
extension MGRankListDetailViewController {
    fileprivate func setUpRefresh() {
        weak var weakSelf = self
        // 头部刷新
        self.tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            let strongSelf = weakSelf
            strongSelf?.loadData()
        })
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        self.tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func loadData() {
        let parameters: [String: Any] = ["method":"baidu.ting.billboard.billList","offset":"0","size":"100","type":self.songGroup!.type,"from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json"]
        NetWorkTools.requestData(type: .get, urlString: "http://tingapi.ting.baidu.com/v1/restserver/ting",parameters: parameters,succeed: { [weak self] (result, err) in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : Any] else { return }
            
            // 2.根据song_list该key,获取数组
            guard let dataArray = resultDict["song_list"] as? [[String : Any]] else { return }
            
            for mdict in dataArray {
                self!.dataSource.append(SongDetail(dict: mdict))
            }
            
            self!.tableView.reloadData()
            self!.tableView.mj_header.endRefreshing()
        }) { (err) in
            if err != nil {
                self.showHint(hint: "网络请求错误❌")
            }
            self.tableView.mj_header.endRefreshing()
        }
    }
}

extension MGRankListDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    
    
    // MARK: - 动画
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isScrollDown {
//            startAnimation(view: cell, offsetY: 90, duration: 2.0)
            let rect = cell.convert((cell.bounds), to: nil)
            if (rect.origin.y) > MGScreenW*0.5 {
                cell.transform = CGAffineTransform(translationX: 0, y: 1.5*cell.mg_height)
                UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
                    cell.transform =  CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= scrollView.contentSize.height {
            isScrollDown = lastOffsetY < scrollView.contentOffset.y
            lastOffsetY = scrollView.contentOffset.y
        }
    }
    
    private func startAnimation(view: UIView, offsetY: CGFloat, duration: TimeInterval) {
        view.transform = CGAffineTransform(translationX: 0, y: offsetY)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            view.transform = CGAffineTransform.identity
        })
    }

}
