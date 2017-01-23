//
//  SysNetWorkTools.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 16/12/30.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

// MARK: - 请求枚举
public enum SYSHTTPMethod: String {
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

// MARK: - 请求工具类
class SysNetWorkTools: NSObject {
    public typealias HTTPHeaders = [String: String]
    //请求成功时需要调用的代码封装为一个嵌套的方法，以便复用
    //同理请求失败需要执行的代码
    
    // MARK:外部控制器的方法
    /**
      通用请求方法
      - parameter code : 已经授权的RequestToken
      - parameter succeed: 请求成功回调
      - parameter failure: 请求失败回调
      - parameter error: 错误信息
     */
    static func httpsRequest(url: String,methodType: SYSHTTPMethod,parameters: [String: Any]?, successed:@escaping ((_ result : Any?, _ error: Error?) -> Swift.Void), failure:@escaping ((_ error: Error?)  -> Swift.Void)) {
        //HTTP头部需要传入的信息，如果没有可以省略 headers:
        // 1.生成session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let trueURL = URL(string: url)
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "text/html"
        ]
//        let request = URLRequest(url: trueURL!, method: methodType)
        let request =  URLRequest(url: trueURL!, method: methodType, headers: headers)
        // 2.这里我没有设置参数，使用了默认的编码方式
        let encodedURLRequest = try? MYURLEncoding().encode(request, with: parameters)
        // 3.生成一个dataTask
        let dataTask = session.dataTask(with: encodedURLRequest!) { (data, response, error) in
            // 4.下面是回调部分，需要手动切换线程
            DispatchQueue.main.async {
                // 5.下面的几种情况参照了responseJSON方法的实现
                guard error == nil else {
                    failure(error)
                    return
                }
                guard let validData = data, validData.count > 0 else {
                    failure(AFError.responseSerializationFailed(reason: .inputDataNil))
                    return
                }
                
                if let response = response as? HTTPURLResponse, [200, 204, 205].contains(response.statusCode) {
                    let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    successed(dict, nil)
                    return
                }
                let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                successed(dict, nil)
            }
        }
        
        // 5.开始请求
        dataTask.resume()
    }
    
     static func getVideoList(withURLString URLString: String, listID ID: String, success:@escaping ((_ listArray : Any?, _ sidArray: Any?) -> ()), failure: @escaping ((_ error: Error?)  -> ())) {
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: URL(string: URLString)!) { (data, response, error) in
            if error != nil {
                print("错误\(error)")
                failure(error)
            } else {
                var  listArray: [VideoList] = []
                let dict: [String: Any] =  try!  JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : Any]
                guard let videoList: [[String: Any]] = dict[ID] as? [[String: Any]] else {return}
                for video in videoList {
                    let model = VideoList(dict: video)
                    listArray.append(model)
                }
                success(listArray, nil)
            }
        }
        dataTask.resume()
    }
}

// MARK: - AFError
public enum AFError: Error {
    public enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(error: Error)
        case propertyListEncodingFailed(error: Error)
    }
    
    public enum MultipartEncodingFailureReason {
        case bodyPartURLInvalid(url: URL)
        case bodyPartFilenameInvalid(in: URL)
        case bodyPartFileNotReachable(at: URL)
        case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
        case bodyPartFileIsDirectory(at: URL)
        case bodyPartFileSizeNotAvailable(at: URL)
        case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
        case bodyPartInputStreamCreationFailed(for: URL)
        
        case outputStreamCreationFailed(for: URL)
        case outputStreamFileAlreadyExists(at: URL)
        case outputStreamURLInvalid(url: URL)
        case outputStreamWriteFailed(error: Error)
        
        case inputStreamReadFailed(error: Error)
    }
    
    public enum ResponseValidationFailureReason {
        case dataFileNil
        case dataFileReadFailed(at: URL)
        case missingContentType(acceptableContentTypes: [String])
        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
        case unacceptableStatusCode(code: Int)
    }
    
    public enum ResponseSerializationFailureReason {
        case inputDataNil
        case inputDataNilOrZeroLength
        case inputFileNil
        case inputFileReadFailed(at: URL)
        case stringSerializationFailed(encoding: String.Encoding)
        case jsonSerializationFailed(error: Error)
        case propertyListSerializationFailed(error: Error)
    }
    
    case invalidURL(url: URL)
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
    case responseValidationFailed(reason: ResponseValidationFailureReason)
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

// MARK: - MYURLEncoding
struct MYURLEncoding {
    public typealias Parameters = [String: Any]
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    
    func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    func encodesParametersInURL(with method: SYSHTTPMethod) -> Bool {
        switch method {
            case .get, .head, .delete:
                return true
            default:
                return false
        }
    }
    
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let parameters = parameters else { return urlRequest }
        
        if let method = SYSHTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodesParametersInURL(with: method) {
            guard let url = urlRequest.url else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }
        
        return urlRequest
    }
}

// MARK: - other
extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

extension URLRequest {
    public init(url: URL, method: SYSHTTPMethod, headers: [String: String]? = nil)  {
        self.init(url: url)
        httpMethod = method.rawValue
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}

