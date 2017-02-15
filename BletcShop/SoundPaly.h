//
//  SoundPaly.h
//  ShiPin2
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@interface SoundPaly : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}
- (id)initSystemShake;//系统 震动
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
- (void)play;//播放声音+震动
+ (SoundPaly *)sharedManager:(NSString *)name type:(NSString *)type;


-(id)initForPlayingSoundEffectWith:(NSString *)filename;

- (void)playSound;//播放声音


@end
