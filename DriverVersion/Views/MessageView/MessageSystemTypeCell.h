//
//  MessageSystemTypeCell.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewCell.h"
@class MessageInfoModel;
@interface MessageSystemTypeCell : BaseTableViewCell
- (void)setupModel:(MessageInfoModel *)infoModel;
@end
