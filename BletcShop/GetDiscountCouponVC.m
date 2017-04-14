//
//  GetDiscountCouponVC.m
//  BletcShop
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "GetDiscountCouponVC.h"
#import "CouponIntroduceVC.h"
#import "LandingController.h"
#import "UIImageView+WebCache.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface GetDiscountCouponVC ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    bool isGeoSearch;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
}
@end

@implementation GetDiscountCouponVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postGetCouponRequest];
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    [_locService startUserLocationService];
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
//        self.GpsLabel.text = [NSString stringWithFormat:@"%@%@",@"当前:",showmeg];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"专属优惠";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-40) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIImageView *shopHead=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 95, 95)];
        shopHead.tag=100;
        [cell addSubview:shopHead];
        
        UILabel *couponNameLable=[[UILabel alloc]initWithFrame:CGRectMake(125, 10, SCREENWIDTH-125-15-78-10, 50)];
        couponNameLable.text=@"美式黑椒牛排立减15元代金券";
        couponNameLable.tag=200;
        couponNameLable.font=[UIFont systemFontOfSize:15.0f];
        couponNameLable.numberOfLines=0;
        [cell addSubview:couponNameLable];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(SCREENWIDTH-78-10, 15, 78, 35);
        button.backgroundColor=[UIColor colorWithRed:237/255.0f green:71/255.0f blue:59/255.0f alpha:1.0f];
        button.layer.cornerRadius=3.0f;
        button.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [button setTitle:@"立即领取" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell addSubview:button];
        button.tag=666;
        [button addTarget:self action:@selector(getCoupon:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *couponMoney=[[UILabel alloc]init];
        couponMoney.tag=300;
        couponMoney.textColor=NavBackGroundColor;
        [cell addSubview:couponMoney];
        
        UILabel *baseCouponMoney=[[UILabel alloc]init];
        baseCouponMoney.tag=400;
        baseCouponMoney.textColor=[UIColor lightGrayColor];
        baseCouponMoney.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:baseCouponMoney];
        
        UILabel *shopNameAndDistant=[[UILabel alloc]initWithFrame:CGRectMake(125, couponMoney.bottom+5, SCREENWIDTH-125, 15)];
        shopNameAndDistant.tag=500;
        shopNameAndDistant.text=@"三人行麻辣香锅 3.0km";
        shopNameAndDistant.font=[UIFont systemFontOfSize:13.0f];
        shopNameAndDistant.textColor=[UIColor lightGrayColor];
        [cell addSubview:shopNameAndDistant];
        
    }
    UIImageView *headImageView=[cell viewWithTag:100];
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[_dataArray[indexPath.row]  objectForKey:@"image_url"] andRepalceStr:@""]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    UILabel *couponMoneyLable=[cell viewWithTag:200];
    couponMoneyLable.text=[NSString stringWithFormat:@"%@减%@元代金券",_dataArray[indexPath.row][@"store"],_dataArray[indexPath.row][@"sum"]];
    couponMoneyLable.frame=CGRectMake(125, 10, SCREENWIDTH-125-15-78-10, 50);

    UILabel *couponMoney=[cell viewWithTag:300];
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:24.0f];
    NSString *money=[NSString stringWithFormat:@"%@元",_dataArray[indexPath.row][@"sum"]];
    CGSize size=[money sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName,nil]];
    CGFloat nameH = size.height;
    CGFloat nameW = size.width;
    couponMoney.frame=CGRectMake(125, couponMoneyLable.bottom+5, nameW, 30);
    couponMoney.text=money;
    //
    UILabel *baseCouponMoney=[cell viewWithTag:400];
    baseCouponMoney.text=[NSString stringWithFormat:@"满%@元可用",_dataArray[indexPath.row][@"pri_condition"]];
    baseCouponMoney.frame=CGRectMake(couponMoney.right,couponMoneyLable.bottom+(nameH-15) , SCREENWIDTH-couponMoney.frame.origin.x-couponMoney.width-5, 15);
    //
    UILabel *shopNameAndDistant=[cell viewWithTag:500];
    shopNameAndDistant.text=_dataArray[indexPath.row][@"store"];
    shopNameAndDistant.frame=CGRectMake(125, couponMoney.bottom+5, SCREENWIDTH-125, 15);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //
    UIButton *sender=[cell viewWithTag:666];
    if ([_dataArray[indexPath.row][@"received"] isEqualToString:@"false"]) {
        sender.backgroundColor=[UIColor colorWithRed:237/255.0f green:71/255.0f blue:59/255.0f alpha:1.0f];
        [sender setTitle:@"立即领取" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"立即使用" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        sender.backgroundColor=[UIColor whiteColor];
        sender.layer.borderWidth=1.0f;
        sender.layer.borderColor=[[UIColor redColor]CGColor];
    }
    //距离
    CLLocationCoordinate2D c1 = CLLocationCoordinate2DMake([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"latitude"] doubleValue], [[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"longtitude"] doubleValue]);
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    BMKMapPoint a=BMKMapPointForCoordinate(c1);
    BMKMapPoint b=BMKMapPointForCoordinate(appdelegate.userLocation.location.coordinate);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);
    
    int meter = (int)distance;
    if (meter>1000) {
        shopNameAndDistant.text = [[NSString alloc]initWithFormat:@"%@ %.1fkm",_dataArray[indexPath.row][@"store"],meter/1000.0];
    }else{
        shopNameAndDistant.text = [[NSString alloc]initWithFormat:@"%@ %dm",_dataArray[indexPath.row][@"store"],meter];
    }
    return cell;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*120/375.0f)];
//    view.backgroundColor=[UIColor grayColor];
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*120/375.0f)];
//    imageView.image=[UIImage imageNamed:@"5-01.png"];
//    [view addSubview:imageView];
//    return view;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)getCoupon:(UIButton *)sender{
    UITableViewCell *cell=(UITableViewCell *)[sender superview];
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    NSLog(@"%@",indexPath);
    NSDictionary *dic=_dataArray[indexPath.row];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.IsLogin) {
        //掉用领取接口
            if ([sender.titleLabel.text isEqualToString:@"立即使用"]) {
                CouponIntroduceVC *couponVC=[[CouponIntroduceVC alloc]init];
                couponVC.index=1;
                couponVC.infoDic=_dataArray[indexPath.row];
                [self.navigationController pushViewController:couponVC animated:YES];
            }else{
                [self postReceiveConponRequest:dic];
            }
    }else{
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取发布优惠券商家列表
-(void)postGetCouponRequest{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/coupon/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.IsLogin) {
        [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    }else{
        params=nil;
    }
    NSLog(@"------%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if ([result count]>0) {
            _dataArray=result;
            [_tableView reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}
-(void)postReceiveConponRequest:(NSDictionary *)dic{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/coupon/receive",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:dic[@"muid"] forKey:@"muid"];
    [params setObject:dic[@"coupon_id"] forKey:@"coupon_id"];
    
    NSLog(@"------%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if ([result[@"result_code"] integerValue]==1) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"领取成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
            [self postGetCouponRequest];
        }else if([result[@"result_code"] integerValue]==1062){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"限领1份", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:1.f];
            [self postGetCouponRequest];
        }

    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
