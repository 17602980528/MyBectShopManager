//
//  FirstViewController.h
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SellerViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#define BUTTONOFFSET ((SCREENWIDTH-300)/6.0f)
#define BUTTONOFFSETT ((SCREENWIDTH-400)/6.0f)
#define BackColor  [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.f/255.0f alpha:1.0f]
#define LabelTextColor1  [UIColor colorWithRed:255.0f/255.0f green:105.0f/255.0f blue:149.f/255.0f alpha:1.0f]
#define LabelTextColor2  [UIColor colorWithRed:92.0f/255.0f green:160.0f/255.0f blue:231.f/255.0f alpha:1.0f]
#define LabelTextColor3  [UIColor colorWithRed:177.0f/255.0f green:203.0f/255.0f blue:42.f/255.0f alpha:1.0f]
#define LabelTextColor4  [UIColor colorWithRed:254.0f/255.0f green:178.0f/255.0f blue:31.f/255.0f alpha:1.0f]
#define LabelTextColor5  [UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:6.f/255.0f alpha:1.0f]
#define LabelTextColor6  [UIColor colorWithRed:69.0f/255.0f green:165.0f/255.0f blue:244.f/255.0f alpha:1.0f]
#define LabelTextColor7  [UIColor colorWithRed:250.0f/255.0f green:117.0f/255.0f blue:112.f/255.0f alpha:1.0f]
#define LabelTextColor8  [UIColor colorWithRed:28.0f/255.0f green:187.0f/255.0f blue:163.f/255.0f alpha:1.0f]
@interface FirstViewController : UIViewController<UITextFieldDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIActivityIndicatorView *activity;
    UIScrollView *guanggao;
    NSTimer *timer;
    int _speed;
    UIScrollView *guanggao1;
}

@property(nonnull,retain)NSMutableArray *shopArray;//广告3
@property(nonnull,retain)NSMutableArray *advArray1;//1
@property(nonnull,retain)NSMutableArray *advArray2;//2
@property(nonnull,retain)NSArray *allClassArray;//最上方  多按钮
@property(nonnull,retain)NSMutableDictionary *allDic;
@property(nonnull,retain)NSString *nowCity;
@property(strong, nonnull) CLLocationManager *locationManager;
@property(nonnull,retain)NSArray *areaListArray;
@property (nonnull,strong)UICollectionView *collectionView;
@property (nonnull,strong)UICollectionViewCell *myCell;
@property(nonnull,retain)NSString *cityChoice;
@property BOOL ifOpen;
@property(nonnull,retain)UIButton *cityBtn;

@end
