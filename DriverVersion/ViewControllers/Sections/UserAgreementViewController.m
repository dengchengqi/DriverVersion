
//
//  UserAgreementViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/14.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()
@property(strong, nonatomic)UIWebView * webView;
@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"用户协议"];
    [self.view addSubview:self.webView];
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (BOOL)getLayoutIncludesOpaqueBars{
    
    return YES;
}
- (UIRectEdge)getViewRect{
    return UIRectEdgeAll;
}
- (void)getNetworkData{
    NSDictionary * parameterDic = nil;
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_useragreement] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_useragreement];
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_useragreement) {
            NSLog(@"===success%@",successInfoObj);
            [strongSelf loadWebView:successInfoObj[@"info"]];
        }
    }];
}
- (void)loadWebView:(NSString *)url{
    NSURL * webUrl = [NSURL URLWithString:url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    return _webView;
}
@end
