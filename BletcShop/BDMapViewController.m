//
//  BDMapViewController.m
//  BletcShop
//
//  Created by Bletc on 16/4/18.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BDMapViewController.h"

@interface BDMapViewController ()

@end

@implementation BDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    NSLog(@"latitude = %@,longitude = %@",[NSString stringWithFormat:@"%f",_latitude],[NSString stringWithFormat:@"%f",_longitude]);
    // 启动定位
    [self locService];
    CLLocationCoordinate2D loc = {_latitude, _longitude};
    
    
    [self.mapView showsUserLocation];
    
    
    
       // 显示地图
    [self.view addSubview:self.mapView];
    [self.mapView setCenterCoordinate:loc];//地图拉回到坐标所在位置
    
    self.daohangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.daohangBtn.frame = CGRectMake(SCREENWIDTH-SCREENWIDTH*0.15-20, SCREENHEIGHT-SCREENWIDTH*0.15-30-64, SCREENWIDTH*0.15, SCREENWIDTH*0.15);
    [self.daohangBtn setBackgroundImage:[UIImage imageNamed:@"danghan"] forState:UIControlStateNormal];
    [self.daohangBtn setBackgroundImage:[UIImage imageNamed:@"danghan"] forState:UIControlStateHighlighted];

    
    
    [self.daohangBtn addTarget:self action:@selector(daohang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.daohangBtn];

    
}
- (BMKLocationService *)locService {
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        _locService.distanceFilter = 200.f;
        [_locService setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        // 后台也定位 并且屏幕上方有蓝条提示
        //_locService.allowsBackgroundLocationUpdates = YES;
        //启动LocationService
        [_locService startUserLocationService];
    }
    return _locService;
}
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    // 1.显示用户位置
    self.mapView.showsUserLocation = YES;
    // 2.更新用户最新位置到地图上
    [self.mapView updateLocationData:userLocation];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    appdelegate.userLocation = userLocation;
    // 3.设置中心 为 用户位置
    CLLocationCoordinate2D loc = {_latitude, _longitude};
    CLLocationCoordinate2D center = loc;
    CLLocationDegrees latitude = 0.0;
    CLLocationDegrees longitude = 0.09;
    // 4.设置跨度 数值越小 越精确
    BMKCoordinateSpan span = BMKCoordinateSpanMake(latitude, longitude);
    // 5.设置区域 中心店 和 范围跨度
    BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
    
    // 设置地图显示区域范围
    [self.mapView setRegion:region animated:YES];
    [self.mapView setZoomLevel:17];
}
#pragma mark - 地图功能-------------------------------------------
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    }
    return _mapView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidAppear:(BOOL)animated {
    // 添加一个PointAnnotation模型
    NSLog(@"latitude = %@,longitude = %@",[NSString stringWithFormat:@"%.2f",_latitude],[NSString stringWithFormat:@"%.2f",_longitude]);
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor; // 定义模型经纬度
    coor.latitude = self.latitude;
    coor.longitude = self.longitude;
    annotation.coordinate = coor;
    //annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
}
//  Override每当添加一个大头针就会调用这个方法(对大头针没有进行封装)
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    // 这里的BMKAnnotationView 就相当于是UITableViewCell一样 其实就是一个View我们也是通过复用的样子一样进行使用。 而传进来的annotation 就是一个模型，它里面装的全都是数据！
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        // 如果大头针类型 是我们自定义的百度的 而且是后加的大头针模型类 的话 才执行
        static NSString *const ID = @"myAnnotation";
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        CLLocationCoordinate2D coor2 = {_latitude, _longitude};
        annotation.coordinate = coor2;
        if (newAnnotationView == nil) {
            newAnnotationView =  [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        }
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"location"];
        return newAnnotationView;
    }
    // 这里是说定位自己本身的那个大头针模型 返回nil 自动就变成蓝色点点
    return nil;
}

-(void)daohang{
    
    
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        CLLocationCoordinate2D dstLoc;
        dstLoc.longitude = _longitude;
        dstLoc.latitude =_latitude;
    
        [self NavigateFrom:appdelegate.userLocation.location.coordinate to:dstLoc];
}



-(void)NavigateFrom:(CLLocationCoordinate2D)from  to:(CLLocationCoordinate2D)to{
    BMKNaviPara * para = [BMKNaviPara alloc];
    para.isSupportWeb = YES;
    //CLLocationCoordinate2D startPt = (CLLocationCoordinate2D){34.229849,108.970386};
    //CLLocationCoordinate2D endPt = (CLLocationCoordinate2D){34.267509,108.953567};
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = from;
    start.name = nil;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = to;
    end.name = @"111";
    
    para.startPoint = start;
    para.endPoint = end;
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        
        [self openBaiDuMap];
    }else{
        para.naviType = BMK_NAVI_TYPE_WEB;
        [BMKNavigation openBaiduMapNavigation:para];
        
    }
    
}
- (void)openBaiDuMap{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",appdelegate.userLocation.location.coordinate.latitude, appdelegate.userLocation.location.coordinate.longitude,_latitude,_longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    
    printf("urlString======%s",[urlString UTF8String]);
    
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}


@end
