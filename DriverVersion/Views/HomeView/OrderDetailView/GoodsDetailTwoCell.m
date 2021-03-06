
//
//  GoodsDetailTwoCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "GoodsDetailTwoCell.h"
#import "PublicDocuments.h"
@interface GoodsDetailTwoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@end
@implementation GoodsDetailTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineV.backgroundColor = project_line_gray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupIcon:(NSString *)iconName Title:(NSString *)title withDetail:(NSString *)detail withAddress:(NSString *)address{
    self.iconImgV.image = [UIImage imageNamed:iconName];
    self.titleLabel.text = title ;
    self.detailLabel.text = detail;
    self.addressLabel.text = address;
    
}
@end
