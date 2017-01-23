//
//  VideoTableViewController.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

private let KVideoCellID = "KVideoCellID"

class VideoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: KVideoCellID)
    }
}

// MARK: - Table view data source
extension VideoTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KVideoCellID, for: indexPath) as? VideoCell
        
        return cell!
    }

}
