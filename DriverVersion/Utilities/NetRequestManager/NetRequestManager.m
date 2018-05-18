//
//  NetRequestManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NetRequestManager.h"
#import "PublicDocuments.h"
#import "CachedDownloadManager.h"

@interface NetRequestManager ()

/// 保存所有的请求参数,已便如果session过期再重新登录以后发送上一次的历史请求
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSDictionary *parameterDic;
@property (nonatomic, retain) NSDictionary *requestHeaders;
@property (nonatomic, copy)   NSString *methodType;
@property (nonatomic, assign) int tag;
@property (nonatomic, weak) id<NetRequestDelegate> delegate;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSString *savePath;
@property (nonatomic, retain) NSString *tempPath;
@property (nonatomic, retain) NSDictionary *fileDic;


@end
@implementation NetRequestManager
DEF_SINGLETON(NetRequestManager);
- (id)init
{
    self = [super init];
    if (self)
    {
        netRequestArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.url = nil;
    self.parameterDic = nil;
    self.requestHeaders = nil;
    self.methodType = nil;
    self.userInfo = nil;
    self.savePath = nil;
    self.tempPath = nil;
    self.fileDic = nil;
    self.delegate = nil;
    netRequestArray = nil;
    
}


// 发送请求
- (void)startRequestWithUrl:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo savePath:(NSString *)savePath tempPath:(NSString *)tempPath fileDic:(NSDictionary *)fileDic  netCachePolicy:(NetCachePolicy)cachePolicy cacheSeconds:(NSTimeInterval)cacheSeconds
{
    // 保存所有的请求参数,已便如果session过期再重新登录以后发送上一次的历史请求
    self.url = url;
    self.parameterDic = parameterDic;
    self.requestHeaders = headers;
    self.methodType = methodType;
    self.tag = tag;
    self.delegate = delegate;
    self.userInfo = userInfo;
    self.savePath = savePath;
    self.tempPath = tempPath;
    self.fileDic = fileDic;
    
    
    NetRequest *netAFRequest = [[NetRequest alloc]init];
    netAFRequest.tag = tag;
    netAFRequest.parameterDic = parameterDic;
    netAFRequest.url = url;
    netAFRequest.methodType = methodType;
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //在http 头里添加数据
    if (headers && [headers isKindOfClass:[NSDictionary class]] &&headers.count != 0) {

        [configuration  setHTTPAdditionalHeaders:headers];

        for (NSString *headerKey in headers.allKeys)
        {
            [netAFRequest.manager.requestSerializer setValue:[headers objectForKey:headerKey]  forKey:headerKey];
        }

    }

    if (fileDic && [fileDic isKindOfClass:[NSDictionary class]] && fileDic.count != 0)
    {

        netAFRequest.fileDic = fileDic;
    }

    
    netAFRequest.manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
//    netAFRequest.manager =  [AFHTTPSessionManager manager];
    // 设置请求格式
//    netAFRequest. manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [netAFRequest.manager.requestSerializer setValue:@"application/json-rpc,application/json,application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    netAFRequest.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    [netAFRequest.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
//    // 设置超时时间
//    [netAFRequest.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    netAFRequest.manager.requestSerializer.timeoutInterval = 20;
//    [netAFRequest.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    //     设置返回格式
//    netAFRequest.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    netAFRequest.delegate = delegate;
    
    // 去除掉值为null的键值对
//    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
//    response.removesKeysWithNullValues = YES;
//    netAFRequest.manager.responseSerializer = response;
 
    
    //    /*
    //     1> NSURLRequestUseProtocolCachePolicy = 0, 默认的缓存策略， 如果缓存不存在，直接从服务端获取。如果缓存存在，会根据response中的Cache-Control字段判断下一步操作，如: Cache-Control字段为must-revalidata, 则询问服务端该数据是否有更新，无更新的话直接返回给用户缓存数据，若已更新，则请求服务端.
    //
    //     2> NSURLRequestReloadIgnoringLocalCacheData = 1, 忽略本地缓存数据，直接请求服务端.
    //
    //     3> NSURLRequestIgnoringLocalAndRemoteCacheData = 4, 忽略本地缓存，代理服务器以及其他中介，直接请求源服务端.
    //
    //     4> NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData
    //
    //     5> NSURLRequestReturnCacheDataElseLoad = 2, 有缓存就使用，不管其有效性(即忽略Cache-Control字段), 无则请求服务端.
    //
    //     6> NSURLRequestReturnCacheDataDontLoad = 3, 死活加载本地缓存. 没有就失败. (确定当前无网络时使用)
    //
    //     7> NSURLRequestReloadRevalidatingCacheData = 5, 缓存数据必须得得到服务端确认有效才使用(貌似是NSURLRequestUseProtocolCachePolicy中的一种情况)
    //     */
    //    netAFRequest.manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    //设置cookies 是否缓存
//    [netAFRequest.manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    
  
    [netAFRequest starRequest];
    
    [netRequestArray addObject:netAFRequest];
    
    
}

- (void)cachePolicy:(NetCachePolicy)cachePolicy withUrl:(NSURL *)url withParameter:(NSDictionary *)parameterDic withRequset:(NetRequest *)netAFRequest withCacheSeconds:(NSTimeInterval)cacheSeconds{

    // 判断是否要作数据缓存
    if (NetNotCachePolicy != cachePolicy)
    {
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDic options:0 error:&parseError];
        
      NSString * cacheAppendingPath  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *cacheKeyStr = [[url absoluteString] stringByAppendingFormat:@"/%@", cacheAppendingPath];
        
        // 如果存在缓存且没有过期则使用缓存数据,否则重新向服务器发送请求
        if (NetAskServerIfModifiedWhenStaleCachePolicy == cachePolicy)
        {
            NSData *cacheData = [CachedDownloadManager cachedResponseDataForKey:cacheKeyStr];
            // 存在缓存数据且没有过期
            if (cacheData)
            {
                netAFRequest.didUseCachedResponse = YES;
                
                if (netAFRequest.delegate && [netAFRequest.delegate respondsToSelector:@selector(netRequest:successWithInfoObj:)])
                {
                    NSDictionary * infoObj =  [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:NULL];
                    [netAFRequest.delegate netRequest:netAFRequest successWithInfoObj:infoObj];
                    
                    return;
                }
            }
            else
            {
                netAFRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:cacheKeyStr,cacheKey,[NSNumber numberWithDouble:cacheSeconds],cacheExpiresInSecondsKey, nil];
            }
        }
        // 无视缓存数据,总是向服务器请求新的数据
        else if (NetAlwaysAskServerCachePolicy == cachePolicy)
        {
            // 删除旧的缓存数据
            [CachedDownloadManager removeCachedDataForKey:cacheKeyStr];
            
            netAFRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:cacheKeyStr,cacheKey,[NSNumber numberWithDouble:cacheSeconds],cacheExpiresInSecondsKey, nil];
        }
    }
}

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    [self sendRequest:url parameterDic:parameterDic requestMethodType:RequestMethodType_GET requestTag:tag delegate:delegate userInfo:userInfo];
}

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;

{
    [self sendRequest:url parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo];
}

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    
    [self startRequestWithUrl:url parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo savePath:nil tempPath:nil fileDic:nil netCachePolicy:NetNotCachePolicy cacheSeconds:1*24*60*60];
}
/////////////////////////////////////////////////////////////////////////

- (void)sendDownloadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate savePath:(NSString *)savePath tempPath:(NSString *)tempPath
{
    [self sendDownloadRequest:url parameterDic:parameterDic requestMethodType:methodType requestTag:tag delegate:delegate userInfo:nil savePath:savePath tempPath:tempPath];
}

- (void)sendDownloadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo savePath:(NSString *)savePath tempPath:(NSString *)tempPath
{
    [self startRequestWithUrl:url parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo savePath:savePath tempPath:tempPath fileDic:nil netCachePolicy:NetNotCachePolicy cacheSeconds:1*24*60*60 ];
}
/////////////////////////////////////////////////////////////////////////

- (void)sendUploadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate fileDic:(NSDictionary *)fileDic
{
    [self sendUploadRequest:url parameterDic:parameterDic requestMethodType:methodType requestTag:tag delegate:delegate userInfo:nil fileDic:fileDic];
}

- (void)sendUploadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo fileDic:(NSDictionary *)fileDic
{
    [self startRequestWithUrl:url parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo savePath:nil tempPath:nil fileDic:fileDic netCachePolicy:NetNotCachePolicy cacheSeconds:1*24*60*60];
}


/////////////////////////////////////////////////////////////////////////

- (void)sendLatestRequest
{
    [self startRequestWithUrl:self.url parameterDic:self.parameterDic requestHeaders:self.requestHeaders requestMethodType:self.methodType requestTag:self.tag delegate:self.delegate userInfo:self.userInfo savePath:self.savePath tempPath:self.tempPath fileDic:self.fileDic netCachePolicy:NetNotCachePolicy cacheSeconds:1*24*60*60];
}


- (void)clearDelegate:(id<NetRequestDelegate>)delegate
{
    NSMutableArray *toRemoveRequestArray = [NSMutableArray array];
    
    for (NetRequest *request in netRequestArray)
    {
        if (delegate == request.delegate)
        {
            
            [request.manager.operationQueue cancelAllOperations];
            [toRemoveRequestArray addObject:request];
             request.delegate = nil;
            
        }
      
        
    }
    
    
    if (0 != toRemoveRequestArray.count)
    {
        [netRequestArray removeObjectsInArray:toRemoveRequestArray];
    }
    
}


- (void) removeRequest:(NetRequest*)request
{
    NSURLSessionDataTask *task = request.task ;
    [task cancel];
    
    [netRequestArray removeObject:request];
}

- (void)downloadTaskPause:(NSInteger)tag{

    for (NetRequest *request in netRequestArray) {
        if (request.tag == tag) {
           
            [request.downloadTask suspend];
        }
    }
    
}
- (void)downloadTaskResume:(NSInteger)tag{
    
    for (NetRequest *request in netRequestArray) {
        if (request.tag == tag) {
            
            [request.downloadTask resume];
        }
    }
    
}

- (void)downloadTaskCancel:(NSInteger)tag{
    for (NetRequest *request in netRequestArray) {
        if (request.tag == tag) {
            
            [request.downloadTask cancel];
        }
    }
}
@end
