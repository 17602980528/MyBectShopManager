//
//  NSString+Addition.h
//  RoySinaWeiboTest
//
//  Created by 智游集团 on 16/1/5.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Addition)
- (NSString *)noWhiteSpaceString;

- (BOOL)isContainSubString:(NSString *)aSubstr;

- (NSString *)sinaWeiboCreatedAtString;

- (NSString *)sinaWeiboSourceString;

- (float)getTextHeightWithShowWidth:(float)width AndTextFont:(UIFont *)aFont AndInsets:(float)inset;

- (NSArray <NSTextCheckingResult *> *)myMatchWithPattern:(NSString *)aPattern;

+(NSString *)getTheNoNullStr:(id)str andRepalceStr:(NSString*)replace;
+ (BOOL) checkCardNo:(NSString*) cardNo;

//判断是整数
+ (BOOL)isPureInt:(NSString*)string;

//是否是小数
+ (BOOL)isPureFloat:(NSString*)string;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (BOOL) isMobileNum:(NSString *)mobNum;
+ (CGFloat)calculateRowWidth:(UILabel *)lable;
- (NSString *)stringByReversed;//字符串倒序
+(NSString*)getCurrentTimestamp;
+(NSString *)getSecretStringWithPhone:(NSString *)phone;
@end




