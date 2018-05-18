

//
//  CompleteGoodsViewController.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//
#define MAX_IMAGE_COUNT             3
#define COLUMN_IMAGE_COUNT          4
#import "CompleteGoodsViewController.h"
#import "CompleteGoodsOneCell.h"
#import "CompleteGoodsImgVCell.h"
#import "CompleteGoodsAddImgVCell.h"
#import "UnloadModel.h"
#import "THScrollChooseView.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ProUtils.h"
#import <UserNotifications/UserNotifications.h>

static NSString *const CompleteGoodsImgVCellIdentifier = @"CompleteGoodsImgVCellIdentifier";
static NSString *const CompleteGoodsOneCellIdentifier = @"CompleteGoodsOneCellIdentifier";
static NSString *const CompleteGoodsAddImgVCellIdentifier = @"CompleteGoodsAddImgVCellIdentifier";
@interface CompleteGoodsViewController () <UNUserNotificationCenterDelegate>
@property(nonatomic, strong) NSMutableArray *selectedPhotos;//图片数据
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString  *goodNum;//货物号
@property(nonatomic, strong) UnloadModel * unloadModel;//卸货数据
@property(nonatomic, assign) NSInteger selectedUnitIndex;//选择卸货地址的index
@property(nonatomic, copy) NSString *unloadAddress;//选择的卸货地址
@property(nonatomic, copy) NSString * roughWeight;//毛重
@property(nonatomic, copy) NSString * tareWeight;//皮重
@property(nonatomic, strong) NSNumber  *orderId;//货物号
@property(nonatomic, copy) NSString *car_id;
#if __IPHONE_OS_VERSION_MAX_ALLOWED  >=  __IPHONE_10_0
@property (nonatomic, strong) UNMutableNotificationContent *notiContent;
#endif
@end

@implementation CompleteGoodsViewController
-(instancetype)initWihtType:(CompleteGoodsVCType)type  withOrderId:(NSNumber *)orderId withGoodNum:(NSString *)goodNum withCarid:(NSString *)car_id{
    self = [super init];
    if (self) {
        self.type = type;
        self.goodNum = goodNum;
        self.orderId = orderId;
        self.car_id = car_id;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * navT = @"";
    if (self.type == CompleteGoodsVCType_Complete) {
        navT = @"完成装货";
    }else if (self.type == CompleteGoodsVCType_Unload){
        navT = @"卸货";
        self.selectedUnitIndex = 0;
        [self requestUnloadAddress];
    }
    [self setNavigationItemTitle:navT ];
    [self setupBottomView];
    
    if (@available(iOS 10.0, *)){
        // Do any additional setup after loading the view, typically from a nib.
        self.notiContent = [[UNMutableNotificationContent alloc] init];
        //引入代理
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    }
}

- (void)regiterLocalNotification{
   if (@available(iOS 10.0, *)){
       [self regiterLocalNotification:self.notiContent];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0){
        [self addLocalNotificationForOldVersion];
    }
}
- (void)deleteLocalNotification{
    
    if (@available(iOS 10.0, *)){
         [self deleteLocalNotification:@"RequestIdentifier"];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0){
        
    }
}
- (void)deleteLocalNotification:(NSString *)identifier{
     if (@available(iOS 10.0, *)){
         [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
         
     }else if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0){
         
         //取消某一个通知
         NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
         //获取当前所有的本地通知
         if (!notificaitons || notificaitons.count <= 0) {
             return;
         }
         for (UILocalNotification *notify in notificaitons) {
             if ([[notify.userInfo objectForKey:@"id"] isEqualToString:@"LOCAL_NOTIFY_SCHEDULE_ID"]) {
                 //取消一个特定的通知
                 [[UIApplication sharedApplication] cancelLocalNotification:notify];
                 break;
             }
         }
     }
}
/**
 iOS 10以前版本添加本地通知
 */
- (void)addLocalNotificationForOldVersion {
    
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置调用时间
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60];//通知触发的时间，1个小时以后
    notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
    notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
 
    //设置通知属性
    notification.alertTitle = [@"货单号:" stringByAppendingString: self.goodNum ?self.goodNum:@""];
    notification.alertBody = @"司机打开提醒\n您已行驶2小时，请及时通知APP进行运输打卡，上报当前车辆位置"; //通知主体
    notification.applicationIconBadgeNumber = 1;//应用程序图标右上角显示的消息数
    notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    notification.soundName = UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    //    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"LOCAL_NOTIFY_SCHEDULE_ID",@"id", nil];
    　notification.userInfo = infoDic;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED  >=  __IPHONE_10_0
- (void)regiterLocalNotification:(UNMutableNotificationContent *)content{
    
    content.title = [@"货单号:" stringByAppendingString: self.goodNum?self.goodNum:@""];
    content.subtitle = @"司机打开提醒";
    content.body = @"您已行驶2小时，请及时通知APP进行运输打卡，上报当前车辆位置";
    content.badge = @1;
//    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"caodi.m4a"];
//    content.sound = sound;
    
    //重复提醒，时间间隔要大于60s
     NSTimeInterval Interval = 60*60*2;
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:Interval repeats:YES];
    NSString *requertIdentifier = @"RequestIdentifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error);
    }];
    
}
#endif
- (void)requestUnloadAddress{
    if (!self.goodNum && !self.car_id) {
        NSLog(@"订单号为空，或车id 为空");
        return;
    }
    NSDictionary * parameterDic = @{@"good_num": self.goodNum,@"car_id":self.car_id};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_xiehuo] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_xiehuo];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
          STRONGSELF
        if (request.tag == NetRequestType_xiehuo) {
            NSLog(@"%@==",successInfoObj);
            strongSelf.unloadModel = [[UnloadModel alloc]initWithDictionary:successInfoObj error:nil];
            
        }else if(request.tag == NetRequestType_unload){
            NSLog(@"%@==",successInfoObj);
            [strongSelf showImgSuccessAlert:@"卸货完成" withType:@"3"];
//            [strongSelf deleteLocalNotification];
        }else if (request.tag == NetRequestType_loading){
            NSLog(@"%@==",successInfoObj);
            [strongSelf showImgSuccessAlert:@"装货完成" withType:@"2"];
//            [strongSelf regiterLocalNotification];
        }
    }];
}
- (void)showImgSuccessAlert:(NSString *)detail withType:(NSString *)type{
    NSString * title = @"提示";
    NSString * content = detail;
    MMPopupItemHandler backBlock = ^(NSInteger index){
        NSArray *viewControllers = [self.navigationController viewControllers];
         UIViewController *view = viewControllers[0];
      
        [self.navigationController popToViewController:view animated:YES];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_HOME_PAGE" object:nil userInfo:@{@"type":type} ];
    };
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, backBlock)];
    [self showNormalAlertTitle:title content:content items:items block:nil];
    
}
- (void)registerCell{
    
   
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CompleteGoodsOneCell class]) bundle:nil] forCellWithReuseIdentifier:CompleteGoodsOneCellIdentifier];
     [self.collectionView registerClass: [CompleteGoodsImgVCell class]  forCellWithReuseIdentifier:CompleteGoodsImgVCellIdentifier];
     [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CompleteGoodsAddImgVCell class]) bundle:nil] forCellWithReuseIdentifier:CompleteGoodsAddImgVCellIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UICollectionViewLayout *)getCollectionViewLayout{
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.itemSize = CGSizeMake(IPHONE_WIDTH /4,IPHONE_WIDTH /4);
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 0;
    return collectionViewLayout;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (section == 0) {
        if (self.type == CompleteGoodsVCType_Complete) {
            row = 3;
        }else if (self.type == CompleteGoodsVCType_Unload){
            row = 4;
        }
    }else{
         row = 1;
        if (self.selectedPhotos.count ) {
            if ( [self.selectedPhotos count] < MAX_IMAGE_COUNT) {
                 row = self.selectedPhotos.count + 1;
            }else{
                row = self.selectedPhotos.count;
            }
        }
    }
    return row;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
         cell = [self getOneCollectionView:collectionView withIndexPath:indexPath];
        
    }else{
        if (indexPath.row == self.selectedPhotos.count) {
          cell = [self getAddImgVCollectionView:collectionView withIndexPath:indexPath];
        }else{
          cell = [self getImgVCollectionView:collectionView withIndexPath:indexPath];
        }
        
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UICollectionViewCell *)getOneCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath{
    
    CompleteGoodsOneCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:CompleteGoodsOneCellIdentifier forIndexPath:indexPath];
    NSString * title = @"";
    NSString * detail = @"";
    NSString * placeholderText = @"";
    UIKeyboardType  keyType = UIKeyboardTypeDefault;
    BOOL isShowLine = YES;//是否显示线
    BOOL isUnload = NO;//是否卸货点
    if (self.type == CompleteGoodsVCType_Complete) {
        switch (indexPath.row) {
            case 0:{
                title = @"毛重（吨）";
                if (self.roughWeight) {
                    detail = self.roughWeight;
                }
                placeholderText = @"请填写毛重";
                tempCell.inputText = ^(NSString *inputText) {
                    self.roughWeight = inputText;
                };
                keyType = UIKeyboardTypeNumberPad;
            }
                break;
            case 1:{
                title = @"皮重（吨）";
                if (self.tareWeight) {
                    detail = self.tareWeight;
                }
                 placeholderText = @"请填写皮重";
                tempCell.inputText = ^(NSString *inputText) {
                    self.tareWeight = inputText;
                };
                 keyType = UIKeyboardTypeNumberPad;
            }
                
                break;
            case 2:{
                title = @"磅单照片";
                isShowLine = NO;
            }
                
                break;
            default:
                break;
        }
        
    }else if (self.type == CompleteGoodsVCType_Unload){
        switch (indexPath.row) {
            case 0:{
                title = @"卸货点";
                if (self.unloadAddress) {
                    detail = self.unloadAddress;
                }
                placeholderText = @"请选择缺货点";
                isUnload = YES;
            }
                break;
            case 1:{
                title = @"毛重（吨）";
                if (self.roughWeight) {
                    detail = self.roughWeight;
                }
                placeholderText = @"请填写毛重";
                tempCell.inputText = ^(NSString *inputText) {
                    self.roughWeight = inputText;
                };
                 keyType = UIKeyboardTypeNumberPad;
            }
                break;
            case 2:{
                title = @"皮重（吨）";
                if (self.tareWeight) {
                    detail = self.tareWeight;
                }
                placeholderText = @"请填写皮重";
                tempCell.inputText = ^(NSString *inputText) {
                    self.tareWeight = inputText;
                };
                 keyType = UIKeyboardTypeNumberPad;
            }
                
                break;
            case 3:{
                title = @"磅单照片";
                isShowLine = NO;
            }
                
                break;
            default:
                break;
        }
        
    }
    tempCell.isShowLine = isShowLine;
    tempCell.isUnload = isUnload;
    [tempCell setupTextFeildType:keyType];
    [tempCell setupTitle:title withDetail:detail withPlaceholder:placeholderText];
    
    return tempCell;
    
}
- (UICollectionViewCell *)getImgVCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath{
    
    CompleteGoodsImgVCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:CompleteGoodsImgVCellIdentifier forIndexPath:indexPath];
     tempCell.imageView.image = self.selectedPhotos[indexPath.row];
     tempCell.asset = self.selectedAssets[indexPath.row];
     tempCell.deleteBtn.hidden = NO;
     tempCell.gifLable.hidden = YES;
     tempCell.deleteBtn.tag = indexPath.row;
     [tempCell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return tempCell;
}
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
    
}
- (UICollectionViewCell *)getAddImgVCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath{
    
    CompleteGoodsAddImgVCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:CompleteGoodsAddImgVCellIdentifier forIndexPath:indexPath];
    [tempCell setupImgMaxNum:MAX_IMAGE_COUNT withCurrenNum:[self.selectedPhotos count]];
    return tempCell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size =  CGSizeZero;
    if (indexPath.section == 0) {
        if (indexPath.row < 3&& indexPath.row >= 0) {
            size = CGSizeMake(IPHONE_WIDTH, 50);
        }else if(indexPath.row  == 3){
            size = CGSizeMake(IPHONE_WIDTH, 50);
        }
    } else{
        size = CGSizeMake(80, 80);
    }
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0 && self.type == CompleteGoodsVCType_Unload){
        
        [self showUnloadAddress];
    }
   else if (indexPath.section == 1) {
        [self pushImagePickerController];
    }
    
}

- (void)showUnloadAddress{
    
    NSMutableArray *questionArray =[NSMutableArray arrayWithCapacity:[self.unloadModel.info count]];
    for (UnloadInfoModel * infoModel in self.unloadModel.info) {
        [questionArray addObject:infoModel.unload_address];
    }
    NSString *defaultDesc = @"";
    if ([questionArray count] >0) {
       defaultDesc = questionArray[self.selectedUnitIndex];
        THScrollChooseView *scrollChooseView = [[THScrollChooseView alloc] initWithQuestionArray:questionArray withDefaultDesc:defaultDesc];
        [scrollChooseView showView];
        WEAKSELF
        scrollChooseView.confirmBlock = ^(NSInteger selectedQuestion) {
            weakSelf.selectedUnitIndex = selectedQuestion;
            UnloadInfoModel * infoModel = self.unloadModel.info[weakSelf.selectedUnitIndex];
            weakSelf.unloadAddress = infoModel.unload_address;
            [self updateCollectionView];
            NSLog(@"==%@==",infoModel.unload_address);
        };
        
      
    }else{
        
     NSArray * items = @[
              MMItemMake(@"确定", MMItemTypeHighlight, nil)];
        AlertView * alert = [[AlertView  alloc]initWithTitle:@"提示" detail:@"暂无地址" items:items];
        [alert show];
        
    }
    
   
}
#pragma mark ---
//预览图
- (void)lookImageDetail:(NSIndexPath *)indexPath{
    
    id asset = _selectedAssets[indexPath.row];
    BOOL isVideo = NO;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
    }
    // preview photos / 预览照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
    imagePickerVc.maxImagesCount = [_selectedAssets count];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.isSelectOriginalPhoto = NO;
    [imagePickerVc setNaviBgColor:project_main_blue];
    [imagePickerVc setNaviTitleFont:fontSize_18];
    
    [imagePickerVc setDoneBtnTitleStr:@"确定"];
    
    [imagePickerVc setOKButtonTitleColorNormal:[UIColor whiteColor]];
    [imagePickerVc setOKButtonTitleColorDisabled:[UIColor lightGrayColor]];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
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
 
    [self.collectionView reloadData];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
}
- (void)setupBottomView{
    UIButton * button = [UIButton  buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:project_main_color];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString * buttonTitle = @"确定";
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
 
    if (self.type == CompleteGoodsVCType_Unload) {
        [self requestUnload];
//        [self showImgSuccessAlert:@"卸货完成" withType:@"3"];
    }else if (self.type == CompleteGoodsVCType_Complete){
        [self requestComplete];
//          [self showImgSuccessAlert:@"装货完成" withType:@"2"];
    }
    
}


- (void)requestUnload{
    NSDictionary * parameterDic = nil;
    if (self.orderId && self.roughWeight && self.tareWeight && self.unloadAddress) {
      parameterDic = @{@"id":self.orderId,@"rough_weight":self.roughWeight,@"tare_weight":self.tareWeight,@"dynamic":self.unloadAddress};
    }
    if (!parameterDic) {
        
        return;
    }
    [self uploadImgV:NetRequestType_unload withDic:parameterDic];
}

- (void)requestComplete{
    NSDictionary * parameterDic = nil;
    if (self.orderId && self.roughWeight && self.tareWeight) {
        parameterDic = @{@"id":self.orderId,@"rough_weight":self.roughWeight,@"tare_weight":self.tareWeight};
    }
    if (!parameterDic) {
        
        return;
    }
    [self uploadImgV:NetRequestType_loading withDic:parameterDic];
}

- (void)uploadImgV:(NetRequestType)type withDic:(NSDictionary *)Dic{
    WEAKSELF
    self.startedBlock = ^(NetRequest *request)
    {
        [weakSelf showHUDInfoByType:HUDInfoType_Loading];
    };
//    NSURL * url = [NSURL URLWithString:Request_NameSpace_company_internal];
//    NSMutableDictionary * fileDic = [NSMutableDictionary dictionary];
    NSMutableArray * imgs = [NSMutableArray array];
    for (int i =0;i<[self.selectedAssets count] ;i++) {
        UIImage * image = self.selectedPhotos[i];
        [imgs addObject:[self base64String:image]];
        
//        NSString * fileName = @"";
//        if (iOS8Later) {
//
//            PHAsset * asset = self.selectedAssets[i];
//            fileName= asset.localIdentifier;
//            //            NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
//            //            fileName = ((PHAssetResource*)resources[0]).originalFilename;
//        } else {
//            ALAsset * asset = self.selectedAssets[i];
//            fileName =  asset.defaultRepresentation.filename;
//        }
 
//        [fileDic setObject:image forKey: fileName];
    }
    
    if ([self.selectedAssets count] > 0) {
        NSMutableDictionary * requestParameterDic = [NSMutableDictionary dictionary ];
        
//        [requestParameterDic addEntriesFromDictionary:@{@"apiCode":[NetRequestAPIManager getRequestURLStr:type]}];
        if (!Dic) {
            [requestParameterDic addEntriesFromDictionary:@{}];
        }else{
            [requestParameterDic addEntriesFromDictionary:Dic];
            
        }
        
        [requestParameterDic addEntriesFromDictionary:@{@"img":[imgs componentsJoinedByString:@","]}];
//        NSDictionary * jsonObject =  [ProUtils parametersString:requestParameterDic];
//        NSString * jsonStr = [ProUtils JSONString:jsonObject];
//        if (!jsonStr) {
//            
//            return ;
//        }
//        NSDictionary *jsonParameterDic = @{@"json":jsonStr};
        
//        [[NetRequestManager sharedInstance] sendUploadRequest: url parameterDic:jsonParameterDic requestMethodType:RequestMethodType_UPLOADIMG requestTag:type  delegate:self fileDic:fileDic];
        [weakSelf sendRequest:[NetRequestAPIManager getRequestURLStr:type] parameterDic:requestParameterDic requestMethodType:RequestMethodType_POST requestTag:type];
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


#if __IPHONE_OS_VERSION_MAX_ALLOWED  >=  __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
    NSLog(@"收到通知：%@",response.notification.request.content);
    
    if ([categoryIdentifier isEqualToString:@"Categroy"]) {
        //识别需要被处理的拓展
        if ([response.actionIdentifier isEqualToString:@"replyAction"]){
            //识别用户点击的是哪个 action
            UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
            //获取输入内容
            NSString *userText = textResponse.userText;
            //发送 userText 给需要接收的方法
            NSLog(@"要发送的内容是：%@",userText);
            //[ClassName handleUserText: userText];
        }else if([response.actionIdentifier isEqualToString:@"enterAction"]){
            NSLog(@"点击了进入应用按钮");
        }else{
            NSLog(@"点击了取消");
        }
        
    }
    completionHandler();
}


//只有当前处于前台才会走，加上返回方法，使在前台显示信息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSLog(@"执行willPresentNotificaiton");
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

#endif
@end
