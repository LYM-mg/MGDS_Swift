//
//	YKLiveList.swift

//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct YKLiveList{

	var dmError : Int!
	var errorMsg : String!
	var expireTime : Int!
	var lives : [YKLive]!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		dmError = dictionary["dm_error"] as? Int
		errorMsg = dictionary["error_msg"] as? String
		expireTime = dictionary["expire_time"] as? Int
		lives = [YKLive]()
		if let livesArray = dictionary["lives"] as? [NSDictionary]{
			for dic in livesArray{
				let value = YKLive(fromDictionary: dic)
				lives.append(value)
			}
		}
	}

}
