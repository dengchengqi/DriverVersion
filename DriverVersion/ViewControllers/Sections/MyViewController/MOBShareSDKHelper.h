//
//  MOBShareSDKHelper.h
//  ShareSDKDemo
//
//  Created by youzu on 2017/6/1.
//  Copyright © 2017年 mob. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 配置开启平台
/**
 ShareSDK 
 设置平台 通过开启关闭平台的宏控制平台 是否注册此平台
 */

//国内平台
#define IMPORT_SINA_WEIBO //注释此行则 不开启【 新浪微博 】平台
#define IMPORT_SUB_QQFriend //注释此行则 不开启【 QQ好友 】平台
#define IMPORT_SUB_QZone //注释此行则 不开启【 QQ空间 】平台
#define IMPORT_SUB_WechatSession //注释此行则 不开启【 微信好友 】平台
#define IMPORT_SUB_WechatTimeline //注释此行则 不开启【 微信朋友圈 】平台
#define IMPORT_SUB_WechatFav //注释此行则 不开启【 微信收藏 】平台
#define IMPORT_AliPaySocial  //注释此行则 不开启【 支付宝好友 】平台
#define IMPORT_AliPaySocialTimeline  //注释此行则 不开启【 支付宝朋友圈 】平台
#define IMPORT_DingTalk //注释此行则 不开启【 钉钉 】平台
#define IMPORT_TencentWeibo //注释此行则 不开启【 腾讯微博 】平台
#define IMPORT_DouBan //注释此行则 不开启【 豆瓣 】平台
#define IMPORT_MeiPai //注释此行则 不开启【 美拍 】平台
#define IMPORT_YinXiang //注释此行则 不开启【 印象笔记 】平台
#define IMPORT_YouDaoNote //注释此行则 不开启【 有道云笔记 】平台
#define IMPORT_Mingdao //注释此行则 不开启【 明道 】平台
#define IMPORT_Kaixin //注释此行则 不开启【 开心网 】平台
#define IMPORT_Renren //注释此行则 不开启【 人人网 】平台
#define IMPORT_SUB_YiXinSession //注释此行则 不开启【 易信好友 】平台
#define IMPORT_SUB_YiXinTimeline //注释此行则 不开启【 易信朋友圈 】平台
#define IMPORT_SUB_YiXinFav //注释此行则 不开启【 易信收藏 】平台
//海外平台
#define IMPORT_Facebook //注释此行则 不开启【 Facebook 】平台
#define IMPORT_FacebookMessenger //注释此行则 不开启【 FacebookMessenger 】平台
#define IMPORT_Instagram //注释此行则 不开启【 Instagram 】平台
#define IMPORT_Twitter //注释此行则 不开启【 Twitter 】平台
#define IMPORT_Line //注释此行则 不开启【 Line 】平台
#define IMPORT_GooglePlus //注释此行则 不开启【 GooglePlus 】平台
#define IMPORT_WhatsApp //注释此行则 不开启【 WhatsApp 】平台
#define IMPORT_SUB_KakaoTalk //注释此行则 不开启【 KakaoTalk 】平台
#define IMPORT_SUB_KakaoStory //注释此行则 不开启【 KakaoStory 】平台
#define IMPORT_YouTube //注释此行则 不开启【 YouTube 】平台
#define IMPORT_Flickr //注释此行则 不开启【 Flickr 】平台
#define IMPORT_Dropbox //注释此行则 不开启【 Dropbox 】平台
#define IMPORT_Evernote //注释此行则 不开启【 Evernote 】平台
#define IMPORT_Pinterest //注释此行则 不开启【 Pinterest 】平台
#define IMPORT_Pocket //注释此行则 不开启【 Pocket 】平台
#define IMPORT_LinkedIn //注释此行则 不开启【 LinkedIn 】平台
#define IMPORT_VKontakte //注释此行则 不开启【 VKontakte 】平台
#define IMPORT_Instapaper //注释此行则 不开启【 Instapaper 】平台
#define IMPORT_Tumblr //注释此行则 不开启【 Tumblr 】平台
//系统平台
#define IMPORT_SMS //注释此行则 不开启【 SMS 】平台
#define IMPORT_Mail //注释此行则 不开启【 Mail 】平台
#define IMPORT_Copy //注释此行则 不开启【 Copy 】平台
#define IMPORT_Print //注释此行则 不开启【 Print 】平台

/**
 以下为各平台的相关参数设置
 */

#pragma mark - QQ平台的配置信息
/*
     info.plist 中需要设置 白名单 LSApplicationQueriesSchemes
     <string>mqq</string>
     <string>mqqapi</string>
     <string>mqqwpa</string>
     <string>mqqbrowser</string>
     <string>mttbrowser</string>
     <string>mqqOpensdkSSoLogin</string>
     <string>mqqopensdkapiV2</string>
     <string>mqqopensdkapiV3</string>
     <string>mqqopensdkapiV4</string>
     <string>wtloginmqq2</string>
     <string>mqzone</string>
     <string>mqzoneopensdk</string>
     <string>mqzoneopensdkapi</string>
     <string>mqzoneopensdkapi19</string>
     <string>mqzoneopensdkapiV2</string>
     <string>mqqapiwallet</string>
     <string>mqqopensdkfriend</string>
     <string>mqqopensdkdataline</string>
     <string>mqqgamebindinggroup</string>
     <string>mqqopensdkgrouptribeshare</string>
     <string>tencentapi.qq.reqContent</string>
     <string>tencentapi.qzone.reqContent</string>
     <string>tim</string>
     <string>timapi</string>
     <string>timopensdkfriend</string>
     <string>timwpa</string>
     <string>timgamebindinggroup</string>
     <string>timapiwallet</string>
     <string>timOpensdkSSoLogin</string>
     <string>wtlogintim</string>
     <string>timopensdkgrouptribeshare</string>
     <string>timopensdkapiV4</string>
     <string>timgamebindinggroup</string>
     <string>timopensdkdataline</string>
     <string>wtlogintimV1</string>
     <string>timapiV1</string>
     
     info.plist 中需要设置 URL Schemes
     规则 tencent+AppKey 例：tencent100371282
     
     授权：客户端SSO 未安装客户端则会使用应用内web
     
     分享：仅客户端 QQ好友 文字 图片 链接 音乐链接 视频链接
     QQ空间 文字 图片 链接 相册视频
     
     分享详例：MOBQQViewController MOBQZoneViewController
 
     开放平台地址： http://open.qq.com
*/
#if (defined IMPORT_SUB_QQFriend) || (defined IMPORT_SUB_QZone)
    //AppID
    #define MOBSSDKQQAppID @"1106747618"
    //AppKey
    #define MOBSSDKQQAppKey @"aed9b0303e3ed1e27bae87c33761161d"
    //AuthType
    #define MOBSSDKQQAuthType SSDKAuthTypeBoth
    //useTIM 是否优先使用TIM客户端
    #define MOBSSDKQQUseTIM YES
    //是否默认返回 UnionID v4.0.2增加
    #define MOBSSDKQQBackUnionID NO
#endif




#pragma mark - 微信平台的配置信息
/*
     info.plist 中需要设置 白名单 LSApplicationQueriesSchemes
     <string>weixin</string>
     
     info.plist 中需要设置 URL Schemes
     规则 appID 例：wx4868b35061f87885
     
     Other Linker Flags 需设置 -ObjC
     
     授权：客户端SSO 未安装客户端则会使用应用内web
     
     分享：仅客户端 微信好友 文字 图片 链接 音乐链接 视频链接 应用消息 表情 文件[本地视频] 小程序
     微信朋友圈 文字 图片 链接 音乐链接 视频链接
     微信收藏 文字 图片 链接 音乐链接 视频链接 文件[本地视频]
     
     分享详例：MOBWechatcontactsViewController MOBWechatmomentsViewController MOBWechatfavoritesViewController
 
     开放平台地址： https://open.weixin.qq.com
*/
#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
    //AppID
    #define MOBSSDKWeChatAppID @"wxdda80894fef9a06d"
    //AppSecret
    #define MOBSSDKWeChatAppSecret @"e53799d31c78aff787f5536ad7dd2f4c"
    //是否默认返回 UnionID v4.0.2增加
    #define MOBSSDKWeChatBackUnionID NO
// 如需测试小程序 需要修改 bundleID 为  com.tencent.wc.xin.SDKSample
// MOBSSDKWeChatAppID @"wxd930ea5d5a258f4f"
#endif




@interface MOBShareSDKHelper : NSObject
{
    
}
+ (MOBShareSDKHelper *)shareInstance;
//保存选择的平台 可用于UI排序
@property (nonatomic,strong)NSArray *platforems;
@end
