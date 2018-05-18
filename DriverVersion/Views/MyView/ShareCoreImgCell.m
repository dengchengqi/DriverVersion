

//
//  ShareCoreImgCell.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/23.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ShareCoreImgCell.h"
#import "AlertView.h"
#import "PublicDocuments.h"
#import "UIImage+QRCode.h"
@interface ShareCoreImgCell()
@property (weak, nonatomic) IBOutlet UIImageView *coreImgV;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
@implementation ShareCoreImgCell
 
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.saveBtn.backgroundColor = project_main_color;
}
- (void)createQRCode:(NSString *)url{
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"]lastObject];
    UIImage *shareImage = [UIImage imageNamed:icon];
    CGRect iconFrame =  CGRectMake(self.coreImgV.frame.size.width/2 - shareImage.size.width/2, self.coreImgV.frame.size.height/2 - shareImage.size.height/2, shareImage.size.width, shareImage.size.height);
    self.coreImgV.image = [UIImage qrCodeImageWithContent:url codeImageSize:self.coreImgV.frame.size.width logo:shareImage logoFrame:iconFrame   red:241 green:107 blue:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)saveButtonAction:(id)sender {
    if (self.coreImgV.image) {
     [self loadImageFinished:self.coreImgV.image];
    }
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    NSArray * items = @[MMItemMake(@"确定", MMItemTypeHighlight, nil)];
    AlertView * alertView = [[AlertView alloc]initWithTitle:@"提示" detail:@"保存成功" items:items];
    [alertView show];
}
@end
