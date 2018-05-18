//
//  CompleteGoodsViewController.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"

typedef NS_ENUM(NSInteger, CompleteGoodsVCType){
    CompleteGoodsVCType_Complete = 0,//完成
    CompleteGoodsVCType_Unload   //卸货
};
@interface CompleteGoodsViewController : BaseCollectionViewController
-(instancetype)initWihtType:(CompleteGoodsVCType)type withOrderId:(NSNumber *)orderId withGoodNum:(NSString *)goodNum withCarid:(NSString *)car_id;
@end
