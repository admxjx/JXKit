//
//  JXStatusBarStyle.h
//  JXKit
//
//  Created by XJX on 16/5/23.
//  Copyright © 2016年 noomet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// textButton Style
extern NSString *const JXStatusBarStyleError;       // 红色背景 & 白色字体
extern NSString *const JXStatusBarStyleWarning;     // 黄色背影 & 灰色字体
extern NSString *const JXStatusBarStyleSuccess;     // 绿色背景 & 白色字体
extern NSString *const JXStatusBarStyleMatrix;      // 黑色背景 & 绿色字体
extern NSString *const JXStatusBarStyleDefault;     // 白色背景 & 灰色字体
extern NSString *const JXStatusBarStyleDark;        // 黑色背景 & 白色字体

// textButton Animation
typedef NS_ENUM(NSInteger, JXStatusBarAnimationType) {
    JXStatusBarAnimationTypeNone,   /// 没有动画
    JXStatusBarAnimationTypeMove,   /// 从顶部往下移动
    JXStatusBarAnimationTypeBounce, /// 从顶部下降并反弹一点
    JXStatusBarAnimationTypeFade    /// 淡入和淡出
};

/*
 * 样式定义的模样
 */
@interface JXStatusBarStyle : NSObject<NSCopying>

/*
 * notification bar背景颜色
 */
@property (nonatomic, strong) UIColor *barColor;

/*
 * notification bar文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/*
 * notification bar label文本的阴影
 */
@property (nonatomic, strong) NSShadow *textShadow;

/*
 * notification bar文字大小
 */
@property (nonatomic, strong) UIFont *font;

/*
 * notification bar文字垂直位置调整
 */
@property (nonatomic, assign) CGFloat textVerticalPositionAdjustment;

#pragma mark Animation

/*
 * notification bar动漫
 */
@property (nonatomic, assign) JXStatusBarAnimationType animationType;

@end
