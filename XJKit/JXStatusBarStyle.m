//
//  JXStatusBarStyle.m
//  JXKit
//
//  Created by XJX on 16/5/23.
//  Copyright © 2016年 noomet. All rights reserved.
//

#import "JXStatusBarStyle.h"

#define color(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]

NSString *const JXStatusBarStyleError   = @"JXStatusBarStyleError";
NSString *const JXStatusBarStyleWarning = @"JXStatusBarStyleWarning";
NSString *const JXStatusBarStyleSuccess = @"JXStatusBarStyleSuccess";
NSString *const JXStatusBarStyleMatrix  = @"JXStatusBarStyleMatrix";
NSString *const JXStatusBarStyleDefault = @"JXStatusBarStyleDefault";
NSString *const JXStatusBarStyleDark    = @"JXStatusBarStyleDark";

@implementation JXStatusBarStyle


-(id)copyWithZone:(NSZone *)zone
{
    JXStatusBarStyle *style = [[self class] allocWithZone:zone];
    style.barColor = self.barColor;
    style.textColor = self.textColor;
    style.textShadow = self.textShadow;
    style.font = self.font;
    style.textVerticalPositionAdjustment = self.textVerticalPositionAdjustment;
    style.animationType = self.animationType;
    return style;
}

+ (NSArray*)allDefaultStyleIdentifier;
{
    return @[JXStatusBarStyleError, JXStatusBarStyleWarning,
             JXStatusBarStyleSuccess, JXStatusBarStyleMatrix,
             JXStatusBarStyleDark];
}

+(JXStatusBarStyle *)setUpStyleWithName:(NSString*)styleName;
{
    // setUp default style
    JXStatusBarStyle *style = [[JXStatusBarStyle alloc] init];
    style.barColor = [UIColor whiteColor];
    style.textColor = [UIColor grayColor];
    style.font = [UIFont systemFontOfSize:12.0];
    style.animationType = JXStatusBarAnimationTypeMove;
    
    // JXStatusBarStyleDefault
    if ([styleName isEqualToString:JXStatusBarStyleDefault]) {
        return style;
    }
    
    // JXStatusBarStyleError
    else if ([styleName isEqualToString:JXStatusBarStyleError]) {
        style.barColor = color(0.588, 0.118, 0.000, 1.000);
        style.textColor = [UIColor whiteColor];
        return style;
    }
    
    // JXStatusBarStyleWarning
    else if ([styleName isEqualToString:JXStatusBarStyleWarning]) {
        style.barColor = color(0.900, 0.734, 0.034, 1.000);
        style.textColor = [UIColor darkGrayColor];
        return style;
    }
    
    // JXStatusBarStyleSuccess
    else if ([styleName isEqualToString:JXStatusBarStyleSuccess]) {
        style.barColor = color(0.588, 0.797, 0.000, 1.000);
        style.textColor = [UIColor whiteColor];
        return style;
    }
    
    // JXStatusBarStyleDark
    else if ([styleName isEqualToString:JXStatusBarStyleDark]) {
        style.barColor = color(0.050, 0.078, 0.120, 1.000);
        style.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return style;
    }
    
    // JXStatusBarStyleMatrix
    else if ([styleName isEqualToString:JXStatusBarStyleMatrix]) {
        style.barColor = [UIColor blackColor];
        style.textColor = [UIColor greenColor];
        style.font = [UIFont fontWithName:@"Courier-Bold" size:14.0];
        return style;
    }
    return nil;
}
@end
