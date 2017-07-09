//
//  MGHotViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

class MGHotViewController: UITableViewController {
    // MARK: - 懒加载
    fileprivate lazy var hotLiveVM = MGHotViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(MGHotADCell.classForCoder(), forCellReuseIdentifier: "KMGHotADCellID")
        tableView.register(UINib(nibName: "MGHotLiveCell", bundle: nil), forCellReuseIdentifier: "KMGHotLiveCellID")
        setUpRefresh()
        
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: view)
            }
        }
    }
}

// MARK: - 加载数据
extension MGHotViewController {
    fileprivate func setUpRefresh() {
        weak var weakSelf = self
        // 头部刷新
        self.tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            let strongSelf = weakSelf
            strongSelf?.hotLiveVM.lives.removeAll()
            strongSelf?.hotLiveVM.currentPage = 1
            strongSelf?.loadData()
        })
        // 下拉刷新
        self.tableView.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {
            let strongSelf = weakSelf
            strongSelf?.hotLiveVM.currentPage += 1
            strongSelf?.loadData()
        })

        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        self.tableView.mj_footer.isAutomaticallyHidden = true
        self.tableView.mj_header.beginRefreshing()
        // 隐藏下拉刷新
        self.tableView.mj_footer.isHidden = true
    }
    
    
    fileprivate func loadData() {
        if self.hotLiveVM.currentPage == 1 { // 如果是下拉刷新 即也是要重新加载图片轮播的数据
            hotLiveVM.getCycleData { [unowned self] (err) in
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
            
            hotLiveVM.getHotData { [unowned self] (err) in
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
        }else {
            hotLiveVM.getHotData { [unowned self] (err) in
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }

        }
    }
}

// MARK: - Table view data source
extension MGHotViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.mj_footer.isHidden = hotLiveVM.lives.count == 0
        return hotLiveVM.lives.count + 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KMGHotADCellID", for: indexPath) as? MGHotADCell
            if (hotLiveVM.hotADS.count > 0) {
                cell?.hotADS = self.hotLiveVM.hotADS
                
                // 图片轮播器点击回调
                cell?.imageClickBlock = { [unowned self] (hotAD) in
                    let webViewVc = WebViewController(navigationTitle: hotAD.title, urlStr: hotAD.link)
                    self.show(webViewVc, sender: nil)
                }
            }
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "KMGHotLiveCellID", for: indexPath) as! MGHotLiveCell
        if (hotLiveVM.lives.count > 0) {
            let live = hotLiveVM.lives[indexPath.row-1];
            cell.live = live
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 160
        }
        return 465
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = MGPlayerViewController(nibName: "MGPlayerView", bundle: nil)
        let hotModel = self.hotLiveVM.lives[indexPath.row-1]
        playerVC.live = hotModel
        navigationController?.pushViewController(playerVC, animated: true)
    }
}

// PEEK和POP
extension MGHotViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) as? MGHotLiveCell else { return nil }
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        }
        
        let playerVC = MGPlayerViewController(nibName: "MGPlayerView", bundle: nil)
        playerVC.live = self.hotLiveVM.lives[indexPath.row-1]
        return playerVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
}
