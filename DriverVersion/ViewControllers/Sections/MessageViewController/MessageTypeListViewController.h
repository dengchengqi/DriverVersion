//
//  MessageTypeListViewController.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, MessageListType) {
    MessageListType_system = 0,
    MessageListType_transport ,
};
@interface MessageTypeListViewController : BaseTableViewController
- (instancetype)initWithType:(MessageListType )type;
@end
