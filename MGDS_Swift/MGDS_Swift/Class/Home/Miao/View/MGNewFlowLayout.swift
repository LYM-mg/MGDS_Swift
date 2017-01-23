//
//  MGNewFlowLayout.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGNewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        let margin: CGFloat = 2
        self.scrollDirection = UICollectionViewScrollDirection.vertical
        let wh = (MGScreenW - 2*margin) / 3.0
        self.itemSize = CGSize(width: wh, height: wh)
        self.minimumLineSpacing = margin
        self.minimumInteritemSpacing = margin
        
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.alwaysBounceVertical = true
    }
}
