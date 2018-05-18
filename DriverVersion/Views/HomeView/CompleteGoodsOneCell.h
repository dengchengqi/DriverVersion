//
//  CompleteGoodsOneCell.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteGoodsTFInptBlock)(NSString * inputText);
@interface CompleteGoodsOneCell : UICollectionViewCell
@property(nonatomic, assign)BOOL isShowLine;
@property(nonatomic, assign)BOOL isUnload;
- (void)setupTextFeildType:(UIKeyboardType )keyType;
@property(nonatomic, copy) CompleteGoodsTFInptBlock inputText;
- (void)setupTitle:(NSString *)title withDetail:(NSString *)detail withPlaceholder:(NSString *)placeholderText;
@end
