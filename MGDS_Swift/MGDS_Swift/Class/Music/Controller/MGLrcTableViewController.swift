//
//  MGLrcTableViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

private let KLrcCellID = "KLrcCellID"

class MGLrcTableViewController: UITableViewController {
    // 提供歌词数组模型
    var lrcMs: [MGLrcModel] = [MGLrcModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    // 行号
    var scrollRow: NSInteger = 0 {
        willSet {
            tempscrollRow = scrollRow
        }
        didSet {
            if tempscrollRow == scrollRow { return }  // 同一行就直接返回
            // 根据行号获取当前是第几组第几行
            let indexPtah = IndexPath(row: scrollRow, section: 0)
            
            // 刷新你当前可见的cell
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .automatic)
            
            // 滚动到当前所在行
            tableView.scrollToRow(at: indexPtah, at: .middle, animated: true)
        }
    }
    /** 歌词进度 */
    var progress: Double = 0.0 {
        didSet {
            let indexPtah = IndexPath(row: self.scrollRow, section: 0)
            let cell = tableView.cellForRow(at: indexPtah) as? MGLrcCell
            cell?.progress = progress
        }
    }
    fileprivate var tempscrollRow: NSInteger = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MGLrcCell.self, forCellReuseIdentifier: KLrcCellID)
        tableView.isUserInteractionEnabled = true
        // 设置背景颜色
        self.tableView.backgroundColor = UIColor.clear
        
        // 去掉下划线(分割线)
        self.tableView.separatorStyle = .none
        
        // 设置模式--居中显示
        self.tableView.contentMode = UIViewContentMode.center
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 设置额外的滚动区域
        self.tableView.contentInset = UIEdgeInsets(top: tableView.mg_height*0.5, left: 0, bottom: tableView.mg_height*0.5, right: 0)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrcMs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MGLrcCell.cellWithTableView(tableView: tableView, reuseIdentifier: KLrcCellID, indexPath: indexPath)
        
        // 2.给cell赋数据
        // 2.1取得模型
        let lrcM = self.lrcMs[indexPath.row]
        // 2.2赋值歌词
        cell.lrcText = lrcM.lrcText

        if (indexPath.row == self.scrollRow) {
            cell.progress = self.progress
        } else {
            cell.progress = 0.0
        }
        return cell
    }
}
