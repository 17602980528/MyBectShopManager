//
//  KKRequestDataService.h
//  taiya
//
//  Created by 杜康 on 15-3-18.
//  Copyright (c) 2015年 DuKang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^FinishDidBlock)(AFHTTPRequestOperation *operation, id result);
typedef void (^FailureDidBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface KKRequestDataService : NSObject

+(AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                            finishDidBlock:(FinishDidBlock)finishDidBlock
                           failuerDidBlock:(FailureDidBlock)failuerDidBlock;

@end
