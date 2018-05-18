//
//  TransportDetailCell.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewCell.h"
@class TransportInfoDetailModel ;

@interface TransportDetailCell : BaseTableViewCell
@property (nonatomic, strong) TransportInfoDetailModel *infoDetailModel;
- (void)setupWithIndexPath:(NSIndexPath *)indexPath withEnd:(NSInteger )endRow;
@end
