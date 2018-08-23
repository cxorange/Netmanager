//
//  CNetManager.m
//  Net
//
//  Created by dxw on 2018/8/3.
//  Copyright © 2018年 dxw. All rights reserved.
//

#import "CNetManager.h"
#import "CNetService.h"
#import "CApiProxy.h"
@interface CNetManager()

@property (nonatomic, strong) NSMutableArray * requestIdList;
@property (nonatomic, strong, readwrite) NSDictionary * responseObject;

@property (nonatomic, assign) CNetManagerRequestType requestType;
@property (nonatomic, assign, readwrite) CNetManagerRequestErrorType errorType;

@property (nonatomic, copy, readwrite) NSString * identifer;
@end
@implementation CNetManager
- (instancetype)init{
    if (self = [super init]) {
        self.requestType = CNetManagerRequestGet;
    }
    
    return self;
}
#pragma mark -- public method
- (NSInteger)requestDataWithUrl:(NSString *)url params:(NSDictionary *)parames requestType:(CNetManagerRequestType)requestType identifer:(NSString *)identifer{
    self.identifer = [identifer copy];
    self.requestType = requestType;
    
    NSInteger requestId = [self p_privateRequestWithUrl:url params:parames requestType:_requestType];
    
    return requestId;
}
//根据Id取消请求
- (void)cancelRequestWithID:(NSInteger)requestId{
    BOOL isContain = [self.requestIdList containsObject:@(requestId)];
    if (isContain) {
        [self p_privateRemoveRequestIdWithRequestID:requestId];
        [[CApiProxy sharedInstance] cancelRequestWithRequestId:@(requestId)];
    }
   
}
//取消全部请求
- (void)cancelAllRequest{
    [[CApiProxy sharedInstance] cancelRequestWithRequestList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}
#pragma mark -- private method
//发起请求
- (NSInteger)p_privateRequestWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(CNetManagerRequestType)requestType{
    NSCAssert(url, @"url 不能为空");
    id <CNetServiceDelegate> service = [CNetService sharedInstance];
    
    //创建
    NSURLRequest * request = [service requestWithUrl:url parans:params requestType:requestType];
    __weak typeof(self) weakSelf = self;
    //发起
    __block NSNumber * requestId = nil;
    requestId = [[CApiProxy sharedInstance] p_callApiWithRequest:request success:^(NSDictionary * responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.requestIdList removeObject:requestId];
        strongSelf.responseObject = [responseObject copy];
        if ([strongSelf.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]) {
            [strongSelf.delegate managerCallAPIDidSuccess:strongSelf];
        }
    } fail:^(NSError *error) {
        self.errorType = error.code;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(managerCallAPIDidFail:)]) {
            [strongSelf.delegate managerCallAPIDidFail:strongSelf];
        }
    }];
    
    [self.requestIdList addObject:requestId];
   
    return [requestId integerValue];
}
//删除保存的requestId
- (void)p_privateRemoveRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
#pragma mark -- Getter
- (NSMutableArray *)requestIdList{
    if (!_requestIdList) {
        _requestIdList = [NSMutableArray arrayWithCapacity:0];
    }
    return _requestIdList;
}
#pragma mark -- dealloc
- (void)dealloc{
    [self cancelAllRequest];
    self.requestIdList = nil;
}
@end
