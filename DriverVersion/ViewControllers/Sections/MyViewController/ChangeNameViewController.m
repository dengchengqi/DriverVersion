
//
//  ChangeNameViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "ChangeNameCell.h"


NSString * const   ChangeNameCellIdentifier = @"ChangeNameCellIdentifier";
@interface ChangeNameViewController ()
@property(nonatomic, copy) NSString * nickName;
@end

@implementation ChangeNameViewController
- (instancetype)initNickName:(NSString *)nickName{
    self = [super init];
    if (self) {
        self.nickName = nickName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"修改昵称"];
}
- (void)registerCell{
    
 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChangeNameCell class]) bundle:nil] forCellReuseIdentifier:ChangeNameCellIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    ChangeNameCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ChangeNameCellIdentifier];
    [tempCell setupNickNameDefault:self.nickName];
    WEAKSELF
    tempCell.changeBlock = ^(NSString *nickName) {
        STRONGSELF
        strongSelf.nickName = nickName;
    
    };
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,80)];
    UIButton * button = [UIButton  buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:UIColorFromRGB(0x028BF3)];
    [button addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    NSString * buttonTitle = @"保存";
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setFrame:CGRectMake(10, 18, self.view.frame.size.width-20, 44)];
    [footerView addSubview:button];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sureAction{
    NSDictionary *parameterDic = @{@"mobile": [[SessionHelper sharedInstance] getSessionPhone],@"car_name":self.nickName};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_amend] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_amend];
    
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if(request.tag == NetRequestType_amend){
            NSLog(@"=%@=",successInfoObj[@"info"]);
            [strongSelf updateTableView];
            [strongSelf  showSaveSucessAlert];
        }
    }];
}
- (void)showSaveSucessAlert{
    MMPopupItemHandler backBlock = ^(NSInteger index){
         [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USER_INFO object: nil];
        //刷新上一页的用户图片
        UIViewController *target = nil;
       target = self.navigationController.viewControllers[ [self.navigationController.viewControllers count] - 3];
        if (target) {
            [self.navigationController popToViewController:target animated:YES]; //跳转
        } 
    };
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, backBlock)];
    [self showNormalAlertTitle:@"提示" content:@"修改昵称成功" items:items block:nil];
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
