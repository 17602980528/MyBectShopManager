//
//  UploadHistoryViewController.h
//  iqiyi_ios_sdk_demo
//
//  Created by meiwen li on 4/1/13.
//  Copyright (c) 2013 meiwen li. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UploadHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_contentTableView;
}
@property(nonatomic,strong) NSArray * uploadingHistoryArray;


@end