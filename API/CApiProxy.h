//
//  CApiProxy.h
//  Net
//
//  Created by dxw on 2018/8/3.
//  Copyright © 2018年 dxw. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CApiCallBackSuccessBlock) (NSDictionary * responseObject);
typedef void(^CApiCallBackFailBlock) (NSError * error);
@interface CApiProxy : NSObject

+ (CApiProxy *)sharedInstance;

- (NSNumber *)p_callApiWithRequest:(NSURLRequest * _Nonnull)request success:(CApiCallBackSuccessBlock)success fail:(CApiCallBackFailBlock)fail;

- (void)cancelRequestWithRequestId:(NSNumber  * _Nonnull)requestId;
- (void)cancelRequestWithRequestList:(NSArray * _Nonnull)requestList;
@end
