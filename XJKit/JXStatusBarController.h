//
//  JXStatusBarController.h
//  JXKit
//
//  Created by XJX on 16/5/23.
//  Copyright © 2016年 noomet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXStatusBarStyle.h"
#import "JXStatusBarView.h"

/**
 *  block
 */
typedef JXStatusBarStyle*(^JXPrepareStyleBlock)(JXStatusBarStyle *style);

/**
 *  这个类是一个单例模式的本地通知
 *  要在状态栏的顶部推出通知，使用其中的一个给定类方法
 */
@interface JXStatusBarController : NSObject

/**
 *  单例实现
 */
+ (JXStatusBarController *)sharedInstance;

/**
 *  block
 *
 *  点击事件 回调
 *  [JXStatusBarController sharedInstance].notificationClickBlock = ^(UIButton *btn){
 *      // Do any additional setup
 *  };
 */
@property (copy) void(^notificationClickBlock)(UIButton*);

#pragma mark Presentation

/**
 *  显示通知,它不会自动隐藏，可以调用【+ (void)dismissAnimated:(BOOL)animated】方法隐藏.
 *
 *  @param title 要显示的文字
 *
 *  @return 提交的通知视图，可以自定义显示
 */
+ (JXStatusBarView *)showWithTitle:(NSString *)title;

/**
 *  显示一个特定样式的通知,它不会自动隐藏，可以调用【+ (void)dismissAnimated:(BOOL)animated】方法隐藏.
 *
 *  @param title 要显示的文字
 *  @param styleName 你可以使用任何JXStatusBarStyle类型 （JXStatusBarStyleDefault等等 或已加入自定义风格列表的自定义风格）
 *
 *  @return 提交的通知视图，可以自定义显示
 */
+ (JXStatusBarView *)showWithTitle:(NSString *)title
                         styleName:(NSString*)styleName;

/**
 *  显示通知,按给定的时间间隔自动隐藏.
 *
 *  @param title 要显示的文字
 *  @param timeInterval 间隔多长时间（包括动画持续时间）
 *
 *  @return 提交的通知视图，可以自定义显示
 */
+ (JXStatusBarView *)showWithTitle:(NSString *)title
                      dismissAfter:(NSTimeInterval)timeInterval;

/**
 *  显示一个特定样式的通知,按给定的时间间隔自动隐藏.
 *
 *  @param title 要显示的文字
 *  @param timeInterval 间隔多长时间（包括动画持续时间）
 *  @param styleName 你可以使用任何JXStatusBarStyle类型 （JXStatusBarStyleDefault等等 或已加入自定义风格列表的自定义风格）
 *
 *  @return 提交的通知视图，可以自定义显示
 */
+ (JXStatusBarView *)showWithTitle:(NSString *)title
                      dismissAfter:(NSTimeInterval)timeInterval
                         styleName:(NSString*)styleName;

#pragma mark 时间间隔

/**
 *  调用带动画的隐藏方法 （立即隐藏 没有时间间隔）
 *  与dismissAnimated:YES相同
 */
+ (void)dismiss;

/**
 *  目前显示的通知立即隐藏  （立即隐藏 没有时间间隔）
 *
 *  @param animated is YES, 使用的动画风格
 */
+ (void)dismissAnimated:(BOOL)animated;

/**
 *  隐藏目前显示的通知 （可以指定一个延迟, 所以不会立即隐藏）
 *
 *  @param delay 通知应该可以看见多长时间
 */
+ (void)dismissAfter:(NSTimeInterval)delay;

#pragma mark Styles

/**
 *  更改默认样式
 *
 *  @param prepareBlock 中有一个 JXStatusBarStyle实例，这个实例可以修改，以满足您的需要。你需要返回修改后的样式。
 */
+ (void)setDefaultStyle:(JXPrepareStyleBlock)prepareBlock;

/**
 *  添加自定义样式，可以修改已存在的样式
 *
 *  @param identifier 样式命名（可参考已配置的样式）
 *  @param prepareBlock 中有一个 JXStatusBarStyle实例，这个实例可以修改，以满足您的需要。你需要返回修改后的样式。
 *
 *  @return identifier, 可以直接用作styleName属性参数。
 */
+ (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JXPrepareStyleBlock)prepareBlock;

#pragma mark 测试

/**
 *  测试方法，如果当前显示通知return YES，如果不当前显示的通知return NO。
 *
 *  @return YES.
 */
+ (BOOL)isVisible;





@end
