//
//  MAnchorViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

private let KEdgeMargin : CGFloat = 8
private let KAnchorCellID = "KAnchorCellID"

class MAnchorViewController: UIViewController {
    // MARK: 定义属性
    fileprivate var moreType: MoreType!
    fileprivate lazy var moreVM : MoreViewModel = MoreViewModel()

    fileprivate lazy var collectionView : UICollectionView = {
        let layout = MGWaterFlowLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: KEdgeMargin, left: KEdgeMargin, bottom: KEdgeMargin, right: KEdgeMargin)
        layout.minimumLineSpacing = KEdgeMargin
        layout.minimumInteritemSpacing = KEdgeMargin
       
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: KAnchorCellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - 系统方法
    convenience init(type: MoreType) {
        self.init()
        self.moreType = type   // 这个type是用作网络参数请求用的
    }
}

// MARK:- 设置UI界面内容
extension MAnchorViewController {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        
        
        collectionView.mj_header = MJRefreshGifHeader(refreshingBlock: { [weak self] in
            self?.loadData(index: 0)
        })
        collectionView.mj_header.beginRefreshing()
        
        collectionView.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: { [weak self] in
            self?.loadData(index: self!.moreVM.anchorModels.count)
        })
    }
}

extension MAnchorViewController {
    fileprivate func loadData(index : Int) {
        weak var weakSelf = self
        moreVM.loadMoreData(type: moreType, index : index, finishedCallback: { _ in
            weakSelf?.collectionView.mj_header.endRefreshing()
            weakSelf?.collectionView.mj_footer.endRefreshing()
            weakSelf?.collectionView.reloadData()
        })
    }
}

// MARK:- collectionView的数据源&代理
extension MAnchorViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KAnchorCellID, for: indexPath) as! HomeViewCell
        
        cell.anchorModel = moreVM.anchorModels[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let liveVc = RoomViewController(anchor: moreVM.anchorModels[indexPath.item])
        navigationController?.pushViewController(liveVc, animated: true)
    }
}

// MARK: - MGWaterFlowLayoutDelegate 布局代理相关方法
extension MAnchorViewController: MGWaterFlowLayoutDelegate {
    
    // 控制显示的高度
    @objc(waterflowLayoutWithWaterflowLayout:heightForItemAtIndex:itemWidth:) func waterflowLayout(waterflowLayout: MGWaterFlowLayout, heightForItemAtIndex indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        if moreVM.anchorModels.count > 100 {
            return indexPath.item % 2 == 0 ? MGScreenW * 3 / 8 : 100
        }else {
            return indexPath.item % 2 == 0 ? MGScreenW * 2 / 3 : MGScreenW * 0.5
        }
    }
    
    // 控制显示行数
    func columnCountInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> Int {
        if moreVM.anchorModels.count > 100  {
            return 3
        } else {
            return 2
        }
    }
    
    func edgeInsetsInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsetsMake(3, 10, 3, 10)
    }
}

