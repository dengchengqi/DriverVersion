//
//  LoadingGoodsBottomView.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, buttonType){
    buttonType_contact = 0,
    buttonType_complete ,
} ;
typedef void(^selectedBtnTypeBlock)(buttonType type);
@interface LoadingGoodsBottomView : UIView
@property(nonatomic, copy) selectedBtnTypeBlock  btnTypeBlock;
@end
