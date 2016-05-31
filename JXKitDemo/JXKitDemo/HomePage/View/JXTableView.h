//
//  JXTableView.h
//  JXKitDemo
//
//  Created by admin on 16/5/31.
//
//

#import <UIKit/UIKit.h>

@interface JXTableView : UITableView
+(JXTableView *)initTableViewWithFrame:(CGRect)frame;

@property (copy) void(^didSelectRowBlock)(NSIndexPath *);

-(void)reloadDataWithArray:(NSArray *)data;
@end
