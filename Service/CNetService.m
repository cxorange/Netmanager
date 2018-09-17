//
//  CNetService.m
//  Net
//
//  Created by dxw on 2018/8/3.
//  Copyright © 2018年 dxw. All rights reserved.
//

#import "CNetService.h"
#import "CNetService+Encryption.h"
#import <AFNetworking/AFNetworking.h>
@interface CNetService()

@property (nonatomic, copy) NSString * rootUrl;//根Url
@property (nonatomic, copy) NSString * requestMethod;//请求方式

@property (nonatomic, assign) CServiceAPIEnviroment enviroment;//项目环境
@property (nonatomic, assign) CNetManagerRequestType requestType;//请求类型

@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization>* httpRequestSerializer;
@end
@implementation CNetService
+ (CNetService *)sharedInstance{
    static dispatch_once_t onceToken;
    static CNetService * service = nil;
    dispatch_once(&onceToken, ^{
        service = [[CNetService alloc] init];
    });
    
    return service;
}
#pragma mark -- CNetServiceDelegate
- (NSURLRequest *)requestWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(CNetManagerRequestType)requestType isEncryption:(BOOL)isEncryption{
    self.requestType = requestType;
    NSString * urlString = [NSString stringWithFormat:@"%@%@",self.rootUrl, url];
    
    NSMutableURLRequest * request = [self.httpRequestSerializer requestWithMethod:self.requestMethod URLString:urlString parameters:params error:nil];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if (isEncryption == YES) {
        NSDictionary * encryptionDic = [self encryptionWithMessage:params];
        NSArray * keys = encryptionDic.allKeys;
        [keys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [request setValue:encryptionDic[obj] forHTTPHeaderField:obj];
        }];
    }
    return [request copy];
}

#pragma mark -- Getter && Setter

- (CServiceAPIEnviroment)enviroment{
    return CServiceAPIEnviromentDeveloper;
}

//不同的项目环境，对应不同url
- (NSString *)rootUrl{
    switch (self.enviroment) {
        case CServiceAPIEnviromentDeveloper:
        {
            _rootUrl = @"http://192.168.1.200:81/hu";
        }
            break;
        case CTServiceAPIEnvironmentRelease:{
             _rootUrl = @"http://api.bgzyedu.com";
        }
            break;
        default:
            break;
    }
    
    return _rootUrl;
}
- (NSString *)requestMethod{
    switch (self.requestType) {
        case CNetManagerRequestGet   : _requestMethod = @"GET"   ; break;
        case CNetManagerRequestPost  : _requestMethod = @"POST"  ; break;
        case CNetManagerRequestPut   : _requestMethod = @"PUT"   ; break;
        case CNetManagerRequestDelete: _requestMethod = @"DELETE"; break;
        default:
            break;
    }
    return _requestMethod;
}
- (AFHTTPRequestSerializer *)httpRequestSerializer{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _httpRequestSerializer;
}
@end
