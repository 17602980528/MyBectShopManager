//
//  CIA.h
//  CIA_SDK
//
//  Created by baoyz-mac on 15/4/28.
//  Copyright (c) 2015年 ciaapp. All rights reserved.
//

#import <Foundation/Foundation.h>

// 这里如果使用枚举swift里面switch会有转换问题，所以使用#define

#define CIA_VERIFICATION_SUCCESS 100 // 验证成功
#define CIA_SECURITY_CODE_MODE 101   // 验证码模式, 显示输入验证码页面
#define CIA_WAITTING_FOR_CODE 105   //请求成功，等待服务器呼叫
#define CIA_SECURITY_CODE_WRONG 102  // 验证码输入错误
#define CIA_SECURITY_CODE_EXPIRED 103    // 验证码已经过期
#define CIA_SECURITY_CODE_EXPIRED_INPUT_OVERRUN 104  // 验证码输入错误次数超过上限
#define CIA_REQUEST_FAIL 110 // 请求失败
#define CIA_REQUEST_EXCEPTION 111 // 请求异常


@interface CIA : NSObject

typedef void (^CIAVerifyCallback) (NSInteger code, NSString *msg, NSError *err);

typedef void (^CIAVerifyCodeCallback) (NSInteger code, NSString *msg, NSString *transId, NSError *err);

/**
 *  初始化SDK
 *  http://www.ciaapp.cn/
 *  @param appId   请输入开发者后台注册的AppId
 *  @param authKey 请输入开发者后台生成的authKey
 */
+ (void) initWithAppId:(NSString *)appId authKey:(NSString *)authKey;

/**
 *
 *  开始验证手机号码，请确保调用过 initWithAppId:authKey: 方法
 *  @param phoneNumber 需要验证的手机号码
 *  @param callback    验证结果回调
 */
+ (void) startVerificationWithPhoneNumber:(NSString *)phoneNumber callback:(CIAVerifyCallback) callback;

/**
 *
 *  开始验证手机号码，请确保调用过 initWithAppId:authKey: 方法
 *  @param phoneNumber 需要验证的手机号码
 *  @param callback    验证结果回调
 */
+ (void) startVerificationWithPhoneNumber:(NSString *)phoneNumber stateCallback:(CIAVerifyCallback) callback NS_DEPRECATED_IOS(6_0, 6_0);

/**
 *  校验验证码准确性
 *
 *  @param code     验证码
 *  @param callback 验证码校验回调
 */
+ (void) verifySecurityCode:(NSString *)code callback:(CIAVerifyCodeCallback) callback;

/**
 *  获取验证码
 *
 *  @return 验证码的后四位是****
 */
+ (NSString *)getSecurityCode;

/**
 *  取消当前的验证请求
 *
 */
+ (void)cancelVerification;

/**
 *  设置验证码的超时时间，单位：秒
 *
 */
+ (void)setSecurityCodeTimeout:(NSTimeInterval) timeout;

/**
 * 设置验证码允许输入错误的次数
 *
 */
+ (void)setSecurityCodeExpiredCount:(int) count;

@end