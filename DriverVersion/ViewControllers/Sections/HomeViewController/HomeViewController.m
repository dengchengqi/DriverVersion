//
//  HomeViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/14.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeViewController.h"
#import "TNTabbarController.h"
#import "LoadingGoodsViewController.h"
#import "TransportViewController.h"
#import "CompleteViewController.h"
#import "OrderDetailViewController.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "HomeOrderModel.h"

@interface HomeViewController ()
@property(nonatomic, strong) HomeOrderModel *homeOrderModel1;
@property(nonatomic, strong) HomeOrderModel *homeOrderModel2;
@property(nonatomic, strong) HomeOrderModel *homeOrderModel3;
@property(nonatomic, copy) NSString *  status;
@property(nonatomic, assign) NSInteger  currentPage;
@property(nonatomic, assign) NSInteger  currentPage1;
@property(nonatomic, assign) NSInteger  currentPage2;
@property(nonatomic, assign) NSInteger  currentPage3;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Do any additional setup after loading the view.
   [self setNavigationItemTitle:@"订单"];
   [self setupIndicator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHome:) name:@"UPDATE_HOME_PAGE" object:nil];
    self.currentPage1 = 1;
    self.currentPage2 = 1;
    self.currentPage3 = 1;
    self.currentPage = self.currentPage1;
    self.status = @"1";
 
}
- (void)updateHome:(NSNotification *)notification{
    if (notification.userInfo) {
        NSString *type = notification.userInfo[@"type"];
        NSInteger  page = 0;
        if ([type isEqualToString: @"1"]) {
            self.status = @"1";
            self.currentPage1 = 1;
            self.currentPage = self.currentPage1;
            page =  0;
        }else if ([type isEqualToString:@"2"]){
            self.status = @"2";
            self.currentPage2 = 1;
            self.currentPage = self.currentPage2;
            page = 1;
        }else if ([type isEqualToString:@"3"]){
            self.status = @"3";
            self.currentPage3 = 1;
            self.currentPage = self.currentPage3;
            page = 2;
        }
        [self moveToViewControllerAtIndex:page];
        [self.containerView setContentOffset:CGPointMake( page * CGRectGetWidth(self.containerView.bounds), 0) animated:YES];
        [self requestNetworkData];
    
     }
}

- (void)requestNetworkData{
    SessionModel * model = [[SessionHelper sharedInstance]getAppSession];
    NSMutableDictionary * parameterDic = [NSMutableDictionary dictionary];
    NSString * page = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSDictionary * dic = @{@"status":self.status,@"page":page,@"size":@"20"};
    [parameterDic addEntriesFromDictionary:dic];
    [parameterDic addEntriesFromDictionary:@{@"mobile":model.mobile}];
//    [parameterDic addEntriesFromDictionary:@{@"mobile":@"15700113563"}];
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_homepagecar] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_homepagecar];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_homepagecar) {
            NSLog(@"ss-%@",successInfoObj);
            if ([strongSelf.status isEqualToString:@"1"]) {
                [strongSelf updateLoadingView:successInfoObj];
            }else  if ([strongSelf.status isEqualToString:@"2"]) {
              
                [strongSelf updateTransportView:successInfoObj];
            } if ([strongSelf.status isEqualToString:@"3"]) {
                [strongSelf updateCompleteView:successInfoObj];
            }
          
        }
    }];
}

- (void)updateLoadingView:(NSDictionary *)successInfoObj{
    
    if (self.currentPage1 == 1) {
        self.homeOrderModel1 = nil;
    }
    if (!self.homeOrderModel1) {
        self.homeOrderModel1  = [[HomeOrderModel alloc]initWithDictionary:successInfoObj error:nil];
        if ([successInfoObj[@"info"] count] > 0) {
            self.currentPage1++;
            self.currentPage = self.currentPage1;
        }
    }else{
        
        HomeOrderModel * tempModel  = [[HomeOrderModel alloc]initWithDictionary:successInfoObj error:nil];
        if ([tempModel.info count] > 0) {
            self.currentPage1++;
            self.currentPage = self.currentPage1;
        }
        [self.homeOrderModel1.info addObjectsFromArray:tempModel.info];
        
    }
    
    [self updateIndexView:0];
}

- (void)updateTransportView:(NSDictionary *)successInfoObj{
    if (self.currentPage2 == 1) {
        self.homeOrderModel2 = nil;
    }
    
    if (!self.homeOrderModel2) {
        self.homeOrderModel2  = [[HomeOrderModel alloc]initWithDictionary:successInfoObj error:nil];
        if ([successInfoObj[@"info"] count] > 0) {
            self.currentPage2++;
            self.currentPage = self.currentPage2;
        }
        
    }else{
        
        HomeOrderModel * tempModel  = [[HomeOrderModel alloc]initWithDictionary:successInfoObj error:nil];
        if ([tempModel.info count] > 0) {
            self.currentPage2++;
            self.currentPage = self.currentPage2;
        }
        [self.homeOrderModel2.info addObjectsFromArray:tempModel.info];
        
    }
    [self updateIndexView:1];
}
- (void)updateCompleteView:(NSDictionary *)successInfoObj{
    if (self.currentPage3 == 1) {
        self.homeOrderModel3= nil;
    }
    if (!self.homeOrderModel3) {
        self.homeOrderModel3  = [[HomeOrderModel alloc]initWithDictionary:successInfoObj error:nil];
        if ([successInfoObj[@"info"] count] > 0) {
            self.currentPage3++;
            self.currentPage = self.currentPage3;
        }
    }else{
        
        HomeOrderModel * tempModel  = [[HomeOrderModel alloc]initWithDictionary:successInfoObj error:nil];
        if ([tempModel.info count] > 0) {
            self.currentPage3++;
            self.currentPage = self.currentPage3;
        }
        [self.homeOrderModel3.info addObjectsFromArray:tempModel.info];
        
    }
    [self updateIndexView:2];
}
- (void)updateIndexView:(NSInteger)index{
     BaseTableViewController * tableVC = self.pagerTabStripChildViewControllers[index];
  
    if (index == 0) {
        ((LoadingGoodsViewController *)tableVC).homeOrderModel =self.homeOrderModel1;
          ((LoadingGoodsViewController *)tableVC).isNetReqeustEmptyData = YES;
    }else if (index == 1){
        ((TransportViewController *)tableVC).homeOrderModel =self.homeOrderModel2;
        ((TransportViewController *)tableVC).isNetReqeustEmptyData = YES;
    }else if (index == 2){
        ((CompleteViewController *)tableVC).isNetReqeustEmptyData = YES;
        ((CompleteViewController *)tableVC).homeOrderModel =self.homeOrderModel3;
    }
//    [self reloadPagerTabStripView];
    [tableVC updateTableView];
}
- (void)setupIndicator{
    self.titleColorSelected = UIColorFromRGB(0x242424);
    self.titleColorNor = UIColorFromRGB(0x242424);
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.isProgressiveIndicator = NO;
    self.buttonBarView.leftRightMargin = 0;
    self.buttonBarView.scrollsToTop = NO;
    self.buttonBarView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
    
    self.buttonBarView.selectedBar.backgroundColor = project_main_color;
    self.buttonBarView.selectedBarW = 20;
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xededed);
    self.buttonBarView.bottomLineHeight = 1;
    
}
- (BOOL )isShowBackItem{
    
    return NO;
}
- (BOOL)getNavBarBgHidden{
    
    return NO;
}
- (UIColor *)getNavigationColor{
    
    return project_main_color;
}

- (UIColor *)getNavigationTitleColor{
    
    return project_Nav_title_color;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
     
    LoadingGoodsViewController *loadingGoodsVC = [[LoadingGoodsViewController alloc]init];
    loadingGoodsVC.selctedBlock = ^(NSNumber * orderId,NSString * good_num) {
        [self gotoOrderDetailVC:orderId withGoodNum:good_num withType:OrderDetailType_loading];
    };
    loadingGoodsVC.updateBlock = ^(NSInteger type) {
        self.status = @"1";
        self.currentPage1 = 1;
        self.currentPage = self.currentPage1;
      
        [self requestNetworkData];
    };
    loadingGoodsVC.LoadingOrderListBlock = ^(NSInteger type) {
        self.status = @"1";
        self.currentPage1 ++;
        self.currentPage = self.currentPage1;
     
        [self requestNetworkData];
    };
    TransportViewController   *transportVC = [[TransportViewController alloc]init];
    transportVC.selctedBlock = ^(NSNumber * orderId,NSString * good_num) {
        [self gotoOrderDetailVC:orderId  withGoodNum:good_num withType:OrderDetailType_transport];
    };
    transportVC.updateBlock = ^(NSInteger type) {
        self.status = @"2";
        self.currentPage2 = 1;
        self.currentPage = self.currentPage2;
     
        [self requestNetworkData];
    };
    transportVC.LoadingOrderListBlock = ^(NSInteger type) {
        self.status = @"2";
        self.currentPage2 ++;
        self.currentPage = self.currentPage2;
        
        [self requestNetworkData];
    };
    CompleteViewController    *completeVC = [[CompleteViewController alloc]init];
    completeVC.selctedBlock = ^(NSNumber * orderId,NSString * good_num) {
        [self gotoOrderDetailVC:orderId withGoodNum:good_num withType:OrderDetailType_complete];
    };
    completeVC.updateBlock = ^(NSInteger type) {
         self.status = @"3";
        self.currentPage3 = 1;
        self.currentPage = self.currentPage3;
  
        [self requestNetworkData];
    };
    completeVC.LoadingOrderListBlock = ^(NSInteger type) {
        self.status = @"3";
        self.currentPage3 ++;
        self.currentPage = self.currentPage3;
        
        [self requestNetworkData];
    };
    NSArray * childViewControllers = [NSMutableArray arrayWithObjects:loadingGoodsVC,transportVC,completeVC,nil];
    
    return childViewControllers;
}

- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
    BaseTableViewController * tableVC = self.pagerTabStripChildViewControllers[toIndex];
    [tableVC drogDownbeginRefreshing];
    [self updateIndexView:toIndex];
}


- (void)gotoOrderDetailVC:(NSNumber *)orderId withGoodNum:(NSString *)good_num withType:(OrderDetailType )type {
    
    OrderDetailViewController * orderDetailVC = [[OrderDetailViewController alloc]initWithOrderType:type WithOrderId:orderId withGoodNum:good_num];
    [self.navigationController  pushViewController: orderDetailVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tnTabbarController setIsTabbarHidden:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tnTabbarController setIsTabbarHidden:NO];
    [super viewWillAppear:animated];
    
}
@end
