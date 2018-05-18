//
//  NetRequestAPIManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger ,NetRequestType ){
    /***********************************************************************************************/
    /*================================*/
    /**注册发送短信
     */
       NetRequestType_registerSms                      = 0,
    /**
     用户登录
     */
      NetRequestType_login                       ,
   /**
    用户协议
    */
     NetRequestType_useragreement           ,
    
    /**
     司机端首页
     */
     NetRequestType_homepagecar             ,
    
    /**
     司机端货源详情订单货源详情
     */
    NetRequestType_car_details          ,
    /**
     司机端运输详情
     */
    NetRequestType_run_details             ,
    
    /**
     打卡
     */
     NetRequestType_clock                   ,
    /**
     卸货点
     */
    NetRequestType_xiehuo                       ,
    
    /**
     提交卸货
     */
    NetRequestType_unload                       ,
    
    /**
     装货
     */
   NetRequestType_loading,
    /**
     系统通知数量
     */
    NetRequestType_shuliangs,
    /**
      消息系统消息列表
     */
    NetRequestType_message ,
    /**
       消息系统消息清空
     */
     NetRequestType_deletemessage,
    /**
      消息系统消息详情
     */
    NetRequestType_message_particulars ,
    /**
     消息运输动态列表
     */
     NetRequestType_message_dynamic ,
    
    /**
        消息运输动态列表清空
     */
     NetRequestType_delete_dynamic,
    /**
         个人中心热线号码
     */
    NetRequestType_hot_line ,
    /**
     个人中心使用指南
     */
    NetRequestType_operating_guide,
    
    /**
     司机端我的信息
     */
    NetRequestType_siji         ,
    
    /**
     司机端修改昵称头像
     */
     NetRequestType_amend          ,
    
    /**
     app分享
     */
     NetRequestType_share         ,
    /***********************************************************************************************/
};


@interface NetRequestAPIManager : NSObject
/**
 根据请求类型获得地址
 */
+ (NSString *)getRequestURLStr:(NetRequestType )requestType;

@end
