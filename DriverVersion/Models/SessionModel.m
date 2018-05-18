
//
//  SessionModel.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SessionModel.h"

@implementation SessionModel



//序列化
- (void)encodeWithCoder:(NSCoder *)aCoder{
  
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
 
    
}
//反序列化
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (!self) { return nil; }
    self.mobile = [aDecoder decodeObjectForKey:@"mobile"]; 
    return self;
}


@end
