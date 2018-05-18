//
//  OrderCarDetailModel.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class  OrderCarInfoDetailModel;
@protocol OrderCarInfoDetailModel;
@interface OrderCarDetailModel : Model
@property(nonatomic, strong) OrderCarInfoDetailModel *info;
@end
@interface OrderCarInfoDetailModel : Model
@property(nonatomic, copy)NSString *carriage_status;//1待装货 2运输中 3已结束
@property(nonatomic, copy)NSString *good_num;//货单号
@property(nonatomic, copy)NSString *loading;//起点
@property(nonatomic, copy)NSString *loading_address;//起点详细地址
@property(nonatomic, strong)NSArray *unload;//卸货点
@property(nonatomic, strong)NSArray *unload_address;//卸货点详细地址
@property(nonatomic, copy)NSString *mileage;//预计里程
@property(nonatomic, copy)NSString *use_time;//用车时间
@property(nonatomic, copy)NSString *type;//货物类型
@property(nonatomic, copy)NSString *remark;
@property(nonatomic, copy)NSString *mobile;//发单人手机号
@property(nonatomic, copy)NSString *lon;
@property(nonatomic, copy)NSString *lat;
@property(nonatomic, strong)NSArray *lons;
@property(nonatomic, strong)NSArray *lats;
@property(nonatomic, copy)NSString *car_id;
@end
