//
//  MOBShareSDKHelper.m
//  ShareSDKDemo
//
//  Created by youzu on 2017/6/1.
//  Copyright © 2017年 mob. All rights reserved.
//
#import "MOBShareSDKHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK+Base.h>


//QQ需要引入的头文件
#if (defined IMPORT_SUB_QQFriend) || (defined IMPORT_SUB_QZone)
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#endif
//微信需要引入的头文件
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
#import "WXApi.h"
#endif


 

//微信回调
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
@interface MOBShareSDKHelper ()<WXApiDelegate>
{
    
}
@end
#endif


@implementation MOBShareSDKHelper

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasGetAppKey:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}

+ (void)hasGetAppKey:(NSNotification *)notification
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MOBShareSDKHelper shareInstance].platforems = [MOBShareSDKHelper _getPlatforems];
        [ShareSDK registerActivePlatforms:[MOBShareSDKHelper shareInstance].platforems
                                 onImport:^(SSDKPlatformType platformType) {
                                     [MOBShareSDKHelper _setConnectorWithPlatformType:platformType];
                                 }
                          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                              [MOBShareSDKHelper _setConfigurationWithPlatformType:platformType appInfo:appInfo];
                          }];
//        [self testShare];
//#define InitTest
#ifdef InitTest
//                [self testShare];
#endif
//    });
}

+ (void)testShare
{
    NSLog(@"---------%s---------",__func__);
    BOOL support = [ShareSDK isSupportAuth:SSDKPlatformTypeQQ];
    
    NSLog(@"--------------> %zd",support);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:@"Text" images:[UIImage imageNamed:@"D45.jpg"] url:nil title:@"test" type:SSDKContentTypeAuto];
    
    [ShareSDK share:SSDKPlatformTypeQQ parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        NSLog(@"\n--------------->HelperWarning<---------------:\n\nState:%zd,Error:%@\n\n----------------------------------",state,error);
    }];
}

//注册平台
+ (NSArray *)_getPlatforems
{
    NSMutableArray *platforems = [NSMutableArray array];
    //QQ好友
#ifdef IMPORT_SUB_QQFriend
    [platforems addObject:@(SSDKPlatformSubTypeQQFriend)];
#endif
    //QQ空间
#ifdef IMPORT_SUB_QZone
    [platforems addObject:@(SSDKPlatformSubTypeQZone)];
#endif
    //微信好友
#ifdef IMPORT_SUB_WechatSession
    [platforems addObject:@(SSDKPlatformSubTypeWechatSession)];
#endif
    //微信朋友圈
#ifdef IMPORT_SUB_WechatTimeline
    [platforems addObject:@(SSDKPlatformSubTypeWechatTimeline)];
#endif
 
    return platforems;
    
}

//注册平台依赖 Connector
+ (void)_setConnectorWithPlatformType:(SSDKPlatformType)platformType
{
    switch (platformType) {
 
            //QQ
        case SSDKPlatformTypeQQ:
#if (defined IMPORT_SUB_QQFriend) || (defined IMPORT_SUB_QZone)
            [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
#endif
            break;
            //微信
        case SSDKPlatformTypeWechat:
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
            //如需要获取微信的回调则 在delegate中设置 需实现 WXApiDelegate协议
            [ShareSDKConnector connectWeChat:[WXApi class] delegate:[MOBShareSDKHelper shareInstance]];
#endif
            break;
       
        default:
            break;
    }
}

//注册平台信息
+ (void)_setConfigurationWithPlatformType:(SSDKPlatformType)platformType appInfo:(NSMutableDictionary *)appInfo
{
    switch (platformType) {
     
            //QQ
        case SSDKPlatformTypeQQ:
#if (defined IMPORT_SUB_QQFriend) || (defined IMPORT_SUB_QZone)
            [appInfo SSDKSetupQQByAppId:MOBSSDKQQAppID
                                 appKey:MOBSSDKQQAppKey
                               authType:MOBSSDKQQAuthType
                                 useTIM:MOBSSDKQQUseTIM
                            backUnionID:MOBSSDKQQBackUnionID];
#endif
            break;
            //微信
        case SSDKPlatformTypeWechat:
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
            [appInfo SSDKSetupWeChatByAppId:MOBSSDKWeChatAppID
                                  appSecret:MOBSSDKWeChatAppSecret
                                backUnionID:MOBSSDKWeChatBackUnionID];
#endif
            break;
     
          
        default:
            break;
    }
}


+ (MOBShareSDKHelper *)shareInstance
{
    static MOBShareSDKHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MOBShareSDKHelper alloc] init];
    });
    return helper;
}

#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
//微信的回调
-(void) onReq:(BaseReq*)req
{
    NSLog(@"wechat req %@",req);
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"wechat resp %@",resp);
}
#endif
@end
