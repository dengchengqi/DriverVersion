//
//  ShareTitleCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/23.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ShareTitleCell.h"
@interface ShareTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation ShareTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.text = @"";
}
- (void)setupTitle:(NSString *)title{
    
    self.titleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
