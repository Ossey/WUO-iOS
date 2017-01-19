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


/*************** 动态界面 ***************/



