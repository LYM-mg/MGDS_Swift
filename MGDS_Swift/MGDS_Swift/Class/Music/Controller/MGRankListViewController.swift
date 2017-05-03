//
//  MGRankListViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/1.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

private let kRankListCellID = "kRankListCellID"

class MGRankListViewController: UIViewController {

    // MARK: 定义属性
    lazy var dataSource = [SongGroup]()
    lazy var collectionView: UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: MGScreenW, height: MGScreenW*0.4)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.register(RankListCell.self, forCellWithReuseIdentifier: kRankListCellID)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMainView()
        
        setUpRefresh()
    }
}

// MARK: - UI 和 data
extension MGRankListViewController {
    fileprivate func setUpMainView() {
        view.addSubview(collectionView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchClick))
    }
    
    @objc fileprivate func searchClick() {
        show(SearchMusicViewController(), sender: nil)
    }
    
    fileprivate func setUpRefresh() {
        weak var weakSelf = self
        // 头部刷新
        self.collectionView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            let strongSelf = weakSelf
            strongSelf?.loadData()
        })
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        collectionView.mj_header.isAutomaticallyChangeAlpha = true
        self.collectionView.mj_header.beginRefreshing()
    }

    
//    http://tingapi.ting.baidu.com/v1/restserver/ting?channel=appstore&format=json&from=ios&kflag=1&method=baidu.ting.billboard.billCategory&operator=1&version=5.5.6
    fileprivate func loadData() {
        let parameters: [String: Any] = ["method":"baidu.ting.billboard.billCategory","kflag":"1","from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json"]
        NetWorkTools.requestData(type: .get, urlString: "http://tingapi.ting.baidu.com/v1/restserver/ting",parameters: parameters,succeed: { [weak self] (result, err) in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : Any] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["content"] as? [[String : Any]] else { return }
            
            for mdict in dataArray {
                self!.dataSource.append(SongGroup(dict: mdict))
            }

            self!.collectionView.reloadData()
            self!.collectionView.mj_header.endRefreshing()
        }) { (err) in
            if err != nil {
                self.showHint(hint: "网络请求错误❌")
            }
            self.collectionView.mj_header.endRefreshing()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MGRankListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRankListCellID, for: indexPath) as! RankListCell
        cell.model = dataSource[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MGRankListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MGRankListDetailViewController(songGroup: dataSource[indexPath.item])
        show(vc, sender: nil)
    }
}
