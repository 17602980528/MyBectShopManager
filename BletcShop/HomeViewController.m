//
//  HomeViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/11/4.
//  Copyright © 2016年 bletc. All rights reserved.
//
#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]


#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShaperView.h"
#import "DLStarRatingControl.h"
#import "HomeViewCell.h"
#import "AddressPickerDemo.h"
#import "SearchTableViewController.h"
#import "GYChangeTextView.h"
#import "NewShopDetailVC.h"
#import "BaseNavigationController.h"
#import "AdvertiseViewController.h"
#import "NewShopViewController.h"
#import "PointConvertViewController.h"
#import "NewMessageVC.h"

#import "LZDCenterViewController.h"
#import "TopActiveListTableVC.h"
#import "SDCycleScrollView.h"

#import "ScanViewController.h"
#import "HolidayActivertyVC.h"
#import "JFCityViewController.h"

#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "HotNewsVC.h"
#import "ChouJiangVC.h"
#import "LandingController.h"
@interface HomeViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GYChangeTextViewDelegate,SelectCityDelegate,JFLocationDelegate,SDCycleScrollViewDelegate>
{
    
    int currentIndex3;//请求页码
    int currentIndex1;//请求页码

    UIView*searchView;
    
    NSString *address_old;//之前的地址
    //广告轮播
    NSArray* _topAdverImages;
    NSInteger _pageID;
    
    UIPageControl *topPageControl;
    MBProgressHUD *data_hud;
   
    NSTimer* _timer;
    
    UIButton* _longAdvertise_btn;//长条广告
    
    //当前展示的页码。
    NSInteger _pageIndex;

    UIImageView *dingwei_img;
    UIButton *dingweiBtn;
    UITextField*search_tf; // placeholder
    UIView *topView;
    
    UITableView *table_View;
    
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    //广告位
    UIScrollView    *_smallSV;
    UIPageControl   *_pc;
    UIView *PopupAdvertiseView;//弹出广告
    SDCycleScrollView *cycleScrollView2;
    
    
    NSDictionary *pop_data_Dic;

}

@property(nonatomic,copy) NSString *city_district;//市区
@property (nonatomic, strong) GYChangeTextView *tView;

@property(nonatomic,strong)NSMutableArray* adverImages;
@property(nonatomic,strong) NSArray *icon_A;//20个小分类
@property(nonatomic,strong) NSArray *advertiseHeaderList;//头条信息
@property(nonatomic,strong) NSDictionary *longAdvertise_dic;//长条广告信息
@property(nonatomic,strong)NSMutableArray *titles;//顶部轮播广告

@property(nonatomic,strong)NSArray *circleAdverlist;//顶部轮播广告
@property(nonatomic,strong)UIView *headerView;//头view
@property(nonatomic,strong)NSMutableArray *data_A3; //广告位.第三部分列表
@property(nonatomic,strong)UIView *secondheaderView;//头2view
@property(nonatomic,strong)UIView *areaView;

@property(nonatomic,strong)NSArray *data_A2;//广告位.第二部分列表

//地点选择
@property(nonatomic,strong)NSArray *areaListArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,copy)NSString *cityChoice;//选择的地点


@property (nonatomic,assign)BOOL ifOpen;


@property(nonatomic,strong)NSTimer *changelabTimer;//定时器,轮播文字
@property(nonatomic,assign)NSInteger  index;


@property(nonatomic,strong)NSMutableArray *shopData_A;//保存所有数据
@property (nonatomic, strong) JFLocation *locationManager;
@property (nonatomic, strong) JFAreaDataManager *manager;


@end

@implementation HomeViewController
- (JFAreaDataManager *)manager {
    if (!_manager) {
        _manager = [JFAreaDataManager shareManager];
        [_manager areaSqliteDBData];
    }
    return _manager;
}

-(NSMutableArray*)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PopupAdvertiseView.hidden=NO;
    self.navigationController.navigationBar.hidden= YES;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (self.tView && (self.advertiseHeaderList.count!=0)) {
        [self.tView startAnimation];
    }
    self.cityChoice = appdelegate.cityChoice;
    
    self.city_district = [NSString stringWithFormat:@"%@%@",appdelegate.cityChoice,[appdelegate.districtString isEqualToString:appdelegate.cityChoice] ? @"":appdelegate.districtString];
    
    printf("viewWillAppear ==%s\n %s",[self.cityChoice UTF8String] ,[self.city_district UTF8String]);

    self.ifOpen =NO;
    
    if (self.ifOpen==NO)
    {
        [self.areaView removeFromSuperview];
        [self initTopView];
    }
    if (self.ifOpen==YES) {
        [self choiceArea];
        
    }

        [self autoAuth];

    
    [cycleScrollView2 adjustWhenControllerViewWillAppera];

 
}
- (void)viewDidAppear:(BOOL)animated {
    
   
}
#pragma mark - action


- (void)viewDidDisappear:(BOOL)animated {
    
    //timer 必须在 viewDidDisappear 进行销毁，才能正确的释放 self。
    [_timer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[JFLocation alloc] init];
    _locationManager.delegate = self;

#if TARGET_IPHONE_SIMULATOR
    
//    [KCURRENTCITYINFODEFAULTS setObject:@"西安市" forKey:@"locationCity"];
//    [KCURRENTCITYINFODEFAULTS setObject:@"西安市" forKey:@"currentcity"];
//    
//
    
    [self.manager currentCityDic:@"西安市" currentCityDic:^(NSDictionary *dic) {
        
        [KCURRENTCITYINFODEFAULTS setObject:dic forKey:@"locationCityDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentEareDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentCityDic"];
        
        
        NSLog(@"TARGET_IPHONE_SIMULATOR------%@",dic);
        
        [self.manager areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            [KCURRENTCITYINFODEFAULTS setObject:areaData forKey:@"currentEreaList"];
            
            
            
        }];
        
    }];

    
#elif TARGET_OS_IPHONE
    
    
#endif
    
    
    
    currentIndex3= 1;
    currentIndex1=1;
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.city_district = [appdelegate.city stringByAppendingString:appdelegate.addressDistrite];
    
    NSLog(@"viewDidLoad===%@",self.city_district);
    if (!self.city_district) {
        self.city_district = @"西安市雁塔区";
    }

    
    [self initTableView];

    
    
    address_old = appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice;


    
}
//创建顶部导航
-(void)initTopView{
    [topView removeFromSuperview];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    NSDictionary *area_dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *allCityKeys = [area_dic allKeys];
    NSMutableDictionary *allCityss = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < allCityKeys.count; i ++) {
        [allCityss addEntriesFromDictionary:[area_dic objectForKey:[allCityKeys objectAtIndex:i]]];
    }
    self.areaListArray = [[NSArray alloc] initWithArray: [allCityss objectForKey: self.cityChoice]];
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //    self.city_district = [appdelegate.city stringByAppendingString:appdelegate.addressDistrite];
    
    NSLog(@"initTopView=====%@",self.city_district);
    if (!self.city_district) {
        self.city_district = @"西安市雁塔区";
    }
    appdelegate.areaListArray = self.areaListArray;
    
    
    topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    
    UIColor *color=NavBackGroundColor;
    CGFloat offset=table_View.contentOffset.y;
    //        NSLog(@"================%lf",offset);
    if (offset<0) {
        topView.backgroundColor = [color colorWithAlphaComponent:0];
    }else {
        CGFloat alpha=1-((100-offset)/100);
        topView.backgroundColor=[color colorWithAlphaComponent:alpha];
    }
    
    
    
    
    
    
    dingweiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 43, 44)];
    [dingweiBtn addTarget:self action:@selector(dingweiClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [dingweiBtn setTitle:appdelegate.districtString.length>0?appdelegate.districtString:appdelegate.cityChoice forState:UIControlStateNormal];
    [dingweiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dingweiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:dingweiBtn];
    
    
    CGFloat ww = [dingweiBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:dingweiBtn.titleLabel.font} context:nil].size.width;
    
    NSLog(@"--------------%f",ww);
    
    CGRect btn_frame = dingweiBtn.frame;
    btn_frame.size.width =  ww<43 ? 43:58;
    dingweiBtn.frame = btn_frame;
    
    
    dingwei_img = [[UIImageView alloc]initWithFrame:CGRectMake(dingweiBtn.right, 20+(44-12)/2, 12, 12)];
    dingwei_img.image = [UIImage imageNamed:@"首页最上面"];
    [topView addSubview:dingwei_img];
    
    
    searchView=[[UIView alloc]init];
    searchView.frame=CGRectMake(dingwei_img.right+5, 28, SCREENWIDTH-dingwei_img.right-5-35-30, 30);
    searchView.backgroundColor=RGB(249, 249, 249);
    searchView.layer.cornerRadius=3;
    searchView.alpha = 0.8;
    [topView addSubview:searchView];
    
    
    UIImageView *search1= [[UIImageView alloc]initWithFrame:CGRectMake(11, 17/2, 13, 13)];
    search1.image = [UIImage imageNamed:@"sousuo"];
    [searchView addSubview:search1];
    
    
    search_tf=[[UITextField alloc]initWithFrame:CGRectMake(search1.right+10, 7, SCREENWIDTH-120, 20)];
    search_tf.placeholder=@"点击搜索";
    search_tf.delegate=self;
    [search_tf setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [search_tf setValue:RGB(153, 153, 153) forKeyPath:@"_placeholderLabel.color"];
    search_tf.userInteractionEnabled=NO;
    search_tf.alpha=0.8;
    [searchView addSubview:search_tf];
    
    UIButton *search_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    search_btn.frame = searchView.frame;
    [search_btn addTarget:self action:@selector(searchViewClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:search_btn];
    
    
    for (int i =0; i<2; i ++) {
        
        
        UIButton *minePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        minePageBtn.tag = i;
        minePageBtn.frame = CGRectMake(CGRectGetMaxX(searchView.frame)+i*35, CGRectGetMinY(searchView.frame), 35, 35);
        [minePageBtn addTarget:self action:@selector(goMineCenter:) forControlEvents:UIControlEventTouchUpInside];
        
        [topView addSubview:minePageBtn];
        
        UIImageView *img_mine = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 20, 20)];
        img_mine.image = [UIImage imageNamed:@"扫描二维码"];
        [minePageBtn addSubview:img_mine];
        if (i==1) {
            
            
           

//            UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(16, 4, 4, 4)];
//            redView.backgroundColor = [UIColor redColor];
//            redView.layer.cornerRadius = redView.width/2;
//            redView.clipsToBounds = YES;
//            [img_mine addSubview:redView];
            
            img_mine.frame =CGRectMake(2.5, 5.5, 24, 24);
            img_mine.image = [UIImage imageNamed:@"home_adress_choose_n"];
            
            //            UIImageView *whitePoint = [[UIImageView alloc]initWithFrame:CGRectMake(img_mine.width-6-2, 0, 6, 6)];
            //            whitePoint.backgroundColor = [UIColor greenColor];
            //
            //            whitePoint.layer.cornerRadius = whitePoint.width/2;
            //            [img_mine addSubview:whitePoint];
            
        }
        
        
    }
    NSLog(@"address_old------%@===%@",address_old,dingweiBtn.titleLabel.text);
    
    if (![address_old isEqualToString:dingweiBtn.titleLabel.text]) {
        address_old = dingweiBtn.titleLabel.text;
        [self getIcons:@""];
 
    }
    
    
    
    
    
}

-(void)initTableView{
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview: table_View];
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:table_View];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block HomeViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        
        [blockSelf getIcons:@""];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:table_View];
    
    _refreshFooter.beginRefreshingOperation =^{
        [blockSelf postRequestAdv1WithMore:@"more"];
        
    };

    

    [self getIcons:@""];

    
    

}

/**
 *  获得版本号
 */
-(void)getVersion_code{
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    // app版本
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/source/version",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:@"ios" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"===--%@",result);
        NSLog(@" app版本  %ld",(long)[app_Version compare:result[@"version"] options:NSNumericSearch]);
        
        if ([app_Version compare:result[@"version"] options:NSNumericSearch] >= 0) {
            
            [self getPopupAdvertise];
                    }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
            return self.headerView;
        
    }else if(section ==1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *like_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        like_lab.text = @"猜你喜欢";
        like_lab.textColor = RGB(102, 102, 102);
        like_lab.textAlignment = NSTextAlignmentCenter;
        like_lab.font = [UIFont systemFontOfSize:14];
        like_lab.backgroundColor = [UIColor whiteColor];
        [view addSubview:like_lab];
        
        CGFloat  WW = [like_lab.text boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:like_lab.font} context:nil].size.width;
        
        UIView *line1 = [[UIView alloc]init];
        line1.frame = CGRectMake(50, 29/2+like_lab.top, SCREENWIDTH/2-50-WW/2-20, 1);
        line1.backgroundColor = RGB(221,221,221);
        [view addSubview:line1];
        
        UIView *line2 = [[UIView alloc]init];
        line2.frame = CGRectMake( SCREENWIDTH/2+WW/2+20, line1.top, line1.width, 1);
        line2.backgroundColor = RGB(221,221,221);
        [view addSubview:line2];
        
        return view;
    }else
        return nil;
    

    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
     if (section ==0) {
       return   self.secondheaderView;
         
     }else
         return nil;

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        return 2*(SCREENWIDTH/5+10)+66-10+150*LZDScale+10;
    }else if(section==1){
        return 30;
    }else
        return 0.01;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     if (section==0){
        
        return 261;
    }else
        return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 0.01;
    }else{
        HomeShopModel *model;
        
        if (self.data_A3.count!=0) {
            model = self.data_A3[indexPath.row];
            
        }
        
        return model.remark.length>0 ? 76:140;
        
          }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else
    return self.data_A3.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeShopModel *model;
    
    if (self.data_A3.count!=0) {
         model = self.data_A3[indexPath.row];
        
        if (model.remark.length>0) {
            
            static NSString *cellID = @"homeCellId";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            
            UIImageView *img_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 76-1)];
            [img_view sd_setImageWithURL:[NSURL URLWithString:model.long_img_url] placeholderImage:[UIImage imageNamed:@"icon3"]];
            
            [cell.contentView addSubview:img_view];
            
            
            UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(0, img_view.bottom, SCREENWIDTH, 1)];
            lineView.backgroundColor=[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
            
            [cell.contentView addSubview:lineView];
            
            
            return cell;
            
        }else{
            HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [HomeViewCell homeViewCellWithTableView:tableView];
            }
            cell.model = model;
            
            return cell;
            
        }

        
    }else{
        return nil;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeShopModel *model = self.data_A3[indexPath.row];
    if (model.remark.length>0) {
        NSLog(@"---长条广告不可点击--");
    }else{
        NSMutableDictionary *shopInfoDic = [self.shopData_A objectAtIndex:indexPath.row];
        NSLog(@"---%@--==%@",model.title_S,shopInfoDic);

        
        NewShopDetailVC *vc= [self startSellerView:shopInfoDic];
        vc.videoID=model.video;
        
        
        [self.navigationController pushViewController:vc animated:YES];

//        NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        //获取商家手机号
//        
//        [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];
//        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
//         {
//             NSLog(@"%@",result);
//             if (result.count>0) {
//                 __block HomeViewController* tempSelf = self;
//                 
//                 if ([result[0][@"state"] isEqualToString:@"true"]) {
//                     vc.videoID=result[0][@"video"];
//                     
//                 }else{
//                     vc.videoID=@"";
//                     
//                 }
//                 [tempSelf.navigationController pushViewController:vc animated:YES];
//             }else{
//                 __block HomeViewController* tempSelf = self;
//                 vc.videoID=@"";
//                 [tempSelf.navigationController pushViewController:vc animated:YES];
//             }
//             
//         } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"%@", error);
//             __block HomeViewController* tempSelf = self;
//             vc.videoID=@"";
//             [tempSelf.navigationController pushViewController:vc animated:YES];
//         }];
        


    }
}

-(NewShopDetailVC *)startSellerView:(NSMutableDictionary*)dic{
    
    NewShopDetailVC *controller = [[NewShopDetailVC alloc]init];
    
    controller.infoDic = dic;
    
    controller.title = @"商铺信息";
    
    return controller;
    
}
//一区区头
-(UIView*)creatHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2+50)];
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, (410-39)*LZDScale)];
    backImg.backgroundColor =[UIColor whiteColor];
//    backImg.image = [UIImage imageNamed:@"chunjie"];
    [view addSubview:backImg];
    
    
    //广告轮播
    UIView *slipBackView=[[UIView alloc]init];
    
    slipBackView.frame = CGRectMake(0, 0, SCREENWIDTH, 150*LZDScale);

    slipBackView.backgroundColor=RGB(240, 240, 240);
    [view addSubview:slipBackView];

    
    if (_adverImages.count !=0) {
        cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, slipBackView.height) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        cycleScrollView2.imageURLStringsGroup = _adverImages;
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//           cycleScrollView2.titlesGroup = self.titles;
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        cycleScrollView2.hidesForSinglePage = YES;
        [slipBackView addSubview:cycleScrollView2];
    }else{
       
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:slipBackView.frame];
        imgView.image = [UIImage imageNamed:@"Active_top4.jpg"];
        [slipBackView addSubview:imgView];
    }
    
 
    
    
    
    
    
    _smallSV=[[UIScrollView alloc]init];
    _smallSV.pagingEnabled=YES;
    _smallSV.bounces=NO;
    _smallSV.delegate=self;
    _smallSV.backgroundColor = [UIColor clearColor];
    _smallSV.showsVerticalScrollIndicator = NO;
    _smallSV.showsHorizontalScrollIndicator = NO;
    [view addSubview:_smallSV];
    
    
    NSInteger yeshu = 0;

    if (self.icon_A.count%10==0) {
        yeshu = self.icon_A.count/10;
    }else{
        yeshu = self.icon_A.count/10+1;
    }

    for (int j = 0; j < yeshu; j ++) {
        
        for (int i = j*10; i < (j+1)*10; i ++) {
            if (i >=self.icon_A.count) {
                break;
            }
            int X = (i-j*10)%5;
            int Y = (i-j*10)/5;
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(X *SCREENWIDTH/5+ SCREENWIDTH*j,5+Y *(SCREENWIDTH/5+10), SCREENWIDTH/5, SCREENWIDTH/5)];
            [btn addTarget:self action:@selector(topClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            btn.tag = i;
            [_smallSV addSubview:btn];
            
            UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(25/2, 5, btn.frame.size.width-25, btn.frame.size.width-25)];
            [btn addSubview:imag];
            
            UILabel *lable_S =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imag.frame), btn.frame.size.width, 25)];
            lable_S.textColor = [UIColor blackColor];
            lable_S.font = [UIFont systemFontOfSize:13];
            lable_S.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:lable_S];
            
            NSDictionary *dic  = self.icon_A[i];
            
            [imag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICONIMAGE,dic[@"icon_url"]]] placeholderImage:[UIImage imageNamed:@"icon3"]];
            [lable_S setText:[NSString getTheNoNullStr:dic[@"text"] andRepalceStr:@"美女服务"]];
            
                   
        }
    }


    
    _pc=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREENWIDTH*0.2, 10+ 2*(SCREENWIDTH/5+10)+150*LZDScale, SCREENWIDTH*0.6, 10)];
    _pc.currentPageIndicatorTintColor=NavBackGroundColor;
    _pc.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_pc addTarget:self action:@selector(pcClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_pc];
    
    _smallSV.frame  = CGRectMake(0, 5+150*LZDScale, SCREENWIDTH, 10+ 2*(SCREENWIDTH/5+10)+10);
    if (self.icon_A.count%10==0) {
        _smallSV.contentSize = CGSizeMake(SCREENWIDTH*self.icon_A.count/10, 0);
        _pc.numberOfPages = self.icon_A.count/10;
    }else{
        _smallSV.contentSize = CGSizeMake(SCREENWIDTH*(self.icon_A.count/10+1), 0);
        _pc.numberOfPages = self.icon_A.count/10+1;

    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _smallSV.bottom, SCREENWIDTH, 1)];
    line.backgroundColor =RGB(240, 240, 240);
    [view addSubview:line];
    
    UILabel *hot_label = [[UILabel alloc]initWithFrame:CGRectMake(0, _smallSV.bottom+1, SCREENWIDTH, 30+10)];
    hot_label.text = @"   今日头条";
    hot_label.font = [UIFont systemFontOfSize:14];
    hot_label.textColor = [UIColor colorWithHexString:@"fe0000"];
    
    hot_label.backgroundColor = [UIColor whiteColor];
    [view addSubview:hot_label];
    
//    UIImageView *imgVi = [[UIImageView alloc]initWithFrame:CGRectMake(5, _smallSV.bottom+1+7.5, 145/2, 15)];
//    imgVi.image = [UIImage imageNamed:@"今日头条"];
//    
//    [view addSubview:imgVi];
    
    CGFloat hot_ww = [self getSizeWithLab:hot_label andMaxSize:CGSizeMake(100, 100)].width;
    
//    GYChangeTextView *tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(hot_ww+5, hot_label.top+(hot_label.height-12)/2, SCREENWIDTH-hot_ww-20, 12)];
    GYChangeTextView *tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(hot_ww+5, hot_label.top, SCREENWIDTH-hot_ww-20, hot_label.height)];

    tView.delegate = self;
    [view addSubview:tView];
    self.tView = tView;
    
    NSMutableArray *mut = [NSMutableArray array];
    if (self.advertiseHeaderList.count!=0) {
        for (NSDictionary *dic in self.advertiseHeaderList) {
            [mut addObject:dic[@"text"]];
        }
        
        [self.tView animationWithTexts:mut];
    }else{
        [self.tView stopAnimation];
    }
    
    
    
    

    view.frame = CGRectMake(0, 0, SCREENWIDTH, CGRectGetMaxY(hot_label.frame));
    

    return view;
}

//二区区头
-(UIView*)creatSecondheardView{
    UIView *back_view = [UIView new];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 10, SCREENWIDTH*0.4, 160);
    button1.backgroundColor = [UIColor whiteColor];
    [button1 addTarget:self action:@selector(advertiseClick:) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:button1];
    
    UILabel *lab1_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, button1.width, 15)];
    lab1_1.text = @"新店入住";
    button1.tag=0;
    lab1_1.font = [UIFont systemFontOfSize:15];
    lab1_1.textColor = [UIColor colorWithHexString:@"fe0000"];
    lab1_1.textAlignment = NSTextAlignmentCenter;
    [button1 addSubview:lab1_1];
    
    UILabel *lab1_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, button1.width, 12)];
    lab1_2.text = @"优惠停不下来";
    lab1_2.font = [UIFont systemFontOfSize:12];
    lab1_2.textColor = RGB(102,102,102);
    lab1_2.textAlignment = NSTextAlignmentCenter;
    [button1 addSubview:lab1_2];
    
    UIImageView *img_1 = [[UIImageView alloc]initWithFrame:CGRectMake((button1.width-119)/2, 87, 119, 49)];
    [button1 addSubview:img_1];
    
    
    NSDictionary *dic ;
    if (self.data_A2.count!=0) {
        
        dic = self.data_A2[0];
        lab1_1.text = dic[@"theme"];
        lab1_2.text = dic[@"content"];
        NSString *img_str = [NSString stringWithFormat:@"%@%@",FOURADVERTIMAGE,dic[@"image_url"]];
        [img_1 sd_setImageWithURL:[NSURL URLWithString:img_str] placeholderImage:[UIImage imageNamed:@"dfg"]];
        

    }
    
    
    
    
    UIButton *button2 =[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button1.right+1, 10, SCREENWIDTH-button1.right-1, 79-5);
    button2.backgroundColor = [UIColor whiteColor];
    [button2 addTarget:self action:@selector(advertiseClick:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag=1;
    [back_view addSubview:button2];
    
    UILabel *lab2_1 = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, button2.width/2, 15)];
    lab2_1.text = @"美发专区";
    lab2_1.font = [UIFont systemFontOfSize:15];
    lab2_1.textColor = [UIColor colorWithHexString:@"fe0000"];
    lab2_1.textAlignment = NSTextAlignmentLeft;
    [button2 addSubview:lab2_1];
    
    UILabel *lab2_2 = [[UILabel alloc]initWithFrame:CGRectMake(13, 31, button2.width/2-13, 12)];
    lab2_2.text = @"办卡永享8折";
    lab2_2.font = [UIFont systemFontOfSize:12];
    lab2_2.textColor = RGB(102,102,102);
    lab2_2.textAlignment = NSTextAlignmentLeft;
    [button2 addSubview:lab2_2];
    
    
    UIImageView *img_2 = [[UIImageView alloc]initWithFrame:CGRectMake(button2.width/2, 0, button2.height*230/124, button2.height)];
//    img_2.backgroundColor = RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
    [button2 addSubview:img_2];
    
    
    if (self.data_A2.count!=0) {
        
        dic = self.data_A2[1];
        lab2_1.text = dic[@"theme"];
        lab2_2.text = dic[@"content"];
        NSString *img_str = [NSString stringWithFormat:@"%@%@",FOURADVERTIMAGE,dic[@"image_url"]];

        [img_2 sd_setImageWithURL:[NSURL URLWithString:img_str] placeholderImage:[UIImage imageNamed:@"dasda.png"]];
        
        CGFloat hh = [lab2_2.text boundingRectWithSize:CGSizeMake(lab2_2.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :lab2_2.font} context:nil].size.height;
        
        
        if (hh>lab2_2.height) {
            lab2_2.frame = CGRectMake(13, 31, button2.width/2-13, 25);
            lab2_2.numberOfLines= 2;
        }
    }

    
    
    for (int i = 0; i <2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(button1.right+1+i*((button2.width-1)/2+1), button2.bottom+1, ((button2.width-1)/2), 80+5);
        [btn addTarget:self action:@selector(advertiseClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+2;
        btn.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab_1 = [[UILabel alloc]initWithFrame:CGRectMake(11, 10, btn.width, 15)];
        lab_1.text = @"会员大放送";
        lab_1.font = [UIFont systemFontOfSize:15];
        lab_1.textColor = [UIColor colorWithHexString:@"fe0000"];
        lab_1.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:lab_1];
        
        UILabel *lab_2 = [[UILabel alloc]initWithFrame:CGRectMake(11, 27, btn.width, 12)];
        lab_2.text = @"优惠停不下来";
        lab_2.font = [UIFont systemFontOfSize:12];
        lab_2.textColor = RGB(102,102,102);
        lab_2.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:lab_2];
//btn.width-13-38, btn.height-38-2, 38, 38
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake( (btn.width-38*224/110)/2, btn.height-38-2, 38*224/110, 38)];
        [btn addSubview:img];
        
              [back_view addSubview:btn];
        
        if (self.data_A2.count!=0) {
            
            dic = self.data_A2[i+2];
            lab_1.text = dic[@"theme"];
            lab_2.text = dic[@"content"];
            
            NSString *img_str = [NSString stringWithFormat:@"%@%@",FOURADVERTIMAGE,dic[@"image_url"]];
            
            [img sd_setImageWithURL:[NSURL URLWithString:img_str] placeholderImage:[UIImage imageNamed:@"icon3.png"]];
            
            
            if (i ==0) {
                //img.frame = CGRectMake(13, btn.height-38-2, 38, 38);
                [img sd_setImageWithURL:[NSURL URLWithString:img_str] placeholderImage:[UIImage imageNamed:@"icon3.png"]];
//                lab_2.text = @"喜迎中国年!";(13, btn.height-38-2, 38, 38
                
            }

            
            
        }

    }
    
    //长条广告
    _longAdvertise_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _longAdvertise_btn.frame = CGRectMake(0, button1.bottom+10, SCREENWIDTH, 76);
//    _longAdvertise_btn.backgroundColor = [UIColor orangeColor];
    
    if (self.longAdvertise_dic) {
        NSString *_longimg_str = [NSString stringWithFormat:@"%@%@",LONGADVERTIMAGE,self.longAdvertise_dic[@"image_url"]];
        
        [_longAdvertise_btn sd_setImageWithURL:[NSURL URLWithString:_longimg_str] forState:0 placeholderImage:[UIImage imageNamed:@"-2-01.jpg"]];
        [_longAdvertise_btn sd_setImageWithURL:[NSURL URLWithString:_longimg_str] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"-2-01.jpg"]];


    }
    
    [back_view addSubview:_longAdvertise_btn];
    


    
    back_view.frame = CGRectMake(0, 0, SCREENWIDTH, _longAdvertise_btn.bottom+5);
    
    return back_view;
}
-(void)choiceArea
{
    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT/2)];
    self.areaView = newView;
    newView.backgroundColor = [UIColor lightGrayColor];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
    NSInteger height = 0;

    height =  SCREENHEIGHT/2-80;
    NSLog(@"%ld",height);
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH ,height) collectionViewLayout:flowLayout];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:YES];
    [self.collectionView setScrollEnabled:YES];
    /*
     *  注册cell
     */
    [self.collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [newView addSubview:self.collectionView];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    UIView *cityView = [[UIView alloc]initWithFrame:CGRectMake(20, SCREENHEIGHT/2-55, SCREENWIDTH-40, 30)];
    cityView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5,0,60,30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    label.text = @"当前城市:";
    [cityView addSubview:label];
    UILabel *labelCity = [[UILabel alloc]initWithFrame:CGRectMake(70,0,100,30)];
    labelCity.font = [UIFont systemFontOfSize:10];
    labelCity.textAlignment = NSTextAlignmentLeft;
    
    labelCity.text = self.cityChoice;
    [cityView addSubview:labelCity];
    UILabel *labelChange = [[UILabel alloc]initWithFrame:CGRectMake(cityView.width-80,0,60,30)];
    labelChange.textAlignment = NSTextAlignmentRight;
    labelChange.font = [UIFont systemFontOfSize:10];
    labelChange.text = @"更换";
    [cityView addSubview:labelChange];
    UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choiceBtn.frame = CGRectMake(cityView.width-20, 10, 10, 10);
    [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
    [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
    
    [cityView addSubview:choiceBtn];
    cityView.userInteractionEnabled = YES;
    UIGestureRecognizer *tapGestureDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allCanChoiceCities)];
    [cityView addGestureRecognizer:tapGestureDate];
    [newView addSubview:cityView];
    [self.view addSubview:newView];
    
}
-(void)allCanChoiceCities
{
    AddressPickerDemo *addressPickerDemo = [[AddressPickerDemo alloc] init];
    addressPickerDemo.delegate = self;
    [self.navigationController pushViewController:addressPickerDemo animated:YES];
}

#pragma mark- Source Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.areaListArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify=@"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //解决视图重叠问题
    for (UIView *subView in cell.subviews) {
        if ([subView isMemberOfClass:[UILabel class]]) {    //UILabel 改为自己加的控件
            [subView removeFromSuperview];
        }
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,1,(SCREENWIDTH-40)/3,35)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    cell.layer.cornerRadius = 1;
    cell.layer.masksToBounds = YES;
    //给图层添加一个有色边框?
    cell.layer.borderWidth = 0.1;
    
    cell.layer.borderColor = [[UIColor grayColor] CGColor];
    NSString *item = [self.areaListArray objectAtIndex:(long)indexPath.row];
    label.text = item;
    label.textAlignment = NSTextAlignmentCenter;
    
    [self minimumInteritemSpacing];
    return cell;
}
- (CGFloat)minimumInteritemSpacing {
    return 0;
}
#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH-40)/3, 35 );
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//点击选择区域
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.districtString= [self.areaListArray objectAtIndex:(long)indexPath.row];;
    self.ifOpen = NO;
    [dingweiBtn setTitle:appdelegate.districtString forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform;
    
    if (dingweiBtn.selected) {
        transform = CGAffineTransformRotate(dingwei_img.transform, M_PI);
    } else {
        transform = CGAffineTransformRotate(dingwei_img.transform, -270*M_PI/90);
    }
    dingwei_img.transform = transform;

    [UIView commitAnimations];
    
    
    dingweiBtn.selected =! dingweiBtn.selected;
    self.ifOpen = !self.ifOpen;
    [self.areaView removeFromSuperview];
    
   
    
    self.city_district = [NSString stringWithFormat:@"%@%@%@",appdelegate.cityChoice,@"市",appdelegate.districtString];
    if (!self.city_district) {
        self.city_district = @"西安市雁塔区";
    }

    printf("didSelectItemAtIndexPath===%s\n",[self.city_district UTF8String]);
    
    CGFloat ww = [dingweiBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:dingweiBtn.titleLabel.font} context:nil].size.width;
    
   
    
    
    NSLog(@"--------------%f",ww);
    
    CGRect btn_frame = dingweiBtn.frame;
    btn_frame.size.width =  ww<43 ? 43:58;
    dingweiBtn.frame = btn_frame;
    
    [self resetFrame];

    
    [self getIcons:@""];
    
}

#pragma  mark 数据请求
//获取小分类
-(void)getIcons:(NSString*)more{
    
    data_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/Source/tradeIconGet",BASEURL];
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         self.icon_A= (NSArray*)result;

         
         [self getAdvertiseHeaderLineGet:more];
         


         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [data_hud hideAnimated:YES];
         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         NSLog(@"%@", error);
     }];
}

//获取头条
-(void)getAdvertiseHeaderLineGet:(NSString*)more{
    NSLog(@"senderSelectCity=====%@",self.city_district);
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advert/headlineGet",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.city_district forKey:@"eare"];
    NSLog(@"--%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result====>>>%@",result);
         self.advertiseHeaderList= (NSArray*)result;
//         self.headerView = [self creatHeaderView];
//         
//         [self postRequestAdv2:more];
         [self getTopCircleAdverList:more];
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         [data_hud hideAnimated:YES];

         NSLog(@"%@", error);
     }];
}


-(void)getTopCircleAdverList:(NSString*)more{
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advertTop/get",BASEURL];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:appdelegate.cityChoice forKey:@"address"];
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSLog(@"getTopCircleAdverList--%@ ==%@",paramer,result);

         self.circleAdverlist= (NSArray*)result;
         
         
         [self.adverImages removeAllObjects];
         
         [self.titles removeAllObjects];
         for (int i=0; i<[result count]; i++) {
             [self.adverImages addObject:[NSString stringWithFormat:@"%@%@",HOME_LUNBO_IMAGE,result[i][@"image_url"]]];
             
             [self.titles addObject:result[i][@"title"]];
         }

         self.headerView = [self creatHeaderView];
         
         [self postRequestAdv2:more];
         
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [data_hud hideAnimated:YES];

         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         NSLog(@"%@", error);
     }];

}

/**
 获取活动数据
 */
-(void)postRequestAdv2:(NSString*)more
{
    
    NSLog(@"------self.cityChoice-------%@-----%@",self.cityChoice,self.city_district);

    
    if ([self.city_district containsString:@"全城"]) {
       self.city_district =  [self.city_district stringByReplacingOccurrencesOfString:@"全城" withString:@""];
    }
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/activity/get",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.city_district forKey:@"eare"];
    NSLog(@"postRequestAdv2-----%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {

         NSLog(@"获取活动数据----%@",result);
         
         self.data_A2= (NSArray*)result;
         [self postRequestAdv1WithMore:more];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         [data_hud hideAnimated:YES];

         NSLog(@"%@", error);
     }];
    
}


/**
 获取长条广告

 @param more <#more description#>
 */
-(void)postRequestAdv1WithMore:(NSString *)more
{
    NSLog(@"------self.cityChoice-------%@-----%@==more=%@",self.cityChoice,self.city_district,more);
    if (![self.city_district containsString:self.cityChoice]) {
        self.city_district =self.cityChoice;
    }
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advert/insertGet",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.city_district forKey:@"eare"];
    
    if ([more isEqualToString:@"more"]) {
        [paramer setValue:[NSString stringWithFormat:@"%d",++currentIndex1] forKey:@"place"];

    }else{
        currentIndex1 = 1;
        [paramer setValue:@"1" forKey:@"place"];
 
    }

    NSLog(@"postRequestAdv1WithMore====%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
                  NSLog(@"postRequestAdv1WithMore---%@",result);
         
         if ([more isEqualToString:@""]) {
             
             if ([result isKindOfClass:[NSDictionary class]]) {
                 self.longAdvertise_dic = (NSDictionary*)result;

             }
             
             self.secondheaderView = [self creatSecondheardView];
             [self postRequestAdv3WithMore:@""];

         }else{
             if ([result isKindOfClass:[NSDictionary class]]) {
                 NSLog(@"--是字典---");
                 
                 HomeShopModel *model = [[HomeShopModel alloc]initWithDictionary:result];
                 model.remark = @"长条广告";
                 
                 [self.data_A3 addObject:model];
                 [self.shopData_A addObject:result];
             }else{
                 NSLog(@"--是数组---");

             }
            

             
             [self postRequestAdv3WithMore:more];

         }
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [data_hud hideAnimated:YES];

         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
                  NSLog(@"postRequestAdv1==%@", error);
     }];
    
}
//获取商家列表
-(void)postRequestAdv3WithMore:(NSString*)more
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/listGet",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    
    [paramer setValue:self.city_district forKey:@"eare"];
    if ([more isEqualToString:@"more"]) {
        
        [paramer setValue:[NSString stringWithFormat:@"%d",++currentIndex3] forKey:@"index"];


    }else{
        
        currentIndex3 = 1;
        
        [self.data_A3 removeAllObjects];
        [self.shopData_A removeAllObjects];
        [paramer setValue:@"1" forKey:@"index"];

    }

    NSLog(@"postRequestAdv3WithMore---%@",paramer);
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         [data_hud hideAnimated:YES];

                  NSLog(@"result3==%@",result);
         
         NSArray *arr = (NSArray*)result;
         
         
         for (NSDictionary *dic in arr) {
             
             HomeShopModel *model = [[HomeShopModel alloc]initWithDictionary:dic];

             [self.data_A3 addObject:model];
             [self.shopData_A addObject:dic];

         }
         
         static dispatch_once_t onceToken;
         dispatch_once(&onceToken, ^{
             
             [self getVersion_code];

         });
         
         
         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         
         [table_View reloadData];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {

         [_refreshheader endRefreshing];
         [_refreshFooter endRefreshing];
         [data_hud hideAnimated:YES];

         NSLog(@"%@", error);
     }];
    
}
//获取弹出广告
-(void)getPopupAdvertise{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/advert/popupGet",BASEURL];
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.city_district forKey:@"eare"];
    NSLog(@"getPopupAdvertise--%@",paramer);
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"getPopupAdvertise-result-%@",result);
         
         pop_data_Dic = [NSDictionary dictionaryWithDictionary:result];
         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
         formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
         
         NSDate *startDate = [formatter dateFromString:[NSString getTheNoNullStr:result[@"start_time"] andRepalceStr:@""]];
        
         NSDate *endDate = [formatter dateFromString:[NSString getTheNoNullStr:result[@"end_time"] andRepalceStr:@""]];
         
         
         NSDate *currentDate = [NSDate date];

         double interVal1 = [currentDate timeIntervalSinceDate:startDate];
         
         double interVal2 = [currentDate timeIntervalSinceDate:endDate];
         NSLog(@"=====%f=%f",interVal1,interVal2);
         if (interVal1>0 && interVal2 <0) {
             
             NSString *img_url = [NSString getTheNoNullStr:result[@"image_url"] andRepalceStr:@""];

             if (img_url.length>0) {
                 [self creatPopupAdvertiseView:result];
                 
             }

         }
         
        
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"getPopupAdvertise=%@", error);
     }];
}

//创建弹出广告视图
-(void)creatPopupAdvertiseView:(NSDictionary*)dic{
    
    NSString *img_url = [NSString getTheNoNullStr:dic[@"image_url"] andRepalceStr:@""];

      PopupAdvertiseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    PopupAdvertiseView.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:0.7];
    
     NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *curent_window = [windows lastObject];
    NSLog(@"------%@",curent_window.subviews);
    
    
    [curent_window addSubview: PopupAdvertiseView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.bounds =CGRectMake(0,0, SCREENWIDTH-20, (SCREENWIDTH-20)*0.8);
    imageView.center = CGPointMake(curent_window.center.x, curent_window.center.y-30);
                              
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POPADVERTIMAGE,img_url]] placeholderImage:[UIImage imageNamed:@"icon3"]];
    

    [PopupAdvertiseView addSubview:imageView];
    
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImgClick)];
    [imageView addGestureRecognizer:tapgesture];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((SCREENWIDTH-30)/2, imageView.bottom+50, 30, 30);
    [button setImage:[UIImage imageNamed:@"关闭"] forState:0];
    [button addTarget:self action:@selector(tapCl) forControlEvents:UIControlEventTouchUpInside];
    [PopupAdvertiseView addSubview:button];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCl)];
//    [PopupAdvertiseView addGestureRecognizer:tap];
    
}
-(void)tapCl{
    
    [PopupAdvertiseView removeFromSuperview];
}
//小分类按钮
-(void)topClick:(UIButton*)sender{
    
    NSLog(@"小分类");
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.menuString = [self.icon_A objectAtIndex:sender.tag][@"text"];
    NSLog(@"appdelegate.menuString%@",appdelegate.menuString);
    //    self.tabBarController.selectedIndex = 1;
    NSLog(@"%ld",(long)sender.tag);
    
    self.tabBarController.selectedIndex =1;

}
//搜索
-(void)searchViewClick{
    NSLog(@"搜索");
    SearchTableViewController *VC = [[SearchTableViewController alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)goMineCenter:(UIButton*)sender{
    NSLog(@"闹铃");
    if (sender.tag==0) {
        ScanViewController *VC = [[ScanViewController alloc]init];
        VC.shopOrUser=@"user";
        [self.navigationController pushViewController:VC animated:YES];

    }else{
        
//        [self showHint:@"暂未开放!"];
        
        
        NewMessageVC *VC = [[NewMessageVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
//定位
-(void)dingweiClick:(UIButton*)btn{
    NSLog(@"定位");
    
    
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    
    cityViewController.title = @"城市";
    __weak typeof(self) weakSelf = self;
    [cityViewController choseCityBlock:^(NSString *cityName,NSString *eareName){
        
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.cityChoice= [NSString getTheNoNullStr:cityName andRepalceStr:appdelegate.cityChoice];
        appdelegate.districtString = eareName.length>0 ? [NSString getTheNoNullStr:eareName andRepalceStr:appdelegate.districtString]:[NSString getTheNoNullStr:cityName andRepalceStr:appdelegate.cityChoice];
        
        NSLog(@"-----%@====%@\\\\",cityName,eareName);
        
        
        
        
        [dingweiBtn setTitle:eareName.length>0 ? eareName:cityName forState:UIControlStateNormal];
        
        
        weakSelf.city_district = [NSString stringWithFormat:@"%@%@",cityName,eareName];
        
        [weakSelf resetFrame];
        
        //        [self getIcons:@""];
        
        
        
    }];
    BaseNavigationController *navigationController = [[BaseNavigationController alloc]initWithRootViewController:cityViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
    
    
    
}

-(void)advertiseClick:(UIButton*)sender{
    
    if (self.data_A2.count!=0) {
        NSDictionary *dic = self.data_A2[sender.tag];
        if (sender.tag ==0) {
            NewShopViewController *VC = [[NewShopViewController alloc]init];
            VC.activityId =dic[@"id"];
            VC.title = dic[@"theme"];
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (sender.tag ==1) {
            AdvertiseViewController *VC = [[AdvertiseViewController alloc]init];
            VC.activityId =dic[@"id"];
            VC.title = dic[@"theme"];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (sender.tag ==2) {
           
            //            [self showHint:@"暂未开通!"];
            HolidayActivertyVC *holidayVC=[[HolidayActivertyVC alloc]init];
            holidayVC.activityId=dic[@"id"];
            holidayVC.title = dic[@"theme"];
            [self.navigationController pushViewController:holidayVC animated:YES];
            
        }


        if (sender.tag ==3) {
            
//            [self showHint:@"暂未开通!"];

            LZDCenterViewController *VC = [[LZDCenterViewController alloc]init];
       
            
            [self.navigationController pushViewController:VC animated:YES];
        }

    }
    
    NSLog(@"---广告---%ld",sender.tag);
}
#pragma mark GYChangeTextViewDelegate

- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
    HotNewsVC *vc=[[HotNewsVC alloc]init];
    vc.title = @"商消乐头条";
    vc.href=self.advertiseHeaderList[index][@"href"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _smallSV) {
        int page = scrollView.contentOffset.x/scrollView.frame.size.width;//分页
        _pc.currentPage = page;
    }
    
    
    if (scrollView ==table_View) {
        UIColor *color=NavBackGroundColor;
        CGFloat offset=scrollView.contentOffset.y;
//        NSLog(@"================%lf",offset);
        if (offset<0) {
            topView.backgroundColor = [color colorWithAlphaComponent:0];
        }else {
            CGFloat alpha=1-((100-offset)/100);
            topView.backgroundColor=[color colorWithAlphaComponent:alpha];
        }

    }
}

-(void)pcClick:(UIPageControl*)pageControl{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _smallSV.contentOffset = CGPointMake(pageControl.currentPage*SCREENWIDTH, 0);
        
    }];
    
}





#pragma mark 私有方法
-(CGSize)getSizeWithLab:(UILabel*)lable andMaxSize:(CGSize)size{
    
    CGSize SZ = [lable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lable.font} context:nil].size ;
    
    return SZ
    ;
}



#pragma mark 选则城市delegate
-(void)senderSelectCity:(NSString *)selectCity{
    self.city_district = [selectCity stringByAppendingString:@"市"];
    
    
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    appdelegate.city = self.city_district;
//    appdelegate.addressDistrite = @"";

    
    NSLog(@"senderSelectCity==%@===%@",selectCity,self.city_district);

    [self getIcons:@""];
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.tView stopAnimation];
    
    if (self.ifOpen==YES) {
        [self.areaView removeFromSuperview];
    }

}

-(void)autoAuth{
//    VCOPClient *client = [self VCOPClientInstance];
//    client.accessToken=kQIYIAppKey;
//    client.appSecret=kQIYIAppSecret;
//    NSLog(@"%@",client.accessToken);
//    __block HomeViewController* tempSelf = self;
//    [client authorizeWithSuccess:^(NSString* queryKey, id responseObjct){
//        NSLog(@"success!");
//        NSLog(@"%@",responseObjct);
//        client.accessToken=[responseObjct objectForKey:@"access_token"];
//        client.expirationDate=[responseObjct objectForKey:@"expires_in"];
//        client.refreshToken=[responseObjct objectForKey:@"refresh_token"];
//        [tempSelf storeAuthData];
//    }
//                         failure:^(NSString* queryKey, NSError* error) {
//                             NSLog(@"error.useinfo=%@",error.userInfo);
//                             //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
//                         }];
//    return;
}
- (VCOPClient *)VCOPClientInstance
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.VCOPClientInstance;
}
- (void)storeAuthData
{
//    VCOPClient *client = [self VCOPClientInstance];
//    
//    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
//                              client.accessToken, @"AccessTokenKey",
//                              client.expirationDate, @"ExpirationDateKey",
//                              client.refreshToken,@"FefreshTokenKey",
//                              nil
//                              ];
//    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"VCOPAuthData"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)resetFrame{
    
    dingwei_img.frame = CGRectMake(dingweiBtn.right, 20+(44-12)/2, 12, 12);
    searchView.frame=CGRectMake(dingwei_img.right+5, 28, SCREENWIDTH-dingwei_img.right-5-35-30, 30);

    
}




-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSDictionary *dic = self.circleAdverlist[index];
    if ([[NSString getTheNoNullStr:dic[@"num"] andRepalceStr:@""] intValue]==0) {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text =@"暂时没有数据!";
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:1.f];
        
        
        

        
        
    }else{
        TopActiveListTableVC *VC = [[TopActiveListTableVC alloc]init];
        VC.activityId = dic[@"id"];
        VC.navigationItem.title = dic[@"title"];
        [self.navigationController pushViewController:VC animated:YES];
    }
   
    
    
    
}


-(void)topActiveClick:(UITapGestureRecognizer*)tap{
   
}

//定位中...
- (void)locating {
    NSLog(@"定位中...");
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    
    NSString *city = [locationDictionary valueForKey:@"City"];
    //    if (![_resultLabel.text isEqualToString:city]) {
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            _resultLabel.text = city;
//    [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
//    [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"currentcity"];
//    [self.manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
//        printf("cityNumber===%s",[cityNumber UTF8String]);
//        [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
//    }];

    
    
    [self.manager currentCityDic:city currentCityDic:^(NSDictionary *dic) {
        
        [KCURRENTCITYINFODEFAULTS setObject:dic forKey:@"locationCityDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentEareDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentCityDic"];

        
        NSLog(@"定位成功------%@",dic);
        
        [self.manager areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            [KCURRENTCITYINFODEFAULTS setObject:areaData forKey:@"currentEreaList"];
            

            
        }];
        
    }];
    
   }




/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
    [self.manager currentCityDic:@"西安市" currentCityDic:^(NSDictionary *dic) {
        
        [KCURRENTCITYINFODEFAULTS setObject:dic forKey:@"locationCityDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentEareDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentCityDic"];
        
        
        NSLog(@"TARGET_IPHONE_SIMULATOR------%@",dic);
        
        [self.manager areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            [KCURRENTCITYINFODEFAULTS setObject:areaData forKey:@"currentEreaList"];
            
            
            
        }];
        
    }];

}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
    [self.manager currentCityDic:@"西安市" currentCityDic:^(NSDictionary *dic) {
        
        [KCURRENTCITYINFODEFAULTS setObject:dic forKey:@"locationCityDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentEareDic"];
        
        [KCURRENTCITYINFODEFAULTS removeObjectForKey:@"currentCityDic"];
        
        
        NSLog(@"TARGET_IPHONE_SIMULATOR------%@",dic);
        
        [self.manager areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            
            [KCURRENTCITYINFODEFAULTS setObject:areaData forKey:@"currentEreaList"];
            
            
            
        }];
        
    }];

}
//弹出广告点击
-(void)popImgClick{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"--popImgClick--%@",pop_data_Dic);
//    if (delegate.IsLogin) {
        [self tapCl];
        ChouJiangVC *VC = [[ChouJiangVC alloc]init];
        VC.urlString = pop_data_Dic[@"url"];
        
        if ([VC.urlString hasPrefix:@"http://"]) {
            [self.navigationController pushViewController:VC animated:YES];
            
        }
//    }else{
//        LandingController *landVC=[[LandingController alloc]init];
//        PopupAdvertiseView.hidden=YES;
//        [self.navigationController pushViewController:landVC animated:YES];
//    }
    
}
#pragma mark 懒加载
-(NSMutableArray*)adverImages{
    if (!_adverImages) {
        _adverImages = [NSMutableArray array];
    }
    return _adverImages;
}

-(NSArray *)circleAdverlist{
    if (!_circleAdverlist) {
        _circleAdverlist = [NSArray array];
    }
    return _circleAdverlist;
}
-(NSDictionary*)longAdvertise_dic{
    if (!_longAdvertise_dic) {
        _longAdvertise_dic = [NSDictionary dictionary];
    }
    return _longAdvertise_dic;
}
-(NSArray *)advertiseHeaderList{
    if (!_advertiseHeaderList) {
        _advertiseHeaderList = [NSArray array];
    }
    return _advertiseHeaderList;
}
-(NSArray*)data_A2{
    if (!_data_A2) {
        _data_A2 = [NSArray array];
    }
    return _data_A2;
}
-(NSMutableArray*)data_A3{
    if (!_data_A3) {
        _data_A3 = [NSMutableArray array];
    }
    return _data_A3;
}
-(NSArray*)areaListArray{
    if (!_areaListArray) {
        _areaListArray =[NSArray array];
    }
    return _areaListArray;
}
-(NSArray*)icon_A{
    
    if (!_icon_A) {
        _icon_A = [NSArray array];
    }
    return _icon_A;
}
-(NSMutableArray*)shopData_A{
    if (!_shopData_A) {
        _shopData_A = [NSMutableArray array];
    }
    return _shopData_A;
}
@end
