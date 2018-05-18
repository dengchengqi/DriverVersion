//
//  ShareIconContentCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/23.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ShareIconContentCell.h"
@interface ShareIconContentCell()
@property (weak, nonatomic) IBOutlet UIView *pengyouquanView;
@property (weak, nonatomic) IBOutlet UIView *weixinView;
@property (weak, nonatomic) IBOutlet UIView *QQView;
@property (weak, nonatomic) IBOutlet UIView *QQKJView;

@end
@implementation ShareIconContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
   
}
- (void)setupSubView{
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pengyouquanAction)];
    [self.pengyouquanView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weixinAction)];
    [self.weixinView addGestureRecognizer:tap2];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(QQAction)];
    [self.QQView addGestureRecognizer:tap3];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(QQKJAction)];
    [self.QQKJView addGestureRecognizer:tap4];
}
- (void)pengyouquanAction{
    if (self.touchTypeBlock) {
        self.touchTypeBlock(ShareIconType_pengyouquan);
    }
}
- (void)weixinAction{
    if (self.touchTypeBlock) {
        self.touchTypeBlock(ShareIconType_weixin);
    }
}
- (void)QQAction{
    if (self.touchTypeBlock) {
        self.touchTypeBlock(ShareIconType_QQ);
    }
}
- (void)QQKJAction{
    if (self.touchTypeBlock) {
        self.touchTypeBlock(ShareIconType_QQKJ);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
