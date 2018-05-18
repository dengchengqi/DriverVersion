//
//  TransporBottomView.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TransporbuttonType){
    TransporbuttonType_contact = 0,
    TransporbuttonType_sign     ,//打卡
    TransporbuttonType_unload   ,//卸货
} ;
typedef void(^TransporselectedBtnTypeBlock)(TransporbuttonType type);
@interface TransporBottomView : UIView
@property(nonatomic, copy) TransporselectedBtnTypeBlock  btnTypeBlock;
@end
