
//
//  GoodsDetailFourCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "GoodsDetailFourCell.h"
#import "PublicDocuments.h"
@interface GoodsDetailFourCell()
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@end
@implementation GoodsDetailFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.lineV.backgroundColor = project_line_gray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupTitle:(NSString *)title withDetail:(NSString *)detail {
    self.titleLabel.text = title;
    self.detail.text = detail;
    
}
@end
