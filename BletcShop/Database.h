//
//  Database.h
//  BletcShop
//
//  Created by Bletc on 16/9/5.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fmdb/FMDatabase.h"

#import "Person.h"

typedef void(^NNDBBlock)(FMDatabase *nn_db);

@interface Database : NSObject


+(FMDatabase*)sharedatabase;

+(void)savePerdon:(Person*)person;

+(NSArray *)searchPersonFromID:(NSString*)IDstring;


@end
