//
//  GoodsDetailOneCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "GoodsDetailOneCell.h"
#import "PublicDocuments.h"
@interface GoodsDetailOneCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@end
@implementation GoodsDetailOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineV.backgroundColor = project_line_gray;
}
- (void)setupIcon:(NSString *)iconName Title:(NSString *)title withDetail:(NSString *)detail{
    self.iconImgV.image = [UIImage imageNamed:iconName];
    self.titleLabel.text = title ;
    self.detailLabel.text = detail;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
