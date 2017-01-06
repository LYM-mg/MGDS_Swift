//
//  QRCodeViewController.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 16/12/29.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMainView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let label = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 100))
        label.text = "我说：不知道为什么,水平菜"
        label.sizeToFit()
        label.frame.size.width += CGFloat(30)
        label.frame.size.height += CGFloat(30)
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(red: 0, green:  0, blue: 0, alpha: 0.5)
        let attrStr = NSMutableAttributedString(string: label.text!)
        attrStr.setAttributes([NSBackgroundColorAttributeName:  UIColor.red], range: NSMakeRange(0, attrStr.length))
        attrStr.setAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSMakeRange(0, 3))
        attrStr.setAttributes([NSForegroundColorAttributeName: UIColor.blue], range: NSMakeRange(3, 10))
        // UIColor(red: 32, green:  43, blue: 120, alpha: 0.5)
       
        label.textAlignment = .center
        label.attributedText = attrStr
        self.view.addSubview(label)
    }
}

extension Date {
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}


// MARK: - 设置UI
extension QRCodeViewController {
    fileprivate func setUpMainView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.center = self.view.center
        imageView.image = creatQRCByString(QRCStr: "http://www.jianshu.com/writer#/notebooks/2919817/notes/5502741", QRCImage: "doushi_icony512")
        self.view.addSubview(imageView)
    }
    
    /// 生成一张二维码图片
    /**
       - parameter QRCStr：网址URL
       - parameter QRCImage：图片名称
     */
    fileprivate func creatQRCByString(QRCStr: String?, QRCImage: String?) -> UIImage? {
        if let QRCStr = QRCStr {
            let stringData = QRCStr.data(using: .utf8, allowLossyConversion: false)
            
            // 创建一个二维码滤镜
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
            filter.setValue(stringData, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = filter.outputImage
            // 创建一个颜色滤镜,黑白色
            guard let colorFilter = CIFilter(name: "CIFalseColor")  else { return nil }
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            
            let r = CGFloat(arc4random_uniform(256))/255.0
            let g = CGFloat(arc4random_uniform(256))/255.0
            let b = CGFloat(arc4random_uniform(256))/255.0
            
            colorFilter.setValue(CIColor(red: r, green: g, blue: b), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: b, green: g, blue: r), forKey: "inputColor1")
           
            let codeImage = UIImage(ciImage: (colorFilter.outputImage!
                .applying(CGAffineTransform(scaleX: 5, y: 5))))

            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let QRCImage = UIImage(named: QRCImage!) {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                // 开启上下文
                UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
                codeImage.draw(in: rect)
                let iconSize = CGSize(width: codeImage.size.width*0.25, height: codeImage.size.height*0.25)
                let iconOrigin = CGPoint(x: (codeImage.size.width-iconSize.width)/2, y: (codeImage.size.height-iconSize.height)/2)
                QRCImage.draw(in: CGRect(origin: iconOrigin, size: iconSize))
                guard let resultImage =  UIGraphicsGetImageFromCurrentImageContext() else { return nil }
                
                // 结束上下文
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
}
