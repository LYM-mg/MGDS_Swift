/**
    NetWorkTools.swift
    Created by i-Techsys.com on 16/11/24.
    Swift 3.0封装 URLSession 的GET/SET方法代替 Alamofire
*/

//import Foundation
import UIKit
import Alamofire

// MARK: - 请求枚举
enum MethodType: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

// MARK: - Swift 3.0封装 URLSession 的GET/SET方法代替 Alamofire
/// Swift 3.0封装 URLSession 的GET/SET方法代替 Alamofire
class NetWorkTools: NSObject {
    /// 请求时间
    var elapsedTime: TimeInterval?
    /// 请求单例工具类对象
    static let share = NetWorkTools()
//    class func share() -> NetWorkTools {
//        struct single {
//            static let singleDefault = NetWorkTools()
//        }
//        return single.singleDefault
//    }

    // MARK: 通用请求的Manager
    static let defManager: SessionManager = {
        var defHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        let defConf = URLSessionConfiguration.default
        defConf.timeoutIntervalForRequest = 8
        defConf.httpAdditionalHeaders = defHeaders
        return Alamofire.SessionManager(configuration: defConf)
    }()
    
    // MARK: 后台请求的Manager
    static let backgroundManager: SessionManager = {
        let defHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        let backgroundConf = URLSessionConfiguration.background(withIdentifier: "io.zhibo.api.backgroud")
        backgroundConf.httpAdditionalHeaders = defHeaders
        return Alamofire.SessionManager(configuration: backgroundConf)
    }()
    
    // MARK: 私有会话的Manager
    static let ephemeralManager: SessionManager = {
        let defHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        let ephemeralConf = URLSessionConfiguration.ephemeral
        ephemeralConf.timeoutIntervalForRequest = 8
        ephemeralConf.httpAdditionalHeaders = defHeaders
        return Alamofire.SessionManager(configuration: ephemeralConf)
    }()
}

// MARK: - 通用请求方法
extension NetWorkTools {
    /// 通用请求方法
    /**
      注册的请求
      - parameter type: 请求方式
      - parameter urlString: 请求网址
      - parameter parameters: 请求参数

      - parameter succeed: 请求成功回调
      - parameter failure: 请求失败回调
      - parameter error: 错误信息
     */
    static func registRequest(type: MethodType,urlString: String, parameters: [String : Any]? = nil ,succeed:@escaping ((_ result : Any?, _ error: Error?) -> Swift.Void), failure:@escaping ((_ error: Error?)  -> Swift.Void)) {
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "text/html",
            "application/x-www-form-urlencoded": "charset=utf-8",
            "Content-Type": "application/json",
            "Content-Length": "12130",
        ]

        let start = CACurrentMediaTime()
        // 2.发送网络数据请求 encoding: URLEncoding.default,
        NetWorkTools.defManager.request(urlString, method: method, parameters: parameters, headers: headers).responseJSON { (response) in
            
            let end = CACurrentMediaTime()
            let elapsedTime = end - start
            print("请求时间 = \(elapsedTime)")
//            print("response.timeline = \(response.timeline)")
            
            // 请求失败
            if response.result.isFailure {
                print(response.result.error)
                failure(response.result.error)
                return
            }
            
            // 请求成功
            if response.result.isSuccess {
                // 3.获取结果
                guard let result = response.result.value else {
                    failure(response.result.error)
                    return
                }
                // 4.将结果回调出去
                succeed(result, nil)
            }
        }
    }
    
    /// 通用请求方法
    /**
     - parameter type: 请求方式
     - parameter urlString: 请求网址
     - parameter parameters: 请求参数
     
     - parameter succeed: 请求成功回调
     - parameter failure: 请求失败回调
     - parameter error: 错误信息
     */
    /// 备注：通用请求方法,增加失败回调，参考系统闭包
    static func requestData(type: MethodType,urlString: String, parameters: [String : Any]? = nil ,succeed:@escaping ((_ result : Any?, _ error: Error?) -> Swift.Void), failure: @escaping ((_ error: Error?)  -> Swift.Void)) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
        ]
        
        // 2.发送网络数据请求
        NetWorkTools.defManager.request(urlString, method: method, parameters: parameters, headers: headers).responseJSON { (response) in
            
            // 请求失败
            if response.result.isFailure {
                print(response.result.error)
                failure(response.result.error)
                return
            }
            
            // 请求成功
            if response.result.isSuccess {
                // 3.获取结果
                guard let result = response.result.value else {
                    succeed(nil, response.result.error)
                    return
                }
                // 4.将结果回调出去
                succeed(result, nil)
            }
        }
    }
}

// MARK: - 下载请求
extension NetWorkTools {
    // 目标路径闭包展开
     func downloadData(type: MethodType,urlString: String, parameters: [String : Any]? = nil ,succeed:@escaping ((_ result : Any?, _ error: Error?) -> Swift.Void), failure:@escaping ((_ error: Error?)  -> Swift.Void)) {
        
        //指定下载路径（文件名不变）
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //开始下载
        NetWorkTools.backgroundManager.download(urlString, to: destination)
            .downloadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
            }
            .response { (response) in
//            if let imagePath = response.destinationURL?.path {
//                let image = UIImage(contentsOfFile: imagePath)
//            }
        }
    }
    
    // 把歌词路劲传出来
    func downloadData(type: MethodType,urlString: String,parameters: [String : Any]? = nil, endPathBlock:@escaping (_ endPath:String)->()) {
        //指定下载路径（文件名不变）
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var fileURL = documentsURL.appendingPathComponent("MusicLrc_List")
            fileURL = fileURL.appendingPathComponent(response.suggestedFilename!)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        //开始下载
        NetWorkTools.backgroundManager.download(urlString, method: method, parameters: parameters, to: destination).downloadProgress { progress in
//            print("当前歌曲下载进度: \(progress.fractionCompleted)")
            }
            .response { (response) in
                if let endPath = response.destinationURL?.path {
                    endPathBlock(endPath)
                }
        }
    }
    
    func downloadMusicData(type: MethodType,urlString: String,parameters: [String : Any]? = nil, endPathBlock:@escaping (_ endPath:String)->()) {
        //指定下载路径（文件名不变）
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var fileURL = documentsURL.appendingPathComponent("Music_List")
            fileURL = fileURL.appendingPathComponent(response.suggestedFilename!)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        //开始下载
        NetWorkTools.backgroundManager.download(urlString, method: method, parameters: parameters, to: destination).downloadProgress { progress in
//            print("当前歌词下载进度: \(progress.fractionCompleted)")
            }
            .response { (response) in
                if let endPath = response.destinationURL?.path {
                    endPathBlock(endPath)
                }
        }
    }
}

// MARK: - 上传
extension NetWorkTools {
    func upload(fileURL: URL,urlStr: String,method: HTTPMethod,completed:@escaping (() -> Swift.Void)) {
        NetWorkTools.backgroundManager.upload(fileURL, to: urlStr, method: method)
            .uploadProgress { progress in // main queue by default
                print("当前进度: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                debugPrint(response)
                completed()
        }
    }
}

// MARK: -
// MARK: -  判断网络类型
//（与官方风格一致，推荐使用）
enum NetworkStatuses {
    case NetworkStatusNone  // 没有网络
    case NetworkStatus2G     // 2G
    case NetworkStatus3G     // 3G
    case NetworkStatus4G     // 4G
    case NetworkStatusWIFI   // WIFI
}

extension NetWorkTools {
     /// 获取网络状态
     class func getNetworkStates() -> NetworkStatuses? {
        guard let object1 = UIApplication.shared.value(forKey: "statusBar") as? NSObject else { return nil }
        guard let object2 = object1.value(forKey: "foregroundView") as? UIView else { return nil }
        let subviews = object2.subviews

        var status = NetworkStatuses.NetworkStatusNone
        
        for child in subviews {
            if child.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
                // 获取到状态栏码
                 guard let networkType = child.value(forKey: "dataNetworkType") as? Int else { return nil }
                switch (networkType) {
                    case 0: // 无网模式
                        status =  NetworkStatuses.NetworkStatusNone;
                    case 1: // 2G模式
                        status =  NetworkStatuses.NetworkStatus2G;
                    case 2: // 3G模式
                        status =  NetworkStatuses.NetworkStatus3G;
                    case 3: // 4G模式
                        status =  NetworkStatuses.NetworkStatus4G;
                    case 5: // WIFI模式
                        status =  NetworkStatuses.NetworkStatusWIFI;
                    default:
                        break
                }
            }
        }
        
        // 返回网络类型
        return status;
    }
}
