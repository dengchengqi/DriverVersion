//
//  LoadingGoodsViewController.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
@class HomeOrderModel ;
typedef void(^selectedOrderBlock)(NSNumber * orderId,NSString * good_num);
typedef void(^UpdateOrderListBlock)( NSInteger type);
@interface LoadingGoodsViewController : BaseTableViewController
@property (nonatomic,copy)selectedOrderBlock selctedBlock;
@property (nonatomic,copy)UpdateOrderListBlock updateBlock;
@property (nonatomic,copy)void(^LoadingOrderListBlock)( NSInteger type);
@property (nonatomic, strong) HomeOrderModel * homeOrderModel;
@end
