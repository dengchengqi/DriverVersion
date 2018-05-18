//
//  ChangeInfoViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ChangeInfoViewController.h"
#import "InfoNameCell.h"
#import "InfoImageCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TabbarConfigManager.h"
#import "ProUtils.h"
#import "ChangeNameViewController.h"

NSString * const InfoNameCellIdentifier = @"InfoNameCellIdentifier";
NSString * const InfoImageCellIdentifier = @"InfoImageCellIdentifier";
@interface ChangeInfoViewController ()
@property(nonatomic, strong) NSMutableArray *selectedPhotos;//图片数据
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, copy) NSString * nickName;
@property(nonatomic, copy) NSString * imgUrl;
@property(nonatomic, strong) UIImage * localImg;
@end

@implementation ChangeInfoViewController
- (instancetype)initWithName:(NSString *)nickName withImgUrl:(NSString *)imgUrl{
    self = [super init];
    if (self) {
        self.nickName = nickName;
        self.imgUrl = imgUrl;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"个人资料"];
    [self setupBottomView];
}
- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 49);
}
- (void)setupBottomView{
    UIButton * button = [UIButton  buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:project_main_color];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString * buttonTitle = @"退出登录";
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [self.bottomView addSubview:button];
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height-49);
        make.height.mas_equalTo(@(49));
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY) ;
        make.height.mas_equalTo(@(44));
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
}

- (void)buttonAction:(id)sender{
    
    NSString * title = @"提示";
    NSString * content = @"是否退出登录";
    MMPopupItemHandler exitBlock = ^(NSInteger index){
       [self exitLogin];
    };
    MMPopupItemHandler canleBlock = ^(NSInteger index){
     
    };
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, exitBlock),
                         MMItemMake(@"取消", MMItemTypeHighlight, canleBlock)];
  
    [self showNormalAlertTitle:title content:content items:items block:nil];
    
}


- (void)exitLogin{
    [[SessionHelper sharedInstance] clearMessageList];
    [[SessionHelper sharedInstance] clearSaveCacheSession];
  
    [self gotoLoginViewController];
    
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InfoImageCell class]) bundle:nil] forCellReuseIdentifier:InfoImageCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InfoNameCell class]) bundle:nil] forCellReuseIdentifier:InfoNameCellIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        InfoImageCell * tempCell = [tableView dequeueReusableCellWithIdentifier:InfoImageCellIdentifier];
        [tempCell setupNetImage:self.imgUrl withLocationImg:self.localImg];
        cell = tempCell;
    }else if (indexPath.row == 1){
        InfoNameCell *tempCell = [tableView dequeueReusableCellWithIdentifier:InfoNameCellIdentifier];
        [tempCell setupName:self.nickName];
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self gotoChangeImg];
        
    }else if (indexPath.row == 1){
        [self gotoChangeName];
    }
}

- (void)gotoChangeName{
    
    ChangeNameViewController * vc = [[ChangeNameViewController alloc]initNickName:self.nickName];
    [self pushViewController:vc];
}

- (void)gotoChangeImg{
    UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:@"请选择头像来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self pushImagePickerController];
    }];
    [actionSheet addAction:photoAction];
    UIAlertAction *picAction = [UIAlertAction actionWithTitle:@"拍照"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
  
 
         [self takePhoto];
    }];
    [actionSheet addAction:picAction];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"  style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:action];
    [self presentViewController:actionSheet animated:YES completion:nil];
}



#pragma mark - TZImagePickerController


- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        //        [alert show];
        MMPopupItemHandler handler = ^(NSInteger index){
            // 去设置界面，开启相机访问权限
            if (iOS8Later) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                
                NSLog(@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢");
                
            }
            
        };
        NSArray * items = @[MMItemMake(@"取消", MMItemTypeNormal, nil),
                            MMItemMake(@"确定", MMItemTypeNormal, handler)];
        [self showNormalAlertTitle:@"无法使用相机" content:@"请在iPhone的""设置-隐私-相机""中允许访问相机" items:items block:nil];
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        
        
        MMPopupItemHandler handler = ^(NSInteger index){
            // 去设置界面
            if (iOS8Later) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                
                NSLog(@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢");
                
            }
            
        };
        NSArray * items = @[MMItemMake(@"取消", MMItemTypeNormal, nil),
                            MMItemMake(@"确定", MMItemTypeNormal, handler)];
        [self showNormalAlertTitle:@"无法访问相册" content:@"请在iPhone的""设置-隐私-相册""中允许访问相册" items:items block:nil];
        
        
    } else if ([TZImageManager authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
        
        
    } else {
        [self gotoImagePickerV];
    }
}

- (void)gotoImagePickerV{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [TabbarConfigManager presentViewController:self.imagePickerVc];
        
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                WEAKSELF
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [weakSelf refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    
    self.selectedPhotos = [NSMutableArray arrayWithObject:image];
    self.selectedAssets = [NSMutableArray arrayWithObject:asset];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)pushImagePickerController {
    int  MAX_IMAGE_COUNT = 1;
    int  COLUMN_IMAGE_COUNT =  4;
    if ( MAX_IMAGE_COUNT  <= 0) {
        return;
    }
    
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_IMAGE_COUNT columnNumber:COLUMN_IMAGE_COUNT delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if (MAX_IMAGE_COUNT > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [imagePickerVc setNaviBgColor:project_main_blue];
    [imagePickerVc setNaviTitleFont:fontSize_18];
    
    [imagePickerVc setDoneBtnTitleStr:@"确定"];
    
    [imagePickerVc setOKButtonTitleColorNormal:[UIColor whiteColor]];
    [imagePickerVc setOKButtonTitleColorDisabled:[UIColor lightGrayColor]];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}



#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    [self requestUserImg];
}

- (void)requestUserImg{
    WEAKSELF
    self.startedBlock = ^(NetRequest *request)
    {
        [weakSelf showHUDInfoByType:HUDInfoType_Loading];
    };
    
//    NSURL * url = [NSURL URLWithString:Request_NameSpace_company_internal];
//
//    NSMutableDictionary * fileDic = [NSMutableDictionary dictionary];
    for (int i =0;i<[self.selectedAssets count] ;i++) {
        UIImage * image = self.selectedPhotos[i];
        
        self.localImg = image;
        NSString * fileName = @"";
        if (iOS8Later) {
            
            PHAsset * asset = self.selectedAssets[i];
            fileName= asset.localIdentifier;
            //            NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
            //            fileName = ((PHAssetResource*)resources[0]).originalFilename;
        } else {
            ALAsset * asset = self.selectedAssets[i];
            fileName =  asset.defaultRepresentation.filename;
        }
        
//        [fileDic setObject:image forKey: fileName];
    }
 
    if ([self.selectedAssets count] > 0) {
        NSMutableDictionary * requestParameterDic = [NSMutableDictionary dictionary ];
         
        [requestParameterDic addEntriesFromDictionary:@{@"mobile": [[SessionHelper sharedInstance] getSessionPhone]}];
        [requestParameterDic  addEntriesFromDictionary:@{@"avatar_url":[self base64String:self.localImg]}];
//        NSDictionary * jsonObject =  [ProUtils parametersString:requestParameterDic];
//        NSString * jsonStr = [ProUtils JSONString:jsonObject];
//        if (!jsonStr) {
//            
//            return ;
//        }
//    NSDictionary *parameterDic = @{@"json":jsonStr};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_amend] parameterDic:requestParameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_amend];
//        [[NetRequestManager sharedInstance] sendUploadRequest: url parameterDic:jsonParameterDic requestMethodType:RequestMethodType_UPLOADIMG requestTag:NetRequestType_amend  delegate:self fileDic:fileDic];
    }
}

- (NSString *) base64String:(UIImage *)img{
    if ([img isKindOfClass:[UIImage class]]) {
        NSData *imageData = UIImageJPEGRepresentation(img, 0.4);
        NSString *image64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return image64;
    }else{
        return nil;
    }
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if(request.tag == NetRequestType_amend){
            NSLog(@"=%@=",successInfoObj[@"error"]);
            if ([successInfoObj[@"error"] integerValue]== 0) {
                [strongSelf  showUploadImgSucessAlert];
            }
           [strongSelf updateTableView];
        }
    }];
}
- (void)showUploadImgSucessAlert{
    MMPopupItemHandler backBlock = ^(NSInteger index){
        //刷新上一页的用户图片
      [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USER_INFO object: nil];
        UIViewController *target = nil;
        target = self.navigationController.viewControllers[ [self.navigationController.viewControllers count] - 2];
        if (target) {
            [self.navigationController popToViewController:target animated:YES]; //跳转
        }
        
    };
    
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, backBlock)];
    [self showNormalAlertTitle:@"提示" content:@"修改头像成功" items:items block:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
