

//
//  TransportDetailCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "TransportDetailCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIView+SDAutoLayout.h"
#import "TransportDetailModel.h"
@interface TransportDetailCell ()
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *dateLable;
@property(nonatomic, strong) UIImageView *topVerticalLine;
@property(nonatomic, strong) UIImageView *orangeImgV;
@property(nonatomic, strong) UIImageView *bottomVerticalLine;

@property(nonatomic, strong) SDWeiXinPhotoContainerView *picContainerView;
@property(nonatomic, strong) UIView *bottomLine;
@end
@implementation TransportDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
 
    }
    return self;
}

- (void)setup
{
    
    NSArray *views = @[self.topVerticalLine,self.orangeImgV,self.bottomVerticalLine,self.contentLabel,self.dateLable,self.picContainerView,self.bottomLine];
    
    [self.contentView sd_addSubviews:views];
    [self confightSubView];
    
}
- (void)confightSubView{
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    self.topVerticalLine.sd_layout
    .leftSpaceToView(contentView, margin*2+margin/2)
    .topSpaceToView(contentView,0)
    .widthIs(FITSCALE(0.5))
    .heightIs(FITSCALE(5));
    
    self.orangeImgV.sd_layout
    .centerXEqualToView(self.topVerticalLine)
    .topSpaceToView(self.topVerticalLine, 0)
    .widthIs(20)
    .heightIs(20);
    
    self.bottomVerticalLine.sd_layout
    .centerXEqualToView(self.orangeImgV)
    .topSpaceToView(self.orangeImgV, 0)
    .bottomEqualToView(contentView)
    .widthIs(FITSCALE(0.5));
    
    self.contentLabel.sd_layout
    .leftSpaceToView(self.orangeImgV, margin)
    .rightSpaceToView(contentView, margin)
    .topEqualToView(self.orangeImgV)
    .autoHeightRatio(0);
    
    
    self.dateLable.sd_layout
    .leftEqualToView(self.contentLabel)
    .topSpaceToView(self.contentLabel,margin)
    .rightEqualToView(self.contentView)
    .heightIs(FITSCALE(20));
    
   
    self.picContainerView.sd_layout
    .leftEqualToView(self.dateLable); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    self.bottomLine.sd_layout
    .topSpaceToView(self.picContainerView,margin)
    .leftEqualToView(self.contentLabel)
    .rightEqualToView(self.contentLabel)
    .heightIs(0.5);
    
    [self setupSelectedBackgrondView];
}
- (void)setupSelectedBackgrondView{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = backgroundView;
    
}
- (UIImageView *)topVerticalLine{
    if (!_topVerticalLine) {
        _topVerticalLine = [[UIImageView alloc]init];
        _topVerticalLine.image = [UIImage imageNamed:@"01"];
    }
    return _topVerticalLine;
}
- (UIImageView *)bottomVerticalLine{
    if (!_bottomVerticalLine) {
        _bottomVerticalLine = [[UIImageView alloc]init];
        _bottomVerticalLine.image = [UIImage imageNamed:@"01"];
    }
    return _bottomVerticalLine;
}
- (UIImageView *)orangeImgV{
    if (!_orangeImgV) {
        _orangeImgV = [[UIImageView alloc]init];
        _orangeImgV.image = [UIImage imageNamed:@"xiugaitouxiang"];
    }
    return _orangeImgV;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = fontSize_14;
        _contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}
- (SDWeiXinPhotoContainerView *)picContainerView{
    if (!_picContainerView) {
        _picContainerView =  [[SDWeiXinPhotoContainerView alloc]init];
    }
    return _picContainerView;
}

- (UILabel *)dateLable{
    if (!_dateLable) {
        _dateLable = [UILabel new];
        _dateLable.font = fontSize_11;
        _dateLable.backgroundColor = [UIColor clearColor];
        _dateLable.textColor = UIColorFromRGB(0x9f9f9f);
        _dateLable.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLable;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = project_line_gray;
    }
    return _bottomLine;
}

- (void)setInfoDetailModel:(TransportInfoDetailModel *)infoDetailModel{
    _infoDetailModel = infoDetailModel;
     self.contentLabel.text = infoDetailModel.dynamic;
    self.dateLable.text =  infoDetailModel.create_time;
    self.picContainerView.sd_layout.topSpaceToView(self.dateLable, 10);
    self.picContainerView.picPathStringsArray = infoDetailModel.img;
    UIView *bottomView;
    bottomView = self.bottomLine;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}
- (void)setupWithIndexPath:(NSIndexPath *)indexPath withEnd:(NSInteger )endRow{
    if (indexPath.row == 0) {
        self.topVerticalLine.hidden = YES;
    }else if (indexPath.row == endRow) {
        self.bottomVerticalLine.hidden = YES;
    }else{
        self.topVerticalLine.hidden = NO;
        self.bottomVerticalLine.hidden = NO;
    }
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
