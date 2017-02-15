//
//  SellerViewController.h
//  BletcShop
//
//  Created by Bletc on 16/3/31.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "VCOPClient.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SellerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property(nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,retain) UITableView *shopTableView;
@property(nonatomic,retain)NSMutableDictionary *infoDic;
@property(nonatomic,retain)NSMutableArray *cardArray;//卡
@property(nonatomic,retain)NSMutableArray *appraiseArray;//评价
@property(nonatomic)CLLocationDegrees latitude;
@property(nonatomic)CLLocationDegrees longitude;
@property BOOL state;
@property(nonatomic,retain)UIButton *rightdBt;
@property(nonatomic,retain)NSMutableArray *pictureAndTextArray;//图文详情
@property(nonatomic,retain)NSArray *data;

@property(nonatomic,retain)UIButton *okButton;
@property(nonatomic,retain)UIButton *noButton;

@property(nonatomic,copy)NSString *videoID;
@property(nonatomic,copy)NSString *playUrl;

@property (strong, nonatomic) MPMoviePlayerController *player;
@property(strong,nonatomic)UIButton *playImageView;
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic,copy)NSString *imageStr;
@property(nonatomic,strong)NSDictionary *priseDic;

@end
