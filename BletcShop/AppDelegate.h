//
//  AppDelegate.h
//  BletcShop
//18220813244
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CIA_SDK/CIA_SDK.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "Singleton.h"



#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "CustomIOSAlertView.h"
@class VCOPClient;
@class VCOPViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,GCDAsyncSocketDelegate,BMKLocationServiceDelegate,CustomIOSAlertViewDelegate,UIScrollViewDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate>



-(void)cutOffSocket; // 断开socket连接
@property (readonly, nonatomic) VCOPClient *VCOPClientInstance;
@property (strong,nonatomic) VCOPViewController *viewController;
@property(nonatomic,retain)UIScrollView *scrollView;
@property (retain, nonatomic)UIButton *loginBt;
@property (strong, nonatomic) UIWindow *window;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property(nonatomic,retain)NSMutableArray *shopArray;
@property BOOL IsLogin;
@property(nonatomic,retain)NSMutableArray *advArray1;//1广告
@property(nonatomic,retain)NSMutableArray *advArray2;//2
@property(nonatomic,retain)NSString *menuString;
@property(nonatomic,retain)NSMutableArray *shopPersonInfo;//2
@property(nonatomic,retain)NSString *userIDString;
@property(nonatomic,retain)NSString *userPassWordString;

@property(nonatomic,retain)NSMutableArray *userInfoArray;//登录信息
@property(nonatomic,retain)NSMutableArray *shopUserInfoArray;//登录信息
@property(nonatomic,retain)NSMutableArray *nowpayCardArray;//要购买的卡





/**
 新的接口使用的变量
 */

/**
 用户信息
 */
@property (nonatomic , strong) NSMutableDictionary *userInfoDic;
/**
 商户信息
 */
@property (nonatomic , strong) NSMutableDictionary *shopInfoDic;

/**
 卡的信息
 */
@property (nonatomic , strong) NSDictionary *cardInfo_dic;


-(UIViewController *)getCurrentRootViewController;
//长连接
@property (nonatomic, copy )GCDAsyncSocket     *asyncSocketShop;
@property (nonatomic, copy )GCDAsyncSocket     *_asyncSocket;
@property (nonatomic, copy ) NSString *socketHost; // socket的Host
@property (nonatomic, assign) UInt16 socketPort; // socket的prot
//-(void)socketConnectHost;// socket连接
//-(void)socketConnectHostShop;//商户
@property (nonatomic, retain) NSTimer *connectTimer;


@property (nonatomic,retain)NSData* aData;
@property BOOL needConnect;
//@property (nonatomic,retain)BMKLocationService *locService;
@property (nonatomic,retain)BMKUserLocation *userLocation;
@property (nonatomic,retain)id<BMKLocationServiceDelegate> locationDelegate;
-(void)changeBMKLoctionSeviceDelegate:(id<BMKLocationServiceDelegate>)delegate;

@property (nonatomic,retain)NSString *cityChoice;//
@property (nonatomic,retain)NSThread *myFirstThread;

@property(nonatomic,retain)NSString *classify;//分类-美容美发等
@property(nonatomic,retain)NSString *districtString;//选择的区
@property (nonatomic , assign) BOOL shopIsLogin;// <#Description#>

@property(nonatomic,retain)NSArray *areaListArray;//区域
@property(nonatomic,strong)CLGeocoder *geocoder;


@property (nonatomic,retain)CustomIOSAlertView *alertView;
@property(nonatomic,retain)NSString *messagePay;
@property(nonatomic,retain)NSString *messagePayAll;
//弹出支付匡
@property(nonatomic,retain)NSString *payShopName;
@property(nonatomic,retain)NSMutableArray *payCardArray;//可支付的卡
@property(nonatomic,retain)NSString *type;;
@property float payMoney;//需要付的价钱总和

@property BOOL isHideNavInfo;

-(void)_initChose;

@property(nonnull,retain)NSMutableDictionary *allDic;
@property int socketCutBy;//1 用户主动

@property(nonnull,retain)BMKLocationService *locService;

@property BOOL isAli;

@property(nonnull,retain)NSString *payCardType;//新的级别
@property(nonnull,retain)NSString *moneyText;;
@property int whoPay;

@property(nonnull,retain)NSString *addressInfo;;
@property(nonnull,copy)NSString *addressDistrite;//定位到的区
//(nonatomic, retain)NSTimer *connectTimer;



@property(nonnull,retain)NSString *province;
@property(nonnull,retain)NSString *city;

@property int paymentType;
@property(nonatomic,strong)NSArray *  superAccoutArray;

/**
 *  退出登录
 */


-(void)loginOutBletcShop;


-(void)repeatLoadAPI;//重复调用接口,查询数据


@end

