//
//  AppDelegate.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/14.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//


#import "TabbarConfigManager.h"
#import "AppPropertiesInitialize.h"
#import "PublicDocuments.h"
#import "Interface.h"
#import "SessionHelper.h"
#import "LoginViewController.h"
#if TARGET_IPHONE_SIMULATOR
#else
#import "WXApi.h"
#import "WXApiObject.h"
#endif
#import <TencentOpenAPI/TencentOAuth.h>

 #import <ShareSDKConnector/ShareSDKConnector.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "SessionModel.h"
#import "ProUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <UMMobClick/MobClick.h>
#import "TNTabbarController.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /////进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
    
 
    
    if (IOS8) { //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            NSLog(@"没有打开---通知，暂时无法接受通知");
        }
    }else{ // ios7 一下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
            NSLog(@"没有打开---通知，暂时无法接受通知");
        }
    }
//    [self registerShareKey];
 
    [self registerJPushKey:launchOptions];
    [self customizeNavigationInterface];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupRootViewController];
    [self.window makeKeyAndVisible];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }else if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        
     if (@available(iOS 10.0, *)){
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //监听回调事件
        center.delegate = self;
        
        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      //获取用户是否同意开启通知
                                      NSLog(@"request authorization successed!");
                                  }
                              }];
         //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。
         [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
             NSLog(@"%@",settings);
         }];

    }
  }
    return YES;
}




- (void)registerJPushKey:(NSDictionary *)launchOptions{
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    NSString * channel = @"iOS鲁明危运司机端";
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:channel
                 apsForProduction:is_production
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"clientId"];
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
}
-  (void)setupRootViewController{
    
    if ([[SessionHelper sharedInstance]checkUserStatus]) {
        //
        /**
         重新设置导航条样式
         */
        //        [[UINavigationBar appearance] setBackgroundImage:[ProUtils createImageWithColor:[UIColor whiteColor] withFrame: CGRectMake(1, 1, 1, 1)] forBarMetrics:UIBarMetricsDefault ];
        //        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        self.window.rootViewController = [TabbarConfigManager getTabbarViewController:TabbarViewControllerType_Login];
        
        
    }else {
        
        LoginViewController * loginVC = [[LoginViewController alloc]initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil]; 
        self.window.rootViewController = loginVC;
    }
    
    
    
}
 
//注册 第三方需要的key值
- (void)registerShareKey{
    
    
#if TARGET_IPHONE_SIMULATOR
#else
    //微信注册
    //向微信注册
    [WXApi registerApp:kWXAppKey enableMTA:YES];
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
#endif
}



/// 自定义导航条
- (void)customizeNavigationInterface {
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:fontSize_18}];
    
    //    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    //        [[UINavigationBar appearance] setTranslucent:NO];
    //    }
    //    [[UINavigationBar appearance]setBarTintColor:project_main_blue];
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance]  setShadowImage:[self createImageWithColor:tn_border_color withFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.1f)]];
    [[UIApplication sharedApplication]  setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //按钮文字
    //    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    
    UIImage *barBackBtnImg = [[UIImage imageNamed:@"zz"] imageWithRenderingMode:UIImageRenderingModeAutomatic]   ;
    
    [[UINavigationBar appearance] setBackIndicatorImage:barBackBtnImg];
    
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:barBackBtnImg];
    //    [UIBarButtonItem appearance].imageInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
    //                                                      forState:UIControlStateNormal
    //                                                    barMetrics:UIBarMetricsDefault];
    
}

- (UIImage*) createImageWithColor: (UIColor*) color withFrame:(CGRect)rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
