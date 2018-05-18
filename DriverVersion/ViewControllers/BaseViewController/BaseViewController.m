//
//  BaseViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseViewController.h"
#import "HUDManager.h"
#import "LoginViewController.h"
#import "ProUtils.h"

@interface BaseViewController ()<UINavigationControllerDelegate>

@end

@implementation BaseViewController
- (void)loadView
{
    [super loadView];
 
    self.view.backgroundColor = view_background_color;
  
    self.edgesForExtendedLayout = [self getViewRect];
    
    self.extendedLayoutIncludesOpaqueBars = [self getLayoutIncludesOpaqueBars];
  
}


- (void)configNavigationBar{
    
    UIColor * imageColor = nil;
    UIColor * titleColor = nil;
    UIColor * shadowColor = nil;
    if ([self getNavBarBgHidden]) {
        imageColor = [UIColor clearColor];
        titleColor =  [UIColor clearColor];
        shadowColor = [UIColor clearColor];
    }else{
        imageColor = [self getNavigationColor];
        titleColor = [self getNavigationTitleColor];
        shadowColor = tn_border_color;
    }
  
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[ProUtils createImageWithColor:imageColor withFrame:CGRectMake(0, 0, 1, 1)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage: [ProUtils createImageWithColor:shadowColor withFrame:CGRectMake(0, 0, IPHONE_WIDTH, 1)]];
    
}

- (UIColor *)getNavigationColor{
    
    return [UIColor whiteColor];
}

- (UIColor *)getNavigationTitleColor{
    
    return project_Nav_title_color;
}
- (void)setupViewFrameHeight:(CGFloat )viewHeight{

    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, viewHeight);
    
}
- (void)confighViewFrame{
    CGFloat  viewHeight = 0;
    CGFloat tempBottomSpacing = 0;
    if (iPhoneX) {
        tempBottomSpacing = iphoneXBottomSpacing;
    }
    if ([self getNavBarBgHidden]) {
   
        viewHeight = self.view.frame.size.height -tempBottomSpacing;
        
    }else{
       
        if ([self getViewRect] == UIRectEdgeNone) {
            viewHeight = self.view.frame.size.height - NavigationBar_Height-tempBottomSpacing;
        }else if ([self getViewRect] == UIRectEdgeAll){
            viewHeight = self.view.frame.size.height- tempBottomSpacing;
        } 
    }
    [self setupViewFrameHeight:viewHeight];
}
//  如果导航条不是隐藏的 UIRectEdgeNone  为下移64高度
// 如果导航条隐藏的 UIRectEdgeAll  需要要设置  extendedLayoutIncludesOpaqueBars 属性 为YES View显示在导航栏下面挡住一部分
- (UIRectEdge)getViewRect{

    return UIRectEdgeNone;
}

//    如果导航栏是不透明的, 默认UIViewController的View就会往下移, 在导航栏下显示, 如果不想往下移, YES 全屏View显示在导航栏挡住  NO 为下移64高度 View不会被导航栏挡住
- (BOOL )getLayoutIncludesOpaqueBars{ 
    return YES;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条代理
    self.navigationController.delegate = self;
    if ([self isShowBackItem]) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zz"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewController)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
     [self configNavigationBar];
     [self confighViewFrame];
//     [self navigationConfig];
}


/**
 导航栏的各种配置
 */
- (void)navigationConfig {
    
    
    //navigationBar下面的黑线隐藏掉
    [self.navigationController.navigationBar setShadowImage:[UIImage  new]];
  
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground addSubview:[self getNavigationBackgroundView]];
   
}

-  (UIView *)getNavigationBackgroundView{
    UIColor * imageColor = nil;
 
    if ([self getNavBarBgHidden]) {
        imageColor = [UIColor clearColor];
    }else{
        imageColor = project_main_color;
   
    }
    
      UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    CGFloat navigationBarBgheight = uiBarBackground.frame.size.height;
    UIView *navigationBackgroundView = nil;
    if (![uiBarBackground viewWithTag:686868]) {
        //添加一个背景颜色view
      navigationBackgroundView = [[UIView alloc] init];
    }else{
        navigationBackgroundView = [uiBarBackground viewWithTag:686868];
    }
    navigationBackgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width,navigationBarBgheight);
    navigationBackgroundView.backgroundColor = imageColor;
    navigationBackgroundView.tag = 686868;
    navigationBackgroundView.alpha = 1.0;
    
    return navigationBackgroundView;
}
- (BOOL )isShowBackItem{
  
    return YES;
}
- (BOOL)prefersStatusBarHidden

{
    return NO;
   
}
-  (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
 
//    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:[self getNavBarBgHidden ] ? 0:1];
}

- (BOOL)getNavBarBgHidden{

    return NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self hideHUD];
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//当界面被刷新后，调用ViewController的“viewDidLayoutSubviews”
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
#pragma mark - 工具类方法    ////////////////////////////////////////////////////////////////////////////
- (void)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)pushViewController:(UIViewController *)viewController
{
     
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentViewController:(UIViewController *)viewController modalTransitionStyle:(UIModalTransitionStyle)style completion:(void (^)(void))completion
{
    if (viewController)
    {
        viewController.modalTransitionStyle = style;
        
        [self presentViewController:viewController animated:YES completion:completion];
    }
}

- (NSString *)getLoadingHUDStr{

    return Loading;
}

- (void)showHUDInfoByType:(HUDInfoType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type)
        {
            case HUDInfoType_Success:
            {
                
                [HUDManager showHUDWithToShowStr:LoadingFinish HUDMode:MBProgressHUDModeText autoHide:NO afterDelay:0.0 userInteractionEnabled:YES HUDAddedToView:self.view addProgress:0.0f];
            }
                break;
            case HUDInfoType_Failed:
            {
                
                
            }
                break;
            case HUDInfoType_Loading:
            {
                UIView * view = [UIApplication sharedApplication].keyWindow;
                //            UIView * view = self.view;
                [HUDManager showHUDWithToShowStr:[self getLoadingHUDStr] HUDMode:MBProgressHUDModeCustomView autoHide:NO afterDelay:0.0 userInteractionEnabled:YES HUDAddedToView:view addProgress:0.0f];
            }
                break;
            case HUDInfoType_NoConnectionNetwork:
            {
                
                [HUDManager showHUDWithToShowStr:NoConnectionNetwork HUDMode:MBProgressHUDModeText autoHide:YES afterDelay:3.0 userInteractionEnabled:YES HUDAddedToView:self.view addProgress:0.0f];
                
            }
                break;
                
            case HUDInfoType_Uploading:
            {
                [HUDManager showHUDWithToShowStr:@"正在上传" HUDMode:MBProgressHUDModeDeterminate autoHide:NO afterDelay:0.0 userInteractionEnabled:YES HUDAddedToView:self.view addProgress:0.0f];
            }
                
                break;
            case HUDInfoType_NormalShadeNo:
            {
                
                [HUDManager  showHUDWithToShowStr:LoadingFinish HUDMode:MBProgressHUDModeCustomView autoHide:NO afterDelay:0.0 userInteractionEnabled:YES showType:HUDOthers HUDAddedToView:self.view addProgress:0.0f hasShade:NO];
            }
                
                break;
            default:
                break;
        }
    });
 
}

- (void)showUploadHUDProgress:(CGFloat )progress{
      [HUDManager showHUDWithToShowStr:@"正在上传" HUDMode:MBProgressHUDModeDeterminate autoHide:NO afterDelay:0.0 userInteractionEnabled:YES HUDAddedToView:self.view addProgress:progress];
    
}

- (void)showHUDInfoByString:(NSString *)str
{
 
   
    [[[AlertView alloc]initWithOperationState:TNOperationState_Normal detail:str items:nil] show];
    
}

- (void)hideHUD
{
    [HUDManager hideHUD];
}
- (void)setNavigationItemTitle:(NSString *)titleStr
{
    [self setNavigationItemTitle:titleStr titleFont:fontSize_18 titleColor: [self getNavigationTitleColor]];
}

- (void)setNavigationItemTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color
{
    /*
     CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(IPHONE_WIDTH, 44) lineBreakMode:NSLineBreakByWordWrapping];
     
     UILabel *navTitleLabel = InsertLabelWithShadowAndContentOffset(nil, CGRectMake(0, 0, size.width, size.height), NSTextAlignmentCenter, title, font, color, NO, IOS7 ? NO : YES, [UIColor darkGrayColor], CGSizeMake(0, -1), CGSizeMake(0, 0));
     self.navigationItem.titleView = navTitleLabel;
     */
    
    self.navigationItem.title = title;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : color, NSFontAttributeName : font};
}

- (void)backViewController
{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (void)showAlert:(TNOperationState )operation content:(NSString *)content{
    
    [self showAlert:operation content:content block:nil];
}
- (void)showAlert:(TNOperationState )operation content:(NSString *)content block:(MMPopupItemHandler) itemHandler{
    NSArray * items = nil;
    if (itemHandler) {
        items =
        @[MMItemMake(@"确定", MMItemTypeHighlight, itemHandler)];

    }
    [[[AlertView  alloc]initWithOperationState:operation detail:content items:items
      ] show];
}

- (void)showNormalAlertTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items block:(MMPopupItemHandler) itemHandler{

    if (!items) {
        items =
        @[MMItemMake(@"取消", MMItemTypeHighlight, nil),
          MMItemMake(@"确定", MMItemTypeHighlight, itemHandler)];
    }
     AlertView * alert = [[AlertView  alloc]initWithTitle:title detail:content items:items ];
     [alert show];
    
    
}

- (void)showAlertNormalInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder    handler:(MMPopupHandler)inputHandler {
    
    AlertView * alert = [[AlertView alloc]initWithNormalInputTitle:title detail:content items:items placeholder:placeholder handler:inputHandler ];
    
    [alert show];
    
    
}

- (void)showAlertInputPhoneTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder    handler:(MMPopupHandler)inputHandler {
    
    AlertView * alert = [[AlertView alloc]initWithInputPhoneTitle:title detail:content items:items placeholder:placeholder handler:inputHandler ];
    
    [alert show];
    
    
}

- (void)showAlertCreateInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder    handler:(MMPopupHandler)inputHandler{
    AlertView * alert = [[AlertView alloc]initWithCreateInputTitle:title detail:content items:items placeholder:placeholder handler:inputHandler ];
    
    [alert show];
  
    
}
- (void)showAlertValidationInputTitle:(NSString* )title content:(NSString *)content items:(NSArray *)items  placeholder:(NSString *)placeholder  handler:(MMPopupHandler)inputHandler  textFeildRightItem:(MMPopupItem *)rightItem{
 
   
    AlertView * alert = [[AlertView alloc]initWithValidationInputTitle:title detail:content items: items placeholder:placeholder handler:inputHandler  textFeildRightItem:rightItem ];
    [alert show];
  
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
