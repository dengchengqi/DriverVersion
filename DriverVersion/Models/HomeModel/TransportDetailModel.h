//
//  TransportDetailModel.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/20.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class TransportInfoDetailModel;
@protocol TransportInfoDetailModel;
@interface TransportDetailModel : Model
@property(nonatomic, strong) NSArray <TransportInfoDetailModel>*info;
@end
@interface TransportInfoDetailModel : Model
@property(nonatomic, copy) NSString *dynamic;
@property(nonatomic, strong)NSArray *img;
@property(nonatomic, copy)NSString *create_time;
@end
