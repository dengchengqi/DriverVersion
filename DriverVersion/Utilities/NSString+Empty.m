
//
//  NSString+Empty.m
//  DriverVersion
//
//  Created by DCQ on 2018/3/26.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "NSString+Empty.h"

@implementation NSString (Empty)
- (NSString *)filterEmpty{
    NSString * str = self;
    if (![str isKindOfClass:[NSString class]]) {
        str = @"";
    }
    if ([str isEqualToString:@"<null>"]) {
        str = @"";
    }
    return str;
}
@end
