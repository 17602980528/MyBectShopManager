//
//  KKRequestDataService.m
//  taiya
//
//  Created by 杜康 on 15-3-18.
//  Copyright (c) 2015年 DuKang. All rights reserved.
//

#import "KKRequestDataService.h"



@implementation KKRequestDataService

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                            finishDidBlock:(FinishDidBlock)finishDidBlock
                           failuerDidBlock:(FailureDidBlock)failuerDidBlock
{
//    LoadingView *view = [LoadingView shareLoadingView];
//    [view show];
    //网络请求风火轮图标（/在向服务端发送请求状态栏显示网络活动标志）
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@", url];

    
    //创建Request请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    AFHTTPRequestOperation *operation = nil;
    
    //GET请求
    if ([httpMethod isEqualToString:@"GET"]) {
        operation = [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            finishDidBlock(operation, responseObject);
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            /*
             如果只是单独的返回一个字符串，不是JSON 用下面的方法
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
             
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSString *md5Str = [MD5 md5:string];
            */
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failuerDidBlock(operation, error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }];
    }
    

    //POST请求
    if ([httpMethod isEqualToString:@"POST"]) {
        //判断请求参数是否有文件数据
        BOOL isFile = NO;
        for (NSString *key in params) {
            id value = params[key];
            if ([value isKindOfClass:[NSData class]]) {
                isFile = YES;
                break;
            }
        }
    
        //没有文件类型
        if (!isFile) {
            operation = [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                
                finishDidBlock(operation, responseObject);
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                failuerDidBlock(operation, error);
                            }];
        }else{
            [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (NSString *key in params) {
                    id value = params[key];
                    if ([value isKindOfClass:[NSData class]]) {
                        
                        [formData appendPartWithFileData:value name:key fileName:key mimeType:@"image/jpeg"];
                    }
                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                finishDidBlock(operation, responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                failuerDidBlock(operation, error);
            }];
        }
    }
    
    //解析数据
//    operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    return operation;
}

@end
