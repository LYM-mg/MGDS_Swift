//
//  DetailGameViewController.swift
//  MGDYZB
//
//  Created by i-Techsys.com on 17/4/8.
//  Copyright © 2017年 ming. All rights reserved.
//

import UIKit
import SafariServices
import MJRefresh

private let KDetailCellItemW = (MGScreenW - 3 * (kItemMargin/2)) / 2

class DetailGameViewController: UIViewController {

    // MARK: - 懒加载属性
    fileprivate lazy var detailGameVM : DetailGameViewModel = DetailGameViewModel()
    fileprivate lazy var collectionView : UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: KDetailCellItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = kItemMargin/2
        layout.sectionInset = UIEdgeInsets(top: 5, left: kItemMargin/2, bottom: 0, right: kItemMargin/2)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - 系统方法
    convenience init(tag_id: String) {
        self.init(nibName: nil, bundle: nil)
        detailGameVM.tag_id = tag_id   // 这个tag_id是用作url参数用的，具体你看ViewModel的两个url分析
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "具体游戏"
        
        setUpMainView()
        setUpRefresh()
        
        if #available(iOS 9, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: self.view)
            }
        }
    }

    func setUpMainView() {
        view.addSubview(collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - loadData
extension DetailGameViewController {
    fileprivate func loadData() {
        // 1.请求数据
        detailGameVM.loadDetailGameData {  [weak self] (err) in
            // 1.1.刷新表格
            self!.collectionView.mj_header.endRefreshing()
            self!.collectionView.mj_footer.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    
    fileprivate func setUpRefresh() {
        // MARK: - 下拉
        self.collectionView.mj_header = MJRefreshGifHeader(refreshingBlock: { [weak self]() -> Void in
            self!.detailGameVM.anchorGroups.removeAll()
            self!.detailGameVM.offset = 0
            self!.loadData()
        })
        // MARK: - 上拉
        self.collectionView.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: {[weak self] () -> Void in
            self!.detailGameVM.offset += 20
            self!.loadData()
            })
        self.collectionView.mj_header.isAutomaticallyChangeAlpha = true
        self.collectionView.mj_header.beginRefreshing()
        self.collectionView.mj_footer.endRefreshingWithNoMoreData()
    }

}

// MARK: - UICollectionViewDataSource
extension DetailGameViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return detailGameVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailGameVM.anchorGroups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)  as! CollectionNormalCell
        if detailGameVM.anchorGroups.count > 0 {
            cell.anchor = detailGameVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DetailGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1.取出对应的主播信息
        let anchor = detailGameVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        
        // 2.判断是秀场房间&普通房间
        anchor.isVertical == 0 ? pushNormalRoomVc(anchor: anchor) : presentShowRoomVc(anchor: anchor)
    }
    
    fileprivate func presentShowRoomVc(anchor: AnchorModel) {
        if #available(iOS 9.0, *) {
            // 1.创建SFSafariViewController
            let safariVC = SFSafariViewController(url: URL(string: anchor.jumpUrl)!, entersReaderIfAvailable: true)
            // 2.以Modal方式弹出
            present(safariVC, animated: true, completion: nil)
        } else {
            let webVC = WKWebViewController(navigationTitle: anchor.room_name, urlStr: anchor.jumpUrl)
            present(webVC, animated: true, completion: nil)
        }
    }
    
    fileprivate func pushNormalRoomVc(anchor: AnchorModel) {
        // 1.创建WebViewController
        let webVC = WKWebViewController(navigationTitle: anchor.room_name, urlStr: anchor.jumpUrl)
        webVC.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // 2.以Push方式弹出
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension DetailGameViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        }
        
        var vc = UIViewController()
        let anchor = detailGameVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        if anchor.isVertical == 0 {
            if #available(iOS 9, *) {
                vc = SFSafariViewController(url: URL(string: anchor.jumpUrl)!, entersReaderIfAvailable: true)
            } else {
                vc = WKWebViewController(navigationTitle: anchor.room_name, urlStr: anchor.jumpUrl)
            }
        }else {
            vc = WKWebViewController(navigationTitle: anchor.room_name, urlStr: anchor.jumpUrl)
        }
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: nil)
    }
}
