//
//  ChangeNameCell.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeNameBlock)(NSString *nickName);

@interface ChangeNameCell : UITableViewCell
- (void)setupNickNameDefault:(NSString *)nickName;
@property(nonatomic, copy)ChangeNameBlock  changeBlock;
@end
