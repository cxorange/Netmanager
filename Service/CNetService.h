//
//  CNetService.h
//  Net
//
//  Created by dxw on 2018/8/3.
//  Copyright © 2018年 dxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNetDefine.h"
@interface CNetService : NSObject<CNetServiceDelegate>
@property (nonatomic, assign) BOOL isEncryption;
+ (CNetService *)sharedInstance;
@end
