//
//  MyFavoutiteViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/9.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

class MyFavoutiteViewController: UITableViewController {

    fileprivate lazy var lives = [MGHotModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "收藏"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        setUpInit()
        MyFavoutiteViewController.loadFavouriteAnchorDataFromLocal(finished: { [weak self](models) in
            self?.lives = models
            self?.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.removeAllFavouriteAnchorDataFromLocal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - setUpInit
extension MyFavoutiteViewController {
    fileprivate func setUpInit(){
        tableView.register(UINib(nibName: "MGHotLiveCell", bundle: nil), forCellReuseIdentifier: "KMGHotLiveCellID")
        tableView.rowHeight = 465
        tableView.tableFooterView = UIView()
        setUpRefresh()
        
        MGNotificationCenter.addObserver(forName: NSNotification.Name(KSelectedFavouriteAnchorNotification), object: nil, queue: nil) {[weak self](noti) in
            print(noti.userInfo)
            // 获取通知传过来的按钮
            let dict = noti.userInfo as! [String : AnyObject]
            let model: MGHotModel = dict["model"] as! MGHotModel
            MyFavoutiteViewController.saveFavouriteAnchorDataToLocal(model: model)
            self?.tableView.mj_header.beginRefreshing()
        }
        
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: view)
            }
        }
    }
    
    fileprivate func setUpRefresh() {
        weak var weakSelf = self
        // 头部刷新
        self.tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            if let strongSelf = weakSelf {
                strongSelf.lives.removeAll()
                MyFavoutiteViewController.loadFavouriteAnchorDataFromLocal(finished: { (models) in
                     strongSelf.lives = models
                     strongSelf.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                })
            }
        })
       
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
}

// MARK: - UITableViewDataSource
extension MyFavoutiteViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lives.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KMGHotLiveCellID", for: indexPath) as! MGHotLiveCell
        if (lives.count > 0) {
            let live = lives[indexPath.row];
            cell.live = live
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyFavoutiteViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = MGPlayerViewController(nibName: "MGPlayerView", bundle: nil)
        let hotModel = self.lives[indexPath.row]
        playerVC.live = hotModel
        navigationController?.pushViewController(playerVC, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = self.lives[indexPath.row]
            self.lives.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.removeOneFavouriteAnchorDataFromLocal(model: model)
        } else if editingStyle == .insert {
            
        }
    }
}

// MARK: - 3DTouch PEEK和POP
extension MyFavoutiteViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) as? MGHotLiveCell else { return nil }
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        }
        
        let playerVC = MGPlayerViewController(nibName: "MGPlayerView", bundle: nil)
        playerVC.live = self.lives[indexPath.row]
        return playerVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}



// MARK: - 数据存储操作
extension MyFavoutiteViewController {
    // 执行SQL语句,插入数据
    /**
     *  存储一条收藏数据到数据库
     */
    static fileprivate func saveFavouriteAnchorDataToLocal(model: MGHotModel) {
        SQLiteManager.shareInstance.dbQueue?.inTransaction({ (db, rollback) in
            // 执行SQL语句,插入数据
            // 1.SQL语句
            //"?"是sql语句中的占位符，sql语句中不确定的值可以用"?"来代替，在执行sql语句的时候再给这个问号对应的值赋值
            let sqlStr = "INSERT INTO t_FavouriteAnchor (userId,myname,smallpic,bigpic,gps,flv,nation,starlevel,allnum,roomid,serverid) VALUES (?,?,?,?,?,?,?,?,?,?,?);"
            
            // 2.执行sql语句
            // 参数1：需要执行的sql语句
            // 参数2：sql语句中的占位符对应的值
            // 返回值：bool
            if db.executeUpdate(sqlStr, withArgumentsIn: [model.userId!,model.myname!,model.smallpic!,model.bigpic!,model.gps!,model.flv!,model.nation!,model.starlevel!,model.allnum!,model.roomid!,model.serverid!]) {
                print("数据插入成功")
            }else {
                rollback.pointee = true
                print("数据插入失败")
            }
        })
    }
    
    /**
        从数据库取出缓存收藏数据
     
     - parasmeter statusArray: 收藏数据数组
     */
    static fileprivate func loadFavouriteAnchorDataFromLocal(finished:@escaping ([MGHotModel]) -> ()){
        DispatchQueue.global().async {
            // 1.查询SQL
            let sql = "SELECT * FROM t_FavouriteAnchor"
            
            // 3.执行SQL语句
            var statusArray = [MGHotModel]()
            SQLiteManager.shareInstance.dbQueue?.inDatabase({ (db) -> Void in
                guard let result = db.executeQuery(sql, withArgumentsIn: statusArray) else { return }
                while result.next() {
                    // 1.取出数据库存储的微博字典
                    let model = MGHotModel()
                    model.userId = result.string(forColumn: "userId")
                    model.myname = result.string(forColumn: "myname")
                    model.smallpic = result.string(forColumn: "smallpic")
                    model.bigpic = result.string(forColumn: "bigpic")
                    model.gps = result.string(forColumn: "gps")
                    model.flv = result.string(forColumn: "flv")
                    model.nation = (result.string(forColumn: "nation") ?? "来自喵星")
                    
                    model.starlevel = NSNumber(value: result.int(forColumn: "starlevel"))
                    model.allnum    = NSNumber(value: result.int(forColumn: "allnum"))
                    model.roomid    = NSNumber(value: result.int(forColumn: "roomid"))
                    model.serverid  = NSNumber(value: result.int(forColumn: "serverid"))

                    // 2.将字符串转成data
                    statusArray.append(model)
                }
            })
            DispatchQueue.main.async {
                finished(statusArray)
            }
        }
    }
    
    /**
     从数据库删除一条缓存收藏数据
     
     - parasmeter model: 删除收藏数据模型
     */
    fileprivate func removeOneFavouriteAnchorDataFromLocal(model: MGHotModel){
        // 1.取得用户ID
        let sql = "DELETE FROM t_FavouriteAnchor WHERE userId = \"\(model.userId!)\""
        SQLiteManager.shareInstance.dbQueue?.inDatabase({ (db) in
            if db.executeUpdate(sql, withArgumentsIn: self.lives) {
                self.showHint(hint: "删除成功")
            }else {
                self.showHint(hint: "删除失败")
            }
        })
    }
    
    /**
     *  从数据库删除所有缓存收藏数据
     */
    fileprivate func removeAllFavouriteAnchorDataFromLocal(){
        // 1.取得用户ID
        let sql = "DELETE FROM t_FavouriteAnchor"
        SQLiteManager.shareInstance.dbQueue?.inDatabase({ (db) in
            if db.executeUpdate(sql, withArgumentsIn: self.lives) {
                self.showHint(hint: "删除成功")
            }else {
                self.showHint(hint: "删除失败")
            }
        })
    }
}
