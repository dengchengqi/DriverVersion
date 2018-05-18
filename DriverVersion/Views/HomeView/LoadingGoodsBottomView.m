//
//  LoadingGoodsBottomView.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "LoadingGoodsBottomView.h"
#import "PublicDocuments.h"
@interface   LoadingGoodsBottomView()
@property (weak, nonatomic) IBOutlet UIButton *comBtn;

@end
@implementation LoadingGoodsBottomView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.comBtn.backgroundColor = project_main_color;
}
- (IBAction)completeAction:(id)sender {
    if (self.btnTypeBlock) {
        self.btnTypeBlock(buttonType_complete);
    }
}

- (IBAction)contactAction:(id)sender {
    if (self.btnTypeBlock) {
        self.btnTypeBlock(buttonType_contact);
    }
}

@end
