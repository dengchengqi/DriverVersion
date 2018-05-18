//
//  ChangeNameCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ChangeNameCell.h"
@interface ChangeNameCell()
@property (weak, nonatomic) IBOutlet UITextField *tfName;

@end
@implementation ChangeNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self.tfName addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldChangeText:(UITextField *)tf{
    if (self.changeBlock) {
        self.changeBlock(tf.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupNickNameDefault:(NSString *)  nickName{
    
    self.tfName.placeholder = nickName;
}
@end
