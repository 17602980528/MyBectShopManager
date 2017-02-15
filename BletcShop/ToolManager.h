//
//  ToolManager.h
//  BletcShop
//
//  Created by Bletc on 16/9/12.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolManager : NSObject
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
+ (BOOL) validateMobile:(NSString *)mobile;



@end
