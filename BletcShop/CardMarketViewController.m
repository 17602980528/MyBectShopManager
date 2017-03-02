//
//  CardMarketViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/1/16.
//  Copyright © 2017年 bletc. All rights reserved.
//


#import "CardMarketViewController.h"
#import "AddressPickerDemo.h"
#import "CardmarketDetailVC.h"

#import "CardMarketCell.h"
#import "CardMarketModel.h"

#import "CardMarketSearchVC.h"

#import "JFCityViewController.h"
#import "BaseNavigationController.h"


@interface CardMarketViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SelectCityDelegate>

{
    UIImageView *dingwei_img;
    UIView*searchView;
    UIButton *dingweiBtn;
    UITextField*search_tf; // placeholder
    UIView *topView;
    
    UIButton *oldBtn;
    
    UITableView *table_View;
    UIView *move_line;
    SDRefreshFooterView *_refreshFooter;
    SDRefreshHeaderView *_refreshheader;
    int currentIndex1;//请求页码
    
    
}
@property(nonatomic,copy)NSString *cityChoice;//选择的地点
@property (nonatomic,assign)BOOL ifOpen;
@property(nonatomic,strong)UIView *areaView;

@property(nonatomic,copy) NSString *city_district;//市区
@property(nonatomic,strong)NSArray *areaListArray;
@property (nonatomic,strong)UICollectionView *collectionView;



@end

@implementation CardMarketViewController


-(NSMutableArray *)data_A{
    if (!_data_A) {
        _data_A = [NSMutableArray array];
    }
    return _data_A;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= YES;
    
    [self initTopView];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden= NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(240, 240, 240);
    
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.city_district = [appdelegate.city stringByAppendingString:appdelegate.addressDistrite];
    
    
    self.cityChoice = appdelegate.cityChoice;
    
    
    
    NSLog(@"viewDidLoad===%@",self.city_district);
    if (!self.city_district) {
        self.city_district = @"西安市雁塔区";
    }
    
    
    [self initTableView];
    
    
    
}


//创建顶部导航
-(void)initTopView{
    
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
    topView.backgroundColor = NavBackGroundColor;
    [self.view addSubview:topView];
    
    
    
    
    
    
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
    searchView.frame=CGRectMake(dingwei_img.right+5, 28, SCREENWIDTH-dingwei_img.right-5-30, 30);
    searchView.backgroundColor=RGB(249, 249, 249);
    searchView.layer.cornerRadius=3;
    [topView addSubview:searchView];
    
    
    UIImageView *search1= [[UIImageView alloc]initWithFrame:CGRectMake(11, 17/2, 13, 13)];
    search1.image = [UIImage imageNamed:@"sousuo"];
    [searchView addSubview:search1];
    
    
    search_tf=[[UITextField alloc]initWithFrame:CGRectMake(search1.right+10, 7, SCREENWIDTH-120, 20)];
    search_tf.placeholder=@"请输入您要找的关键字";
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
    
    
    //    for (int i =0; i<1; i ++) {
    //
    //
    //        UIButton *minePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        minePageBtn.tag = i;
    //        minePageBtn.frame = CGRectMake(CGRectGetMaxX(searchView.frame)+i*35, CGRectGetMinY(searchView.frame), 35, 35);
    //        [minePageBtn addTarget:self action:@selector(goMineCenter:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        [topView addSubview:minePageBtn];
    //
    //        UIImageView *img_mine = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 7.5, 20, 20)];
    ////        img_mine.image = [UIImage imageNamed:@"扫描二维码"];
    //        [minePageBtn addSubview:img_mine];
    ////        if (i==1) {
    //            img_mine.frame =CGRectMake(2.5, 5.5, 24, 24);
    //            img_mine.image = [UIImage imageNamed:@"home_adress_choose_n"];
    //
    //
    ////        }
    //
    //
    //    }
    
    self.cityChoice = appdelegate.cityChoice;
    self.city_district = [NSString stringWithFormat:@"%@%@",appdelegate.cityChoice,[appdelegate.districtString isEqualToString:appdelegate.cityChoice] ? @"":appdelegate.districtString];
    
    [self getDataWithMore:@""];
    
    
    
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
    
    
    
    self.city_district = [NSString stringWithFormat:@"%@%@",appdelegate.cityChoice,appdelegate.districtString];
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
    
    
    [self getDataWithMore:@""];
    
}

-(void)initTableView{
    
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10, SCREENWIDTH, 42)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];
    NSArray *arr = @[@"二手卡",@"蹭卡"];
    
    
    for (int i = 0; i < arr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*SCREENWIDTH*0.5, 0, SCREENWIDTH*0.5, selectView.height);
        [button setTitle:arr[i] forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button setTitleColor:RGB(51, 51, 51) forState:0];
        [selectView addSubview:button];
        
        if (i == 0) {
            oldBtn = button;
            move_line = [[UIView alloc]init];
            move_line.bounds = CGRectMake(0, 0, 51, 1);
            move_line.center = CGPointMake(button.center.x, button.bottom-1);
            move_line.backgroundColor = RGB(17,141,240);
            [selectView addSubview:move_line];
        }
        
        
    }
    
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, selectView.bottom+1, SCREENWIDTH, SCREENHEIGHT-(selectView.bottom+1)-self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    
    //    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, selectView.bottom+1, SCREENWIDTH, 180) style:UITableViewStyleGrouped];
    
    table_View.dataSource = self;
    table_View.delegate = self;
    table_View.separatorStyle= UITableViewCellSeparatorStyleNone;
    table_View.estimatedRowHeight = 92;
    
    [self.view addSubview: table_View];
    
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:table_View];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block CardMarketViewController *blockSelf = self;
    _refreshheader.beginRefreshingOperation = ^{
        
        [blockSelf getDataWithMore:@""];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:table_View];
    
    _refreshFooter.beginRefreshingOperation =^{
        [blockSelf getDataWithMore:@"more"];
        
    };
    
    
    
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_A.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellH = 0.1;
    
    if (self.data_A.count!=0) {
        CardMarketModel *m = self.data_A[indexPath.row];
        cellH = m.cellHight;
    }
    return cellH;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardMarketCell *cell = [CardMarketCell creatCellWithTableView:tableView];
    
    if (self.data_A.count !=0) {
        cell.model = self.data_A[indexPath.row];
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_refreshFooter endRefreshing];
    [_refreshheader endRefreshing];
    
    CardmarketDetailVC *VC = [[CardmarketDetailVC alloc]init];
    
    VC.model = self.data_A[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
}
//搜索
-(void)searchViewClick{
    NSLog(@"搜索");
    CardMarketSearchVC *VC = [[CardMarketSearchVC alloc]init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)goMineCenter:(UIButton*)sender{
    NSLog(@"闹铃");
    if (sender.tag==0) {
        //        ScanViewController *VC = [[ScanViewController alloc]init];
        //        [self.navigationController pushViewController:VC animated:YES];
        
    }else{
        
        [self showHint:@"暂未开放!"];
        
        
        //        NewMessageVC *VC = [[NewMessageVC alloc]init];
        //        [self.navigationController pushViewController:VC animated:YES];
    }
}
//定位
-(void)dingweiClick:(UIButton*)btn{
    NSLog(@"定位");
    
    //    {
    //        btn.selected =! btn.selected;
    //        self.ifOpen = !self.ifOpen;
    //        if (btn.selected==NO) {
    //            [self.areaView removeFromSuperview];
    //        }else
    //            [self choiceArea];
    //        //    加动画旋转
    //        [UIView beginAnimations:nil context:nil];
    //        [UIView setAnimationDuration:0.3];
    //        CGAffineTransform transform;
    //        if (btn.selected) {
    //            transform = CGAffineTransformRotate(dingwei_img.transform, M_PI);
    //        } else {
    //            transform = CGAffineTransformRotate(dingwei_img.transform, -270*M_PI/90);
    //        }
    //
    //        dingwei_img.transform = transform;
    //
    //        [UIView commitAnimations];
    //
    //    }
    
    
    
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    
    cityViewController.title = @"城市";
    __block typeof(self) weakSelf = self;
    [cityViewController choseCityBlock:^(NSString *cityName,NSString *eareName){
        
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.cityChoice= cityName;
        appdelegate.districtString = eareName.length>0 ? eareName:cityName;
        
        NSLog(@"-----%@====%@\\\\",cityName,eareName);
        
        
        [dingweiBtn setTitle:eareName.length>0 ? eareName:cityName forState:UIControlStateNormal];
        
        
        weakSelf.city_district = [NSString stringWithFormat:@"%@%@",cityName,eareName];
        
        [weakSelf resetFrame];
        
        
        //        [self getDataWithMore:@""];
        
        
        
        
    }];
    BaseNavigationController *navigationController = [[BaseNavigationController alloc]initWithRootViewController:cityViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
}
#pragma mark 选则城市delegate
-(void)senderSelectCity:(NSString *)selectCity{
    self.city_district = [selectCity stringByAppendingString:@"市"];
    
    
    
    NSLog(@"senderSelectCity==%@===%@",selectCity,self.city_district);
    [self getDataWithMore:@""];
    
}
-(void)buttonClick:(UIButton*)sender{
    if (oldBtn !=sender) {
        oldBtn = sender;
        
        [UIView animateWithDuration:0.3 animations:^{
            move_line.center = CGPointMake(sender.center.x, sender.bottom-1);
            
        }];
        
        [self getDataWithMore:@""];
        
    }
    
    
}

-(void)resetFrame{
    
    CGFloat ww = [dingweiBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:dingweiBtn.titleLabel.font} context:nil].size.width;
    
    
    
    
    NSLog(@"--------------%f",ww);
    
    CGRect btn_frame = dingweiBtn.frame;
    btn_frame.size.width =  ww<43 ? 43:58;
    dingweiBtn.frame = btn_frame;
    
    
    dingwei_img.frame = CGRectMake(dingweiBtn.right, 20+(44-12)/2, 12, 12);
    searchView.frame=CGRectMake(dingwei_img.right+5, 28, SCREENWIDTH-dingwei_img.right-5-30, 30);
    
    
}



-(void)getDataWithMore:(NSString *)more{
    
    
    NSLog(@"oldBtn.tag---%ld",oldBtn.tag);
    NSString *url = [NSString stringWithFormat:@"%@UserType/CardMarket/get",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.city_district forKey:@"address"];
    
    switch (oldBtn.tag) {
        case 0:
            [paramer setValue:@"transfer" forKey:@"method"];
            
            break;
        case 1:
            [paramer setValue:@"share" forKey:@"method"];
            
            break;
            
            
        default:
            break;
    }
    
    [paramer setValue:self.city_district forKey:@"address"];
    
    
    if ([more isEqualToString:@"more"]) {
        [paramer setValue:[NSString stringWithFormat:@"%d",++currentIndex1] forKey:@"page"];
        
    }else{
        
        [self.data_A removeAllObjects];
        
        currentIndex1 = 1;
        [paramer setValue:@"1" forKey:@"page"];
        
    }
    
    
    NSLog(@"CardMarket===%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        NSLog(@"CardMarket===%@",result);
        
        NSArray *arr = (NSArray *)result;
        
        for (int i = 0; i <arr.count; i ++) {
            
            CardMarketModel *M = [[CardMarketModel alloc]intiWithDictionary:arr[i]];
            [self.data_A addObject:M];
        }
        
        
        
        
        
        [table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_refreshheader endRefreshing];
        [_refreshFooter endRefreshing];
        
    }];
    
}




@end
