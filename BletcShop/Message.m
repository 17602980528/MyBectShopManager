//
//  Message.m
//  WoLaiYe
//
//  Created by 鲁征东 on 16/6/24.
//  Copyright © 2016年 鲁征东. All rights reserved.
//

#import "Message.h"
#import "MessageCell.h"
@implementation Message

-(Message*)initWithDic:(NSDictionary*)dic{
    
    self.avatar = dic[@"avatar"];
    self.subTitle = dic[@"message"];
    self.title = dic[@"userName"];
//    self.userName = dic[@"userName"];

    
    return self;
}

//-(CGFloat)cellHight{
//    
//    MessageCell *cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:message];
//    _cellHight = [cell cellHightWithModel:self];
//    return _cellHight;
//    
//}
@end
