//
//  XYFigureSpecial.swift
//  WUO
//
//  Created by mofeini on 17/1/23.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  人物专刊

import UIKit

class XYFigureSpecial: NSObject {
    
    var responseInfo : XYHTTPResponseInfo?

    var createTime : String?
    var did : Int?
    var dname : String?
    var logo : String?
    var readCount : Int?
    
    /// 对模型属性进行处理
    var logoFullURL : URL? {
        get {
            var logoFullStr : String? = nil
            
            if let logo = logo {
                if logo.characters.count != 0 {
                    /// 注意：服务端返回logo路径，有些是完整的路径，有些需要拼接，这里做出来
                    if logo.contains("http:") {
                        logoFullStr = logo
                    } else {
                        logoFullStr =  (responseInfo?.basePath)! + logo
                    }
                    return URL.init(string: logoFullStr!)
                }
            }
            return nil
        }
    }
    
    
    convenience init(dict: [String : Any], responseInfo: XYHTTPResponseInfo) {
        self.init()
        
        setValuesForKeys(dict)
        self.responseInfo = responseInfo
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
