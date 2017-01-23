//
//	YKLive.swift

//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct YKLive{

	var city : String!
	var creator : YKCreator!
	var group : Int!
	var id : String!
	var image : String!
	var link : Int!
	var multi : Int!
	var name : String!
	var onlineUsers : Int!
	var optimal : Int!
	var pubStat : Int!
	var roomId : Int!
	var rotate : Int!
	var shareAddr : String!
	var slot : Int!
	var status : Int!
	var streamAddr : String!
	var version : Int!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		city = dictionary["city"] as? String
		if let creatorData = dictionary["creator"] as? NSDictionary{
				creator = YKCreator(fromDictionary: creatorData)
			}
		group = dictionary["group"] as? Int
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		link = dictionary["link"] as? Int
		multi = dictionary["multi"] as? Int
		name = dictionary["name"] as? String
		onlineUsers = dictionary["online_users"] as? Int
		optimal = dictionary["optimal"] as? Int
		pubStat = dictionary["pub_stat"] as? Int
		roomId = dictionary["room_id"] as? Int
		rotate = dictionary["rotate"] as? Int
		shareAddr = dictionary["share_addr"] as? String
		slot = dictionary["slot"] as? Int
		status = dictionary["status"] as? Int
		streamAddr = dictionary["stream_addr"] as? String
		version = dictionary["version"] as? Int
	}

}
