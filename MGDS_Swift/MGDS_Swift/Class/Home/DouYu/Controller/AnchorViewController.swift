//
//  AnchorViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/2/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MJRefresh
import SafariServices


let kItemMargin: CGFloat = 10
let kHeaderViewH: CGFloat = 50


let kCycleViewH = MGScreenW * 3 / 8
let kGameViewH: CGFloat = 90

let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"

let kPrettyCellID = "kPrettyCellID"
let kNormalItemW = (MGScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 3
let kPrettyItemH = kNormalItemW * 4 / 3

class AnchorViewController: UIViewController {
    var headerIndexPath: IndexPath?
    // MARK: 定义属性
    lazy var anchorVM: AnchorViewModel = AnchorViewModel()
    lazy var collectionView: UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: MGScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    // MARK:- 懒加载属性
    fileprivate lazy var cycleView : RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: MGScreenW, height: kCycleViewH)
        return cycleView
    }()
    fileprivate lazy var gameView : RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: MGScreenW, height: kGameViewH)
        return gameView
    }()
    
    // MARK: 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        loadData()
        setUpRefresh()
        
        if #available(iOS 9, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: self.view)
            }
        }
    }
}

// MARK:- 设置UI界面
extension AnchorViewController {
    func setupUI() {
        // 1.添加collectionView
        view.addSubview(collectionView)
        
        // 2.将CycleView添加到UICollectionView中
        collectionView.addSubview(cycleView)
        
        // 3.将gameView添加collectionView中
        collectionView.addSubview(gameView)
        
        // 4.设置collectionView的内边距 -MGNavHeight
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
    }
}

// MARK:- 请求数据
extension AnchorViewController {
    fileprivate func setUpRefresh() {
        weak var weakSelf = self
        // 头部刷新
        self.collectionView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            let strongSelf = weakSelf
            strongSelf?.anchorVM.anchorGroups.removeAll()
            strongSelf?.anchorVM.bigDataGroup.anchors.removeAll()
            strongSelf?.anchorVM.prettyGroup.anchors.removeAll()
            strongSelf?.anchorVM.cycleModels.removeAll()
            strongSelf?.loadData()
        })
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        collectionView.mj_header.ignoredScrollViewContentInsetTop = kCycleViewH + kGameViewH
        collectionView.mj_header.isAutomaticallyChangeAlpha = true
        self.collectionView.mj_header.beginRefreshing()
    }

    
    fileprivate func loadData() {
        // 1.请求推荐数据
        anchorVM.requestData {[unowned self] (err) in
            if err != nil {
                self.showHint(hint: "网络请求失败")
                self.collectionView.mj_header.endRefreshing()
                return
            }
            // 1.展示推荐数据
            self.collectionView.reloadData()
            
            // 2.将数据传递给GameView
            var groups = self.anchorVM.anchorGroups
            
            // 2.1.移除前两组数据
            if groups.count > 2 {
                // 2.1.移除前两组数据
                groups.removeFirst()
                groups.removeFirst()
            }
            
            // 2.2.添加更多组
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)
            
            self.gameView.groups = groups
            self.collectionView.mj_header.endRefreshing()
        }
        
        // 2.请求轮播数据
        anchorVM.requestCycleData { [unowned self] (err) in
            if err != nil {
                return
            }
            self.cycleView.cycleModels = self.anchorVM.cycleModels
        }
    }
}



// MARK:- 遵守UICollectionView的数据源
extension AnchorViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return anchorVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anchorVM.anchorGroups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            // 1.取出Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
            
            // 2.给cell设置数据
            cell.anchor = anchorVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            
            return cell
        }else {
            let prettyCell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell

            prettyCell.anchor = anchorVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            
            return prettyCell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        // 2.给HeaderView设置数据
        headerView.group = anchorVM.anchorGroups[indexPath.section]
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AnchorViewController.headerClick(_:))))
        headerIndexPath = indexPath
        return headerView
    }
    
    @objc fileprivate func headerClick(_ tap: UITapGestureRecognizer) {
        switch headerIndexPath!.section {
            case 0:
                let webVC = WebViewController(navigationTitle: "主机游戏", urlStr: "http://www.douyu.com/directory/game/TVgame")
                navigationController?.pushViewController(webVC, animated: true)
            case 1:
                let webVC = WebViewController(navigationTitle: "美颜", urlStr: "http://www.douyu.com/directory/game/yz")
                navigationController?.pushViewController(webVC, animated: true)
            default:
                let model = anchorVM.anchorGroups[headerIndexPath!.section]
                self.show(HeaderViewDetailController(model: model), sender: self)
        }

//        var url = ""
//        var title = ""
//        switch headerIndexPath!.section {
//            case 0:
//                url = "http://www.douyu.com/directory/game/TVgame"
//                title = "主机游戏"
//            case 1:
//                url = "http://www.douyu.com/directory/game/yz"
//                title = "美颜"
//            case 2:
//                url = "http://www.douyu.com/directory/game/outdoor"
//                title = "户外"
//            case 3:
//                url = "http://www.douyu.com/directory/game/LOL"
//                title = "英雄联盟"
//            case 4:
//                 url = "http://www.douyu.com/directory/game/mhxy"
//                title = "梦幻西游手游"
//            case 5:
//                url = "http://www.douyu.com/directory/game/How"
//                title = "炉石传说"
//            case 6:
//                 url = "http://www.douyu.com/directory/game/wzry"
//                 title = "王者荣耀"
//            default:
//                url = "http://www.douyu.com/directory/game/yz"
//                title = "美颜"
//        }
//        
//        let webVC = WebViewController(navigationTitle: title, urlStr: url)
//        navigationController?.pushViewController(webVC, animated: true)
    }
}


// MARK:- 遵守UICollectionView的代理协议
extension AnchorViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1.取出对应的主播信息
        let anchor = anchorVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        // 2.判断是秀场房间&普通房间
        anchor.isVertical == 0 ? pushNormalRoomVc(anchor: anchor) : presentShowRoomVc(anchor: anchor)
    }
    
    fileprivate func presentShowRoomVc(anchor: AnchorModel) {
        // 1.创建SFSafariViewController
        if #available(iOS 9.0, *) {
            let safariVC = SFSafariViewController(url: URL(string: anchor.jumpUrl)!, entersReaderIfAvailable: true)
            // 2.以Modal方式弹出
            present(safariVC, animated: true, completion: nil)
        } else {
            let webVC = WebViewController(navigationTitle: anchor.room_name, urlStr: anchor.jumpUrl)
            // 2.以Modal方式弹出
            present(webVC, animated: true, completion: nil)
        }
    }
    
    fileprivate func pushNormalRoomVc(anchor: AnchorModel) {
        // 1.创建WebViewController
        let webVC = WebViewController(navigationTitle: anchor.room_name, urlStr: anchor.jumpUrl)
        webVC.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // 2.以Push方式弹出
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK:- 遵守UICollectionViewDelegateFlowLayout的代理协议
extension AnchorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kNormalItemW, height: kNormalItemH)
    }
}

// MARK: - peek和pop
// MARK: - UIViewControllerPreviewingDelegate
extension AnchorViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        }
        
        var vc = UIViewController()
        let anchor = anchorVM.anchorGroups[indexPath.section].anchors[indexPath.item]
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


