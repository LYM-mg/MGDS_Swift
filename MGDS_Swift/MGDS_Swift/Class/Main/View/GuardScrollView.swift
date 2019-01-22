//
//  GuardScrollView.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/2/9.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class GuardScrollView: UIView {
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: MGScreenW*5, height: MGScreenH)
        return scrollView
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.mg_center = CGPoint(x: MGScreenW*0.5, y: MGScreenH-44)
        pageControl.numberOfPages = 5
        pageControl.setValue(UIImage(named: "current"), forKey: "_currentPageImage")
        pageControl.setValue(UIImage(named: "other"), forKey: "_pageImage")
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GuardScrollView {
    fileprivate func setUpUI() {
        for i in stride(from: 0, to: 5, by: 1) {
            let imageV = UIImageView(frame: CGRect(x: MGScreenW*CGFloat(i), y: 0, width: MGScreenW, height: MGScreenH))
            
            imageV.image = UIImage(named: String(format: "GuardImage%02i", arguments: [i]))
            scrollView.addSubview(imageV)
            
            if(i == 4) {
//                let x = MGScreenW/2+MGScreenW*4-187/4
//                let deformationBtn  = DeformationButton(frame: CGRect(x: x, y:MGScreenH/2+100, width:  187/2, height:  187/2))
                let x = MGScreenW/2-187/4
                let deformationBtn  = DeformationButton(frame: CGRect(x: x, y:MGScreenH/2+100, width:  187/2, height:  187/2))
                deformationBtn.contentColor  =  UIColor.clear
                deformationBtn.progressColor  = UIColor(r: 126, g: 235, b: 251)
                deformationBtn.forDisplayButton.setImage(UIImage(named: "按前")!, for: .normal)
                let bgImage  = UIImage(named: "按前")!
                deformationBtn.forDisplayButton.setBackgroundImage(bgImage, for: .normal)
                deformationBtn.addTarget(self, action: #selector(GuardScrollView.EnterApp(sender:)), for: .touchUpInside)
                imageV.addSubview(deformationBtn)
                imageV.isUserInteractionEnabled = true
            }
        }
        self.addSubview(scrollView)
        self.addSubview(pageControl)
    }
    
    // 先进入App引导界面，通过点击按钮进入主界面
    @objc fileprivate func EnterApp(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        NotificationCenter.default.post(name: NSNotification.Name(KEnterHomeViewNotification), object: nil, userInfo: ["sender": sender])
    }
}

extension GuardScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        // 2.计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (5)
    }
}
