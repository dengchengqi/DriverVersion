//
//  MessageTransportCell.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewCell.h"
@class DynamicListInfoMode;
@interface MessageTransportCell : BaseTableViewCell
- (void)setupModel:(DynamicListInfoMode *)infoModel;
@end
