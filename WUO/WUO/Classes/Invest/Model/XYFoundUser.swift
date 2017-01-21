//
//  XYFoundUser.swift
//  WUO
//
//  Created by mofeini on 17/1/21.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYFoundUser: NSObject {

    // MARK: - 模型属性
    var responseInfo : XYHTTPResponseInfo?
    /** 投资人数量 */
    var beGmCount : Int?
    /** 赚取的金币数量 */
    var earningsGoldCoin : CGFloat?
    /** 粉丝数量 */
    var fansCount : Int?
    var head : String?
    var imgList : [XYTrendImgItem]?
    var isFollow : Bool?
    var isInvest : Bool?
    var job : String?
    var name : String?
    var uid : Int?
    
    // MARK: - 扩展属性
    var cellHeight : CGFloat = 0
    
    
    // MARK: - 对模型属性的处理
    var headImageURL : URL? {
        get {
            let fullPath : String?
            guard let head = head else {
                return nil
            }
            if head.contains("http://") {
                fullPath = head
            } else {
                guard let basePath = responseInfo?.basePath else {
                    return nil
                }
                fullPath = basePath + head
            }
            return URL.init(string: fullPath!)
        }
    }
    
    var jobStr : String? {
        get {
            if let job = job {
                if job.characters.count == 0 {
                    return "TA很懒还没有设置"
                }
            }
            return job
        }
    }
    
    convenience init(dict: [String: Any], info: XYHTTPResponseInfo) {
        self.init()
        
        setValuesForKeys(dict)
        responseInfo = info
        // 使用setValuesForKeys转换模型，Int CGFloat数据类型尽然转换失败，郁闷，手动再转换下
        beGmCount = dict["beGmCount"] as? Int
        earningsGoldCoin = dict["earningsGoldCoin"] as? CGFloat
        fansCount = dict["fansCount"] as? Int
        uid = dict["uid"] as? Int
        isFollow = dict["isFollow"] as? Bool
        isInvest = dict["isInvest"] as? Bool
        
        if let imgList = dict["imgList"] as? [[String: Any]] {
            var tempArr = [XYTrendImgItem]()
            for obj in imgList {
               tempArr.append(XYTrendImgItem(dict: obj, responseInfo: info))
            }
            self.imgList = tempArr
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    

}
