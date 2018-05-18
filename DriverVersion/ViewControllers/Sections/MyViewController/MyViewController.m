
//
//  MyViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/14.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MyViewController.h"
#import "TNTabbarController.h"
#import "MyListCell.h"
#import "MXNavigationBarManager.h"
#import "MyHeaderView.h"
#import "HelpViewController.h"
#import "ChangeInfoViewController.h"
#import "ShareViewController.h"


NSString *const MyListCellIdentifier = @"MyListCellIdentifier";
@interface MyViewController () 
@property(nonatomic, strong) NSArray * myArray;
@property(nonatomic, strong) MyHeaderView * headerView;
@property(nonatomic, strong) NSArray * infoArray;
@property(nonatomic, copy) NSString * nickName;
@property(nonatomic, copy) NSString * userImgUrl;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setNavigationItemTitle:@"我的"];
    NSArray * one = @[@{@"icon":@"lianxipingtai",@"title":@"联系平台"}];
    NSArray * two = @[@{@"icon":@"shiyongzhinan",@"title":@"使用指南"},@{@"icon":@"yaoqinghaoyou",@"title":@"邀请好友"}];
    self.myArray = @[one,two];
//    [self setupRightBarItem];
    [self setupTableViewHeaderView];
 
    [self requestInfo];
     self.view.backgroundColor = UIColorFromRGB(0xEDEFEF);
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:UPDATE_USER_INFO object:nil];
}
- (void)setupRightBarItem{
    UIButton * rightButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButtonView setImage:[UIImage imageNamed:@"XIN"] forState:UIControlStateNormal];
        [rightButtonView setImage:[UIImage imageNamed:@"xinyuandian"] forState:UIControlStateSelected];
    [rightButtonView addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
}
- (void)messageAction{
    
    
}

- (void)requestInfo{
    NSDictionary *parameterDic = @{@"mobile":[[SessionHelper sharedInstance] getSessionPhone]};
   [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_siji] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_siji];
}
- (void)requestionOperatingGuide{
    NSDictionary *parameterDic = @{@"mobile":[[SessionHelper sharedInstance] getSessionPhone]};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_hot_line] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_hot_line];
    

}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_hot_line) {
            NSLog(@"==%@=",successInfoObj);
            strongSelf.infoArray = successInfoObj[@"info"];
            if (strongSelf.infoArray && ![strongSelf.infoArray isKindOfClass:[NSNull class]]) {
                  [strongSelf showContact];
            }else{
                NSArray* items = @[MMItemMake(@"确定", MMItemTypeNormal, nil)];
                [strongSelf showNormalAlertTitle:@"提示" content:@"暂无联系人" items:items block:nil];
            }
           
        }else if (request.tag == NetRequestType_siji){
            NSString *  car_name  = successInfoObj[@"info"][@"car_name"];
            NSString * avatar_url = successInfoObj[@"info"][@"avatar_url"];
            strongSelf.userImgUrl = avatar_url;
            strongSelf.nickName = car_name;
             [strongSelf.headerView setupName:car_name withImg:avatar_url];
        }
    }];
}
- (void)setupTableViewHeaderView{
   
    [self.headerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    [self.headerView setupbgViewColor:project_main_color];
    self.tableView.tableHeaderView = self.headerView;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCountAction)];
    
    [self.headerView addGestureRecognizer:tap];
}
- (MyHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyHeaderView class]) owner:nil options:nil].firstObject;
    }
    return _headerView;
}
- (CGRect)getTableViewFrame{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return CGRectMake(0, - self.navigationController.navigationBar.frame.size.height- rectStatus.size.height, self.view.frame.size.width, self.view.frame.size.height + rectStatus.size.height);
}

- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}
- (BOOL )isShowBackItem{
    
    return NO;
}
- (BOOL)getNavBarBgHidden{
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tnTabbarController setIsTabbarHidden:YES];
//    self.tableView.delegate = nil;
//    [MXNavigationBarManager reStoreToSystemNavigationBar];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tnTabbarController setIsTabbarHidden:NO];
    [super viewWillAppear:animated];
   
//    [self initBarManager];
}

- (void)initBarManager {
    //optional, save navigationBar status
    
    //required
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
    
    //optional
    [MXNavigationBarManager setTintColor:[UIColor blackColor]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)registerCell{
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyListCell class]) bundle:nil] forCellReuseIdentifier:MyListCellIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  [self.myArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
      row =  [self.myArray[section] count];
 
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
  
    MyListCell * tempCell = [tableView dequeueReusableCellWithIdentifier:MyListCellIdentifier];
    NSArray * rowArray = self.myArray[indexPath.section];
    NSDictionary * dic = rowArray[indexPath.row];
    [tempCell setIcon:dic[@"icon"] withTitle:dic[@"title"]];
    cell = tempCell;
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.infoArray && ![self.infoArray isKindOfClass:[NSNull class]]) {
            [self showContact];
            
        }else{
            [self requestionOperatingGuide];
        }
    }else{
        if (indexPath.row == 0) {
            [self gotoHelpVController];
        }else if (indexPath.row == 1){
            [self gotoShare];
        }
    }
  

}

- (void)showContact{
    
    UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
    for (NSDictionary * dic in self.infoArray) {
       NSString * mobile = dic[@"mobile"];
       NSString * name  =  dic[@"name"];
        NSString * title = [NSString stringWithFormat:@"%@：%@",name,mobile];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([title containsString:@"："]&&[[title componentsSeparatedByString:@"："] count] == 2) {
                NSString *phone = [title componentsSeparatedByString:@"："][1];
                [self  phoneAction: phone];
            }
          
        }];
        [actionSheet addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
     [actionSheet addAction:action];
    [self presentViewController:actionSheet animated:YES completion:nil];
}


- (void)phoneAction:(NSString *)mobile{
    
    NSString * callPhone = [NSString stringWithFormat:@"telprompt://%@",mobile];
    
    if (@available(iOS 10.0, *)) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
}

- (void)gotoHelpVController{
    HelpViewController * helpVC = [[HelpViewController alloc]init];
    [self pushViewController:helpVC];
    
}

- (void)gotoShare{
    
    ShareViewController * shareVC = [[ShareViewController alloc]init];
    [self pushViewController:shareVC];
}
- (void)tapCountAction{
    ChangeInfoViewController * info = [[ChangeInfoViewController alloc]initWithName:self.nickName withImgUrl:self.userImgUrl];
    [self pushViewController:info];
}
- (void)gotoInfo{
    
    ChangeInfoViewController * infoVC = [[ChangeInfoViewController alloc]init];
    [self pushViewController:infoVC];
}
@end
