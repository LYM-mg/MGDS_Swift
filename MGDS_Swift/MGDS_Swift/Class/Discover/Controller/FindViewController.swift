//
//  FindViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

private let KFindCellID = "KFindCellID"

class FindViewController: UIViewController {
    // MARK: - 懒加载属性
    fileprivate lazy var findHeaderView: LivekyCycleHeader = {[unowned self] in
        let hdcView = LivekyCycleHeader(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: MGScreenW/2.5),type: .find)
        // 图片轮播器点击回调
        hdcView.carouselsClickBlock = { [unowned self] (carouselModel) in
            if (carouselModel.linkUrl != nil) {
                let webViewVc = WebViewController(navigationTitle: carouselModel.name, urlStr: carouselModel.linkUrl)
                self.show(webViewVc, sender: nil)
            }
        }
        return hdcView
    }()
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tb = UITableView(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tb.dataSource = self
        tb.delegate = self
//        tb.estimatedRowHeight = 60  // 设置估算高度
//        tb.rowHeight = UITableViewAutomaticDimension // 告诉tableView我们cell的高度是自动的
        tb.register(FindCell.self, forCellReuseIdentifier: KFindCellID)
        return tb
    }()
    fileprivate lazy var findVM: FindViewModel = FindViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMainView()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

// MARK: - setUpMainView
extension FindViewController {
    fileprivate func setUpMainView() {
        view.addSubview(tableView)
        tableView.tableHeaderView = findHeaderView
        setupFooterView()
        
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "惊喜", style: .plain, target: self, action: #selector(rightClick))
    }
    
    fileprivate func setupFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: 80))
        
        let btn = UIButton(frame: CGRect.zero)
        btn.frame.size = CGSize(width: MGScreenW * 0.5, height: 40)
        btn.center = CGPoint(x: MGScreenW * 0.5, y: 40)
        btn.setTitle("换一换", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(changeAnchor), for: .touchUpInside)
        
        footerView.addSubview(btn)
        footerView.backgroundColor = UIColor(r: 250, g: 250, b: 250)
        tableView.tableFooterView = footerView
    }
    
    fileprivate func setupSectionHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: 40))
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: 40))
        headerLabel.textAlignment = .center
        headerLabel.text = "猜你喜欢"
        headerLabel.textColor = UIColor.orange
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    
    @objc fileprivate func rightClick() {
        let discoverVC = DiscoverViewController()
        self.show(discoverVC, sender: nil)
    }
    
    @objc fileprivate func changeAnchor() {
       MGNotificationCenter.post(name: NSNotification.Name(KChangeanchorNotification), object: nil, userInfo: nil)
    }
}

// MARK: - 加载数据
extension FindViewController {
    func loadData() {
        findVM.loadContentData { (err) in
            if err == nil {
                self.tableView.reloadData()
            }else {
                self.showHint(hint: "网络请求失败\(err)")
            }
        }
    }

}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension FindViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findVM.anchorModels.count > 0 ? 1:0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KFindCellID, for: indexPath) as? FindCell
        cell?.anchorData = findVM.anchorModels
        cell?.cellDidSelected = { (anchor) in
            let liveVc = RoomViewController(anchor:anchor)
            self.navigationController?.pushViewController(liveVc, animated: true)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupSectionHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200*3
    }
}
