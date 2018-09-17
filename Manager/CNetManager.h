//
//  CNetManager.h
//  Net
//
//  Created by dxw on 2018/8/3.
//  Copyright © 2018年 dxw. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CNetDefine.h"

@interface CNetManager : NSObject

@property (nonatomic, weak) id <CNetManagerCallBackDelegate> delegate;


@property (nonatomic, assign, readonly) CNetManagerRequestErrorType errorType;
@property (nonatomic, strong, readonly) NSDictionary * responseObject;
@property (nonatomic,   copy, readonly) NSString * identifer;

/**
 网络请求

 @param url 请求地址
 @param params 参数
 @param requestType 请求方式
 @param identifer 地址标示
 @param isEncryption 是否加密
 @return 发起的请求的ID
 */
- (NSInteger)requestDataWithUrl:(NSString * _Nonnull)url
                         params:(NSDictionary *)params
                    requestType:(CNetManagerRequestType)requestType
                      identifer:(NSString *)identifer
                   isEncryption:(BOOL)isEncryption;


/**
 取消某个ID的网络请求

 @param requestId 网络请求ID
 */
- (void)cancelRequestWithID:(NSInteger)requestId;

/**
 取消全部网络请求
 */
- (void)cancelAllRequest;
@end
