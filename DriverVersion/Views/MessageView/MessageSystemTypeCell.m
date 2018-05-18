
//
//  MessageSystemTypeCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MessageSystemTypeCell.h"
#import "PublicDocuments.h"
#import "MessageListModel.h"
@interface MessageSystemTypeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@end
@implementation MessageSystemTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.lineV.backgroundColor = project_line_gray;
    self.titleLabel.textColor = UIColorFromRGB(0x242424);
    self.titleLabel.font =  [UIFont boldSystemFontOfSize:15];
    self.detailLabel.textColor = UIColorFromRGB(0x242424);
     self.detailLabel.font =  [UIFont boldSystemFontOfSize:15];
    self.dateLabel.textColor = UIColorFromRGB(0xA4A4A4);
}

- (void)setupModel:(MessageInfoModel *)infoModel{
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",infoModel.title];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",infoModel.create_time];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",infoModel.vice_title?infoModel.vice_title:@""];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
