//
//  JXTableView.m
//  JXKitDemo
//
//  Created by admin on 16/5/31.
//
//

#import "JXTableView.h"

@interface JXTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSArray *data;

@end

@implementation JXTableView
@synthesize data = _data;

+(JXTableView *)initTableViewWithFrame:(CGRect)frame
{
    return [[[self class] alloc] initWithFrame:frame style:UITableViewStyleGrouped];
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark -- tableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.didSelectRowBlock(indexPath);
}

#pragma mark -- dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

// cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"identifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    }
    
    NSDictionary *data = self.data[indexPath.section][indexPath.row];
    cell.textLabel.text = data[@"JXButtonName"];
    cell.detailTextLabel.text = data[@"JXButtonInfo"];
    
//    cell.textLabel.text = @"123";
//    cell.detailTextLabel.text = @"12312";
    
    cell.textLabel.backgroundColor = [UIColor redColor];
    cell.textLabel.backgroundColor = [UIColor greenColor];
    
    return cell;
}

// cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [UIView new];
}

// 底视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return [UIView new];
}

// 头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

// 底高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark ReloadData
-(void)reloadDataWithArray:(NSArray *)data;
{
    _data = data;
    [self reloadData];
}

@end
