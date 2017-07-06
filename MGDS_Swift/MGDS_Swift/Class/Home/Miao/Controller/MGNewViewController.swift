//
//  MGNewViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh

private let KMGAnchorCellID = "KMGAnchorCellID"

class MGNewViewController: UIViewController {
    // MARK: - 懒加载
    fileprivate lazy var newAnchorVM = MGNewViewModel()
    @objc public lazy var collectionView: UICollectionView = { [unowned self] in
        let waterFlowLayout = MGWaterFlowLayout()
        waterFlowLayout.delegate = self
        
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: waterFlowLayout)
        cv.frame = CGRect(x: 0, y: 0, width: MGScreenW, height: self.view.mg_height)
        cv.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(collectionView)
        self.collectionView.register(MGAnchorCell.self, forCellWithReuseIdentifier: KMGAnchorCellID)
        
        if #available(iOS 9.0, *) {
            // 创建长按手势
            let longPressGesture =  UILongPressGestureRecognizer(target: self, action: #selector(MGNewViewController.handleLongGesture(lpGesture:)))
            self.collectionView.addGestureRecognizer(longPressGesture)
        }
        
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                registerForPreviewing(with: self, sourceView: view)
            }
        }
        setUpRefresh()
    }
}

// MARK: - 加载数据
extension MGNewViewController {
    fileprivate func setUpRefresh() {
        weak var weakSelf = self
        // 头部刷新
        self.collectionView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            let strongSelf = weakSelf
            strongSelf?.newAnchorVM.anchors.removeAll()
            strongSelf?.newAnchorVM.currentPage = 1
            strongSelf?.loadData()
        })
        // 下拉刷新
        self.collectionView.mj_footer = MJRefreshBackFooter(refreshingBlock: {
            let strongSelf = weakSelf
            strongSelf?.newAnchorVM.currentPage += 1
            strongSelf?.loadData()
        })
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        collectionView.mj_header.isAutomaticallyChangeAlpha = true
        self.collectionView.mj_footer.isAutomaticallyHidden = true
        self.collectionView.mj_header.beginRefreshing()
        // 隐藏下拉刷新
        self.collectionView.mj_footer.isHidden = true
    }
    
    fileprivate func loadData() {
        newAnchorVM.getHotData() { [unowned self] (err) in
            self.collectionView.reloadData()
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MGNewViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView.mj_footer.isHidden = newAnchorVM.anchors.count == 0
        return newAnchorVM.anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KMGAnchorCellID, for: indexPath) as! MGAnchorCell
        
        cell.user = newAnchorVM.anchors[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MGNewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerVC = MGPlayerViewController(nibName: "MGPlayerView", bundle: nil)
        let anchor =  self.newAnchorVM.anchors[indexPath.row]
        let hotModel = MGHotModel()
        hotModel.bigpic = anchor.photo;
        hotModel.myname = anchor.nickname;
        hotModel.smallpic = anchor.photo;
        hotModel.gps = anchor.position;
        hotModel.useridx = anchor.useridx;
        hotModel.allnum = NSNumber(value: arc4random_uniform(2000))
        hotModel.flv = anchor.flv
        playerVC.live = hotModel
        
        show(playerVC, sender: self)
    }

    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        for animationCell in collectionView.visibleCells {
            animationCell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 1.0, animations: {
                animationCell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }

    
    // MARK: - 手势
    @objc(collectionView:canFocusItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc(collectionView:moveItemAtIndexPath:toIndexPath:) func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 1、取出源item数据   2、从资源数组中移除该数据
        let anchor = self.newAnchorVM.anchors.remove(at: sourceIndexPath.item)
        // 3、将数据插入到资源数组中的目标位置上
        self.newAnchorVM.anchors.insert(anchor, at: destinationIndexPath.item)
    }
    
    @objc fileprivate func handleLongGesture(lpGesture: UILongPressGestureRecognizer) {
        switch(lpGesture.state) {
            case .began:
                    let selectedIndexPath =  self.collectionView.indexPathForItem(at: lpGesture.location(in: lpGesture.view!))
                    /** 在MGCollectionController中发现一处崩溃的地方。 长按cells间空白的地方，拖动程序就会崩溃
                     *  解法1 当移动空白处时，indexPath是空的，移除nil的index时就会崩溃。直接返回
                     */
                    if (selectedIndexPath == nil){
                        return
                    }
                    self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath!)
            case .changed:
                    self.collectionView.updateInteractiveMovementTargetPosition(lpGesture.location(in: self.collectionView))
        
            case .ended:
                    self.collectionView.endInteractiveMovement()
            default:
                self.collectionView.cancelInteractiveMovement()
                break
        }
    }
}

// MARK: - MGWaterFlowLayoutDelegate 布局代理相关方法
extension MGNewViewController: MGWaterFlowLayoutDelegate {

    @objc(waterflowLayoutWithWaterflowLayout:heightForItemAtIndex:itemWidth:) func waterflowLayout(waterflowLayout: MGWaterFlowLayout, heightForItemAtIndex indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        let arc = arc4random_uniform(10) + 1
        
        var a = CGFloat(Double(arc).truncatingRemainder(dividingBy: 3.0))
        if a == 0 {
            a += 1.0
        } else if a == 1{
            a += 0.2
        } else {
            a -= 0.8
        }
        return itemWidth*a
    }
    
    func columnMarginInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> CGFloat {
        if newAnchorVM.anchors.count > 36  {
            return 2
        }
        return 10
    }
    
    func rowMarginInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> CGFloat {
        if newAnchorVM.anchors.count > 36  {
            return 2
        }
        return 10
    }
    
    func columnCountInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> Int {
        if newAnchorVM.anchors.count > 36  {
            return 3
        } else {
            return 2
        }
    }
    
    func edgeInsetsInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> UIEdgeInsets {
        if newAnchorVM.anchors.count > 36  {
            return UIEdgeInsetsMake(2, 2, 2, 2)
            
        }
        return UIEdgeInsetsMake(2, 10, 2, 10)
    }
}

// MARK: - peek和pop
extension MGNewViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location) else {
            return nil
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return nil
        }
        
        // 设置背景虚化
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        }
        
        //  要预览的控制器
        let playerVC = MGPlayerViewController(nibName: "MGPlayerView", bundle: nil)
        let anchor =  self.newAnchorVM.anchors[indexPath.item]
        let hotModel = MGHotModel()
        hotModel.bigpic = anchor.photo;
        hotModel.myname = anchor.nickname;
        hotModel.smallpic = anchor.photo;
        hotModel.gps = anchor.position;
        hotModel.useridx = anchor.useridx;
        hotModel.allnum = NSNumber(value: arc4random_uniform(2000))
        hotModel.flv = anchor.flv
        playerVC.live = hotModel
        
        return playerVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

