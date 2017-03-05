//
//  MGTimeTool.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 17/3/2.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGTimeTool: NSObject {

    class func getFormatTimeWithTimeInterval(timeInterval: Double) -> String{
        
        let sec = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let min = Int(timeInterval / 60)
        
        return String(format: "%02zd:%02zd", arguments: [min,sec])
    }
    
    class func getTimeIntervalWithFormatTime(format: String) -> Double{
        let minAsec = format.components(separatedBy: ":")
        let min = minAsec.first
        let sec = minAsec.last
        
        return Double(min!)! * 60 + Double(sec!)!
    }
}
