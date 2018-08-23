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

- (NSInteger)requestDataWithUrl:(NSString * _Nonnull)url params:(NSDictionary *)params requestType:(CNetManagerRequestType)requestType identifer:(NSString *)identifer;

- (void)cancelRequestWithID:(NSInteger)requestId;
- (void)cancelAllRequest;
@end
