//
//  SaveTools.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/28.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

class SaveTools: NSObject {

    // MARK: - UserDefaults
    // 存储
    class func mg_SaveToLocal(value: Any, key: String?) {
        UserDefaults.standard.set(value, forKey: key!)
        UserDefaults.standard.synchronize()
    }
    
    
    // 读取
    class func mg_getLocalData(key: String) -> Any {
       return UserDefaults.standard.value(forKey: key)
    }
    
    class func mg_removeLocalData(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// 删除NSUserDefaults所有记录
    class func mg_removeAllDataByUserDefaults() {
        // 方法一
        guard let appDomain = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
//        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
    
    
    // MARK: - NSKeyedArchiver
    // 存储
    class func mg_Archiver(_ object: Any, path: String) {
        NSKeyedArchiver.archiveRootObject(object, toFile: path)
    }
    
    // 读取
    class func mg_UnArchiver(path: String) -> Any{
        return NSKeyedUnarchiver.unarchiveObject(withFile: path)
    }
}


/*
 
 //                let userAccountPath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!)/userAccount.plist"
 //                NSKeyedArchiver.archiveRootObject(self.userVM.userModel!, toFile: userAccountPath)
 
 
 
 //        // 1.1.获取命名空间的名称
 //        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
 //            print("没有找到命名空间")
 //            return
 //        }
 //
 //        // 1.2.通过完整的字符串找到对应的Class
 //        guard let AnyClass = NSClassFromString("\(nameSpace)." + childVcName) else {
 //            XMGLog("没有找到对应的类")
 //            return
 //        }
 */
