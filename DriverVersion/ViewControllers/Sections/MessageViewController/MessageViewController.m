//
//  MessageViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/14.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MessageViewController.h"
#import "TNTabbarController.h"
#import "MessageListCell.h"
#import "MessageTypeListViewController.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "JPUSHService.h"
NSString * const MessageListCellIdentifier  = @"MessageListCellIdentifier";
@interface MessageViewController ()
@property(nonatomic, strong) NSDictionary * messageNumDic;
@end

@implementation MessageViewController
-(instancetype)init{
    self = [super init];
    if (self) {
        [self registerJPush];
    }
    return self;
}
- (void)registerJPush{
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(networkDidSetup:)
    //                          name:kJPFNetworkDidSetupNotification
    //                        object:nil];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(networkDidClose:)
    //                          name:kJPFNetworkDidCloseNotification
    //                        object:nil];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(networkDidRegister:)
    //                          name:kJPFNetworkDidRegisterNotification
    //                        object:nil];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(networkDidLogin:)
    //                          name:kJPFNetworkDidLoginNotification
    //                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(serviceError:)
    //                          name:kJPFServiceErrorNotification
    //                        object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"消息"];
}
- (void)networkDidReceiveMessage:(NSNotification *)notification{
    [self   requestShuliangs];
}
- (void)requestShuliangs{
    NSString *phone = [[SessionHelper sharedInstance]getSessionPhone];
    NSDictionary * parameterDic = @{@"mobile":phone};
    
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_shuliangs] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_shuliangs];
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_shuliangs) {
            NSLog(@"==%@",successInfoObj);
            strongSelf.messageNumDic = [[NSDictionary alloc]initWithDictionary:successInfoObj[@"info"]];
            [strongSelf updateTableView];
        }
    }];
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageListCell class]) bundle:nil] forCellReuseIdentifier:MessageListCellIdentifier];
}
- (BOOL )isShowBackItem{
    
    return NO;
}
- (BOOL)getNavBarBgHidden{
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    MessageListCell * tempCell = [tableView dequeueReusableCellWithIdentifier:MessageListCellIdentifier];
    NSString * iconName = @"";
    NSString * title = @"";
    NSInteger  number = 0;
    if (indexPath.row == 0) {
        iconName = @"lab";
        title = @"系统通知";
        number = [self.messageNumDic[@"message_num"] integerValue];
    }else{
        
        iconName = @"wodecheliang";
        title = @"运输动态";
        number = [self.messageNumDic[@"carriage_num"] integerValue];
    }

    [tempCell setupIcon:iconName withTitle:title withNumber:number];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self gotoMessageTypeListVCType:MessageListType_system];
    }else if(indexPath.row == 1){
        [self gotoMessageTypeListVCType:MessageListType_transport];
    }
   
}

- (void)gotoMessageTypeListVCType:(MessageListType) type{
    
    MessageTypeListViewController * listVC = [[MessageTypeListViewController alloc]initWithType:type];
    [self pushViewController:listVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tnTabbarController setIsTabbarHidden:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tnTabbarController setIsTabbarHidden:NO];
    [super viewWillAppear:animated];
    [self requestShuliangs];
    
}

- (UIColor *)getNavigationColor{
    
    return project_main_color;
}

- (UIColor *)getNavigationTitleColor{
    
    return project_Nav_title_color;
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
