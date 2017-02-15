//
//  QYViewController.h
//  iqiyi_ios_sdk_demo
//
//  Created by meiwen li on 3/4/13.
//  Copyright (c) 2013 meiwen li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCOPClient.h"
#import "VCOPView.h"
#import "Item.h"
#import "UIImageView+WebCache.h"
@interface VCOPViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong) VCOPView* contentView;
@property(nonatomic,copy) NSString *resumeFileID;
@property(nonatomic, strong)    NSMutableArray* uploadHistory;
@property(nonatomic, strong)    Item* onUploadingItem;
@property(nonatomic,copy)NSString *videoID;
-(void)setVideoMetaInfo:(NSDictionary*)useInfo;

@end
