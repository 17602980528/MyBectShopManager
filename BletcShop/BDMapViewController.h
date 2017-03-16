//
//  BDMapViewController.h
//  BletcShop
//
//  Created by Bletc on 16/4/18.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
@interface BDMapViewController : UIViewController<BMKMapViewDelegate, BMKLocationServiceDelegate>
/**
 *  百度地图
 */
@property (strong, nonatomic) BMKMapView *mapView;
/**
 *  定为服务
 */



@property(nonatomic,strong)NSMutableDictionary *infoDic;// 商户信息




@property (nonatomic , strong) UIButton *daohangBtn;// 导航按钮

@property (strong, nonatomic) BMKLocationService *locService;
@property(nonatomic)CLLocationDegrees latitude;
@property(nonatomic)CLLocationDegrees longitude;
@end
