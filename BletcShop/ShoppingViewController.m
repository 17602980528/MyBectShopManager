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
    
    NSArray *arr;
    
    NSDictionary *curentEare;
    
    NSDictionary *currentCityDic;

}

@property(nonatomic,strong)DOPIndexPath *indexpathSelect;
@property(nonatomic,weak)UILabel *GpsLabel;//地址的lable
@property(nonatomic,weak)UITableView *shopTabel;//商户的列表

@property(nonatomic, strong)NSMutableArray *dataSourceProvinceArray;
@property(nonatomic, strong)NSMutableArray *dataSourceCityArray;
//
@property(nonatomic,strong)NSMutableArray *data1;
@property (nonatomic, strong) NSMutableArray *areas;// 区列表
@property (nonatomic, strong) NSArray *sorts;//智能排序
@property (nonatomic, weak) DOPDropDownMenu *menu;//下拉列表
@property (nonatomic, strong) NSMutableArray *classifys;// 分类数组


@property (nonatomic, strong) NSMutableArray *adverList;// 上面的广告数组


@end

@implementation ShoppingViewController



-(NSMutableArray *)adverList{
    if (!_adverList) {
        _adverList = [NSMutableArray array];
    }
    return _adverList;
}
//-(NSMutableArray *)classifys{
//    if (!_classifys) {
//        _classifys = [[NSMutableArray alloc]initWithArray:@[@"全部分类",@"美容",@"美发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所"]];
//    }
//    return _classifys;
//}
-(NSMutableArray *)areas{
    if (!_areas) {
        _areas = [NSMutableArray array];
        
    }
    return _areas;
}
-(NSMutableArray *)dataSourceCityArray{
    if (!_dataSourceCityArray) {
        _dataSourceCityArray = [NSMutableArray array];
    }
    return _dataSourceCityArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    currentCityDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] :[[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] ;
    
    _classifys = [[NSMutableArray alloc]initWithArray:@[@"全部分类",@"美容",@"美发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所"]];
    
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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    
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
    
    //数据
    if (appdelegate.menuString!=nil&&![appdelegate.menuString isEqualToString:@""]) {
        [self.classifys insertObject:appdelegate.menuString atIndex:0];
    }
    if (appdelegate.addressDistrite!=nil&&![appdelegate.addressDistrite isEqualToString:@""]) {
        [self.areas insertObject:appdelegate.addressDistrite atIndex:0];
    }
    
    self.sorts = @[@"智能排序",@"好评优先",@"离我最近"];
    
    
    if (arr != [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEreaList"] || [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEareDic"] != curentEare) {
        curentEare = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEareDic"];
        NSLog(@"getData");
        [self getData];
    }
    [_menu selectDefalutIndexPath];
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
    NSLog(@"viewDidLoad");
    curentEare = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEareDic"];
    
    currentCityDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"currentCityDic"] :[[NSUserDefaults standardUserDefaults]objectForKey:@"locationCityDic"] ;
    
    [self getData];

    
    [self _initView];
    [self _initTable];
    [self _initFootTab];
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
    
//    UITableView *shopTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 155-60, SCREENWIDTH, SCREENHEIGHT/2) style:UITableViewStylePlain];

    shopTable.delegate = self;
    shopTable.dataSource = self;
    shopTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.shopTabel = shopTable;
    [self.view addSubview:shopTable];
    //self.shopTabel.bounces = NO;
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:self.shopTabel];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block ShoppingViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        blockSelf.indexss=1;
        
        [blockSelf.data1 removeAllObjects];
        [blockSelf getAdverListRequestWithIndePath:blockSelf.indexpathSelect];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.shopTabel];
    
    _refreshFooter.beginRefreshingOperation =^{
        blockSelf.indexss++;
        [blockSelf postRequestShopWithAddress:blockSelf.ereaString];
        
    };

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


-(void)postRequestShopWithAddress:(NSString *)address
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/search/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",self.indexss] forKey:@"index"];
    [params setObject:address forKey:@"eare"];
    [params setObject:self.classifyString forKey:@"trade"];
    DebugLog(@"===url=%@\n===paramer==%@",url,params);
  
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//       NSLog(@"postRequestShop-----%@",result);
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
    NSMutableDictionary *dic;
    
    if (indexPath.section==0) {
        dic = [[self.adverList objectAtIndex:indexPath.row][@"info"] firstObject];
        NSDictionary *para = [self.adverList objectAtIndex:indexPath.row][@"para"];
        
        if (para) {
            if ([para[@"pay_type"] isEqualToString:@"click"]) {
                
                [self postRemainClickCount:para];

            }

        }
        
    }else{
        dic = [self.data1 objectAtIndex:indexPath.row];

    }
//    NSMutableDictionary *dic = [self.data1 objectAtIndex:indexPath.row];
    
    SellerViewController *vc= [self startSellerView:dic];
    vc.videoID=@"";
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    
    [params setObject:dic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"%@",result);
         if (result.count>0) {
             __block ShoppingViewController* tempSelf = self;
             if ([result[0][@"state"] isEqualToString:@"true"]) {
                 vc.videoID=result[0][@"video"];
                 
             }else{
                 vc.videoID=@"";
                 
             }
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

//点击广告处理
-(void)postRemainClickCount:(NSDictionary *)dic{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advert/click",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    [params setObject:dic[@"muid"] forKey:@"muid"];
    [params setObject:@"near" forKey:@"advert_type"];
    [params setObject:[getUUID getUUID] forKey:@"local_id"];
    [params setObject:dic[@"address"] forKey:@"advert_id"];
    [params setObject:dic[@"position"] forKey:@"advert_position"];
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result==%@",result);
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         
     }];
    
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
        NSLog(@"titleForRowAtIndexPath=%@",m.name);

        return m.name;
//        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
    
}





- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
   
    if (column==1) {
        NSLog(@"numberOfItemsInRow=====%ld",self.dataSourceCityArray.count);
        
            return self.dataSourceCityArray.count;

    }else return -1;
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 1) {
        
        CityModel *m = self.dataSourceCityArray[indexPath.item];
        NSLog(@"titleForItemsInRowAtIndexPath=%@",m.name);
        
        return m.name;
    }else
    
    return nil;
}



- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    NSLog(@"currentSelectRowArray----%@",menu.currentSelectRowArray);
    NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);


    if (indexPath.item >= 0) {
        self.indexpathSelect =indexPath;


        [self getAdverListRequestWithIndePath:indexPath];
       // [self postRequestShop];
    }else {

        if (indexPath.column == 0) {
            if([[self.classifys objectAtIndex:indexPath.row] isEqualToString:@"全部分类"]){
                self.classifyString =@"";
            }else
                self.classifyString = [self.classifys objectAtIndex:indexPath.row];
        }else if (indexPath.column == 1 ) {
            self.indexpathSelect =indexPath;

            
            ProvinceModel *m = _dataSourceProvinceArray[indexPath.row];
            
            [self getcityDataById:m.code AndIndexPath:indexPath];
            
        }
        
        self.indexss=1;
        NSLog(@"点击了 %@ - %@",self.classifyString,self.ereaString);
        
            [self getAdverListRequestWithIndePath:self.indexpathSelect];


    }
   
}


//店铺列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return _adverList.count;
    }else
        return self.data1.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    ShopListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ShopListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary *dic ;
    if (indexPath.section==0) {
        
        if (self.adverList.count>0) {
            dic=[[self.adverList objectAtIndex:indexPath.row][@"info"] firstObject];
        }
        
    }else{
        
        if (self.data1.count>0) {
            dic=[self.data1 objectAtIndex:indexPath.row];
        }
        
    }
    
    if (dic) {
        
        
        //店铺名
        cell.nameLabel.text=[dic objectForKey:@"store"];
        //销量
        cell.sellerLabel.text=[NSString stringWithFormat:@"已售%@笔",[dic objectForKey:@"sold"]];
        //距离
        CLLocationCoordinate2D c1 = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longtitude"] doubleValue]);
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        
        BMKMapPoint a=BMKMapPointForCoordinate(c1);
        BMKMapPoint b=BMKMapPointForCoordinate(appdelegate.userLocation.location.coordinate);
        CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
        
        int meter = (int)distance;
        if (meter>1000) {
            cell.distanceLabel.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
        }else
            cell.distanceLabel.text = [[NSString alloc]initWithFormat:@"%dm",meter];
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[dic objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
        
        
        //评星
        
        NSString *starsss = [NSString getTheNoNullStr:[dic objectForKey:@"stars"] andRepalceStr:@"0"];
        cell.dlCtrl.rating=[starsss floatValue];
        //    [NSString stringWithFormat:@"%.1f折",[_model.subTitl floatValue]/10]    //sheContent
        
        NSString *discount =[NSString getTheNoNullStr:[dic objectForKey:@"discount"] andRepalceStr:@""];
        
        if ([discount doubleValue]>0.0 && [discount doubleValue]<100.0) {
            discount =  [NSString stringWithFormat:@"%.1f折",[discount floatValue]/10];
            
        }else{
            discount  = @"暂无折扣!";
        }
        
        cell.sheContent.text=discount;
        
        
        NSString *giveString =[NSString getTheNoNullStr:[dic objectForKey:@"add"] andRepalceStr:@""];
        
        if ([giveString floatValue]>0.0) {
            cell.giveContent.text = [NSString stringWithFormat:@"办卡就送%@",giveString];
            
        }else{
            cell.giveContent.text  = @"暂无活动!";
            
        }
        if ([dic[@"coupon"] isEqualToString:@"yes"]) {
            cell.couponLable.hidden=NO;
        }else{
            cell.couponLable.hidden=YES;
        }
        
    }
    
    
    return cell;
    
}

//getData这个方法里是网络请求数据的解析省份数据信息
- (void)getData
{
    self.indexpathSelect = [DOPIndexPath indexPathWithCol:1 row:0 item:-1];

    //数据源数组:
    self.dataSourceProvinceArray = [NSMutableArray array];
    
    

    arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentEreaList"];
    
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSString *currentEare = appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice;
    
    
    
    ProvinceModel *MM = [[ProvinceModel alloc]init];
    [MM setName:@"全城"];

    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *dic = arr[i];
        
        ProvinceModel *model = [[ProvinceModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        //        NSLog(@"%@ * %@", model.fullname, model.id);
        if ([currentEare isEqualToString:model.name]) {
            [self.dataSourceProvinceArray insertObject:model atIndex:0];
            if (i ==0) {
                [self.dataSourceProvinceArray insertObject:MM atIndex:1];

            }
            
        }else{
            [self.dataSourceProvinceArray addObject:model];
            
            if (i ==0) {
                [self.dataSourceProvinceArray insertObject:MM atIndex:0];
                
            }

        }

    }
    
    

    
    
    
    if (self.dataSourceProvinceArray.count!=0) {
        ProvinceModel *M = [self.dataSourceProvinceArray firstObject];
        
        
        [self getcityDataById:M.code AndIndexPath:nil];

    }
}

//getcityDataById:这个方法里是网络请求数据的解析市数据信息
- (void)getcityDataById:(NSString *)proID AndIndexPath:(DOPIndexPath*)indexPath
{

    
    NSString *url = [NSString stringWithFormat:@"%@Extra/address/getStreet",BASEURL];;
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    [parame setValue:proID forKey:@"district_id"];
    
    NSLog(@"url====+%@=====%@",url,parame);
    [KKRequestDataService requestWithURL:url params:parame httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        //        NSLog(@"----%@",result);
        //遍历当前数组给madel赋值
        [self.dataSourceCityArray removeAllObjects];
        

        NSLog(@"indexPath-----%@=%ld=%ld=%ld",indexPath,indexPath.column ,indexPath.row,indexPath.item);
        
        if (!proID) {
            
            for (int i = 0; i <1; i ++) {
                CityModel *mod = [[CityModel alloc] init];

                
                if (i==0) {
//                    [mod setName:@"全城"];

                    [mod setName: currentCityDic[@"name"]];

                }else{

                }
                
                [self.dataSourceCityArray insertObject:mod atIndex:i];

            }
           
        
        }else
        {
            for (NSDictionary *diction in result)
            {
                CityModel *model = [[CityModel alloc] init];
                [model setValuesForKeysWithDictionary:diction];
                [self.dataSourceCityArray addObject:model];
            }
        }
        
     
        
        
        

        if (indexPath) {
            [self.menu reloadRightData:indexPath];

        }else{
            
            

            [_menu reloadData];
            

            [self getAdverListRequestWithIndePath:self.indexpathSelect];

//            [self performSelector:@selector(setdefaultTitle) withObject:nil afterDelay:0.2];
            
               }
        
        NSLog(@"=========%ld",self.dataSourceCityArray.count);
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error-----%@",error);
    }];

    
    
    
}
//-(void)setdefaultTitle{
//    
//    if ([_menu.dataSource respondsToSelector:@selector(menu:numberOfItemsInRow:column:)]) {
//        
//        NSLog(@"setdefaultTitle======%ld===%ld===%ld",self.indexpathSelect.column,self.indexpathSelect.row,self.indexpathSelect.item);
//        
//        [_menu selectIndexPath:self.indexpathSelect];
//        
//    }
//    
//
//}
//获取广告请求

-(void)getAdverListRequestWithIndePath:(DOPIndexPath*)indexPath{
    

    
//    ProvinceModel*provinceM =self.dataSourceProvinceArray[indexPath.row];
    ProvinceModel*provinceM;
    CityModel *cityM;
    if (_dataSourceProvinceArray.count!=0) {
        provinceM =self.dataSourceProvinceArray[indexPath.row];
        self.ereaString = provinceM.name;

    }
    if (_dataSourceCityArray.count!=0 && indexPath.item>=0) {

        cityM = self.dataSourceCityArray[indexPath.item];
        self.streetString = [NSString getTheNoNullStr:cityM.name andRepalceStr:@""];

    }
//    CityModel *cityM = self.dataSourceCityArray[indexPath.item];

    
    
    NSLog(@"----%ld==%ld==%ld",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@",currentCityDic[@"name"],[NSString getTheNoNullStr:provinceM.name andRepalceStr:@""],[NSString getTheNoNullStr:cityM.name andRepalceStr:@""]];
    
    
    NSLog(@"=componentsSeparatedByString===%@==+%@",address,[address componentsSeparatedByString:@"全城"]);
    
    if ([address containsString:@"全城"]) {
    
        address = [[address componentsSeparatedByString:@"全城"] firstObject];
        
        
        
    }
    
    self.ereaString = address;
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/search/multiGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:address forKey:@"eare"];
    [params setObject:self.classifyString forKey:@"trade"];
    DebugLog(@"===url=%@\n===paramer==%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//                  NSLog(@"getAdverListRequestWithIndePath-----%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            
            NSArray *ad_A = result[@"advert"];
            
           // NSArray *shop_A = result[@"merchant"];
            
            [self.adverList removeAllObjects];
            
            
            for (NSDictionary *dic in ad_A) {
                [self.adverList addObject:dic];

                
            }
//            for (NSDictionary *dic in shop_A) {
//                [self.adverList addObject:dic];
//
//                
//            }
            
            
            
            [self postRequestShopWithAddress:address];
            
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
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.menuString = self.classifyString;
    appdelegate.addressDistrite = @"";
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
