//
//  MGWaterFlowLayout.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/1/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

// MARK: - 协议
@objc
protocol MGWaterFlowLayoutDelegate: NSObjectProtocol {
    @objc optional func waterflowLayout(waterflowLayout: MGWaterFlowLayout,heightForItemAtIndex indexPath: IndexPath,itemWidth: CGFloat) -> CGFloat
   
    @objc optional  func columnCountInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> Int
    @objc optional  func columnMarginInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> CGFloat
    @objc optional  func rowMarginInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> CGFloat
    @objc optional  func edgeInsetsInWaterflowLayout(waterflowLayout: MGWaterFlowLayout) -> UIEdgeInsets
    
    @objc optional func layoutCollectionView(collectionView: UICollectionView,layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath)
}


// MARK: - 默认参数
/** 默认的列数 */
private let MGDefaultColumnCount: Int = 3
/** 每一列之间的间距 */
private let MGDefaultColumnMargin: CGFloat = 10
/** 每一行之间的间距 */
private let MGDefaultRowMargin: CGFloat = 10
/** 边缘间距 */
private let MGDefaultEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)


class MGWaterFlowLayout: UICollectionViewFlowLayout {
    // MARK: - 自定义属性
    /** 存放所有cell的布局属性 */
    fileprivate var attrsArray = [UICollectionViewLayoutAttributes]()
    /** 存放所有列的当前高度 */
    fileprivate var columnHeights: [CGFloat] = [CGFloat]()
    /** MGWaterFlowLayout的代理 */
    weak var delegate: MGWaterFlowLayoutDelegate?

}

// MARK: - 边距和距离等
extension MGWaterFlowLayout {
    func rowMargin() -> CGFloat {
        if (self.delegate?.responds(to: #selector(MGWaterFlowLayoutDelegate.rowMarginInWaterflowLayout(waterflowLayout:))))! {
            return (delegate?.rowMarginInWaterflowLayout!(waterflowLayout: self))!
        }else {
            return MGDefaultRowMargin
        }
    }
    
    func columnMargin() -> CGFloat {
        if (self.delegate?.responds(to: #selector(MGWaterFlowLayoutDelegate.columnMarginInWaterflowLayout(waterflowLayout:))))! {
            return (delegate?.columnMarginInWaterflowLayout!(waterflowLayout: self))!
        }else {
            return MGDefaultColumnMargin
        }
    }
    
    func columnCount() -> Int {
        if (self.delegate?.responds(to: #selector(MGWaterFlowLayoutDelegate.columnCountInWaterflowLayout(waterflowLayout:))))! {
            return (delegate?.columnCountInWaterflowLayout!(waterflowLayout: self))!
        }else {
            return MGDefaultColumnCount
        }
    }
    
    func edgeInsets() -> UIEdgeInsets {
        if (self.delegate?.responds(to: #selector(MGWaterFlowLayoutDelegate.edgeInsetsInWaterflowLayout(waterflowLayout:))))! {
            return (delegate?.edgeInsetsInWaterflowLayout!(waterflowLayout: self))!
        }else {
            return MGDefaultEdgeInsets
        }
    }
}

// MARK: - 系统方法
extension MGWaterFlowLayout {
    override func prepare() {
        super.prepare()
        columnHeights.removeAll()
        
        for _ in 0..<self.columnCount() {
            self.columnHeights.append(self.edgeInsets().top)
        }
        
        // 清除之前所有的布局属性
        attrsArray.removeAll()
        
        // 1.获取cell的个数
       let count = (collectionView?.numberOfItems(inSection: 0))! as Int
        
        // 2.遍历cell，把每一个布局添加到数组
        for i in 0..<count {
            let indexPath = IndexPath(item: i, section: 0)
            let attrs = self.layoutAttributesForItem(at: indexPath)
            attrsArray.append(attrs!)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        // 创建布局属性
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        var x,y,w,h :CGFloat
        
        w = (self.collectionView!.frame.size.width - self.edgeInsets().left - self.edgeInsets().right - (CGFloat(self.columnCount()-1) * self.columnMargin())) / CGFloat(self.columnCount())
        
        // 通过代理可以设置高度
        if (self.delegate?.responds(to: #selector(MGWaterFlowLayoutDelegate.waterflowLayout(waterflowLayout:heightForItemAtIndex:itemWidth:))))! {
            h = self.delegate!.waterflowLayout!(waterflowLayout: self, heightForItemAtIndex: indexPath, itemWidth: w)
        }else {
            h = CGFloat(70) + CGFloat(arc4random_uniform(100))
        }
        
        
        // 取得所有列中高度最短的列
        let minHeightColumn = self.minHeightColumn()
        
        x = self.edgeInsets().left + CGFloat(minHeightColumn) * (w + self.columnMargin());
        
        y = self.edgeInsets().top + self.columnHeights[minHeightColumn] + self.rowMargin()
        
        // #warning 更改最短的一列
        self.columnHeights[minHeightColumn] = y + h
        
        attrs.frame = CGRect(x: x, y: y, width: w, height: h)
        
        return attrs;
    }
    
    /**
     * 决定cell的排布
     * 第一次显示时会调用一次
     * 用力拖拽时也会调一次
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        return self.attrsArray
    }
    
    /// 返回collectionView的滚动范围
    override var collectionViewContentSize: CGSize {
        let _ = super.collectionViewContentSize
        if (self.columnHeights.count == 0) {
            return CGSize.zero
        }
        
        // 获得最高的列
        let maxColum = self.maxHeightColumn()
        
        let height: CGFloat = self.columnHeights[maxColum] + MGDefaultEdgeInsets.bottom;
        let width: CGFloat = self.collectionView!.frame.size.width;
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - 自定义方法
extension MGWaterFlowLayout {
    /// 取得所有列中高度最短的列
    fileprivate func minHeightColumn() -> Int {
        // 找出columnHeights的最小值
        var minHeightColum: Int = 0
        var minColumHeight: CGFloat = self.columnHeights[0]
        
        for i in 1..<columnHeights.count {
            let tempHeight:CGFloat = self.columnHeights[i]
        
            if (tempHeight < minColumHeight) {
                minHeightColum = i;
                minColumHeight = tempHeight;
            }
        }
        return minHeightColum
    }
    
    /// 取得所有列中高度最高的列
   fileprivate func maxHeightColumn() -> Int {
        // 找出columnHeights的最高值
        var maxHeightColumn: Int = 0
        var maxColumnHeight: CGFloat = self.columnHeights[0]
        
        for i in 1..<columnHeights.count {
            let tempHeight:CGFloat = self.columnHeights[i]
            
            if (tempHeight < maxColumnHeight) {
                maxHeightColumn = i
                maxColumnHeight = tempHeight
            }
        }
        return maxHeightColumn
    }
}
