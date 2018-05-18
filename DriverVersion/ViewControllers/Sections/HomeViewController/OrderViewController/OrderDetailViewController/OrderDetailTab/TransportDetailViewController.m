

//
//  TransportDetailViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "TransportDetailViewController.h"
#import "TransportDetailCell.h"
#import "TransportDetailModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
NSString * const TransportDetailCellIdentifier = @"TransportDetailCellIdentifier";

@class XLPagerTabStripViewController;
@interface TransportDetailViewController ()
@property(nonatomic, copy) NSNumber *orderId;
@property(nonatomic, strong) TransportDetailModel * detailModel;
@end

@implementation TransportDetailViewController
- (instancetype)initWithOrderId:(NSNumber *)orderId{
    self = [super init];
    if (self) {
        self.orderId = orderId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestRunDetails];
}
- (void)requestRunDetails{
    NSDictionary * parameterDic = @{@"id":self.orderId};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_run_details] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_run_details];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_run_details) {
            NSLog(@"==%@",successInfoObj);
            strongSelf.detailModel = [[TransportDetailModel  alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf updateTableView];
        }
    }];
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"运输信息";
    
}

- (NSString *)getDescriptionText{
    
    NSString * description = @"请先在指定地点完成装货";
    
    return description;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
 
    return [UIImage imageNamed:@"dabaoguo"];
}
- (UIColor *)getDescriptionTextColor{
    return UIColorFromRGB(0xCCCCCC);
}
- (UIFont *)getDescriptionTextFont{
    return fontSize_14;
}

#pragma mark ---

- (void)registerCell{
    
    [self.tableView registerClass:[TransportDetailCell class] forCellReuseIdentifier:TransportDetailCellIdentifier];
  
}
- (CGRect)getTableViewFrame{
    CGRect  frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height - 49 - 44 -10);
    return frame;
}
#define mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if (self.detailModel) {
        section = 1;
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.detailModel.info count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
   
    TransportInfoDetailModel * model = self.detailModel.info[indexPath.row];
    height = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"infoDetailModel" cellClass:[TransportDetailCell class] contentViewWidth:[self cellContentViewWith]];
    return height;
   
}


- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.tableView.editing) {
        
        width = width - FITSCALE(40);
    }
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    
    TransportDetailCell *tempCell = [tableView dequeueReusableCellWithIdentifier:TransportDetailCellIdentifier];
     TransportInfoDetailModel * model = self.detailModel.info[indexPath.row];
    tempCell.infoDetailModel = model;
    [tempCell setupWithIndexPath:indexPath withEnd:[self.detailModel.info count]-1];
    cell = tempCell;
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
    return 0;
}
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
