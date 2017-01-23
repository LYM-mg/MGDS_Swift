//
//	YKCreator.swift
//  JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct YKCreator{

	var birth : String!
	var descriptionField : String!
	var emotion : String!
	var gender : Int!
	var gmutex : Int!
	var hometown : String!
	var id : Int!
	var inkeVerify : Int!
	var level : Int!
	var location : String!
	var nick : String!
	var portrait : String!
	var profession : String!
	var rankVeri : Int!
	var thirdPlatform : String!
	var veriInfo : String!
	var verified : Int!
	var verifiedReason : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		birth = dictionary["birth"] as? String
		descriptionField = dictionary["description"] as? String
		emotion = dictionary["emotion"] as? String
		gender = dictionary["gender"] as? Int
		gmutex = dictionary["gmutex"] as? Int
		hometown = dictionary["hometown"] as? String
		id = dictionary["id"] as? Int
		inkeVerify = dictionary["inke_verify"] as? Int
		level = dictionary["level"] as? Int
		location = dictionary["location"] as? String
		nick = dictionary["nick"] as? String
		portrait = dictionary["portrait"] as? String
		profession = dictionary["profession"] as? String
		rankVeri = dictionary["rank_veri"] as? Int
		thirdPlatform = dictionary["third_platform"] as? String
		veriInfo = dictionary["veri_info"] as? String
		verified = dictionary["verified"] as? Int
		verifiedReason = dictionary["verified_reason"] as? String
	}

}
