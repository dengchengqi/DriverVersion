

//
//  MessageTypeListViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MessageTypeListViewController.h"
#import "MessageDetailViewController.h"
#import "MessageTransportCell.h"
#import "MessageSystemTypeCell.h"
#import "DynamicListModel.h"
#import "MessageListModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
NSString * const  MessageTransportCellIdentifier = @"MessageTransportCellIdentifier";
NSString * const  MessageSystemTypeCellIdentifier = @"MessageSystemTypeCellIdentifier";

@interface MessageTypeListViewController ()
@property(nonatomic, assign) MessageListType  type;
@property(nonatomic, strong) MessageListModel * messageModel;
@property(nonatomic, strong) DynamicListModel * dynamicModel;
@end

@implementation MessageTypeListViewController
- (instancetype)initWithType:(MessageListType )type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * navTitle = @"";
    NetRequestType type = NetRequestType_message;
    if (self.type == MessageListType_system) {
        navTitle = @"系统通知";
        type = NetRequestType_message;
    }else if (self.type == MessageListType_transport){
        navTitle = @"运输动态";
        type = NetRequestType_message_dynamic;
    }
    [self requestMessage:type];
    [self setNavigationItemTitle:navTitle];
    [self setupRightBarItem];
}
- (void)requestMessage:(NetRequestType)type {
     NSString *phone = [[SessionHelper sharedInstance]getSessionPhone];
    NSDictionary * parameterDic = @{@"mobile":phone};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:type] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:type];
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_message) {
            NSLog(@"==%@==",successInfoObj);
            strongSelf.messageModel =  [[MessageListModel alloc]initWithDictionary:successInfoObj error:nil];
            if ([strongSelf.messageModel.info count] > 0) {
                strongSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
            }
        }else if (request.tag == NetRequestType_message_dynamic){
             NSLog(@"==%@==",successInfoObj);
             strongSelf.dynamicModel =  [[DynamicListModel alloc]initWithDictionary:successInfoObj error:nil];
            if ([strongSelf.dynamicModel.info count] > 0) {
                strongSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
            }
        }else if (request.tag == NetRequestType_delete_dynamic){
             NSLog(@"==%@==",successInfoObj);
            strongSelf.dynamicModel = nil;
            [strongSelf showClearAlert];
            strongSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
            
        }else if (request.tag == NetRequestType_deletemessage){
             NSLog(@"==%@==",successInfoObj);
             strongSelf.messageModel = nil;
            [strongSelf showClearAlert];
            strongSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
        [strongSelf updateTableView];
    }];
}
- (void)showClearAlert{
    
    NSString * title = @"提示";
    NSString * content = @"消息列表已清空";
    MMPopupItemHandler backBlock = ^(NSInteger index){
        [self backViewController];
    };
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, backBlock)];
    [self showNormalAlertTitle:title content:content items:items block:nil];
}
- (void)setupRightBarItem{
    UIButton * rightButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButtonView setTitle:@"清空" forState:UIControlStateNormal];
    [rightButtonView setTitleColor:UIColorFromRGB(0x242424) forState:UIControlStateNormal];
    [rightButtonView setFrame:CGRectMake(0, 0, 60, 44)];
    [rightButtonView addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    rightButtonView.hidden = YES;
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageTransportCell class]) bundle:nil] forCellReuseIdentifier:MessageTransportCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageSystemTypeCell class]) bundle:nil] forCellReuseIdentifier:MessageSystemTypeCellIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoMessageDetailVC:(NSString *)id{
    MessageDetailViewController * detailVC = [[MessageDetailViewController alloc]initWithId:id];
    [self pushViewController:detailVC];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (self.type == MessageListType_system) {
        row = [self.messageModel.info count];
    }else if(self.type == MessageListType_transport){
        row = [self.dynamicModel.info count];
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat  height = 0;
    if (self.type == MessageListType_transport) {
        height = [tableView fd_heightForCellWithIdentifier:MessageTransportCellIdentifier configuration:^(id cell) {
            [self configthTransportCell:cell withIndexPath: indexPath];
        }];
    }else if (self.type == MessageListType_system){
        height = [tableView fd_heightForCellWithIdentifier:MessageSystemTypeCellIdentifier configuration:^(id cell) {
            [self configthSystemCell:cell withIndexPath: indexPath];
        }];
    }
    return height ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    if (self.type == MessageListType_system) {
        MessageSystemTypeCell * tempCell = [tableView dequeueReusableCellWithIdentifier:MessageSystemTypeCellIdentifier];
        [self configthSystemCell:tempCell withIndexPath:indexPath];
        cell = tempCell;
    }else if (self.type == MessageListType_transport){
        MessageTransportCell * tempCell = [tableView dequeueReusableCellWithIdentifier:MessageTransportCellIdentifier];
        [self configthTransportCell:tempCell withIndexPath:indexPath];
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = tempCell;
    }
    return cell;
}
- (void)configthSystemCell:(MessageSystemTypeCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    [cell setupModel:self.messageModel.info[indexPath.row]];
}
- (void)configthTransportCell:(MessageTransportCell *)cell withIndexPath:(NSIndexPath *)indexPath {
     cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
      [cell setupModel:self.dynamicModel.info[indexPath.row]];
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
    if (self.type == MessageListType_system) {
        MessageInfoModel *info = self.messageModel.info[indexPath.row];
        [self gotoMessageDetailVC:info.id];
    }
   
}


- (void)clearAction{
    
    if (self.type == MessageListType_system) {
        [self requestMessage:NetRequestType_deletemessage];
    }else if (self.type == MessageListType_transport){
        [self requestMessage:NetRequestType_delete_dynamic];
    }
}


@end
