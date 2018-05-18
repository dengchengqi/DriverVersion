//
//  GoodsDetailTwoCell.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface GoodsDetailTwoCell : BaseTableViewCell
- (void)setupIcon:(NSString *)iconName Title:(NSString *)title withDetail:(NSString *)detail withAddress:(NSString *)address;
@end
