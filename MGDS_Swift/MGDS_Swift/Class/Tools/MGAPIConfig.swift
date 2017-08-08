//
//  MGAPiConfig.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/27.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

struct API{
    // 用于上传数据
    static var tronUpdata = SysNetWorkTools()
    
    // 用于请求普通接口
    static var tron = SysNetWorkTools()
}

// 结构体,这里可以把每一个模块的的接口再细分，分别创建一个文件对应写扩展
extension API {
    struct File {
        //上传图片文件
        static  func upload(_ parameters: [String:Any]?,imageData:NSData,imageName:String) -> SysNetWorkTools {
            
            let request = tronUpdata.updataRequest(path: "common/File/upload", data: imageData as Data,contentType:"image/jpeg")
            request.parameters = parameters ?? [:]
            request.method = .post
            request.type = .upData
            return request
        }
        
        //上传视频文件
        static  func uploadVideo(_ parameters: [String:Any]?,videoData:NSData,videoName:String) -> SysNetWorkTools {
            let request = tronUpdata.updataRequest(path: "common/File/upload", data: videoData as Data,contentType:"multipart/form-data")
            request.parameters = parameters ?? [:]
            request.method = .post
            request.type = .upData
            return request
        }
    }
    
    struct Common {
        struct Base {
            // 登录接口测试
            static  func login(parameters: [String:Any]?) -> SysNetWorkTools {
                let request: SysNetWorkTools = tron.request(path: "ReportService/UserEdit")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
            // 获取列表
            static  func get_one(parameters: [String:Any]?) -> SysNetWorkTools {
                let request: SysNetWorkTools = tron.request(path: "ReportService/ProdProgressList")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
        }
    }
    // API.File.upload(["by_module":"3","key":"FILES"], imageData: UIImageJPEGRepresentation(image, 0.9)! as NSData, imageName: "FILES").progressTitle("上传中")
}
