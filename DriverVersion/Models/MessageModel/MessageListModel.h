//
//  MessageListModel.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class MessageInfoModel;
@protocol MessageInfoModel;
@interface MessageListModel : Model
@property(nonatomic, strong) NSArray <MessageInfoModel >* info;
@end
@interface MessageInfoModel : Model
@property(nonatomic, copy) NSString  *id;//id
@property(nonatomic, copy) NSString  *title;//主标题
@property(nonatomic, copy) NSString  *vice_title;//副标题
@property(nonatomic, copy) NSString  *create_time;//时间
@property(nonatomic, copy) NSString  *has_read;//1已读 2未读
@end
