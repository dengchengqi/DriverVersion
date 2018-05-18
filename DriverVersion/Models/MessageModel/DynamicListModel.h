//
//  DynamicListModel.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class  DynamicListInfoMode;
@protocol DynamicListInfoMode;
@interface DynamicListModel : Model
@property(nonatomic, strong) NSArray<DynamicListInfoMode>*info;
@end

@interface DynamicListInfoMode:Model
@property(nonatomic, copy) NSString *good_num;//货单号
@property(nonatomic, copy) NSString *create_time;//时间
@property(nonatomic, copy) NSString *dynamic;//动态
@property(nonatomic, copy) NSString *license;//车牌号
@property(nonatomic, copy) NSString *car_name;//司机姓名
@end
