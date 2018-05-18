//
//  UnloadModel.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/20.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class UnloadInfoModel;
@protocol  UnloadInfoModel;
@interface UnloadModel : Model
@property(nonatomic, strong) NSArray <UnloadInfoModel>*info;
@end
@interface UnloadInfoModel : Model
@property(nonatomic, copy) NSString  *id;//id
@property(nonatomic, copy) NSString  *unload;//卸货地点
@property(nonatomic, copy) NSString  *unload_address;//卸货地点详细地址
@end
