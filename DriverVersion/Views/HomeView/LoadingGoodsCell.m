
//
//  LoadingGoodsCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "LoadingGoodsCell.h"
#import "PublicDocuments.h"
#import "HomeOrderModel.h"
#import "NSString+Empty.h"
@interface LoadingGoodsCell()
@property (weak, nonatomic) IBOutlet UILabel *startDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@end
@implementation LoadingGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView{
    self.topLine.backgroundColor = project_line_gray;
    self.bottomLine.backgroundColor = project_line_gray;
    self.startDetailLabel.font = [UIFont systemFontOfSize:12];
    self.endDetailLabel.font = [UIFont systemFontOfSize: 12];
    self.startDetailLabel.textColor = UIColorFromRGB(0x747474);
    self.endDetailLabel.textColor = UIColorFromRGB(0x747474);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupModel:(HomeDaiZhuangHuoModel *)model{
   
    self.orderNumberLabel.text = [NSString stringWithFormat:@"货单号:%@",model.good_num?model.good_num:@""];
    self.startTitleLabel.text = [NSString stringWithFormat:@"%@", model.loading?model.loading:@"" ];
     self.startDetailLabel.text = [NSString stringWithFormat:@"%@",model.loading_address?model.loading_address:@""  ];
     self.endTitleLabel.text = [NSString stringWithFormat:@"%@",model.unload?model.unload:@"" ];
     self.endDetailLabel.text = [NSString stringWithFormat:@"%@",model.unload_address?model.unload_address:@""];
     self.typeLabel.text = [NSString stringWithFormat:@"%@",model.type?model.type:@"" ];
     self.weightLabel.text = [NSString stringWithFormat:@"%@ 吨",model.rough_weight?model.rough_weight:@"" ];
    
}
@end
