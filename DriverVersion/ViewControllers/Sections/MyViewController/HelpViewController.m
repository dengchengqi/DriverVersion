//
//  HelpViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property(strong, nonatomic)UIWebView * webView;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"使用帮助"];
    [self.view addSubview:self.webView];
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self requestOperating_guide];
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _webView;
}
- (void)requestOperating_guide{
    NSDictionary * parameterDic = @{};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_operating_guide] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_operating_guide];
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        if (request.tag == NetRequestType_operating_guide) {
            NSLog(@"%@===",successInfoObj[@"info"]);
             [weakSelf loadWebView:successInfoObj[@"info"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
