//
//  TabbarConfigManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TabbarConfigManager.h"
#import "TNTabbarController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "MyViewController.h"


@implementation TabbarConfigManager

+ (UIViewController *)getTabbarViewController:(TabbarViewControllerType )type{
    
    TNTabbarController * tabbarVC = [[TNTabbarController alloc]init];
  
    HomeViewController* homeVC = [[HomeViewController alloc]init];
    MessageViewController* messageVC = [[MessageViewController alloc]init];
    MyViewController * personalVC = [[MyViewController alloc]init];
    UINavigationController * homeNavVC = [[UINavigationController alloc]initWithRootViewController:homeVC];
     UINavigationController * messageNavVC = [[UINavigationController alloc]initWithRootViewController:messageVC];
    UINavigationController * personalNavVC = [[UINavigationController alloc]initWithRootViewController:personalVC];
    
    tabbarVC.viewcontrollerArray = @[homeNavVC,messageNavVC,personalNavVC];
    [TabbarConfigManager initCustomerTabbar:tabbarVC];
    tabbarVC.selectedIndex =  0;
    return tabbarVC;
}

+ (void)initCustomerTabbar:(TNTabbarController  *)tabbarVC{
    
    
    
    NSArray *selectedImages = @[[UIImage imageNamed:@"dingdandianji"], [UIImage imageNamed:@"xiaoxidianji"],[UIImage imageNamed:@"wodedianji"]];
    
    NSArray *unSelectedImages = @[[UIImage imageNamed:@"dingdan"],[UIImage imageNamed:@"xiaoxi"], [UIImage imageNamed:@"wode"]];
    
    for (int i=0; i<tabbarVC.tabBar.items.count; i++) {
        TNTabbarItem *item = tabbarVC.tabBar.items[i];
        switch (i) {
            case 0:
                item.title = @"订单";
                break;
            case 1:
                item.title = @"消息";
                break;
            case 2:
                item.title = @"我的";
                break;
            default:
                break;
        }
        
        [item setSelectedItemImage:selectedImages[i] withUnselectedItemImage:unSelectedImages[i]];
    }
    
    
}
+ (void)presentViewController:(UIImagePickerController *)imagePickerVc{

    if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[TNTabbarController class]]) {
        TNTabbarController *rootVC = (TNTabbarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        [rootVC presentViewController:imagePickerVc];
 
    }else{
        UINavigationController * navc  = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
       
        [ navc.topViewController.presentedViewController presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
  
}
@end
