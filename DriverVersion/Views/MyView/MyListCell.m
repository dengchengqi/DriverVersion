
//
//  MyListCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MyListCell.h"
#import "PublicDocuments.h"

@interface MyListCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
@implementation MyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomView.backgroundColor = project_line_gray;
}
- (void)setIcon:(NSString *)icon withTitle:(NSString *)title {
    
    self.iconImgV.image = [UIImage imageNamed:icon];
    self.titleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
