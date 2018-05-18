
//
//  CompleteBottomView.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/15.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CompleteBottomView.h"

@interface CompleteBottomView()

@end
@implementation CompleteBottomView
- (IBAction)contactAction:(id)sender {
    if (self.btnTypeBlock) {
        self.btnTypeBlock(CompletebuttonType_contact);
    }
}


@end
