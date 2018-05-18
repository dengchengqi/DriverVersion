
//
//  LoadingGoodsViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "LoadingGoodsViewController.h"
#import "LoadingGoodsCell.h"
#import "HomeOrderModel.h"

NSString * const LoadingGoodsCellIdentifier = @"LoadingGoodsCellIdentifier";
@class XLPagerTabStripViewController;
@interface LoadingGoodsViewController ()

@end

@implementation LoadingGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"待装货";
    
}
- (NSString *)getDescriptionText{
    
    NSString * description = @"暂无数据~!";
    return description;
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadingGoodsCell class]) bundle:nil] forCellReuseIdentifier:LoadingGoodsCellIdentifier];
}
- (CGRect)getTableViewFrame{
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 49);
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
    
    LoadingGoodsCell *cell = [ tableView dequeueReusableCellWithIdentifier:LoadingGoodsCellIdentifier];
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
 
- (void)getLoadMoreTableViewNetworkData{
    self.LoadingOrderListBlock(0);
}
- (void)drogDownRefresh{
    
    self.updateBlock(0);
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    NSLog(@"%s",__FUNCTION__);
    
    [self drogDownbeginRefreshing];
}

- (UIColor *)getNavigationColor{
    
    return project_main_color;
}

- (UIColor *)getNavigationTitleColor{
    
    return [UIColor whiteColor];
}
#define mark ---
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
