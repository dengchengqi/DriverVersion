
//
//  TransportViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "TransportViewController.h"
#import "LoadingGoodsCell.h"
 #import "HomeOrderModel.h"
NSString * const TransportCellIdentifier = @"TransportCellIdentifier";
@class XLPagerTabStripViewController;
@interface TransportViewController ()

@end

@implementation TransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (CGRect)getTableViewFrame{
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 49);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"运输中";
    
}

- (NSString *)getDescriptionText{
    
    NSString * description = @"暂无数据~!";
    return description;
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadingGoodsCell class]) bundle:nil] forCellReuseIdentifier:TransportCellIdentifier];
}
#define mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
      return [self.homeOrderModel.info count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LoadingGoodsCell *cell = [ tableView dequeueReusableCellWithIdentifier:TransportCellIdentifier];
       [cell setupModel:self.homeOrderModel.info[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selctedBlock) {
        HomeDaiZhuangHuoModel * model = self.homeOrderModel.info[indexPath.section];
        self.selctedBlock(model.id,model.good_num);
    }
}
- (BOOL)isAddRefreshHeader{
    return YES;
}

- (BOOL)isAddRefreshFooter{
    return YES;
}
- (BOOL)loadViewIsRefresh{
    return NO;
}
- (void)getLoadMoreTableViewNetworkData{
    if (self.LoadingOrderListBlock) {
         self.LoadingOrderListBlock(1);
    } 
}
- (void)drogDownRefresh{
 self.updateBlock(1);
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    NSLog(@"%s",__FUNCTION__);
    
    [self drogDownRefresh];
}

- (UIColor *)getNavigationColor{
    
    return project_main_color;
}

- (UIColor *)getNavigationTitleColor{
    
    return [UIColor whiteColor];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
