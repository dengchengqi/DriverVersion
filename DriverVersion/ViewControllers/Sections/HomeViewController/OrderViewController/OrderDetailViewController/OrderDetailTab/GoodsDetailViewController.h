//
//  GoodsDetailViewController.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@class OrderCarInfoDetailModel;
@interface GoodsDetailViewController : BaseTableViewController
@property(nonatomic, strong)OrderCarInfoDetailModel * infoModel;
@end
