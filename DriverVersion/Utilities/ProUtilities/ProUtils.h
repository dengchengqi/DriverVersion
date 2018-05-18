//
//  ProUtils.h
//  AplusEduPro
//
//  Created by neon on 15/7/15.
//  Copyright (c) 2015年 neon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,ButtonContentType){

    ButtonContentType_imageRight  = 0,
    ButtonContentType_imageCenter     ,
};
@class LoginDO;

@interface ProUtils : NSObject
+ (BOOL)isNilOrEmpty:(NSString *)str;
+ (BOOL)isChinese:(NSString *)str;
+ (BOOL)IsPwd:(NSString *)str;
+ (NSString *)checkPwd:(NSString *)str;
+ (NSString *)checkAccount:(NSString *)str;
+ (NSString *)checkMobilePhone:(NSString *)str;

+ (NSString *)replacingCenterPhone:(NSString *)phone withReplacingSymbol:(NSString *)replacingSymbol;

//电话号码中间部分替换为*   range = NSMakeRange(3, 5)   replacing= :@"*****"
+(NSString *)replacingPhone:(NSString *)phone withCharactersRange:(NSRange )range withString:(NSString *)replacing;

+ (UIImage *) createImageWithColor:(UIColor *)color withFrame:(CGRect)rect;
+ (NSString *)decodeURL:(NSString *)string;
//左右摆动动画
+ (void) shake:(UIView *)view ;
/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value andWidth:(float)width;

//按钮垂直
- (void)setButtonContentCenter:(UIButton *) btn;
+ (void)phoneTextFieldEditChanged:(UITextField *)textField;
//限制长度
+ (void)confineTextFieldEditChanged:(UITextField *)textField withlength:(NSInteger )length;

+ (UIImage *)getResizableImage:(UIImage *)image withEdgeInset:(UIEdgeInsets ) insets;

+  (NSString *) compareCurrentTime:(NSString *)str;

+  (NSString *)updateTime:(NSString *)timeStr;
//比较两个日期大小
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
+  (NSAttributedString *)setAttributedText:(NSString *)text withColor:(UIColor *)color withRange:(NSRange )range withFont:(UIFont *)font;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;


//设置button 文字 图片位置
+ (void)setupButtonContent:(UIButton  *)button  withType:(ButtonContentType) type;
+ (void)setupButtonContent:(UIButton  *)button  withType:(ButtonContentType) type withSpacing:(CGFloat)spac;

+ (NSDictionary *)getZXLXUnitIconDic;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

//指定宽度按比例缩放
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;


/**
 *  富文本转html字符串
 */
+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri;

/**
 *  字符串转富文本
 */
+ (NSAttributedString *)strToAttriWithStr:(NSString *)htmlStr;

/**
 *  绘制虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 */
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

 

+ (NSDictionary *)parametersString:(NSDictionary *)parameters;

+ (NSString *)JSONString:(NSDictionary *)jsonObject;
@end
