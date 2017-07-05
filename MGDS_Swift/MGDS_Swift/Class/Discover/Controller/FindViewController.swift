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
    
    fileprivate lazy var findHeaderView: LivekyCycleHeader = {[unowned self] in
        let hdcView = LivekyCycleHeader(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: MGScreenW*190/338))
        hdcView.type = self.topicType == .top ? .top : .search
        // 图片轮播器点击回调
        hdcView.imageClickBlock = { [unowned self] (cycleHeaderModel) in
            let webViewVc = WebViewController(navigationTitle: cycleHeaderModel.title, urlStr: cycleHeaderModel.url!)
            self.show(webViewVc, sender: nil)
        }
        return hdcView
    }()
    // MARK: - 懒加载属性
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tb.dataSource = self
        tb.delegate = self
        tb.isHidden = true
        tb.rowHeight = 60
        tb.tableFooterView = UIView()
        //        tb.estimatedRowHeight = 60  // 设置估算高度
        //        tb.rowHeight = UITableViewAutomaticDimension // 告诉tableView我们cell的高度是自动的
        tb.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tb.register(FindCell.self, forCellReuseIdentifier: KFindCellID)
        return tb
    }()



    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - setUpMainView
extension FindViewController {
    fileprivate func setUpMainView() {
        view.addSubview(tableView)
        tableView.tableHeaderView = findHeaderView
        setupFooterView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "惊喜", style: .plain, target: self, action: #selector(rightClick))
    }
    
    @objc fileprivate func rightClick() {
        let discoverVC = DiscoverViewController()
        self.show(discoverVC, sender: nil)
    }
    
    fileprivate func setupFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 80))
        
        let btn = UIButton(frame: CGRect.zero)
        btn.frame.size = CGSize(width: kScreenW * 0.5, height: 40)
        btn.center = CGPoint(x: kScreenW * 0.5, y: 40)
        btn.setTitle("换一换", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        headerLabel.textAlignment = .center
        headerLabel.text = "猜你喜欢"
        headerLabel.textColor = UIColor.orange
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor.white
        return headerView
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension FindViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KFindCellID, for: indexPath) as? FindCell
        cell?.textLabel?.text = "21313"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupSectionHeaderView()
    }
}
