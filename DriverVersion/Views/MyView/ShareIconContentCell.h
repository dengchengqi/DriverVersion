//
//  ShareIconContentCell.h
//  DriverVersion
//
//  Created by DCQ on 2018/3/23.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ShareIconType) {
    ShareIconType_pengyouquan =0,//朋友圈
    ShareIconType_weixin  ,
    ShareIconType_QQ  ,
    ShareIconType_QQKJ ,//空间
};
typedef void(^TouchShareIconTypeBlock)(ShareIconType type);
@interface ShareIconContentCell : UITableViewCell
@property(nonatomic, strong) TouchShareIconTypeBlock  touchTypeBlock;
@end
