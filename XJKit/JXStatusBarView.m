//
//  JXStatusBarView.m
//  JXKit
//
//  Created by XJX on 16/5/23.
//  Copyright © 2016年 noomet. All rights reserved.
//

#import "JXStatusBarView.h"

@interface JXStatusBarView ()
@property (nonatomic, strong) UIButton *textButton;
@end

@implementation JXStatusBarView
-(UIButton *)textButton
{
    if (!_textButton) {
        _textButton = [[UIButton alloc] init];
        _textButton.backgroundColor = [UIColor clearColor];
        _textButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _textButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _textButton.clipsToBounds = YES;
        [self addSubview:_textButton];
    }
    return _textButton;
}

#pragma mark setter 
/**
-(void)setTag:(NSInteger)tag
{
    _textButton.tag = tag;
    [self setTag:tag];
}
 */

-(void)setTextVerticalPositionAdjustment:(CGFloat)textVerticalPositionAdjustment
{
    _textVerticalPositionAdjustment = textVerticalPositionAdjustment;
    [self setNeedsLayout];
}

#pragma mark layout

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textButton.frame = CGRectMake(0, self.textVerticalPositionAdjustment,
                                            self.bounds.size.width,self.bounds.size.height );
}


@end
