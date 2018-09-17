//
//  CNetService+Encryption.h
//  EdugradianAngel
//
//  Created by chenxiang on 2018/9/16.
//  Copyright © 2018年 cx. All rights reserved.
//

#import "CNetService.h"

@interface CNetService (Encryption)
- (NSDictionary *)encryptionWithMessage:(NSDictionary *)parameters;
@end
