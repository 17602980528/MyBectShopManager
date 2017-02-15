//
//  DebugLog.h
//  iqiyi_ios_sdk_demo
//
//  Created by MaohuaLiu on 4/16/13.
//  Copyright (c) 2013 meiwen li. All rights reserved.
//

#ifdef  DEBUG
#define DebugLog(format, ...) NSLog(format, ##__VA_ARGS__)

#else
#define DebugLog(format, ...)
#endif
