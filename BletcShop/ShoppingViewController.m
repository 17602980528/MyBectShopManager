//
//  ShoppingViewController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShoppingViewController.h"
#import "DOPDropDownMenu.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "AppDelegate.h"
#import "SellerViewController.h"
#import "ShopListTableViewCell.h"
#import "DLStarRatingControl.h"
#import "ShaperView.h"

#import "JFAreaDataManager.h"

#import "ProvinceModel.h"
#import "CityModel.h"


@interface ShoppingViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    bool isGeoSearch;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
}


@property(nonatomic,weak)UILabel *GpsLabel;//地址的lable
@property(nonatomic,weak)UITableView *shopTabel;//商户的列表

@property(nonatomic, strong)NSMutableArray *dataSourceProvinceArray;
@property(nonatomic, strong)NSMutableArray *dataSourceCityArray;
//
@property(nonatomic,strong)NSMutableArray *data1;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *footsArray;
@property (nonatomic, strong) NSArray *movices;
@property (nonatomic, strong) NSArray *hostels;
@property (nonatomic, strong) NSMutableArray *areas;// 区列表
@property (nonatomic, strong) NSArray *sorts;//智能排序
@property (nonatomic, weak) DOPDropDownMenu *menu;//下拉列表
@property (nonatomic, strong) NSMutableArray *classifys;// 分类数组

@property(nonatomic,weak)UIButton *AllBtn;
@property(nonatomic,weak)UIButton *prefBtn;


@end

@implementation ShoppingViewController


-(NSMutableArray *)dataSourceCityArray{
    if (!_dataSourceCityArray) {
        _dataSourceCityArray = [NSMutableArray array];
    }
    return _dataSourceCityArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    [[JFAreaDataManager shareManager] areaData:[[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"] areaData:^(NSMutableArray *areaData) {
        
        
        appdelegate.areaListArray =areaData;
        
        
    }];

    self.classifyString = [[NSString alloc]init];
    self.ereaString = [[NSString alloc]init];
    if ([appdelegate.menuString isEqualToString:@""]) {
        self.classifyString =@"";
    }else
        self.classifyString = appdelegate.menuString;
    if ([appdelegate.addressDistrite isEqualToString:@""]) {
        self.ereaString = appdelegate.cityChoice;
    }else
        
        self.ereaString = [NSString stringWithFormat:@"%@%@",appdelegate.cityChoice,appdelegate.addressDistrite];
    
    self.navigationController.navigationBarHidden = YES;
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    [_locService startUserLocationService];
    self.areas = [[NSMutableArray alloc]init];
    self.classifys = [[NSMutableArray alloc]initWithArray:@[@"全部分类",@"美容",@"美发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所"]];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    //    DebugLog(@"%@",appdelegate.menuString);
    
    if (self.areas.count>0) {
        [self.areas removeAllObjects];
    }
    
    for (int i=0; i<appdelegate.areaListArray.count; i++) {
        [self.areas addObject:[appdelegate.areaListArray objectAtIndex:i] ];
    }
    for (int i=0; i<self.classifys.count; i++)
    {
        if([appdelegate.menuString isEqualToString:[self.classifys objectAtIndex:i]])
            
        {
            [self.classifys removeObjectAtIndex:i];
            break;
        }
        
    }
    for (int i=0; i<self.areas.count; i++)
    {
        if([appdelegate.addressDistrite isEqualToString:[self.areas objectAtIndex:i]])
            
        {
            [self.areas removeObjectAtIndex:i];
            break;
        }
        
    }
    
    //    数据
    if (appdelegate.menuString!=nil&&![appdelegate.menuString isEqualToString:@""]) {
        [self.classifys insertObject:appdelegate.menuString atIndex:0];
    }if (appdelegate.addressDistrite!=nil&&![appdelegate.addressDistrite isEqualToString:@""]) {
        [self.areas insertObject:appdelegate.addressDistrite atIndex:0];
    }
    
    self.sorts = @[@"智能排序",@"好评优先",@"离我最近"];
    [self getData];

    [self _initView];
    [self _initTable];
    [self _initFootTab];
    

    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
    [_locService stopUserLocationService];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexss=1;
}


-(void)_initFootTab
{
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 110-60) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    menu.isClickHaveItemValid = YES;
    [self.view addSubview:menu];
    _menu = menu;
    
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    [menu selectDefalutIndexPath];

}



//创建顶部控件;
-(void)_initView
{
    //    顶部地理位置
    UIView *back_v =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    back_v.backgroundColor = NavBackGroundColor;
    [self.view addSubview:back_v];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"appdelegate.addressInfo%@",appdelegate.addressInfo);
    UILabel *GpsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 30)];
    GpsLabel.text = appdelegate.addressInfo;
    GpsLabel.backgroundColor = NavBackGroundColor;
    GpsLabel.textAlignment = NSTextAlignmentCenter;
    GpsLabel.font = [UIFont systemFontOfSize:10];
    [GpsLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:GpsLabel];
    self.GpsLabel = GpsLabel;
    
    UIView *Fview = [[UIView alloc]initWithFrame:CGRectMake(0, 110-60, SCREENWIDTH, 45)];
    Fview.backgroundColor = [UIColor whiteColor];
    Fview.layer.borderWidth = 1;
    Fview.layer.borderColor = [UIColor grayColor].CGColor;
    Fview.alpha = 0.3;
    [self.view addSubview:Fview];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 109-60, SCREENWIDTH, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.3;
    [self.view addSubview: lineView];
    //
}

//商户列表
-(void)_initTable
{
    UITableView *shopTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 155-60, SCREENWIDTH, SCREENHEIGHT-155-50+60) style:UITableViewStylePlain];
    shopTable.delegate = self;
    shopTable.dataSource = self;
    shopTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    shopTable.showsVerticalScrollIndicator = NO;
    self.shopTabel = shopTable;
    [self.view addSubview:shopTable];
    //self.shopTabel.bounces = NO;
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.shopTabel];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block ShoppingViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        blockSelf.indexss=1;
        [blockSelf postRequestShop];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.shopTabel];
    
    _refreshFooter.beginRefreshingOperation =^{
        blockSelf.indexss++;
        [blockSelf postRequestShop];
        
    };
    
    [self postRequestShop];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];
    
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"检索发送成功");
    }
    else
    {
        NSLog(@"检索发送失败");
    }
}

//反向地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* showmeg;
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        self.GpsLabel.text = [NSString stringWithFormat:@"%@%@",@"当前:",showmeg];
    }
}
//顶部分类按钮事件
-(void)allBtnAction:(UIButton *)btn
{
    btn.selected =! btn.selected;
    self.AllBtn.selected = YES;
    self.prefBtn.selected =NO;
    self.indexss=1;
    [self postRequestShop];
    NSLog(@"全部商品");
}


-(void)postRequestShop
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSLog(@"appdelegate.addressDistrite===%@",appdelegate.addressDistrite);

    
    if([appdelegate.addressDistrite isEqualToString:@"全城"]){
        self.ereaString =appdelegate.cityChoice;
    }

    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/search/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",self.indexss] forKey:@"index"];
    [params setObject:self.ereaString forKey:@"eare"];
    [params setObject:self.classifyString forKey:@"trade"];
    DebugLog(@"===url=%@\n===paramer==%@",url,params);
    NSLog(@"%@",self.ereaString);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        NSLog(@"postRequestShop-----%@",result);
        if ([result isKindOfClass:[NSArray class]]) {
            if (self.indexss==1) {
                
                self.data1=[NSMutableArray arrayWithArray:result];
                
            }else{
                for (int i=0; i<[result count]; i++) {
                    [self.data1 addObject:result[i]];
                }
            }
            [_refreshheader endRefreshing];
            [_refreshFooter endRefreshing];
            
            [self.shopTabel reloadData];
        }
       
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];

        NSLog(@"%@", error);
        
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 进入下层入口
    NSMutableDictionary *dic = [self.data1 objectAtIndex:indexPath.row];
    
    SellerViewController *vc= [self startSellerView:dic];
    vc.videoID=@"";
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    
    [params setObject:dic[@"muid"] forKey:@"merchant"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"%@",result);
         if (result.count>0) {
             __block ShoppingViewController* tempSelf = self;
             vc.videoID=result[0][@"video"];
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }else{
             __block ShoppingViewController* tempSelf = self;
             vc.videoID=@"";
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         __block ShoppingViewController* tempSelf = self;
         vc.videoID=@"";
         [tempSelf.navigationController pushViewController:vc animated:YES];
     }];
    
    
}

-(SellerViewController *)startSellerView:(NSMutableDictionary*)dic{
    
    SellerViewController *controller = [[SellerViewController alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    
    return controller;
    
}



//下拉列表的代理方法
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
    }else if (column == 1){
        
        return self.dataSourceProvinceArray.count;
//        return self.areas.count;
    }else {
        return self.sorts.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        
        ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
        return m.name;
//        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
    
}
// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0 || indexPath.column == 1) {
        NSString *str = [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.row];
//        NSLog(@"ic_filter_category==%@",str);
        return str;
        
    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.item];
    }
    return nil;
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column < 2) {
        //        return [@(arc4random()%1000) stringValue];
        return nil;
    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //    return [@(arc4random()%1000) stringValue];
    return nil;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
   
    if (column==1) {
        
        NSLog(@"numberOfItemsInRow====%ld===%ld===%ld",self.dataSourceCityArray.count,row,column);
        
            return self.dataSourceCityArray.count;

    }else return -1;
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 1) {
        
//        NSLog(@"-------%ld------%ld--%ld-%ld",self.dataSourceCityArray.count,indexPath.row,indexPath.column,indexPath.item);
        CityModel *m = self.dataSourceCityArray[indexPath.item];
        
        
        return m.name;
//        return self.classifys[indexPath.item];
    }else
    
    return nil;
}



- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (indexPath.item >= 0) {
//        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
//        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        if (indexPath.column == 0) {
            if([[self.classifys objectAtIndex:indexPath.row] isEqualToString:@"全部分类"]){
                self.classifyString =@"";
            }else
                self.classifyString = [self.classifys objectAtIndex:indexPath.row];
        }else if (indexPath.column == 1 ) {
            
            
            ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
            self.ereaString = m.name;
            
            [self getcityDataById:m.code];
        }
    }
    self.indexss=1;
    NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    NSLog(@"点击了 %@ - %@",self.classifyString,self.ereaString);
    [self postRequestShop];
}


//店铺列表的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.data1.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 64, 64)];
    shopImageView.layer.cornerRadius = 5;
    shopImageView.layer.masksToBounds = YES;
    [cell addSubview:shopImageView];
    //店名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, SCREENWIDTH-90, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.numberOfLines = 0;
    nameLabel.text = @"";
    [cell addSubview:nameLabel];
    
    //距离
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 63, 150, 12)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.text = @"1000米";
    [cell addSubview:distanceLabel];
    //销售额
    UILabel *sellerLabel=[[UILabel alloc]initWithFrame:CGRectMake(90+95+20, 40, SCREENWIDTH-90-95-20, 12)];
    sellerLabel.font=[UIFont systemFontOfSize:12.0f];
    sellerLabel.textAlignment=NSTextAlignmentLeft;
    [cell addSubview:sellerLabel];
    
    ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(90, 85, SCREENWIDTH-90, 1)];
    ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    [cell addSubview:viewt];
    
    UILabel *sheLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 97, 12, 12)];
    sheLab.backgroundColor=[UIColor colorWithRed:238/255.0 green:94/255.0 blue:44/255.0f alpha:1.0];
    sheLab.text=@"折";
    sheLab.textAlignment=1;
    sheLab.textColor=[UIColor whiteColor];
    sheLab.font=[UIFont systemFontOfSize:12.0f];
    [cell addSubview:sheLab];
    
    UILabel *sheContent=[[UILabel alloc]initWithFrame:CGRectMake(114, 97, SCREENWIDTH-114, 12)];
    sheContent.textAlignment=NSTextAlignmentLeft;
    sheContent.font=[UIFont systemFontOfSize:12.0f];
    
    [cell addSubview:sheContent];
    
    UILabel *giveLab=[[UILabel alloc]initWithFrame:CGRectMake(90, 117, 12, 12)];
    giveLab.backgroundColor=[UIColor colorWithRed:86/255.0 green:171/255.0 blue:228/255.0f alpha:1.0];
    giveLab.text=@"赠";
    giveLab.textAlignment=1;
    giveLab.textColor=[UIColor whiteColor];
    giveLab.font=[UIFont systemFontOfSize:12.0f];
    [cell addSubview:giveLab];
    
    UILabel *giveContent=[[UILabel alloc]initWithFrame:CGRectMake(114, 117, SCREENWIDTH-114, 12)];
    giveContent.textAlignment=NSTextAlignmentLeft;
    giveContent.font=[UIFont systemFontOfSize:12.0f];
    
    [cell addSubview:giveContent];
    
    UILabel *brandLabel=[[UILabel alloc]initWithFrame:CGRectMake(52, 10, 24, 12)];
    brandLabel.textAlignment=1;
    brandLabel.text=@"品牌";
    brandLabel.font=[UIFont systemFontOfSize:11.0f];
    [cell addSubview:brandLabel];
    brandLabel.backgroundColor=[UIColor colorWithRed:255/255.0 green:210/255.0 blue:0 alpha:1];
    
    DLStarRatingControl* dlCtrl = [[DLStarRatingControl alloc]initWithFrame:CGRectMake(-40, 0, 160, 35) andStars:5 isFractional:YES star:[UIImage imageNamed:@"result_small_star_disable_iphone"] highlightStar:[UIImage imageNamed:@"redstar"]];
    dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    dlCtrl.userInteractionEnabled = NO;
    dlCtrl.rating =0.0;
    
    UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 95, 15)];
    starLabel.backgroundColor = [UIColor clearColor];
    starLabel.textAlignment = NSTextAlignmentLeft;
    starLabel.font = [UIFont systemFontOfSize:15];
    
    [starLabel addSubview:dlCtrl];
    [cell addSubview:starLabel];
    
    if (self.data1.count>0) {
        
        nameLabel.text = @"";
        distanceLabel.text = @"";
        //店铺名
        nameLabel.text=[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"store"];
        //销量
        sellerLabel.text=[NSString stringWithFormat:@"已售%@笔",[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"sold"]];
        //距离
        CLLocationCoordinate2D c1 = CLLocationCoordinate2DMake([[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"latitude"] doubleValue], [[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"longtitude"] doubleValue]);
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        
        BMKMapPoint a=BMKMapPointForCoordinate(c1);
        BMKMapPoint b=BMKMapPointForCoordinate(appdelegate.userLocation.location.coordinate);
        CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
        
        int meter = (int)distance;
        if (meter>1000) {
            distanceLabel.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
        }else
            distanceLabel.text = [[NSString alloc]initWithFormat:@"%dm",meter];
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
    }
    
    //评星
    
    NSString *starsss = [NSString getTheNoNullStr:[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"stars"] andRepalceStr:@"0"];
    dlCtrl.rating=[starsss floatValue];
//    [NSString stringWithFormat:@"%.1f折",[_model.subTitl floatValue]/10]    //sheContent
    
    NSString *discount =[NSString getTheNoNullStr:[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"discount"] andRepalceStr:@""];
    
    if ([discount doubleValue]>0.0 && [discount doubleValue]<100.0) {
        discount =  [NSString stringWithFormat:@"%.1f折",[discount floatValue]/10];
        
    }else{
     discount  = @"暂无折扣!";
    }
//    NSString *sheString=[NSString getTheNoNullStr:[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"discount"] andRepalceStr:@"暂无折扣!"];
    
    sheContent.text=discount;
    
    //giveContent.text=@"单次消费满500送50抵用劵";
    
    NSString *giveString =[NSString getTheNoNullStr:[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"add"] andRepalceStr:@""];
    
    if ([giveString floatValue]>0.0) {
        giveContent.text = [NSString stringWithFormat:@"办卡就送%@",giveString];
        
    }else{
        giveContent.text  = @"暂无活动!";
        
    }

//    giveContent.text=giveContentStr;

//    NSString *giveContentStr=[NSString getTheNoNullStr:[[self.data1 objectAtIndex:indexPath.row] objectForKey:@"add"] andRepalceStr:@"暂无活动!"];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 139, SCREENWIDTH, 1)];
    
    lineView.backgroundColor=[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
    [cell addSubview:lineView];
    
    return cell;
    
}

//getData这个方法里是网络请求数据的解析省份数据信息
- (void)getData
{
//    //请求数据并解析
//    NSString *strURL = @"http://apis.map.qq.com/ws/district/v1/list?key=K3VBZ-M6WWV-PPSPY-UVGGC-DRM2Z-PGBMV";
//    NSURL *URL = [NSURL URLWithString:strURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"=====%@",dic);
    //数据源数组:
    self.dataSourceProvinceArray = [NSMutableArray array];
    
    
//    self.dataSourceProvinceArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityList"];

    NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEreaList"];
    
//    NSLog(@"====%@",arr);
    
    for (NSDictionary *dic in arr)
    {
        ProvinceModel *model = [[ProvinceModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        //        NSLog(@"%@ * %@", model.fullname, model.id);
        [self.dataSourceProvinceArray addObject:model];
        
    }
    
    if (self.dataSourceProvinceArray.count!=0) {
        ProvinceModel *M = [self.dataSourceProvinceArray firstObject];
        
        [self getcityDataById:M.code];

    }
}

//getcityDataById:这个方法里是网络请求数据的解析市数据信息
- (void)getcityDataById:(NSString *)proID
{

    
//    NSString *url = [NSString stringWithFormat:@"%@Extra/address/getStreet",BASEURL];;
//    
//    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
//    [parame setValue:proID forKey:@"district_id"];
    
//    NSLog(@"url====+%@=====%@",url,parame);
//    [KKRequestDataService requestWithURL:url params:parame httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        
//        
////        NSLog(@"----%@",result);
//        //遍历当前数组给madel赋值
//        [self.dataSourceCityArray removeAllObjects];
//        
//     
//        
//        
//            for (NSDictionary *diction in result)
//            {
//                CityModel *model = [[CityModel alloc] init];
//                [model setValuesForKeysWithDictionary:diction];
//                [self.dataSourceCityArray addObject:model];
//            }
//
//            
////        [self.menu reloadData];
//        
//        
//        NSLog(@"=========%ld",self.dataSourceCityArray.count);
//        
//        
//        
//    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error-----%@",error);
//    }];

    
    NSString *urlString = [NSString stringWithFormat:@"%@Extra/address/getStreet",BASEURL];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"district_id=%@",proID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    NSData *receiced = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:receiced options:NSJSONReadingMutableContainers error:nil];
   
    [self.dataSourceCityArray removeAllObjects];
    
    
    
    
    for (NSDictionary *diction in array)
    {
        CityModel *model = [[CityModel alloc] init];
        [model setValuesForKeysWithDictionary:diction];
        [self.dataSourceCityArray addObject:model];
    }
    

    
    
}


//BaiduMap释放
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.AllBtn.selected = NO;
    self.prefBtn.selected = NO;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.menuString = @"";
    appdelegate.addressDistrite = @"";
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
