//
//  PublicDocuments.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#ifndef PublicDocuments_h
#define PublicDocuments_h


/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~型号~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
// 设备相关
#define isIPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断设备型号
#define iPhone4                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhoneX                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS6                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) // 判断是否是IOS6的系统
#define IOS7                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) // 判断是否是IOS7的系统
#define IOS8                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) // 判断是否是IOS8的系统
#define IOS9                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) // 判断是否是IOS9的系统
#define IOS10                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) // 判断是否是IOS10的系统
#define IOS11                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) // 判断是否是IOS11的系统
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
// 动态获取设备高度
#define IPHONE_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH                [UIScreen mainScreen].bounds.size.width

// block self
#define WEAKSELF                    typeof(self) __weak weakSelf = self;
#define STRONGSELF                  typeof(weakSelf) __strong strongSelf = weakSelf;

#define iphoneXBottomSpacing 34.f
#define tn_tabbat_height (iPhoneX?(49.f+iphoneXBottomSpacing):49.0f)
#define NavigationBar_Height (iPhoneX?88.f:64.0f)
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~字体~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define scale_y (iPhone4? 1:(IPHONE_HEIGHT/568))
#define scale_x (iPhone4? 1:(IPHONE_WIDTH/320))
#define ip6size 1.2f
#define FITSCALE(parameter) (parameter*(iPhoneX?ip6size:scale_y))


#define fontSize_22  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:22*ip6size]:[UIFont systemFontOfSize:FITSCALE(22)])
#define fontSize_20  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:20*ip6size]:[UIFont systemFontOfSize:FITSCALE(20)])
#define fontSize_18  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:18*ip6size]:[UIFont systemFontOfSize:FITSCALE(18)])
#define fontSize_16  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:16*ip6size]:[UIFont systemFontOfSize:FITSCALE(16)])
#define fontSize_15  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:15*ip6size]:[UIFont systemFontOfSize:FITSCALE(15)])
#define fontSize_14  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:14*ip6size]:[UIFont systemFontOfSize:FITSCALE(14)])
#define fontSize_13  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:13*ip6size]:[UIFont systemFontOfSize:FITSCALE(13)])
#define fontSize_12  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:12*ip6size]:[UIFont systemFontOfSize:FITSCALE(12)])
#define fontSize_11  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:11*ip6size]:[UIFont systemFontOfSize:FITSCALE(11)])
#define fontSize_10  ((iPhone6Plus||iPhoneX)? [UIFont systemFontOfSize:10*ip6size]:[UIFont systemFontOfSize:FITSCALE(10)])

#define tn_tabbar_font [UIFont fontWithName:@"STHeitiSC-Light" size:10]
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~颜色~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define rightBarButtonItem_font   fontSize_14
#define tn_tabbar_select_color    UIColorFromRGB(0xF16B14)
#define tn_tabbar_unselect_color   [UIColor whiteColor]
#define tn_background_gray         UIColorFromRGB(0xf5f5f5)

//转换16进制颜色
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define tn_lighter_gray         UIColorFromRGB(0xCCCCCC)
#define tn_border_color         UIColorFromRGB(0xE3E3E3)
#define tn_dark_gray            UIColorFromRGB(0x333333)

#define view_background_color                 [UIColor  whiteColor]  //viewController的背景色

#define project_main_blue       UIColorFromRGB(0x3EB6FF)

#define project_border_color    UIColorFromRGB(0xDEE1E7)
#define project_textgray_white  UIColorFromRGB(0x919499)
#define project_textgray_gray   UIColorFromRGB(0x6b6b6b)

#define project_background_gray   UIColorFromRGB(0xf5f5f5)
#define project_line_gray         UIColorFromRGB(0xE3E3E3)
#define btn_cornerRadius            2.0f
#define project_Nav_title_color        UIColorFromRGB(0x242424)
#define project_detail_text_color  UIColorFromRGB(0x747474)
#define project_view_background_color    UIColorFromRGB(0xFFFFFF)

#define project_main_color    UIColorFromRGB(0xF16B14)
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define UPDATE_USER_INFO                            @"UPDATE_USER_INFO"
#define SESSIONMSG_KEY                              @"SESSIONMSG_KEY"
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~提示文字~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define AlertTitle                      @"温馨提示"
#define Cancel                          @"取消"
#define Confirm                         @"确定"

#define NoConnectionNetwork             @"当前网络不可用,请检查您的网络设置"
#define Loading                         @""
#define LoginLoading                    @"登录中..."
#define LoadingFinish                   @"完成"
#define LoadFailed                      @"加载失败"
#define SaveFailed                      @"保存失败"

#define OperationFailure                @"操作失败,请重试"
#define OperationSuccess                @"操作成功"

#define DeprecatedYourInputInfo         @"是否放弃您所输入的信息?"

#define NotLogin                        @"您还没有登录或者登录已过期,请登录"

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#define max_dou                 5
#define min_dou                 -5
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
//QQ分享
#define  kQQAppKey  @"1106747618"
//微信
#define  kWXAppKey  @""

//极光
#define JPushAppKey   @"16117c4aba8ae1e4e7db7493"

//友盟统计
#define UMengAppKey   @""

#define kRecordAudioFile    @"myRecord.caf"
#define kMyselfRecordFile   @"myselfRecord.mp3"



#define CustomerServicePhoneNumber   @""//客服电话
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

// NSlog
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#endif /* PublicDocuments_h */
