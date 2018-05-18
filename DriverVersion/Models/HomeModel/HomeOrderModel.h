//
//  HomeOrderModel.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class HomeDaiZhuangHuoModel;
@protocol HomeDaiZhuangHuoModel;
@interface HomeOrderModel : Model
//@property(nonatomic, strong)  HomeInfoModel*info;
@property(nonatomic, strong) NSMutableArray <HomeDaiZhuangHuoModel> *info;
@end

@class HomeDaiZhuangHuoModel;
@class HomeYunShuModel;
@class  HomeXieHuoModel;
@protocol HomeDaiZhuangHuoModel;
@protocol HomeYunShuModel;
@protocol HomeXieHuoModel;
@interface HomeInfoModel : Model
@property(nonatomic, strong)  NSArray <HomeDaiZhuangHuoModel>*yunshu;//运输
@property(nonatomic, strong) NSArray <HomeDaiZhuangHuoModel> *daizhuanghuo;//待装货
@property(nonatomic, strong) NSArray <HomeDaiZhuangHuoModel> *xiehuo;// 完成

@end

@interface HomeYunShuModel : Model
@property(nonatomic, strong)NSNumber *carriage_status ;//1待装货 2运输中 3已结束
@property(nonatomic, strong)NSNumber *good_num ;//货单号
@property(nonatomic, strong)NSNumber *id ;
@property(nonatomic, copy)NSString  * loading ;//起点
@property(nonatomic, copy)NSString  * loading_address;//起点详细地址
@property(nonatomic, strong)NSNumber *rough_weight;//装载重量
@property(nonatomic, copy)NSString  * type;//货物类型
@property(nonatomic, copy)NSString  * unload ;//货源终点
@property(nonatomic, copy)NSString  * unload_address;//货源终点详细地址
@end

@interface HomeDaiZhuangHuoModel : Model
@property(nonatomic, strong)NSNumber *carriage_status ;//1待装货 2运输中 3已结束
@property(nonatomic, copy)NSString *good_num ;//货单号
@property(nonatomic, strong)NSNumber *id ;
@property(nonatomic, copy)NSString  * loading ;//起点
@property(nonatomic, copy)NSString  * loading_address;//起点详细地址
@property(nonatomic, strong)NSNumber *rough_weight;//装载重量
@property(nonatomic, copy)NSString  * type;//货物类型
@property(nonatomic, copy)NSString  * unload ;//货源终点
@property(nonatomic, copy)NSString  * unload_address;//货源终点详细地址
@end
@interface HomeXieHuoModel : Model

@property(nonatomic, strong)NSNumber *carriage_status ;//1待装货 2运输中 3已结束
@property(nonatomic, strong)NSNumber *good_num ;//货单号
@property(nonatomic, strong)NSNumber *id ;
@property(nonatomic, copy)NSString  * loading ;//起点
@property(nonatomic, copy)NSString  * loading_address;//起点详细地址
@property(nonatomic, strong)NSNumber *rough_weight;//装载重量
@property(nonatomic, copy)NSString  * type;//货物类型
@property(nonatomic, copy)NSString  * unload ;//货源终点
@property(nonatomic, copy)NSString  * unload_address;//货源终点详细地址

@end

