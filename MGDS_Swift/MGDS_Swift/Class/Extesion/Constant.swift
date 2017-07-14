//
//  Constant.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/24.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

// "Apple ID 为您的 App 自动生成的 ID。
let appid = "1228164508"
// MARK:- 全局参数
let MGScreenBounds = UIScreen.main.bounds
let MGScreenW = UIScreen.main.bounds.size.width
let MGScreenH = UIScreen.main.bounds.size.height

/// 状态栏高度20
let MGStatusHeight: CGFloat = 20
/// 导航栏高度64
let MGNavHeight: CGFloat = 64
/// tabBar的高度 50
let MGTabBarHeight: CGFloat = 50
/// 全局的间距 10
let MGGloabalMargin: CGFloat = 10
/** 导航栏颜色 */
let navBarTintColor  = UIColor.colorWithCustom(r: 83, g: 179, b: 163)

/** 全局字体 */
let MG_FONT = "Bauhaus ITC"

// 全局存储的key
/// 存储登录用户信息的路径
let MGUserPath: String = "user.plist".cache()
/// 是否登录
let isLoginKey: String = "isLoginKey"

let MGGetCompanysKey: String = "MGGetCompanysKey"
/// 记录服务器IP
let MGServeraddressKey = "MGServeraddressKey"
/// storyBoard跳转到配置IP的标志
let MGTurnToServerIPID = "MGTurnToServerIPID"

/// 搜索数组的key
let MGSearchMusicHistorySearchArray = "MGSearchMusicHistorySearchArray"





/// 主窗口代理
let KAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

// iOS在当前屏幕获取第一响应
let MGKeyWindow = UIApplication.shared.keyWindow
let MGFirstResponder = MGKeyWindow?.perform(Selector(("firstResponder")))


// MARK:- 通知
/// 通知中心
let MGNotificationCenter = NotificationCenter.default

// MARK:- 首页排序的通知
/// 首页自定义导航栏按钮的点击
let MGBarLeftBtnClickNoti  = "MGBarLeftBtnClickNoti"
let KEnterHomeViewNotification = "KEnterHomeViewNotification"
/// 通知换一换
let KChangeanchorNotification = "KChangeanchorNotification"
/// 通知换一换
let KSelectedFavouriteAnchorNotification = "KSelectedFavouriteAnchorNotification"
/// 通知#DTouch变化
let KChange3DTouchNotification = "KChange3DTouchNotification"
