//  LiveTableViewController.swift
//  Created by ming on 16/9/19.
//  Copyright © 2017年 明. All rights reserved.
// http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=15&multiaddr=2

import Just
import Kingfisher
import UIKit
import MJRefresh


class LiveTableViewController: UITableViewController {
    // MARK: - 属性
    var topicType: LivekyTopicType = .top
    fileprivate lazy var list : [LiveCell] = [LiveCell]()
    var multiaddr: Int = 0
    var proto: Int = 5
    fileprivate lazy var livekyHeaderView: LivekyCycleHeader = {[unowned self] in
        let hdcView = LivekyCycleHeader(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: MGScreenW/2.8),type: self.topicType == .top ? .top : .search)
            // 图片轮播器点击回调
        hdcView.imageClickBlock = { [unowned self] (cycleHeaderModel) in
            if (cycleHeaderModel.url != nil) {
                let webViewVc = WebViewController(navigationTitle: cycleHeaderModel.title, urlStr: cycleHeaderModel.url!)
                self.show(webViewVc, sender: nil)
            }
        }
        return hdcView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = livekyHeaderView
        
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: view)
            }
        }

//        self.tableView.estimatedRowHeight = 150
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // 头部刷新
        self.tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.proto = 5
            self.livekyHeaderView.loadData()   // 轮播器数据
            self.list.removeAll()
            self.loadList()
        })
        // 下拉刷新
        self.tableView.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {
            self.multiaddr += 5
             self.proto += 5
            self.loadList()
        })
        self.tableView.mj_header.beginRefreshing()
    }
    
    // 加载数据
    func loadList()  {
        var urlStr = ""
        if topicType == .top {
            urlStr = "http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=\(proto)&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=10&multiaddr=\(self.multiaddr)"
            
            
        }else {
            urlStr = "http://120.55.238.158/api/live/themesearch?lc=0000000000000040&cc=TG0001&cv=IK3.7.00_Iphone&proto=\(proto)&idfa=00000000-0000-0000-0000-000000000000&idfv=64020C43-7EE7-4175-8A40-0DDC48C913B6&devi=41c42500bc5f28f4a79c6eb529706b12817052eb&osversion=ios_10.000000&ua=iPhone8_4&imei=&imsi=&uid=248036681&sid=20i1SHXxme13D7ooInw1pcWhrmyi0cK6rMjAsn7rWc12Chj7rHFI&conn=wifi&mtid=95d648efc6268131017dbba9f494bca9&mtxid=6c408c17cf2&logid=&keyword=AFCC0BC263924F20&longitude=108.893557&latitude=34.245905&s_sg=75be1abb462c90405b82c8a40f004bde&s_sc=100&s_st=1478569622"
        }
        
        Just.post(urlStr) { (r) in
            guard let json = r.json as? NSDictionary else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            let lives = YKLiveList(fromDictionary: json).lives!
            
            self.list += lives.map({ (live) -> LiveCell in
                return LiveCell(portrait: live.creator.portrait, addr: live.city, cover: "", viewers: live.onlineUsers, caster: live.creator.nick, url: live.streamAddr)
            })
            
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.tableView.mj_footer != nil) {
            self.tableView.mj_footer.isHidden = (list.count == 0)
        }
        
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveTableViewCell", for: indexPath) as! LiveTableViewCell

        let live = list[indexPath.row]
        
        cell.labelNick.text = live.caster
        cell.labelAddr.text = live.addr.isEmpty ? "未知星球" : live.addr
        cell.labelViewers.text = "\(live.viewers)"
        
        //头像
        var imgUrl = URL(string: live.portrait)
        
        if imgUrl == nil {
            imgUrl = URL(string: "http://img.meelive.cn/" + live.portrait)
        }
        
        //封面
        cell.imgPortrait.kf.setImage(with: imgUrl, placeholder: UIImage(named: "10"))
        cell.imgCover.kf.setImage(with: imgUrl, placeholder:  UIImage(named: "10"))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = UIStoryboard(name: "Liveky", bundle: nil).instantiateViewController(withIdentifier: "KTurnToPlayerID") as! PlayerViewController
        playerVC.live = list[indexPath.row]
        present(playerVC, animated: true, completion: nil)
    }
}

// MARK: - PEEK和POP
extension LiveTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        }
        
        let playerVC = UIStoryboard(name: "Liveky", bundle: nil).instantiateViewController(withIdentifier: "KTurnToPlayerID") as! PlayerViewController
        playerVC.live = list[indexPath.row]
        
        return playerVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }
}
