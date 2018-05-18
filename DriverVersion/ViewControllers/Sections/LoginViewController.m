
//
//  LoginViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/14.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "LoginViewController.h"
#import "UserAgreementViewController.h"
#import "TabbarConfigManager.h"
#import "ProUtils.h"
#import "SessionModel.h"
#import "SessionHelper.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;
@property (weak, nonatomic) IBOutlet UIButton *userAgreementBtn;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (nonatomic) NSTimer *sendTimer;
@property (nonatomic) NSDate  *fireDate;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
//    self.accountTF.text = @"17682318061";
     self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendSms) userInfo:nil repeats:YES];
    NSString * bgImgName = @"";
    if (iPhone4) {
        bgImgName = @"login_bg";
    }else if (iPhone5) {
        bgImgName = @"login_bg_5";
    }else if (iPhone6) {
        bgImgName = @"login_bg_6";
    }
    else if (iPhone6Plus) {
        bgImgName = @"login_bg_6p";
    }
    else if (iPhoneX) {
        bgImgName = @"login_bg_x";
    }else{
        bgImgName = @"login_bg";
    }
    self.bgImgV.image = [UIImage imageNamed:bgImgName];
}
- (void)sendSms {
    
    NSDate *sDate = self.fireDate;
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:sDate];
    NSInteger timeT = 60 - t;
    if (timeT <= 0)
    {
        [self.smsButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsButton setUserInteractionEnabled:YES];
        [self.sendTimer setFireDate:[NSDate distantFuture]];
        
        [self.smsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.smsButton.backgroundColor = project_main_blue;
        return ;
    }
    self.smsButton.userInteractionEnabled = NO;
    [self.smsButton setTitle:[NSString stringWithFormat:@"%zd秒", timeT] forState:UIControlStateNormal];
    [self.smsButton setBackgroundColor:UIColorFromRGB(0xcdd2da)];
    [self.smsButton setTitleColor: UIColorFromRGB(0x9ca1ab) forState:UIControlStateNormal];
    self.smsButton.layer.borderColor = UIColorFromRGB(0xcdd2da).CGColor;
    
}
- (void)configView{
    
    NSString * text = @"登录即代表您同意《用户使用协议》";
    NSString * colorStr = @"《用户使用协议》";
    UIColor *textColor = UIColorFromRGB(0x009EFF);
    NSRange range = [text rangeOfString:colorStr];
    self.userAgreementBtn.titleLabel.attributedText = [ProUtils setAttributedText:text withColor:textColor withRange:range  withFont: fontSize_14];
    
    NSRange accountTFPlaceholderRange = [self.accountTF.placeholder rangeOfString:self.accountTF.placeholder ];
    self.accountTF.attributedPlaceholder = [ProUtils setAttributedText: self.accountTF.placeholder withColor:[UIColor whiteColor] withRange:accountTFPlaceholderRange  withFont: fontSize_14];
    self.accountTF.textAlignment = NSTextAlignmentLeft;
    
    NSRange verificationTFPlaceholderRange = [self.verificationTF.placeholder rangeOfString:self.verificationTF.placeholder ];
    self.verificationTF.attributedPlaceholder = [ProUtils setAttributedText: self.verificationTF.placeholder withColor:[UIColor whiteColor] withRange:verificationTFPlaceholderRange  withFont: fontSize_14];
    self.verificationTF.textAlignment = NSTextAlignmentLeft;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tFresignFirstResponder{
    [self.accountTF resignFirstResponder];
    [self.verificationTF resignFirstResponder];
}
- (IBAction)verificationBtnAction:(id)sender {
    [self tFresignFirstResponder];
    NSString *accountFlag = [ProUtils checkMobilePhone:self.accountTF.text];
    if (![ProUtils isNilOrEmpty:accountFlag]) {
        [self showAlert:TNOperationState_Unknow content:accountFlag];
        return ;
    }
    NSDictionary *parameterDic = @{@"mobile":self.accountTF.text};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_registerSms] parameterDic:parameterDic requestMethodType:RequestMethodType_POST  requestTag:NetRequestType_registerSms];
}

- (void)setNetworkRequestStatusBlocks{
     WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
          STRONGSELF
        if (request.tag == NetRequestType_registerSms) {
            strongSelf.fireDate = [NSDate date];
            [strongSelf.sendTimer setFireDate:[NSDate date]];
            //2513
        }else if (request.tag == NetRequestType_login){
      
            SessionModel *model = [[SessionModel alloc]initWithDictionary:successInfoObj[@"info"] error:nil];
            [[SessionHelper sharedInstance] setAppSession:model];
            [[SessionHelper sharedInstance] saveCacheSession:model];
            [strongSelf gotoHomeVC];
        }
        
    } ];
}

- (IBAction)loginBtnAction:(id)sender {
    
    [self tFresignFirstResponder];
    NSString *accountFlag = [ProUtils checkMobilePhone:self.accountTF.text];
    if (![ProUtils isNilOrEmpty:accountFlag]) {
        [self showAlert:TNOperationState_Unknow content:accountFlag];
        return ;
    }
    
    NSDictionary *parameterDic = @{@"mobile":self.accountTF.text,@"code":self.verificationTF.text};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_login] parameterDic:parameterDic requestMethodType:RequestMethodType_POST  requestTag:NetRequestType_login];
}

- (void)gotoHomeVC{
    
    UIViewController * tabbarConfigManager = [TabbarConfigManager getTabbarViewController:TabbarViewControllerType_Login];
    
    [self presentViewController:tabbarConfigManager animated:YES completion:nil];
}

- (IBAction)userAgreementBtnAction:(id)sender {
    UserAgreementViewController * userAgreementVC = [[UserAgreementViewController alloc]init];
    UINavigationController * userAgreementNavc = [[UINavigationController alloc]initWithRootViewController:userAgreementVC];
    
    [self presentViewController:userAgreementNavc animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
