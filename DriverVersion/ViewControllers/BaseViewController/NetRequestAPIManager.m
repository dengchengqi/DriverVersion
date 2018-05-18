//
//  NetRequestAPIManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NetRequestAPIManager.h"

@implementation NetRequestAPIManager
+ (NSString *)getRequestURLStr:(NetRequestType )requestType
{
    // 与"NetProductRequestType"一一对应
    static NSMutableArray *urlForTypeArray = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        urlForTypeArray = [NSMutableArray arrayWithObjects:
                           
                           /***************************************************************/
                           //注册发送短信
                           @"_sms_002",
                           //用户登录
                           @"_denglu_001",
                           //用户协议
                           @"_useragreement_002",
                           //司机端首页
                           @"_homepagecar_001",
                           //司机端货源详情订单货源详情
                           @"_car_details_001",
                           //司机端运输详情
                           @"_run_details_001",
                           
                           //打卡
                           @"_clock_001",
                           //卸货点
                           @"_xiehuo_001",
                           //卸货
                           @"_unload_001",
                           //装货
                           @"_loading_001",
                           //系统通知数量
                           @"_shuliangs_001",
                           //消息系统消息列表
                           @"_message_001",
                           //消息系统消息清空
                           @"_deletemessage_001",
                           //消息系统消息详情
                           @"_message_particulars_001",
                           //消息运输动态列表
                           @"_message_dynamic_001",
                           //消息运输动态列表清空
                           @"_delete_dynamic_001",
                           
                           //个人中心热线号码
                           @"_hot_line_001",
                           //个人中心使用指南
                           @"_operating_guide_001",
                           //司机端我的
                           @"_siji_001",
                           
                           //司机端修改昵称头像
                           @"_amend_001",
                           
                           //app分享
                           @"_share_001",
                           nil];
    });
    return urlForTypeArray[requestType];
}
@end
