//
//  CompleteBottomView.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CompletebuttonType){
    CompletebuttonType_contact = 0,
 
} ;
typedef void(^CompleteSelectedBtnTypeBlock)(CompletebuttonType type);
@interface CompleteBottomView : UIView
@property(nonatomic, copy) CompleteSelectedBtnTypeBlock  btnTypeBlock;
@end
