
//
//  InfoNameCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "InfoNameCell.h"
#import "PublicDocuments.h"
@interface InfoNameCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation InfoNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineV.backgroundColor = project_line_gray;
}

- (void)setupName:(NSString *)name{
    self.nameLabel.text = name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
