//
//  TransporBottomView.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "TransporBottomView.h"

@interface  TransporBottomView()

@end
@implementation TransporBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)contactAction:(id)sender {
    if (self.btnTypeBlock) {
        self.btnTypeBlock(TransporbuttonType_contact);
    }
}
- (IBAction)signAction:(id)sender {
    if (self.btnTypeBlock) {
        self.btnTypeBlock(TransporbuttonType_sign);
    }
}
- (IBAction)unloadAction:(id)sender {
    if (self.btnTypeBlock) {
        self.btnTypeBlock(TransporbuttonType_unload);
    }
}

@end
