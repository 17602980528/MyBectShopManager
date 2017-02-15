//
//  Message.h
//  WoLaiYe
//
//  Created by 鲁征东 on 16/6/24.
//  Copyright © 2016年 鲁征东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *subTitle;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *userName;
//@property(nonatomic,assign) CGFloat cellHight;

-(Message*)initWithDic:(NSDictionary*)dic;
@end
