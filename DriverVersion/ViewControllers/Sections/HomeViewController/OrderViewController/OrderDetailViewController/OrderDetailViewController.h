//
//  OrderDetailViewController.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

 
#import "XLButtonBarPagerTabStripViewController.h"

typedef NS_ENUM(NSInteger,OrderDetailType ){
    OrderDetailType_loading = 0 ,// 待装货
    OrderDetailType_transport  ,//运输中
    OrderDetailType_complete  ,//已完成
};
@interface OrderDetailViewController : XLButtonBarPagerTabStripViewController
- (instancetype)initWithOrderType:(OrderDetailType)type WithOrderId:(NSNumber *)id withGoodNum:(NSString *)good_num;
@end
