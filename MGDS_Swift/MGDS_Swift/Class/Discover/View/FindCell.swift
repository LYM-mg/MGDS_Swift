//
//  FindCell.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/5.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

private let KFindAnchorCellID = "KFindAnchorCellID"

class FindCell: UITableViewCell {
    fileprivate lazy var collectionView : UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        let itemMargin : CGFloat = 10
        let itemW: CGFloat = (MGScreenW - 5 * itemMargin) / 3
        let itemH: CGFloat = 200
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = itemMargin
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemMargin, bottom: 0, right: itemMargin)
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: "FindAnchorCell", bundle: nil), forCellWithReuseIdentifier: KFindAnchorCellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    var cellDidSelected : ((_ anchor : MoreModel) -> ())?
    var anchorArray:  [MoreModel]?
    var currentIndex: Int = 0

    var anchorData: [MoreModel]? {
        didSet {
            if ((self.currentIndex + 1) * 9 < ((anchorData?.count)! - 1)) {
                self.anchorArray = Array(anchorData![self.currentIndex * 9..<(self.currentIndex + 1) * 9])
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(collectionView)
        MGNotificationCenter.addObserver(self, selector: #selector(change), name: NSNotification.Name(KChangeanchorNotification), object: nil)
    }
    
    @objc fileprivate func change() {
        self.currentIndex += 1
        if !((self.currentIndex + 1) * 9 < ((anchorData?.count)! - 1)) {
            self.currentIndex = 0
        }
        self.anchorArray?.removeAll()
        self.anchorArray = Array(anchorData![self.currentIndex * 9..<(self.currentIndex + 1) * 9])
        self.collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FindCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anchorArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KFindAnchorCellID, for: indexPath) as! FindAnchorCell
        cell.anchor = anchorArray![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cellDidSelected = cellDidSelected {
            cellDidSelected(anchorArray![indexPath.item])
        }
    }
}

