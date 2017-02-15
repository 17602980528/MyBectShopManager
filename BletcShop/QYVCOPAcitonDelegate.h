//
//  QYVCOPAcitonDelegate.h
//  iqiyi_ios_sdk_demo
//
//  Created by 苏 瑞强 on 13-4-20.
//  Copyright (c) 2013年 meiwen li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QYVCOPAcitonDelegate <NSObject>
@optional

-(void)vcopAcitonButtonPressed:(id)sender tag:(int)buttonTag userInfo:(id)userInfo;

-(void)vcopAcitonTextFiled:(id)sender tag:(int)queryTag userInfo:(id)useInfo;

@end
