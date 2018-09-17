//
//  CApiProxy.m
//  Net
//
//  Created by dxw on 2018/8/3.
//  Copyright © 2018年 dxw. All rights reserved.
//

#import "CApiProxy.h"
#import <AFNetworking/AFNetworking.h>

#ifdef DEBUG

#define MLog(fmt, ...) NSLog((@"调用的方法:%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else

#define MLog(...)

#endif


@interface CApiProxy()
@property (nonatomic, strong) NSMutableDictionary  * requestTable;
@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;
@end
@implementation CApiProxy

+ (CApiProxy *)sharedInstance{
    static CApiProxy * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CApiProxy alloc] init];
    });
    
    return sharedInstance;
}
#pragma mark -- public method
- (NSNumber *)p_callApiWithRequest:(NSURLRequest *)request success:(CApiCallBackSuccessBlock)success fail:(CApiCallBackFailBlock)fail{

    
    __weak typeof(self) weakSelf = self;
    __block NSURLSessionTask * task = nil;
    task = [self.sessionManager dataTaskWithRequest:request
                                     uploadProgress:nil
                                   downloadProgress:nil
                                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSNumber * requestId = @(task.taskIdentifier);
        [strongSelf.requestTable removeObjectForKey:requestId];

        if (error) {
            fail? fail(error):nil;
        }else{
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            MLog(@"responseData == %@",dataDic);
            success? success(dataDic):nil;
        }
    }];
    
    NSNumber * requestId = @(task.taskIdentifier);
    
    self.requestTable[requestId] = task;
    
    [task resume];
    
    return requestId;
}
//取消某个id的请求
- (void)cancelRequestWithRequestId:(NSNumber *)requestId{
    NSURLSessionTask * requestOperation = self.requestTable[requestId];
    [requestOperation cancel];
    [self.requestTable removeObjectForKey:requestId];
}
//取消多个id的请求
- (void)cancelRequestWithRequestList:(NSArray *)requestList{
    for (NSNumber * requestId in requestList) {
        [self cancelRequestWithRequestId:requestId];
    }
}
#pragma mark -- Getter && Setter
- (NSMutableDictionary *)requestTable{
    if (!_requestTable) {
        _requestTable = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _requestTable;
}
- (AFHTTPSessionManager *)sessionManager{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

@end
