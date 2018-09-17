//
//  CNetService+Encryption.m
//  EdugradianAngel
//
//  Created by chenxiang on 2018/9/16.
//  Copyright © 2018年 cx. All rights reserved.
//

#import "CNetService+Encryption.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CNetService (Encryption)
- (NSDictionary *)encryptionWithMessage:(NSDictionary *)parameters{
    NSString * md5String;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (parameters) {
        //将所有的key放进数组
        NSArray *allKeyArray = [parameters allKeys];
        
        //序列化器对数组进行排序的block 返回值为排序后的数组
        NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            //小写转化
            obj1 = [obj1 lowercaseString];
            obj2 = [obj2 lowercaseString];
            //排序操作
            NSComparisonResult resuest = [obj1 compare:obj2];
            return resuest;
        }];
        
        //通过排列的key值获取value
        NSMutableArray *valueArray = [NSMutableArray array];
        NSMutableArray *parametersArray = [NSMutableArray array];
        for (NSString *sortsing in afterSortKeyArray) {
            NSString *valueString = [parameters objectForKey:sortsing];
            [valueArray addObject:valueString];
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@=%@",sortsing,valueString];
            [parametersArray addObject:str];
        }
        
        NSString *str = [parametersArray componentsJoinedByString:@","];//,为分隔符
        NSString *str2 = [str stringByReplacingOccurrencesOfString:@"," withString:@"&"];
        
        NSString *key = [defaults objectForKey:@"KEY"];
        NSString *str6 = [NSString stringWithFormat:@"%@&key=%@",str2,key];
        md5String = [self md532BitUpper:str6];
    }else{
        md5String = @"{}";
    }
    NSString *worker = [defaults objectForKey:@"WORKER"];
    NSDictionary * encryption = @{@"SIGN":md5String,
                                  @"WORKER":worker,
                                  @"TE":@"1"
                                  };
    return encryption;
}

/**
 *  把字符串加密成32位大写md5字符串
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位大写md5字符串
 */
- (NSString*)md532BitUpper:(NSString*)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (uint32_t)strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}
@end
