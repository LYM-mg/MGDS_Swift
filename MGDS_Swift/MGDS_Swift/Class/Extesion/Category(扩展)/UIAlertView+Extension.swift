//
//  UIAlertView+Extension.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 17/3/22.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

fileprivate var dismissBlock: ((_ buttonIndex: NSInteger)->())?
fileprivate var cancelBlock: (()->())?
extension UIAlertView: UIAlertViewDelegate {
    convenience init(title: String?,message: String?,cancleTitle: String,otherButtonTitle: [String]?, onDismissBlock:((_ buttonIndex: NSInteger) -> Swift.Void)? = nil,onCancleBlock:(() -> Swift.Void)? = nil){
        self.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancleTitle)
        self.delegate = self
        if (onDismissBlock != nil)  {
            dismissBlock = onDismissBlock
        }
        
        if (onCancleBlock != nil) {
            cancelBlock = onCancleBlock
        }
        
        if otherButtonTitle != nil {
            for buttonTitle in otherButtonTitle! {
                self.addButton(withTitle: buttonTitle)
            }
        }
        
        self.show()
        /*
        var count: Int = 0
        for view in self.subviews where view is UILabel{
            count += 1
            if count == 2 {
                // 仅对message左对齐
                let label: UILabel? = (view as? UILabel)
                label?.textAlignment = .left
            }
        }
        */
    }
    
    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            if ((cancelBlock) != nil) {
                cancelBlock!()
            }
        } else{
            if ((dismissBlock) != nil) {
                dismissBlock!(buttonIndex);
            }
        }
    }
}
