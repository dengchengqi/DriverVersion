
//
//  MyHeaderView.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MyHeaderView.h"
#import "UIImageView+WebCache.h"
@interface MyHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation MyHeaderView
- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = [UIColor whiteColor];
}
- (void)setupName:(NSString *)name withImg:(NSString *)img{
    
    self.nameLabel.text = name;
   
   [self.imgV sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"wode-morentouxiang.png"]];
  
}
- (void)setupbgViewColor:(UIColor *)color{
    
    self.bgView.backgroundColor = color;
}
@end
