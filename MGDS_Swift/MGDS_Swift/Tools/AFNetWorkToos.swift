//
//  AFNetWorkToos.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 16/11/25.
//  Copyright © 2016年 i-Techsys. All rights reserved.
// http://222.222.222.221:8786/ReportService/ProdProgressList?UserName=admin&UserPwd=123&BuyerName=&ItemName=&PageIndex=1&RowSize=20

import UIKit
import AFNetworking

enum AFNMethodType {
    case get
    case post
}


class AFNetWorkToos: AFHTTPSessionManager{
    
    static let shareInstance : AFNetWorkToos = {
        let url = NSURL(string: "https://api.weibo.com/")
        let configuration = URLSessionConfiguration.default
        let instance = AFNetWorkToos(sessionConfiguration: configuration)
//        let instance = AFNetWorkToos(baseURL: url as URL?, sessionConfiguration: configuration)
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain","application/json","text/html") as? Set
        // 设置请求超时为8秒
        instance.requestSerializer.timeoutInterval = 8.0
        return instance
    }()
    
    // MARK:- 外部控制器的方法
    /**
     *   请求授权accessToken
     *
     *   - parameter code : 已经授权的RequestToken
     *   - parameter succeed: 请求成功回调
     *   - parameter failure: 请求失败回调
     *   - parameter error: 错误信息
     */
    func requestData(type: MethodType,urlString: String,parameters: [String : Any]? = nil ,succeed:@escaping ((_ result : Any?, _ error: Error?) -> Swift.Void), failure:@escaping ((_ error: Error?)  -> Swift.Void)) {
        // 1.获取类型
        let method = type == .post
        if method {
            post(urlString, parameters: parameters, progress: nil, success: { (task, JSON) in
                guard let dict = JSON as? [String : Any] else {
                    failure(NSError(domain: "错误", code: 110, userInfo: ["message" : "获取到的授权信息是nil"]))
                    return
                }
                succeed(dict, nil)
            }, failure: { (_, error) in
                failure(error)
            })
        } else {
            get(urlString, parameters: parameters, progress: nil, success: { (task, JSON) in
                guard let dict = JSON as? [String : Any] else {
                    failure(NSError(domain: "错误", code: 110, userInfo: ["message" : "获取到的授权信息是nil"]))
                    return
                }
                succeed(dict, nil)
                }, failure: { (_, error) in
                    failure(error)
            })
        }
    }
}


// MARK: - 系统的类封装
extension AFNetWorkToos {
    // MARK:- 外部控制器的方法
    /**
    - parameter type: 已经授权的RequestToken
    - parameter succeed: 请求成功回调
    - parameter failure: 请求失败回调
    - parameter error: 错误信息
     */
    /// 请求授权accessToken
    class func requestData(type: MethodType,urlString: String,parameters: [String : Any]? = nil ,successed:@escaping ((_ result : Any?, _ error: Error?) -> Swift.Void), failure:@escaping ((_ error: Error?)  -> Swift.Void)) {
        let url:URL = URL(string: urlString)!
        
        // 1.2url
        let requestM = NSMutableURLRequest(url: url)
        
        // 1.3修改请求方法
        // 1.4设置请求体
        requestM.httpBody = "UserName=admin&UserPwd=123&type=JSON".data(using: String.Encoding.utf8)
        requestM.httpMethod = "POST"
        
        
        // 2.2创建请求 Task
        let session = URLSession.shared
        
        /*
         第一个参数：请求对象
         第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
         data：响应体信息（期望的数据）
         response：响应头信息，主要是对服务器端的描述
         error：错误信息，如果请求失败，则error有值
         */
        
        let dataTask: URLSessionDataTask = session.dataTask(with: requestM as URLRequest) { (data, response, error) in
            //3.解析数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            var dict:NSDictionary? = nil
            do {
                dict  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? NSDictionary
                successed(dict, nil)
            } catch {
                failure(error)
            }
            print("%@",dict)
        }
        
        // 2.3发送请求（执行Task）
        dataTask.resume()
    }
}

