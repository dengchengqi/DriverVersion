
//
//  OrderDetailViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "LoadingGoodsCell.h"
#import "LoadingGoodsBottomView.h"
#import "TransporBottomView.h"
#import "CompleteBottomView.h"
#import "GoodsDetailViewController.h"
#import "TransportDetailViewController.h"
#import "CompleteGoodsViewController.h"
#import "OrderCarDetailModel.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
@interface OrderDetailViewController ()<CLLocationManagerDelegate>
@property(nonatomic, strong) UIView * bottomView;
@property(assign,nonatomic) OrderDetailType type;
@property(strong,nonatomic) NSNumber *orderId;
@property(strong,nonatomic) NSString *goodNum;
@property(strong,nonatomic) NSString *car_id;
@property(strong,nonatomic) OrderCarDetailModel *carDetailModel;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, copy) NSString *placemarkName;
@property(nonatomic, assign) NSInteger isOpenLocation;
@end

@implementation OrderDetailViewController
- (instancetype)initWithOrderType:(OrderDetailType)type WithOrderId:(NSNumber *)id withGoodNum:(NSString *)good_num{
    self = [super init];
    if (self) {
        self.type = type;
        self.orderId = id;
        self.goodNum = good_num;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"订单详情"];
    [self setupIndicator];
    [self setupBottomView];
    [self reqeustCarDetails];
    
    if (self.type == OrderDetailType_transport) {
        self.isOpenLocation = YES;
        [self startLocation];
    }
    
}

- (void)reqeustCarDetails{
    if (!self.orderId) {
        return;
    }
    NSDictionary * parameterDic = @{@"id":self.orderId};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_car_details] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_car_details];
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_car_details) {
            strongSelf.carDetailModel = [[OrderCarDetailModel alloc]initWithDictionary:successInfoObj error:nil];
            strongSelf.car_id = strongSelf.carDetailModel.info.car_id;
            [strongSelf updateViewIndex:0];
            NSLog(@"%@==-",successInfoObj);
        }else if (request.tag == NetRequestType_clock){
             NSLog(@"%@==-",successInfoObj);
            [strongSelf showClockSuceesAlert];
        }
    }];
}
- (void)showClockSuceesAlert{
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, nil)];
    [self showNormalAlertTitle:@"提示" content:@"打卡成功" items:items block:nil];
}
- (void)updateViewIndex:(NSInteger)index{
    BaseTableViewController * baseVC =  self.pagerTabStripChildViewControllers[index];
    if (index == 0) {
        ((GoodsDetailViewController *)baseVC).infoModel = self.carDetailModel.info;
    }else if (index == 1){
//         ((TransportDetailViewController *)baseVC).infoModel = self.carDetailModel.info;
        
    }
    [baseVC updateTableView];
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
    
    self.buttonBarView.selectedBar.backgroundColor =  project_main_color;
    self.buttonBarView.selectedBarW = 20;
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xededed);
    self.buttonBarView.bottomLineHeight = 1;
    
}
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    
   GoodsDetailViewController    *goodsVC = [[GoodsDetailViewController alloc]init];
    TransportDetailViewController   *transportVC = [[TransportDetailViewController alloc]initWithOrderId:self.orderId];
 
    NSArray * childViewControllers = [NSMutableArray arrayWithObjects:goodsVC,transportVC,nil];
    
    return childViewControllers;
}

- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
    
    
}

- (void)setupBottomView{
    if (self.type == OrderDetailType_loading) {
        LoadingGoodsBottomView * tempBottomView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LoadingGoodsBottomView class]) owner:nil options:nil].firstObject;
        tempBottomView.btnTypeBlock = ^(buttonType type) {
            if (type == buttonType_complete) {
                [self gotoCompleteGoodsVC];
            }else  if (type == buttonType_contact) {
                [self phoneAction];
            }
        };
        self.bottomView = tempBottomView;
       
        
    }else if (self.type == OrderDetailType_complete)
    {
        CompleteBottomView * tempBottomView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CompleteBottomView class]) owner:nil options:nil].firstObject;
        tempBottomView.btnTypeBlock = ^(CompletebuttonType type) {
            if (type == TransporbuttonType_contact) {
                [self phoneAction];
            }
        };
          self.bottomView = tempBottomView;
    }else if (self.type == OrderDetailType_transport){
         TransporBottomView * tempBottomView =   [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TransporBottomView class]) owner:nil options:nil].firstObject;
        tempBottomView.btnTypeBlock = ^(TransporbuttonType type) {
            if (type == TransporbuttonType_contact) {
                [self phoneAction];
            }else  if (type == TransporbuttonType_unload) {
                [self gotoUnloadGoodsVC];
            }
            else  if (type == TransporbuttonType_sign) {
                if (self.isOpenLocation) {
                     [self  gotoRequestTypeClock];
                }else{
                    [self startLocation];
                }
            }
        };
          self.bottomView = tempBottomView;
        
    }
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height-49);
        make.height.mas_equalTo(@(49));
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
}
- (BOOL )isShowBackItem{
    
    return YES;
}
- (BOOL)getNavBarBgHidden{
    
    return NO;
}
#pragma mark --
- (void)gotoCompleteGoodsVC{
  
    CompleteGoodsViewController * completeGoodsVC = [[CompleteGoodsViewController alloc]initWihtType:CompleteGoodsVCType_Complete withOrderId:self.orderId withGoodNum:self.goodNum withCarid:self.car_id];
    [self pushViewController:completeGoodsVC];
}
-(void)gotoUnloadGoodsVC{
    
    CompleteGoodsViewController * completeGoodsVC = [[CompleteGoodsViewController alloc]initWihtType:CompleteGoodsVCType_Unload withOrderId:self.orderId withGoodNum:self.goodNum withCarid:self.car_id];
    [self pushViewController:completeGoodsVC];
}

- (void)phoneAction{
    NSString * mobile = self.carDetailModel.info.mobile;
    if (!mobile) {
        NSArray * items = @[MMItemMake(@"确定", MMItemTypeHighlight, nil)];
        [self showNormalAlertTitle:@"提示" content:@"无号码" items:items block:nil];
        return ;
    }
    NSString * callPhone = [NSString stringWithFormat:@"telprompt://%@",mobile];
 
    if (@available(iOS 10.0, *)) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)gotoRequestTypeClock{
    if (!self.placemarkName) {
        [self showNoLocationAlert];
        return ;
    }
    NSDictionary * parameterDic =@{@"id":self.orderId,@"dynamic":self.placemarkName};
    [self  sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_clock] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_clock];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- 定位
- (void)startLocation
{
    
    if ([CLLocationManager locationServicesEnabled])  //确定用户的位置服务启用
    {
        self.locationManager = [[CLLocationManager alloc] init];
        
        // 2.想用户请求授权(iOS8之后方法)   必须要配置info.plist文件
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 以下方法选择其中一个
            // 请求始终授权   无论app在前台或者后台都会定位
            //  [locationManager requestAlwaysAuthorization];
            // 当app使用期间授权    只有app在前台时候才可以授权
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 距离筛选器   单位:米   100米:用户移动了100米后会调用对应的代理方法didUpdateLocations
        // kCLDistanceFilterNone  使用这个值得话只要用户位置改动就会调用定位
        self.locationManager.distanceFilter = 100.0;
        // 期望精度  单位:米   100米:表示将100米范围内看做一个位置 导航使用kCLLocationAccuracyBestForNavigation
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        // 3.设置代理
        self.locationManager.delegate = self;
        
        // 4.开始定位 (更新位置)
        [self.locationManager startUpdatingLocation];
        
        //        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        // 5.临时开启后台定位  iOS9新增方法  必须要配置info.plist文件 后台定位不然直接崩溃
        //            self.locationManager.allowsBackgroundLocationUpdates = YES;
        //        }
        
        
        NSLog(@"start gps");
        
    }else{
        
        [self showNoLocationAlert];
        self.isOpenLocation = NO;
        
        //        if (IOS8) {
        //            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        //            if ([[UIApplication sharedApplication] canOpenURL:url]) {
        //                [[UIApplication sharedApplication] openURL:url];
        //            }
        //        } else {
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        //        }
        
        
    }
}

- (void)showNoLocationAlert{
    
    NSString * title = @"提示";
    NSString * content = @"无法获取您的位置信息。请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务，并允许此app使用定位服务。";
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, nil)];
    [self showNormalAlertTitle:title content:content items:items block:nil];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    //    CLLocation *location = newLocation;
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f===", coordinate.latitude, coordinate.longitude);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0){
            CLPlacemark * placemark = placemarks[0];
            
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
//            NSString * state =  [placemark.addressDictionary objectForKey:@"State"];
            // 省
            //            NSLog(@"state,%@",state);
            //            // 位置名
            //            NSLog(@"name,%@",placemark.name);
            //            // 街道
            //            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            //            // 子街道
            //            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            //            // 市
            //            NSLog(@"locality,%@",placemark.locality);
            //            // 区
            //            NSLog(@"subLocality,%@",placemark.subLocality);
            //            // 国家
            //            NSLog(@"country,%@",placemark.country);
//            self.cityName = city;
//            self.provinceName = state;
            
//            self.subLocality =placemark.subLocality;
            self.placemarkName   = placemark.name;
            //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
            [manager stopUpdatingLocation];
            
       
        };
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
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
