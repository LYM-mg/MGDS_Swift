//
//  MGHelpTools.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/8/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGHelpTools: NSObject {
    static func getKeyWindow() -> UIWindow? {
        var window: UIWindow?
//        if #available(iOS 13.0, *) {
//            window = UIApplication.shared.connectedScenes
//                .filter({ $0.activationState == .foregroundActive })
//                .map({ $0 as? UIWindowScene })
//                .compactMap({ $0 })
//                .last?.windows
//                .filter({ $0.isKeyWindow })
//                .last
//        } else {
            window = UIApplication.shared.keyWindow
//        }
        return window
    }
}

// CustomStringConvertible
// 定义个协议
//protocol descriptionProtocol{
//    func mg_description()-> String
//}
//
//extension Array: descriptionProtocol {
//    func mg_description() -> String {
//        var strM: String = "{\n"
//        (self as NSArray).enumerateKeysAndObjects(usingBlock: {(_ key: Any, _ obj: Any, _ stop: Bool) -> Void in
//            strM += "\t\(key) = \(obj);\n"
//        })
//        strM += "}\n"
//        return strM
//    }
//}

//extension NSDictionary: descriptionProtocol {
//    func mg_description(withLocale locale: Any?) -> String {
//        var strM: String = "{\n"
//        for (key,value) in self.enumerated(){
//            strM += "\t\(key) = \(obj);\n"
//        }
//        strM += "}\n"
//        return strM
//    }
//}

//extension Sequence: CustomStringConvertible {
//    override var description: String {
//        var strM: String = "{\n"
//        enumerateKeysAndObjects(usingBlock: {(_ key: Any, _ obj: Any, _ stop: Bool) -> Void in
//            strM += "\t\(key) = \(obj);\n"
//        })
//        strM += "}\n"
//        return strM
//    }
//}


