
//
//  GoodsDetailThreeCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "GoodsDetailThreeCell.h"

#import "PublicDocuments.h"
@interface GoodsDetailThreeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation GoodsDetailThreeCell

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
