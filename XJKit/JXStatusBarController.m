//
//  JXStatusBarController.m
//  JXKit
//
//  Created by XJX on 16/5/23.
//  Copyright © 2016年 noomet. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "JXStatusBarController.h"

@interface JXStatusBarStyle (Hidden)
+ (NSArray *)allDefaultStyleIdentifier;
+ (JXStatusBarStyle *)setUpStyleWithName:(NSString*)styleName;
@end

@interface JXStatusBarViewController : UIViewController
@end

@interface JXStatusBarController ()
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) JXStatusBarView *topBar;

@property (nonatomic, strong) NSTimer *dismissTimer;
@property (nonatomic, weak) JXStatusBarStyle *activeStyle;

@property (nonatomic, strong) JXStatusBarStyle *defaultStyle;
@property (nonatomic, strong) NSMutableDictionary *userStyles;
@end

static JXStatusBarController *_sharedInstance;
@implementation JXStatusBarController
@synthesize overlayWindow = _overlayWindow;
@synthesize topBar = _topBar;

#pragma mark Class methods

+ (JXStatusBarController *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    return _sharedInstance;
}

+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}


+ (UIView*)showWithTitle:(NSString *)title;
{
    return [[self sharedInstance] showWithTitle:title
                                       styleName:nil];
}

+ (UIView*)showWithTitle:(NSString *)title
                styleName:(NSString*)styleName;
{
    return [[self sharedInstance] showWithTitle:title
                                       styleName:styleName];
}

+ (UIView*)showWithTitle:(NSString *)title
             dismissAfter:(NSTimeInterval)timeInterval;
{
    UIView *view = [[self sharedInstance] showWithTitle:title
                                               styleName:nil];
    [self dismissAfter:timeInterval];
    return view;
}

+ (UIView*)showWithTitle:(NSString *)title
             dismissAfter:(NSTimeInterval)timeInterval
                styleName:(NSString*)styleName;
{
    UIView *view = [[self sharedInstance] showWithTitle:title
                                               styleName:styleName];
    [self dismissAfter:timeInterval];
    return view;
}

+ (void)dismiss;
{
    [self dismissAnimated:YES];
}

+ (void)dismissAnimated:(BOOL)animated;
{
    [[JXStatusBarController sharedInstance] dismissAnimated:animated];
}

+ (void)dismissAfter:(NSTimeInterval)delay;
{
    [[JXStatusBarController sharedInstance] setDismissTimerWithInterval:delay];
}

+ (void)setDefaultStyle:(JXPrepareStyleBlock)prepareBlock;
{
    NSAssert(prepareBlock != nil, @"No prepareBlock provided");
    
    JXStatusBarStyle *style = [[self sharedInstance].defaultStyle copy];
    [JXStatusBarController sharedInstance].defaultStyle = prepareBlock(style);
}

+ (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JXPrepareStyleBlock)prepareBlock;
{
    return [[JXStatusBarController sharedInstance] addStyleNamed:identifier
                                                           prepare:prepareBlock];
}

+ (BOOL)isVisible;
{
    return [[JXStatusBarController sharedInstance] isVisible];
}

#pragma mark implementation

-(instancetype)init
{
    if (_sharedInstance) {
        return _sharedInstance;
    }
    self = [super init];
    if (self) {
        [self setUpDefaultStyles];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrame:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Custom styles

-(void)setUpDefaultStyles
{
    self.defaultStyle = [JXStatusBarStyle setUpStyleWithName:JXStatusBarStyleDefault];
    
    for (NSString *styleName in [JXStatusBarStyle allDefaultStyleIdentifier]) {
        [self.userStyles setObject:[JXStatusBarStyle setUpStyleWithName:styleName] forKey:styleName];
    }
}

-(NSString *)addStyleNamed:(NSString *)identifier
                  prepare:(JXPrepareStyleBlock)prepareBlock
{
    JXStatusBarStyle *style = [self.defaultStyle copy];
    [self.userStyles setObject:prepareBlock(style) forKey:identifier];
    return identifier;
}

#pragma mark show

-(UIView *)showWithTitle:(NSString *)title
               styleName:(NSString *)styleName
{
    JXStatusBarStyle *style = nil;
    if (styleName) {
        style = self.userStyles[styleName];
    }
    
    if (!style) style = self.defaultStyle;
    return [self showWithTitle:title style:style];
}

-(UIView *)showWithTitle:(NSString *)title
                    style:(JXStatusBarStyle *)style
{
    if ([UIApplication sharedApplication].statusBarHidden) return nil;
    
    if (style != self.activeStyle) {
        self.activeStyle = style;
        if (self.activeStyle.animationType == JXStatusBarAnimationTypeFade) {
            self.topBar.alpha = 0.0;
            self.topBar.transform = CGAffineTransformIdentity;
        } else {
            self.topBar.alpha = 1.0;
            self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
        }
    }
    
    [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(dismiss) target:self argument:nil];
    [self.topBar.layer removeAllAnimations];
    
    [self.overlayWindow setHidden:NO];
    
    self.topBar.backgroundColor = style.barColor;
    self.topBar.textVerticalPositionAdjustment = style.textVerticalPositionAdjustment;
    UIButton *textButton = self.topBar.textButton;
    textButton.titleLabel.textColor = style.textColor;
    textButton.titleLabel.font = style.font;
    textButton.titleLabel.accessibilityLabel = title;
    [textButton setTitle:title forState:UIControlStateNormal];
    [textButton setTitleColor:style.textColor forState:UIControlStateNormal];
    
    if (style.textShadow) {
        textButton.titleLabel.shadowColor = style.textShadow.shadowColor;
        textButton.titleLabel.shadowOffset = style.textShadow.shadowOffset;
    } else {
        textButton.titleLabel.shadowColor = nil;
        textButton.titleLabel.shadowOffset = CGSizeZero;
    }
    
    BOOL animationsEnabled = (style.animationType != JXStatusBarAnimationTypeNone);
    if (animationsEnabled && style.animationType == JXStatusBarAnimationTypeBounce) {
        [self animateInWithBounceAnimation];
    } else {
        [UIView animateWithDuration:(animationsEnabled ? 0.4 : 0.0) animations:^{
            self.topBar.alpha = 1.0;
            self.topBar.transform = CGAffineTransformIdentity;
        }];
    }
    
    return self.topBar;
}
#pragma mark 时间间隔

- (void)setDismissTimerWithInterval:(NSTimeInterval)interval;
{
    [self.dismissTimer invalidate];
    self.dismissTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]
                                                 interval:0 target:self selector:@selector(dismiss:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.dismissTimer forMode:NSRunLoopCommonModes];
}

- (void)dismiss:(NSTimer*)timer;
{
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated;
{
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    
    BOOL animationsEnabled = (self.activeStyle.animationType != JXStatusBarAnimationTypeNone);
    animated &= animationsEnabled;
    
    dispatch_block_t animation = ^{
        if (self.activeStyle.animationType == JXStatusBarAnimationTypeFade) {
            self.topBar.alpha = 0.0;
        } else {
            self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
        }
    };
    
    void(^complete)(BOOL) = ^(BOOL finished) {
        [self.overlayWindow removeFromSuperview];
        [self.overlayWindow setHidden:YES];
        _overlayWindow.rootViewController = nil;
        _overlayWindow = nil;
        _topBar = nil;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.4 animations:animation completion:complete];
    } else {
        animation();
        complete(YES);
    }
}

#pragma mark Bounce Animation

- (void)animateInWithBounceAnimation;
{
    if (self.topBar.frame.origin.y >= 0) {
        return;
    }
    
    CGFloat(^RBBEasingFunctionEaseOutBounce)(CGFloat) = ^CGFloat(CGFloat t) {
        if (t < 4.0 / 11.0) return pow(11.0 / 4.0, 2) * pow(t, 2);
        if (t < 8.0 / 11.0) return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2);
        if (t < 10.0 / 11.0) return 15.0 /16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2);
        return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2);
    };
    
    int fromCenterY=-20, toCenterY=0, animationSteps=100;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:animationSteps];
    for (int t = 1; t<=animationSteps; t++) {
        float easedTime = RBBEasingFunctionEaseOutBounce((t*1.0)/animationSteps);
        float easedValue = fromCenterY + easedTime * (toCenterY-fromCenterY);
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, easedValue, 0)]];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.66;
    animation.values = values;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [self.topBar.layer setValue:@(toCenterY) forKeyPath:animation.keyPath];
    [self.topBar.layer addAnimation:animation forKey:@"JXBounceAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
    self.topBar.transform = CGAffineTransformIdentity;
    [self.topBar.layer removeAllAnimations];
}

#pragma mark State

- (BOOL)isVisible;
{
    return (_topBar != nil);
}

#pragma mark getter/setter
-(NSMutableDictionary *)userStyles
{
    if (!_userStyles) {
        _userStyles = [NSMutableDictionary dictionary];
    }
    return _userStyles;
}

- (UIWindow *)overlayWindow;
{
    if(_overlayWindow == nil) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
//        _overlayWindow.userInteractionEnabled = NO;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        _overlayWindow.rootViewController = [[JXStatusBarViewController alloc] init];
        _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // < ios7
        _overlayWindow.rootViewController.wantsFullScreenLayout = YES;
#endif
        [self updateWindowTransform];
        [self updateTopBarFrameWithStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
        
    }
    return _overlayWindow;
}

-(JXStatusBarView *)topBar
{
    if(!_topBar) {
        _topBar = [[JXStatusBarView alloc] init];
        [_topBar.textButton addTarget:self action:@selector(showNotificationClick:)
                                 forControlEvents:UIControlEventTouchUpInside];
        [self.overlayWindow.rootViewController.view addSubview:_topBar];
        
        JXStatusBarStyle *style = self.activeStyle ?: self.defaultStyle;
        if (style.animationType != JXStatusBarAnimationTypeFade) {
            self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
        } else {
            self.topBar.alpha = 0.0;
        }
    }
    return _topBar;
}

#pragma mark 屏幕旋转

- (void)updateWindowTransform;
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    _overlayWindow.transform = window.transform;
    _overlayWindow.frame = window.frame;
}

- (void)updateTopBarFrameWithStatusBarFrame:(CGRect)rect;
{
    CGFloat width = MAX(rect.size.width, rect.size.height);
    CGFloat height = MIN(rect.size.width, rect.size.height);
    
    // on ios7 fix position, if statusBar has double height
    CGFloat yPos = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && height > 20.0) {
        yPos = -height/2.0;
    }
    
    _topBar.frame = CGRectMake(0, yPos, width, height);
    _overlayWindow.frame = _topBar.frame;
    _overlayWindow.rootViewController.view.frame = _topBar.frame;
}

- (void)willChangeStatusBarFrame:(NSNotification*)notification;
{
    CGRect newBarFrame = [notification.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];

    NSTimeInterval duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];
    
    void(^updateBlock)() = ^{
        [self updateWindowTransform];
        [self updateTopBarFrameWithStatusBarFrame:newBarFrame];
    };
    
    [UIView animateWithDuration:duration animations:^{
        updateBlock();
    } completion:^(BOOL finished) {
        updateBlock();
    }];
}

#pragma mark Response event

- (void)showNotificationClick:(UIButton*)sender
{
    self.notificationClickBlock(sender);
    [self dismissAnimated:YES];
}

@end

@implementation JXStatusBarViewController

-(UIViewController *)mainController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

/*
 * 项目中，只有个别控制器允许横屏
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [[self mainController] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    return [[self mainController] shouldAutorotate];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
    - (NSUInteger)supportedInterfaceOrientations {
#else
    - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
#endif
    return [[self mainController] supportedInterfaceOrientations];
}
    
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self mainController] preferredInterfaceOrientationForPresentation];
}

static BOOL JXUIViewControllerBasedStatusBarAppearanceEnabled() {
    static BOOL enabled = NO;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        enabled = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue];
    });
    
    return enabled;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if(JXUIViewControllerBasedStatusBarAppearanceEnabled()) {
        return [[self mainController] preferredStatusBarStyle];
    }
    
    return [[UIApplication sharedApplication] statusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if(JXUIViewControllerBasedStatusBarAppearanceEnabled()) {
        return [[self mainController] preferredStatusBarUpdateAnimation];
    }
    return [super preferredStatusBarUpdateAnimation];
}

@end
