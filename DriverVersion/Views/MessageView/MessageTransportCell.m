//
//  MessageTransportCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MessageTransportCell.h"
#import "PublicDocuments.h"
#import "DynamicListModel.h"
@interface MessageTransportCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation MessageTransportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.lineV.backgroundColor = project_line_gray;
    self.titleLabel.textColor = UIColorFromRGB(0x242424);
    self.titleLabel.font =  [UIFont boldSystemFontOfSize:15];
    self.nameLabel.textColor = UIColorFromRGB(0x242424);
    self.detailLabel.textColor = UIColorFromRGB(0x242424);
    self.detailLabel.font =  [UIFont boldSystemFontOfSize:15];
   self.dateLabel.textColor = UIColorFromRGB(0xA4A4A4);
}

- (void)setupModel:(DynamicListInfoMode *)infoModel{
    
    self.titleLabel.text = [NSString stringWithFormat:@"货单号: %@",infoModel.good_num];
    NSString * dateStr = infoModel.create_time;
    if (infoModel.create_time && [infoModel.create_time containsString:@" "] &&[[infoModel.create_time componentsSeparatedByString:@" "] count]==2 ) {
        dateStr = [infoModel.create_time componentsSeparatedByString:@" "][1];
    }
     self.dateLabel.text = [NSString stringWithFormat:@"%@",dateStr];
     self.nameLabel.text = [NSString stringWithFormat:@"【 %@  %@】",infoModel.license,infoModel.car_name];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@",infoModel.dynamic?infoModel.dynamic:@""];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
