//
//  MessageListCell.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCell : UITableViewCell
- (void)setupIcon:(NSString *)icon withTitle:(NSString *)title withNumber:(NSInteger)number;
@end
