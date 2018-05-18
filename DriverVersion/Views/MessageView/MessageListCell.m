//
//  MessageListCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MessageListCell.h"
#import "UIView+WZLBadge.h"

@interface MessageListCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupIcon:(NSString *)icon withTitle:(NSString *)title withNumber:(NSInteger)number{
    
    self.titleLabel.text = title;
    self.iconImgV.image = [UIImage imageNamed:icon];
    [self.number showBadgeWithStyle:WBadgeStyleNumber value:number animationType:WBadgeAnimTypeNone];
}
@end
