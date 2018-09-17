//
//  CNetDefine.h
//  Net
//
//  Created by dxw on 2018/8/3.
//  Copyright © 2018年 dxw. All rights reserved.
//

#ifndef CNetDefine_h
#define CNetDefine_h

@class CNetManager;



typedef NS_ENUM(NSUInteger, CServiceAPIEnviroment){
    CServiceAPIEnviromentDeveloper,
    CTServiceAPIEnvironmentRelease
};

typedef NS_ENUM(NSUInteger, CNetManagerRequestType){
    CNetManagerRequestGet,
    CNetManagerRequestPost,
    CNetManagerRequestPut,
    CNetManagerRequestDelete
};

typedef NS_ENUM(NSUInteger, CNetManagerRequestErrorType){
    CNetManagerRequestErrorBadRequest    = 400,
    CNetManagerRequestErrorUnauthorized  = 401,
    CNetManagerRequestErrorNotFount      = 404,
    CNetManagerRequestErrotServerUnusual = 500,
    CNetManagerRequestErrorCancel        = -999
};
//manager回调协议
@protocol CNetManagerCallBackDelegate <NSObject>
- (void)managerCallAPIDidSuccess:(CNetManager * _Nonnull)manager;
- (void)managerCallAPIDidFail:(CNetManager * _Nonnull)manager;
@end
//service协议
@protocol CNetServiceDelegate <NSObject>
- (NSURLRequest *)requestWithUrl:(NSString *)url params:(NSDictionary *)params requestType:(CNetManagerRequestType)requestType isEncryption:(BOOL)isEncryption;
@end

#endif /* CNetDefine_h */
