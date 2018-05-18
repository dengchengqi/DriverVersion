
//
//  ShareViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareTitleCell.h"
#import "ShareCoreImgCell.h"
#import "ShareIconContentCell.h"
#import <CoreImage/CoreImage.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import <ShareSDK/ShareSDK.h>

NSString * const  ShareTitleCellIdentifier = @"ShareTitleCellIdentifier";
NSString * const  ShareCoreImgCellIdentifier = @"ShareCoreImgCellIdentifier";
NSString * const ShareIconContentCellIdentifier = @"ShareIconContentCellIdentifier";
@interface ShareViewController (){
    
     BOOL _isShare;
    SSDKPlatformType platformType;
}
@property(nonatomic, assign) BOOL shareOnOff;
@property(nonatomic, copy) NSString *shareDownloadUrl;
@property(nonatomic, copy) NSString *shareTitle;
@property(nonatomic, copy) NSString *shareDetail;
@property(nonatomic, copy) NSString *shareIconImg;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"邀请好友"];
    [self requestShareInfo];
}
- (void)requestShareInfo{
    NSDictionary * parameterDic = @{};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_share] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_share];
    
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_share) {
            NSDictionary * info =  successInfoObj[@"info"];
            
            if (info[@"app_onoff"] ) {
                    //app分享开关 1关 2开
                if ([info[@"app_onoff"] isEqualToString:@"1"]) {
                    strongSelf.shareOnOff = NO;
                }else if ([info[@"app_onoff"] isEqualToString:@"2"]) {
                     strongSelf.shareOnOff = YES;
                }
            }
            
            //ios下载链接地址
           if (info[@"ios"] ) {
               strongSelf.shareDownloadUrl = info[@"ios"];
                
            }
            //分享主标题
           if (info[@"host_title"] ) {
                strongSelf.shareTitle = info[@"host_title"];
            }
            //分享副标题
           if (info[@"vice_title"] ) {
               strongSelf.shareDetail = info[@"vice_title"];
            }
            //分享图标
             if (info[@"img"] ) {
    
                strongSelf.shareIconImg = info[@"img"] ;
                 
            }
        }
        [strongSelf updateTableView];
    }];
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShareTitleCell class]) bundle:nil] forCellReuseIdentifier:ShareTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShareCoreImgCell class]) bundle:nil] forCellReuseIdentifier:ShareCoreImgCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShareIconContentCell class]) bundle:nil] forCellReuseIdentifier:ShareIconContentCellIdentifier];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    switch (indexPath.row ) {
        case 0:{
           height = [tableView fd_heightForCellWithIdentifier:ShareTitleCellIdentifier configuration:^(id cell) {
                [self configthTitleCell:cell withIndexPath: indexPath];
           }];
            
        }
            break;
        case 1:{
            height =  90;
            
        }
            break;
        case 2:{
            height = [tableView fd_heightForCellWithIdentifier:ShareTitleCellIdentifier configuration:^(id cell) {
                [self configthTitleCell:cell withIndexPath: indexPath];
            }];
            
        }
            break;
        case 3:{
            height = 260;
            
        }
            break;
        default:
            break;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0|| indexPath.row == 2) {
        ShareTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ShareTitleCellIdentifier];
        [self configthTitleCell:tempCell withIndexPath:indexPath];
        cell = tempCell;
    }else  if (indexPath.row == 1) {
        ShareIconContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ShareIconContentCellIdentifier];
        WEAKSELF
        tempCell.touchTypeBlock = ^(ShareIconType type) {
            STRONGSELF
            if (!strongSelf.shareOnOff) {
                NSLog(@"==分享关闭==");
                return ;
            }
            switch (type) {
                case ShareIconType_QQ:
                    platformType = SSDKPlatformSubTypeQQFriend;
                    break;
                case ShareIconType_QQKJ:
                    platformType = SSDKPlatformSubTypeQZone;
                    break;
                case ShareIconType_weixin:
                    platformType = SSDKPlatformSubTypeWechatSession;
                    break;
                case ShareIconType_pengyouquan:
                    platformType = SSDKPlatformSubTypeWechatTimeline;
                    break;
                default:
                    break;
            }
            [self shareLink];
            NSLog(@"==%ld==",type);
        };
        cell = tempCell;
    } if (indexPath.row == 3) {
        ShareCoreImgCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ShareCoreImgCellIdentifier];
        NSString * codeStr =  self.shareDownloadUrl;
        [tempCell createQRCode: codeStr];
        cell = tempCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)configthTitleCell:(ShareTitleCell *)cell  withIndexPath:(NSIndexPath *)indexPath{
    cell.fd_enforceFrameLayout = NO;
    NSString * titleStr = @"";
    if (indexPath.row == 0) {
        titleStr = @"【1】通过分享链接邀请好友使用加入鲁明危运，点击即可分享鲁明危运APP下载地址；";
    }else if (indexPath.row == 2){
        titleStr = @"【2】通过扫描二维码下载APP，邀请好友加入鲁明危运；";
    }
    [cell setupTitle:titleStr];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)shareLink
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置
    [parameters SSDKSetupShareParamsByText:self.shareDetail
                                    images:self.shareIconImg
                                       url:[NSURL URLWithString:self.shareDownloadUrl]
                                     title:self.shareTitle
                                      type:SSDKContentTypeWebPage];
     [self shareWithParameters:parameters];
}

#pragma mark -- 分享

- (void)shareWithParameters:(NSMutableDictionary *)parameters
{
    if(_isShare)
    {
        return;
    }
    _isShare = YES;
    if(parameters.count == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请先设置分享参数"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [ShareSDK share:platformType
         parameters:parameters
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         if(state == SSDKResponseStateBeginUPLoad){
             return ;
         }
         NSString *titel = @"";
         NSString *typeStr = @"";
         UIColor *typeColor = [UIColor grayColor];
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 NSLog(@"分享成功");
                 _isShare = NO;
                 titel = @"分享成功";
                 typeStr = @"成功";
                 typeColor = [UIColor blueColor];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 _isShare = NO;
                 NSLog(@"error :%@",error);
                 titel = @"分享失败";
                 typeStr = [NSString stringWithFormat:@"%@",error];
                 typeColor = [UIColor redColor];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 _isShare = NO;
                 titel = @"分享已取消";
                 typeStr = @"取消";
                 break;
             }
             default:
                 break;
         }
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titel
                                                             message:typeStr
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
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
