
//
//  CompleteViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CompleteViewController.h"
#import "LoadingGoodsCell.h"
#import "HomeOrderModel.h"
NSString * const CompleteIdentifier = @"CompleteIdentifier";

@class XLPagerTabStripViewController;
@interface CompleteViewController ()

@end

@implementation CompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)loadViewIsRefresh{
    return NO;
}
- (BOOL)isAddRefreshFooter{
    return YES;
}
- (CGRect)getTableViewFrame{
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 49);
}
- (void)getLoadMoreTableViewNetworkData{
    if (self.LoadingOrderListBlock) {
          self.LoadingOrderListBlock(2);
    } 
}
- (void)drogDownRefresh{
    self.updateBlock(2);
}
- (BOOL)isAddRefreshHeader{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"已完成";
    
}

- (NSString *)getDescriptionText{
    
    NSString * description = @"暂无数据~!";
    
    return description;
}


- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadingGoodsCell class]) bundle:nil] forCellReuseIdentifier:CompleteIdentifier];
}
#define mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger  sections = 1;
    if (self.homeOrderModel) {
        sections =  [self.homeOrderModel.info count];
    }
      return  sections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       NSInteger  row = 0;
    if (self.homeOrderModel) {
        row =  1;
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LoadingGoodsCell *cell = [ tableView dequeueReusableCellWithIdentifier:CompleteIdentifier];
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
