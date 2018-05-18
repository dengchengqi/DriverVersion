//
//  CompleteGoodsAddImgVCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CompleteGoodsAddImgVCell.h"

@interface CompleteGoodsAddImgVCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
@implementation CompleteGoodsAddImgVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupImgMaxNum:(NSInteger)max withCurrenNum:(NSInteger)currenNum{
    NSString * number = @"";
    if (currenNum >0) {
         number = [NSString stringWithFormat:@"(%ld/%ld)",currenNum,max];
    } 
    self.numberLabel.text = number;
}
@end
