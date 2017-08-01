//
//  XYConstant-Swift.swift
//  WUO
//
//  Created by mofeini on 17/1/19.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit


/*************** 颜色 ***************/
func COLOR(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func RANDOM_COLOR() -> UIColor {
    return COLOR(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)), a: 1.0)
}

// title文本的颜色
func COLOR_TITLE_TEXT() -> UIColor {
    return COLOR(r: 25, g: 25, b: 25, a: 1.0);
}
// content文本颜色
func COLOR_CONTENT_TEXT() -> UIColor {
    return COLOR(r: 125, g: 125, b: 125, a: 1.0)
}

// job文本颜色
func COLOR_JOB_TEXT() -> UIColor {
    return COLOR(r: 94, g: 167, b: 86, a: 1.0)
}

// 昵称name文本颜色
func COLOR_NAME_TEXT() -> UIColor {
    return COLOR_NAME_TEXT_BLACK()
}

// 昵称name文本颜色  浅蓝色
func COLOR_NAME_TEXT_BLUE() -> UIColor {
    return COLOR(r: 106, g: 140, b: 181, a: 1.0)
}

// name文字颜色 黑色
func COLOR_NAME_TEXT_BLACK() -> UIColor {
   return COLOR(r: 10, g: 101, b: 10, a: 1.0)
}

// 浅蓝色
func COLOR_LIGHTBLUE() -> UIColor {
    return COLOR(r: 106, g: 140, b: 181, a: 1.0)
}

// 分隔符的颜色
func COLOR_SEPARATOR() -> UIColor {
    return COLOR(r: 140, g: 140, b: 140, a: 0.6)
}

// cell的全局颜色
func COLOR_GLOBAL_CELL() -> UIColor {
    return COLOR(r: 250, g: 250, b: 250, a: 1.0)
}

// 灰色
func COLOR_LIGHTGRAY() -> UIColor {
    return COLOR(r: 180, g: 180, b: 180, a: 1.0)
}

// 绿色
func COLOR_GLOBAL_GREEN() -> UIColor {
    return COLOR(r: 47, g: 189, b: 169, a: 1.0)
}

func SCREENT_W() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

/*************** 动态界面 ***************/
let SIZE_CONTENT_W = SCREENT_W() - SIZE_GAP_MARGIN * 2 - SIZE_HEADERWH - SIZE_GAP_PADDING
let SIZE_SEPARATORH : CGFloat = 5.0                       // 分割线高度
let SIZE_TOOLVIEWH : CGFloat = 40.0                       // 工具条高度
let SIZE_GAP_MARGIN : CGFloat = 15.0                      // 全局外间距
let SIZE_GAP_TOP : CGFloat = 13.0                         // 全局顶部间距
let SIZE_HEADERWH  : CGFloat = 50.0                        // 头像尺寸
let SIZE_GAP_PADDING  : CGFloat = 10.0                     // 内间距
let SIZE_PIC_BOTTOM : CGFloat = 20.0                      // 图片底部间距
let SIZE_GAP_SMALL : CGFloat = 5.0                        // 最小的间距
let SIZE_PICMARGIN : CGFloat = 5.0                        // 每张图片之间的间距
let SIZE_PICWH : CGFloat = 80.0                           // 单张图片宽度
let SIZE_FONT : CGFloat = 17.0                            // 字体大小
let SIZE_FONT_NAME = SIZE_FONT - 1                       // 昵称字体大小
let SIZE_FONT_SUBTITLE = SIZE_FONT-8                     // job及创建日期字体大小
let SIZE_FONT_TITLE : CGFloat = 15.0                     // 标题字体大小
let SIZE_FONT_LOCATION : CGFloat = SIZE_FONT - 5          // 标题字体大小
let SIZE_FONT_CONTENT = (SIZE_FONT_TITLE-3)              // 内容文本字体大小
let COLOR_COUNT_TEXT = COLOR(r: 205, g: 205, b: 205, a: 1.0) // 工具条的各种数量文本颜色
let COLOR_READCOUNT_TEXT = COLOR(r: 180, g: 180, b: 180, a: 1.0) // 阅读文本数量颜色
let SIZE_TREND_DETAIL_SELECTVIEW_H : CGFloat = 35.0


let COLOR_INVEST_SEARCH_BG = COLOR(r: 211, g: 211, b: 211, a: 1.0)
let COLOR_TABLEVIEW_BG = COLOR(r: 238, g: 238, b: 238, a: 238)        // 所有tableView的背景颜色
let SIZE_INVESET_HEADERVIEW_H : CGFloat = 260.0

/** 全局字体 */
func FontWithSize(s: CGFloat) -> UIFont {
    return UIFont.init(name: "HelveticaNeue-Light", size: s)!
}

let TableViewBgColor = COLOR(r: 238, g: 238, b: 238, a: 1.0)        // 所有tableView的背景颜色



