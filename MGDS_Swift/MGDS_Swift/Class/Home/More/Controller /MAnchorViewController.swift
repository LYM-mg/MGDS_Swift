//
//  MAnchorViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

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
        loadData(index: 0)
    }
    
    // MARK: - 系统方法
    convenience init(type: MoreType) {
        self.init()
        self.moreType = type   // 这个tag_id是用作url参数用的，具体你看ViewModel的两个url分析
    }
}

// MARK:- 设置UI界面内容
extension MAnchorViewController {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
    }
}

extension MAnchorViewController {
    fileprivate func loadData(index : Int) {
        moreVM.loadHomeData(type: moreType, index : index, finishedCallback: { _ in
            self.collectionView.reloadData()
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
        
        if indexPath.item == moreVM.anchorModels.count - 1 {
            loadData(index: moreVM.anchorModels.count)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let liveVc = RoomViewController()
//        liveVc.anchor = moreVM.anchorModels[indexPath.item]
//        navigationController?.pushViewController(liveVc, animated: true)
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
}


//// MARK: - peek和pop
//extension MAnchorViewController: UIViewControllerPreviewingDelegate {
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        guard let indexPath = collectionView.indexPathForItem(at: location) else {
//            return nil
//        }
//        
//        guard let cell = collectionView.cellForItem(at: indexPath) else {
//            return nil
//        }
//        
//        // 设置背景虚化
//        if #available(iOS 9.0, *) {
//            previewingContext.sourceRect = cell.frame
//        }
//        
//        //  要预览的控制器
//        let playerVC = MGPlayerViewController(nibName: "MGPlayerView", bundle: nil)
//        let anchor =  self.newAnchorVM.anchors[indexPath.item]
//        let hotModel = MGHotModel()
//        hotModel.bigpic = anchor.photo;
//        hotModel.myname = anchor.nickname;
//        hotModel.smallpic = anchor.photo;
//        hotModel.gps = anchor.position;
//        hotModel.useridx = anchor.useridx;
//        hotModel.allnum = NSNumber(value: arc4random_uniform(2000))
//        hotModel.flv = anchor.flv
//        playerVC.live = hotModel
//        
//        return playerVC
//    }
//    
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        show(viewControllerToCommit, sender: self)
//    }
//}


