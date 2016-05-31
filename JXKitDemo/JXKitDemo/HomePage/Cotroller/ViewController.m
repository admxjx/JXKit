//
//  ViewController.m
//  JXKitDemo
//
//  Created by admin on 16/5/30.
//
//

#import "ViewController.h"
#import "JXTableView.h"
#import "JXStatusBarController.h"

static NSString *const JXButtonName = @"JXButtonName";
static NSString *const JXButtonInfo = @"JXButtonInfo";
static NSString *const JXNotificationText = @"JXNotificationText";

static NSString *const SBStyle1 = @"SBStyle1";
static NSString *const SBStyle2 = @"SBStyle2";

@interface ViewController ()
@property (nonatomic, strong) JXTableView *tableView;
@property (nonatomic, strong) NSArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JXStatusBarNotification";
    // 自定义样式
    [self setUpCustomStyle];
    // tableView
    [self.view addSubview:self.tableView];
        // tableView block 响应事件;
    [self setUpTableViewResponseEvent];
        // tableView reloadData;
    [self.tableView reloadDataWithArray:self.data];
}

#pragma mark SetUpJXStatus
-(void)setUpCustomStyle{
    [JXStatusBarController addStyleNamed:SBStyle1
                                 prepare:^JXStatusBarStyle *(JXStatusBarStyle *style) {
                                     style.barColor = [UIColor colorWithRed:0.797 green:0.000 blue:0.662 alpha:1.000];
                                     style.textColor = [UIColor whiteColor];
                                     style.animationType = JXStatusBarAnimationTypeFade;
                                     style.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:17.0];
                                     return style;
                                 }];
    
    [JXStatusBarController addStyleNamed:SBStyle2
                                 prepare:^JXStatusBarStyle *(JXStatusBarStyle *style) {
                                     style.barColor = [UIColor cyanColor];
                                     style.textColor = [UIColor colorWithRed:0.056 green:0.478 blue:0.998 alpha:1.000];
                                     style.animationType = JXStatusBarAnimationTypeBounce;
                                     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                                         style.font = [UIFont fontWithName:@"DINCondensed-Bold" size:17.0];
                                         style.textVerticalPositionAdjustment = 2.0;
                                     } else {
                                         style.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0];
                                     }
                                     return style;
                                 }];
}

#pragma mark -- ResponseEvent
-(void)setUpTableViewResponseEvent
{
    __weak typeof(self) weakSelf = self;
    self.tableView.didSelectRowBlock = ^(NSIndexPath *indexPath){
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        
        NSDictionary *data = weakSelf.data[indexPath.section][indexPath.row];
        NSString *status = data[JXNotificationText];
        
        // show notification
        if (section == 0) {
            if (row == 0) {
                [JXStatusBarController showWithTitle:status];
            }  else if (row == 1) {
                [JXStatusBarController dismiss];
            }
        } else if (section == 1) {
            NSString *style = JXStatusBarStyleError;
            if (row == 1) {
                style = JXStatusBarStyleWarning;
            } else if(row == 2) {
                style = JXStatusBarStyleSuccess;
            } else if(row == 3) {
                style = JXStatusBarStyleDark;
            } else if(row == 4) {
                style = JXStatusBarStyleMatrix;
            }
            
            [JXStatusBarController showWithTitle:status
                                       dismissAfter:2.0
                                          styleName:style];
        } else if (section == 2) {
            NSString *style = (row==0) ? SBStyle1 : SBStyle2;
            [JXStatusBarController showWithTitle:status
                                       dismissAfter:4.0
                                          styleName:style];
        }
    };
    
    [JXStatusBarController sharedInstance].notificationClickBlock = ^(UIButton *btn){
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.view.backgroundColor = [UIColor whiteColor];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
}

#pragma mark -- setter/getter
-(JXTableView *)tableView
{
    if (!_tableView) {
        _tableView = [JXTableView initTableViewWithFrame:self.view.frame];
    }
    return _tableView;
}

-(NSArray *)data
{
    if(!_data){
        _data = @[@[@{JXButtonName:@"显示推送", JXButtonInfo:@"默认样式,点击TopBar跳转", JXNotificationText:@"Hello Word!"},
                    @{JXButtonName:@"隐藏推送", JXButtonInfo:@"Animated", JXNotificationText:@""}],
                  @[@{JXButtonName:@"样式:JXStatusBarStyleError", JXButtonInfo:@"持续: 2s", JXNotificationText:@"Error：。。。。"},
                    @{JXButtonName:@"样式:JXStatusBarStyleWarning", JXButtonInfo:@"持续: 2s", JXNotificationText:@"！Warning：。。。。。"},
                    @{JXButtonName:@"样式:JXStatusBarStyleSuccess", JXButtonInfo:@"持续: 2s", JXNotificationText:@"Success!"},
                    @{JXButtonName:@"样式:JXStatusBarStyleDark", JXButtonInfo:@"持续: 2s", JXNotificationText:@"Dark：。。。。"},
                    @{JXButtonName:@"样式:JXStatusBarStyleMatrix", JXButtonInfo:@"持续: 2s", JXNotificationText:@"Matrix"}],
                  @[@{JXButtonName:@"自定义样式:style 1", JXButtonInfo:@"持续: 4s, 动画效果:JXStatusBarAnimationTypeFade", JXNotificationText:@"Oh, I love it!"},
                    @{JXButtonName:@"自定义样式:style 2", JXButtonInfo:@"持续: 4s, 动画效果:JXStatusBarAnimationTypeBounce", JXNotificationText:@"Level up!"}]
                ];
    }
    return _data;
}

@end
