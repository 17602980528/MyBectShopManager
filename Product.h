//
//  Product.h
//  BletcShop
//
//  Created by Bletc on 16/5/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
{
@private
float     _price;
NSString *_subject;
NSString *_body;
NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end
