//
//  QRCodeViewController.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 16/12/29.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit
import MobileCoreServices

extension Date {
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}

class QRCodeViewController: UIViewController {
    
    fileprivate lazy var isHiddenNavBar: Bool = false // 是否隐藏导航栏
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.isUserInteractionEnabled = true
        imageView.center = self.view.center
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(QRCodeViewController.longClick(longPress:))))
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QRCodeViewController.tapClick(tap:))))
        self.view.addSubview(imageView)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpMainView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let label = UILabel(frame: CGRect(x: 20, y: 80, width: 300, height: 100))
//        label.text = "我说：不知道为什么,水平菜"
//        label.sizeToFit()
//        label.frame.size.width += CGFloat(30)
//        label.frame.size.height += CGFloat(30)
//        label.layer.cornerRadius = 20
//        label.layer.masksToBounds = true
//        label.backgroundColor = UIColor(red: 0, green:  0, blue: 0, alpha: 0.5)
//        let attrStr = NSMutableAttributedString(string: label.text!)
//        attrStr.setAttributes([NSBackgroundColorAttributeName:  UIColor.red], range: NSMakeRange(0, attrStr.length))
//        attrStr.setAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSMakeRange(0, 3))
//        attrStr.setAttributes([NSForegroundColorAttributeName: UIColor.blue], range: NSMakeRange(3, 10))
//        // UIColor(red: 32, green:  43, blue: 120, alpha: 0.5)
//        
//        label.textAlignment = .center
//        label.attributedText = attrStr
//        self.view.addSubview(label)
        
        API.Common.Base.login(
            parameters: ["UserName": "admin", "UserPwd" : "techsys2015"])
            .progressTitle("heihaih>...").perform(successed: { (reslut, err) in
            print(reslut)
        }) { (err) in
            print(err)
        }
        
        
        isHiddenNavBar = !isHiddenNavBar
        UIView.animate(withDuration: 1.0) {
            self.navigationController?.setNavigationBarHidden(self.isHiddenNavBar, animated: true)
        }
    }
}


// MARK: - 设置UI
extension QRCodeViewController {
    fileprivate func setUpMainView() {
        let backBtn = UIButton(type: .custom)
        backBtn.showsTouchWhenHighlighted = true
        backBtn.setTitle("❎", for: .normal)
        backBtn.sizeToFit()
        backBtn.frame.origin = CGPoint(x: 20, y: 30)
        backBtn.addTarget(self, action: #selector(QRCodeViewController.backBtnClick), for: .touchUpInside)
        if self.navigationController == nil {
            self.view.addSubview(backBtn)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhotoFromAlbun))
        
        imageView.image = creatQRCByString(QRCStr: "itms-apps://itunes.apple.com/app/id\(appid)", QRCImage: "doushi_icony512")
    }
    
    @objc fileprivate func backBtnClick() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 扫描系统相片中二维码和录制视频
extension QRCodeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    @objc fileprivate func takePhotoFromAlbun() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in }
        let OKAction = UIAlertAction(title: "拍照", style: .default) { (action) in
            self.openCamera(.camera)
        }
        let videotapeAction = UIAlertAction(title: "录像", style: .default) { (action) in
            self.openCamera(.camera, title: "录像")
        }
        let destroyAction = UIAlertAction(title: "从相册上传", style: .default) { (action) in
            print(action)
            self.openCamera(.photoLibrary)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
        alertController.addAction(videotapeAction)
        alertController.addAction(destroyAction)
        
        // 判断是否为pad 弹出样式
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     *  打开照相机/打开相册
     */
    func openCamera(_ type: UIImagePickerControllerSourceType,title: String? = "") {
        if !UIImagePickerController.isSourceTypeAvailable(type) {
            self.showInfo(info: "Camera不可用")
            return
        }
        let ipc = UIImagePickerController()
        ipc.sourceType = type
        ipc.allowsEditing = true
        ipc.delegate = self
        
        if title == "录像" {
            ipc.videoMaximumDuration = 60 * 3
            ipc.videoQuality =  .typeIFrame1280x720
            ipc.mediaTypes = [(kUTTypeMovie as String)]
            // 可选，视频最长的录制时间，这里是20秒，默认为10分钟（600秒）
            ipc.videoMaximumDuration = 20
            // 可选，设置视频的质量，默认就是TypeMedium
            //            ipc.videoQuality = UIImagePickerControllerQualityType.typeMedium
        }
        present(ipc, animated: true,  completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        //判读是否是视频还是图片
        if mediaType == kUTTypeMovie as String {
            let moviePath = info[UIImagePickerControllerMediaURL] as? URL
            //获取路径
            let moviePathString = moviePath!.relativePath
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePathString){
                UISaveVideoAtPathToSavedPhotosAlbum(moviePathString, self, #selector(QRCodeViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            print("视频")
        } else {
            print("图片")
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imageView.image = image
            getQRCodeInfo(image: image!)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
        guard error == nil else{
            self.showMessage(info: "保存视频失败")
            return
        }
        self.showMessage(info: "保存视频成功")
    }
}

// MARK: - 生成二维码和手势点击
extension QRCodeViewController {
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
            // 恢复滤镜的默认属性
            filter.setDefaults()
            filter.setValue(stringData, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = filter.outputImage
            
            // 创建一个颜色滤镜,黑白色
            guard let colorFilter = CIFilter(name: "CIFalseColor")  else { return nil }
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            
//            let r = CGFloat(arc4random_uniform(256))/255.0
//            let g = CGFloat(arc4random_uniform(256))/255.0
//            let b = CGFloat(arc4random_uniform(256))/255.0
            let r: CGFloat = 0.20
            let g: CGFloat = 0.30
            let b: CGFloat = 0.90
            
            colorFilter.setValue(CIColor(red: r, green: g, blue: b), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: b, green: g, blue: r), forKey: "inputColor1")
            
            let codeImage = UIImage(ciImage: (colorFilter.outputImage!
                .applying(CGAffineTransform(scaleX: 5, y: 5))))
            
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let QRCImage = UIImage(named: QRCImage!) {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                
                // 开启上下文
                let context = UIGraphicsGetCurrentContext()
                UIGraphicsBeginImageContextWithOptions(rect.size, true, 1.0)
                codeImage.draw(in: rect)
                let iconSize = CGSize(width: codeImage.size.width*0.25, height: codeImage.size.height*0.25)
                let iconOrigin = CGPoint(x: (codeImage.size.width-iconSize.width)/2, y: (codeImage.size.height-iconSize.height)/2)
                QRCImage.draw(in: CGRect(origin: iconOrigin, size: iconSize))
                guard let resultImage =  UIGraphicsGetImageFromCurrentImageContext() else { return nil }
                context?.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                context?.addEllipse(in: rect)
                context?.drawPath(using: CGPathDrawingMode.fill)
                
                // 结束上下文
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
    
    @objc fileprivate func longClick(longPress: UILongPressGestureRecognizer) {
        showAlertVc(ges: longPress)
    }
    @objc fileprivate func tapClick(tap: UITapGestureRecognizer) {
        showAlertVc(ges: tap)
    }
    fileprivate func showAlertVc(ges: UIGestureRecognizer) {
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let qrcAction = UIAlertAction(title: "保存图片", style: .default) { (action) in
            self.saveImage()
        }
        let saveAction = UIAlertAction(title: "识别图中二维码", style: .default) {[unowned self] (action) in
            self.getQRCodeInfo(image: self.imageView.image!)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertVc.addAction(qrcAction)
        alertVc.addAction(saveAction)
        alertVc.addAction(cancelAction)
        
        // 判断是否为pad 弹出样式
        if let popPresenter = alertVc.popoverPresentationController {
            popPresenter.sourceView = ges.view;
            popPresenter.sourceRect = (ges.view?.bounds)!
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    /// 取得图片中的信息
    fileprivate func getQRCodeInfo(image: UIImage) {
        // 1.创建扫描器
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)  else { return }
        
        // 2.扫描结果
        guard let ciImage = CIImage(image: image) else { return }
        let features = detector.features(in: ciImage)
        
        // 3.遍历扫描结果
        for f in features {
            guard let feature = f as? CIQRCodeFeature else { return }
            if (feature.messageString?.isEmpty)! {
                return
            }
            // 如果是网址就跳转
            if feature.messageString!.contains("http://") || feature.messageString!.contains("https://") || feature.messageString!.contains("apps://") {
                let url = URL(string: feature.messageString!)
                if  UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            } else {  // 其他信息 弹框显示
                self.showInfo(info: feature.messageString!)
            }
        }
    }
    
    fileprivate func saveImage() {
        //        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        // 将图片保存到相册中
        // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(QRCodeViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    // MARK:- 保存图片的方法
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
        guard error == nil else{
            self.showMessage(info: "保存图片失败")
            return
        }
        self.showMessage(info: "保存图片成功")
    }
    
    
    fileprivate func showMessage(info: String) {
        let alertView = UIAlertView(title: nil, message: info, delegate: nil, cancelButtonTitle: "好的")
        alertView.show()
    }
}

// MARK: - 生成条形码
extension QRCodeViewController {
    /// 生成一张条形码方法
    /**
     - parameter QRCStr：网址URL
     - parameter QRCImage：图片名称
     */
    fileprivate func barCodeImageWithInfo(info: String?) -> UIImage? {
        // 创建条形码
        // 创建一个二维码滤镜
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
        
        // 恢复滤镜的默认属性
        filter.setDefaults()
        // 将字符串转换成NSData
        let data = info?.data(using: .utf8)
        // 通过KVO设置滤镜inputMessage数据
        filter.setValue(data, forKey: "inputMessage")
        
        // 获得滤镜输出的图像
        let outputImage =  filter.outputImage
        // 将CIImage 转换为UIImage
        let image = UIImage(cgImage: outputImage as! CGImage)
        
        // 如果需要将image转NSData保存，则得用下面的方式先转换为CGImage,否则NSData 会为nil
        //    CIContext *context = [CIContext contextWithOptions:nil];
        //    CGImageRef imageRef = [context createCGImage:outputImage fromRect:outputImage.extent];
        //
        //    UIImage *image = [UIImage imageWithCGImage:imageRef];
        
        return image
    }
}


func resizeQRCodeImage(_ image: CIImage, withSize size: CGFloat) -> UIImage {
    let extent = image.extent.integral
    let scale = min(size / extent.width, size / extent.height)
    let width = extent.width*scale
    let height = extent.height*scale
    let colorSpaceRef: CGColorSpace? = CGColorSpaceCreateDeviceGray()
    let contextRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpaceRef!, bitmapInfo: CGBitmapInfo.init(rawValue: 0).rawValue)
    let context = CIContext(options: nil)
    let imageRef: CGImage = context.createCGImage(image, from: extent)!
    contextRef!.interpolationQuality = CGInterpolationQuality.init(rawValue: 0)!
    contextRef?.scaleBy(x: scale, y: scale)
    contextRef?.draw(imageRef, in: extent)
    let imageRefResized: CGImage = contextRef!.makeImage()!
    return UIImage(cgImage: imageRefResized)
}
