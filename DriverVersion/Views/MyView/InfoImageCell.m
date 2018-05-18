
//
//  InfoImageCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "InfoImageCell.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
@interface InfoImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *portraitLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation InfoImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.imgV.layer.masksToBounds = YES;
//    self.imgV.layer.cornerRadius = 20;
    self.imgV.backgroundColor = [UIColor clearColor];
    self.lineV.backgroundColor =project_line_gray;
}
- (void)setupNetImage:(NSString *)imgUrl  withLocationImg:(UIImage *)img{
 
    if (img) {
        [self.imgV setImage:img]; 
    }else{
          [self.imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"wode-morentouxiang.png"]];
      
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
