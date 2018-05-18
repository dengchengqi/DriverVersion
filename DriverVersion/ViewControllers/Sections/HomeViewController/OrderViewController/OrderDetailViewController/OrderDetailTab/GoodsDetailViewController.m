
//
//  GoodsDetailViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsDetailOneCell.h"
#import "GoodsDetailTwoCell.h"
#import "GoodsDetailThreeCell.h"
#import "GoodsDetailFourCell.h"
#import "OrderCarDetailModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
NSString * const GoodsDetailOneCellIdentifier = @"GoodsDetailOneCellIdentifier";
NSString * const GoodsDetailTwoCellIdentifier = @"GoodsDetailTwoCellIdentifier";
NSString * const GoodsDetailThreeCellIdentifier = @"GoodsDetailThreeCellIdentifier";
NSString * const GoodsDetailFourCellIdentifier = @"GoodsDetailFourCellIdentifier";
@class XLPagerTabStripViewController;
@interface GoodsDetailViewController ()

@end

@implementation GoodsDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
- (CGRect)getTableViewFrame{
    CGRect  frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 44 -10);
    return frame;
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsDetailOneCell class]) bundle:nil] forCellReuseIdentifier:GoodsDetailOneCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsDetailTwoCell class]) bundle:nil] forCellReuseIdentifier:GoodsDetailTwoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsDetailThreeCell class]) bundle:nil] forCellReuseIdentifier:GoodsDetailThreeCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsDetailFourCell class]) bundle:nil] forCellReuseIdentifier:GoodsDetailFourCellIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"货源详情";
    
}

- (NSString *)getDescriptionText{
    
    NSString * description = @"暂无数据~!";
    
    return description;
}

- (void)updateTableView{
//    NSDictionary * one = @{@"title":@"货单号",@"detail":self.infoModel.good_num,@"icon":@"survey",@"detail_2":@""};
//    NSDictionary * two = @{@"title":@"装货点",@"detail":self.infoModel.good_num,@"icon":@"map",@"detail_2":@""};
//    NSDictionary * three = @{@"title":@"卸货点",@"detail":self.infoModel.good_num,@"icon":@"map",@"detail_2":@""};
//    NSDictionary * four = @{@"title":@"货单号",@"detail":self.infoModel.good_num,@"icon":@"map",@"detail_2":@""};
//    NSDictionary * five = @{@"title":@"货单号",@"detail":self.infoModel.good_num,@"icon":@"",@"detail_2":@""};
//    NSDictionary * six = @{@"title":@"货单号",@"detail":self.infoModel.good_num,@"icon":@"",@"detail_2":@""};
//    NSDictionary * seven = @{@"title":@"货单号",@"detail":self.infoModel.good_num,@"icon":@"",@"detail_2":@""};
//    NSDictionary * eight = @{@"title":@"货单号",@"detail":self.infoModel.good_num,@"icon":@"",@"detail_2":@""};
//    self.carDetalArray = @[one,two,three,four,five,six,seven,eight];
    [super updateTableView];
}
#define mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if (self.infoModel) {
        section = 1;
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6 + [self.infoModel.unload count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50;
  if (indexPath.row == 5 + [self.infoModel.unload count]) {
      height = [tableView fd_heightForCellWithIdentifier:GoodsDetailFourCellIdentifier configuration:^(id cell) {
          [self configthCell:cell withIndexPath: indexPath];
      }] +1;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   ;
    
    UITableViewCell *cell =  nil;
    if (indexPath.row == 0) {
       GoodsDetailOneCell *tempCell = [tableView dequeueReusableCellWithIdentifier:GoodsDetailOneCellIdentifier];
        [tempCell setupIcon:@"survey" Title:@"货单号"  withDetail:self.infoModel.good_num];
        cell = tempCell;
    }else if (indexPath.row == 1){
        
        GoodsDetailTwoCell *tempCell = [tableView dequeueReusableCellWithIdentifier:GoodsDetailTwoCellIdentifier];
        [tempCell setupIcon:@"map" Title:@"装货点"  withDetail:self.infoModel.loading  withAddress:self.infoModel.loading_address];
        cell = tempCell;
    }else if (indexPath.row > 1 && indexPath.row < (2+ [self.infoModel.unload count])){
        
       GoodsDetailTwoCell *tempCell = [tableView dequeueReusableCellWithIdentifier:GoodsDetailTwoCellIdentifier];
        NSString *unload =  self.infoModel.unload[indexPath.row -2];
        NSString *unload_address =  self.infoModel.unload_address[indexPath.row -2];
        [tempCell setupIcon:@"map" Title:@"卸货点"  withDetail:unload  withAddress:unload_address];
         cell = tempCell;
    }else if (indexPath.row >= (2+ [self.infoModel.unload count]) && indexPath.row< 5+ [self.infoModel.unload count]){
         GoodsDetailThreeCell *tempCell = [tableView dequeueReusableCellWithIdentifier:GoodsDetailThreeCellIdentifier];
        NSString * title = @"";
        NSString * detail = @"";
        if(indexPath.row == (2+ [self.infoModel.unload count])){
            title = @"预计里程";
             detail = self.infoModel.mileage;
        }else if(indexPath.row == (3+ [self.infoModel.unload count])){
            title = @"用车时间";
            detail = self.infoModel.use_time;
        }else if(indexPath.row == (4+ [self.infoModel.unload count])){
            title = @"货物名称";
            detail = self.infoModel.type;
        }
        [tempCell setupTitle:title withDetail:detail];
         cell = tempCell;
    }else if (indexPath.row == 5 + [self.infoModel.unload count]){
         GoodsDetailFourCell  *tempCell =[tableView dequeueReusableCellWithIdentifier:GoodsDetailFourCellIdentifier];
        [self  configthCell:tempCell withIndexPath:indexPath];
         cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configthCell:(GoodsDetailFourCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    NSString * title = @"货物备注";
    NSString * detail = self.infoModel.remark;
    [cell setupTitle:title withDetail:detail];
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
    if (indexPath.row >= 1 && indexPath.row < (2+ [self.infoModel.unload count])){
        NSString * latitude = @"";
        NSString * longitude = @"";
        if (indexPath.row == 1) {
            latitude = self.infoModel.lat;
            longitude =  self.infoModel.lon;
        }else{
            latitude = self.infoModel.lats[indexPath.row-2];
            longitude = self.infoModel.lons[indexPath.row-2];
            
        }
        [self gotoGDMapAppLat:latitude withLon:longitude ];
    }
    
}

- (void)gotoGDMapAppLat:(NSString *)latitude withLon:(NSString *)longitude{
    NSURL *scheme = [NSURL URLWithString:@"iosamap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if (!canOpen) {
       NSArray *items =@[MMItemMake(@"确定", MMItemTypeHighlight, nil),
                 ];
        AlertView * alertView = [[AlertView alloc]initWithTitle:@"提示" detail:@"请安装高德地图" items:items];
        [alertView show];
        return;
    }
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"鲁明危运",@"",[ latitude floatValue], [longitude floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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
