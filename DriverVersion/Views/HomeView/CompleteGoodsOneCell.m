
//
//  CompleteGoodsOneCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CompleteGoodsOneCell.h"
#import "PublicDocuments.h"
@interface CompleteGoodsOneCell()
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end
@implementation CompleteGoodsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.tf addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    self.lineV.backgroundColor = project_line_gray;
    self.tf.keyboardType = UIKeyboardTypeDefault;
}
- (void)setupTextFeildType:(UIKeyboardType )keyType{
    
    self.tf.keyboardType = keyType;
}
- (void)textFieldChangeText:(UITextField *)tf{
    
    NSLog(@"===%@==",tf.text);
    if (self.inputText) {
        self.inputText(tf.text);
    }
}
- (void)setupTitle:(NSString *)title withDetail:(NSString *)detail withPlaceholder:(NSString *)placeholderText{
    
    self.titleLabel.text = title;
    self.tf.placeholder = placeholderText;
    self.tf.text = detail;
    self.lineV.hidden = !self.isShowLine;
    self.arrowImgV.hidden = !self.isUnload;
    self.tf.enabled = !self.isUnload;
}

@end
