//
//  SessionHelper.m
//  AplusKidsMasterPro
//
//  Created by neon on 16/5/16.
//  Copyright © 2016年 neon. All rights reserved.
//

#import "SessionHelper.h"
#import "SessionModel.h"
#import "CommonConfig.h"

@interface SessionHelper ()

@property (nonatomic,strong) id sessionData;
@end

@implementation SessionHelper

+(instancetype)sharedInstance {

    static dispatch_once_t onceToken;
    static SessionHelper *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SessionHelper alloc] init];
    });
    return sharedInstance;
}

- (void)saveCacheSession :(SessionModel *)session {

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:session];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:SESSIONMSG_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)checkUserStatus {
    NSData *loginSession=[[NSUserDefaults standardUserDefaults]objectForKey:SESSIONMSG_KEY];
    if(loginSession!=nil){
        SessionModel  *sessiondata = [NSKeyedUnarchiver unarchiveObjectWithData:loginSession];
        if(nil!=sessiondata && sessiondata.mobile){
            [[SessionHelper sharedInstance] setAppSession:sessiondata];
            return YES;
        }
    }
    return NO;
}



- (SessionModel *)getAppSession {
    return self.sessionData;
}

- (void)setAppSession:(SessionModel *)session {
    self.sessionData = session;
}


- (BOOL)checkSession {
    if ([[SessionHelper sharedInstance]getAppSession]) {
        return YES;
    }
    return NO;
}
- (NSString *)getSessionPhone{

    NSString * account = @"";
    NSData *loginSession=[[NSUserDefaults standardUserDefaults]objectForKey:SESSIONMSG_KEY];
    if(loginSession!=nil){
        SessionModel  *sessiondata = [NSKeyedUnarchiver unarchiveObjectWithData:loginSession];
        account = sessiondata.mobile;
    }
    return  account;
}

- (void)clearMessageList{
 
  
}


- (void)clearSaveCacheSession{

    NSString * phone = [[SessionHelper sharedInstance]getAppSession].mobile;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SESSIONMSG_KEY];
  
    SessionModel *sesstion =  [[SessionModel alloc]initWithDictionary:@{@"mobile":phone} error:nil];
 
    [[SessionHelper sharedInstance] setAppSession:sesstion];
    [[SessionHelper sharedInstance] saveCacheSession:sesstion];
    
    
}
//- (void)doneNetServiceWithResponseData:(id)responseData withState:(NSInteger)state withTag:(NSInteger)tag {
//    if (tag == self.ownClzzReq) {
//        if (state == TNStateOK) {
//            [[SessionHelper sharedInstance]setbindClazzList:responseData];
//        }
//    }
//}



@end