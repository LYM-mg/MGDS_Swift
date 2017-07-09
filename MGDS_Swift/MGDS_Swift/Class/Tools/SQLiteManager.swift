//
//  SQLiteManager.swift
//  FMDB的基本使用
//
//  Created by ming on 16/4/18.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import FMDB

class SQLiteManager: NSObject {
    //  单例
    static let shareInstance: SQLiteManager = SQLiteManager()
    
    override init() {
        super.init()
        openDB(name: "Anchor.db")
    }
    
    var dbQueue: FMDatabaseQueue?
    // 打开数据库/数据库的名称
    func openDB(name: String) {
        // 1.拼接路径
        let path = name.cache()
//        debugPrint(path)
        
        // 2.创建数据库对象 // 这哥们会自动打开。内部已经封装创建db
        dbQueue = FMDatabaseQueue(path: path)
        
        // 3.创建表
        creatTable()
    }
    
    /// 创建表
    private func creatTable(){
        // 1.编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS t_FavouriteAnchor (" +
            "userId TEXT PRIMARY KEY, " +
            "myname TEXT, " +
            "smallpic TEXT, " +
            "bigpic TEXT, " +
            "gps TEXT, " +
            "flv TEXT, " +
            "nation TEXT, " +
            "starlevel INT, " +
            "allnum INT, " +
            "roomid INT, " +
            "serverid INT, " +
            "creatTime TEXT NOT NULL DEFAULT (datetime('now','localtime'))" +
        ");"
        
        // 2.执行SQL语句
        /// 在FMDB中除了查询语句其他所有的操作都称为更新
        /// 在这里执行的操作就是线程安全的？为什么呢？因为其内部是一个串行队列内部开启一条子线程
        dbQueue?.inDatabase({ (db) -> Void in
           try? db.executeUpdate(sql, values: nil)
        })
    }
}







