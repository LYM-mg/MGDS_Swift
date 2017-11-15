//  RegexHelper.swift
//  MGDS_Swift
//  Created by i-Techsys.com on 2017/10/24.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// https://github.com/LYM-mg
// http://www.jianshu.com/u/57b58a39b70e
import UIKit

struct RegexHelper {
    let regex: NSRegularExpression
    
    /* pattern: 正则表达式 */
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .caseInsensitive)
    }
    
    /* input: 要匹配的字符串 */
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input,
                                    options: [],
                                    range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
    
    func testMail() {
//        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
//        let matcher: RegexHelper
//        do {
//            matcher = try! RegexHelper(mailPattern)
//        }
//
//        let maybeMailAddress = "onev@onevcat.com"
//        if matcher.match(maybeMailAddress) {
//            print("有效的邮箱地址")
//        }
        if "onev@onevcat.com" =~
            "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
            print("有效的邮箱地址")
        }
    }
}

precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}

infix operator =~: MatchPrecedence

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}
