

//
//  MessageDetailViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()
@property( nonatomic, strong) UIWebView * webView;
@property( nonatomic, copy)   NSString  * messageId;
@property( nonatomic, strong) UILabel * titleLabel;//标题
@property( nonatomic, strong) UILabel * detaLabel;//时间
@end

@implementation MessageDetailViewController
- (instancetype)initWithId:(NSString *)messageId{
    self = [super init];
    if (self) {
        self.messageId = messageId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"通知详情"];

    [self.view addSubview:self.webView];
    [self.webView.scrollView addSubview:self.titleLabel];
    [self.webView.scrollView addSubview:self.detaLabel];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    [self requestMessage];
}

- (void)requestMessage{
    if (!self.messageId) {
        NSLog(@"id==为空");
        return ;
    }
    NSDictionary * parameterDic= @{@"id":self.messageId};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_message_particulars] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_message_particulars];
    
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_message_particulars) {
            NSLog(@"%@===",successInfoObj);
             NSString * content = successInfoObj[@"info"][@"content"];
             NSString * title = successInfoObj[@"info"][@"title"];
             NSString * vice_title = successInfoObj[@"info"][@"vice_title"];
             NSString * create_time = successInfoObj[@"info"][@"create_time"];
            [strongSelf confightHeaderView:title withCreateTime:create_time];
            [strongSelf.webView loadHTMLString:content baseURL:nil];
//            [strongSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:content]]];
            
        }
    }];
}
- (void)confightHeaderView:(NSString *)title withCreateTime:(NSString *)createTime{
    
    self.titleLabel.text =  title;
    self.detaLabel.text = createTime;
  
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, -30-40, self.view.frame.size.width-10,40)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}

- (UILabel *)detaLabel{
    if (!_detaLabel) {
        _detaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, -30, self.view.frame.size.width, 30)];
    }
    return _detaLabel;
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.scrollView.bounces = NO;
    }
    return _webView;
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
