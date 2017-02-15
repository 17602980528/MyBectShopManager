//
//  FirstViewController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstLikeCell.h"
#import "ShoppingViewController.h"
#import "ShoppingViewController.h"
#import "AddressPickerDemo.h"
#import "SearchTableViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ActiveViewController.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)UIScrollView *bjsc; //背景滑动视图
@property(nonatomic,weak)UIScrollView *TopSc;//顶部分类的滑动视图
@property(nonatomic,weak)UIView *CentView;//中间推荐的视图
@property(nonatomic,weak)UIView *BtmView;//猜你喜欢
@property(nonatomic,weak)UIView *TopView;//顶部分类滑动视图第一页
@property(nonatomic,weak)UIView *fenyeView;//放分页控制器的视图
@property(nonatomic,weak)UIView *areaView;
@property(nonatomic,weak)UIImageView *fenyeImg;//分页控制器图片
@property(nonatomic,weak)UIView *ToptwoView;//顶部分类滑动视图第二页
@property(nonatomic,weak)UIView *TopthreeView;//顶部分类滑动试图第三页
@property(nonatomic,weak)UITableView *btmTab;//底部列表
@property(nonatomic,weak)UIView *searchView;
@property(nonatomic,weak)UIButton *tixingBtn;
@property(nonatomic,weak)UIButton *erweimaBtn;
@property(nonatomic,weak)UIButton *dizhiBtn;
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,strong)UIPageControl *btnPage;//点击按钮下的pageController
@property(nonatomic,weak)UIImageView *imgView;

@property(nonatomic,strong)UIImageView *animationView;

@end

@implementation FirstViewController
//顶部导航上的按钮其他页面不显示
{
    UIEdgeInsets inset;
    UIView *topView;
    CGFloat bjscOffset;
    UIRefreshControl *refreshControl;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.searchView.hidden = NO;
    self.tixingBtn.hidden = NO;
    _animationView.hidden = NO;
    self.erweimaBtn.hidden = NO;
    self.dizhiBtn.hidden = NO;
    self.ifOpen =NO;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.cityChoice = appdelegate.cityChoice;
    NSLog(@"%@",self.cityChoice);
    
    if (self.ifOpen==NO)
    {
        [self.areaView removeFromSuperview];
        [self _initItem];
    }
    if (self.ifOpen==YES) {
        [self choiceArea];
        
    }
    [self.cityBtn setTitle:self.cityChoice forState:UIControlStateNormal];
    
    [self autoAuth];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    
    [self.searchView removeFromSuperview];
    [self.tixingBtn removeFromSuperview];
    [_animationView removeFromSuperview];
    [self.erweimaBtn removeFromSuperview];
    self.searchView.hidden = YES;
    self.tixingBtn.hidden = YES;
    _animationView.hidden = YES;
    self.erweimaBtn.hidden = YES;
    [self.dizhiBtn removeFromSuperview];;
    
    if (self.ifOpen==YES) {
        [self.areaView removeFromSuperview];
    }
    [timer invalidate];
    timer=nil;
    
    
}
#pragma mark - viewDidAppear
-(void)viewDidAppear:(BOOL)animated{
    timer= [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
#pragma mark 定时器方法
- (void)onTimer
{
    //CGPoint currentOffset = guanggao.contentOffset;
    int page = guanggao.contentOffset.x/SCREENWIDTH;
    //判断是否需要改变方向
    if (page == 2)
    {
        _speed = - SCREENWIDTH;
    }
    else if (page== 0)
    {
        _speed = + SCREENWIDTH;
    }
    //在上次的基础上，加一个_speed
    [guanggao setContentOffset:CGPointMake(page*SCREENWIDTH + _speed, 0) animated:YES];
}

-(void)showIndicatorView {
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activity.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    activity.color = [UIColor grayColor];
    
    activity.hidesWhenStopped = YES;
    [activity startAnimating];
    [self.view setUserInteractionEnabled:NO]; //禁止操作
    
    [self.view addSubview:activity];
}
-(void)dismissIndicatorView{
    [activity stopAnimating];  //关闭动画
    [activity removeFromSuperview];
    [self.view setUserInteractionEnabled:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    //self.automaticallyAdjustsScrollViewInsets=NO;
    self.shopArray = [[NSMutableArray alloc]init];
    self.allClassArray = @[@"美容",@"美发",@"美甲",@"足疗按摩",@"皮革养护",@"汽车服务",@"洗衣",@"瑜伽舞蹈",@"瘦身纤体",@"宠物店",@"电影院",@"运动健身",@"零售连锁",@"餐饮食品",@"医药",@"游乐场",@"娱乐KTV",@"婚纱摄影",@"游泳馆",@"超市购物",@"甜点饮品",@"酒店",@"教育培训",@"商务会所",@"全部分类"];
    
    self.areaListArray = @[@"未央区",@"碑林区",@"新城区",@"灞桥区",@"高新区",@"雁塔区"];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.shopArray.count>0) {
        self.shopArray = [appdelegate.shopArray copy];
        [self.view reloadInputViews];
    }
    if (appdelegate.advArray2.count>0) {
        self.advArray2 = [appdelegate.advArray2 copy];
        NSLog(@"%ld",(unsigned long)self.advArray2.count);
        [self.view reloadInputViews];
    }if (appdelegate.advArray1.count>0) {
        self.advArray1 = [appdelegate.advArray1 copy];
        [self.view reloadInputViews];
    }
    
    
    [self _initBjs];
    [self _initTopsc];
    [self _initCent];
    [self _initBtm];
    [self _iniTable];
    
    
    [self postRequestAdv1];
}
-(void)_initItem
{
    
    UIButton *tixingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tixingBtn.frame = CGRectMakeNew(310, -9 , 55 , 55);
    //[tixingBtn addTarget:self action:@selector(noticeActionClick) forControlEvents:UIControlEventTouchUpInside];
    //    [tixingBtn setImage:[UIImage imageNamed:@"tixing"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:tixingBtn];
    self.tixingBtn = tixingBtn;
    
    _animationView=[[UIImageView alloc]init];
    _animationView.frame = CGRectMakeNew(310, -9 , 55 , 55);
    //_animationView.image=[UIImage imageNamed:@"未标题-1-02"];
    [self.navigationController.navigationBar addSubview:_animationView];
    _animationView.animationDuration=0.8f;
    _animationView.animationImages=@[[UIImage imageNamed:@"award_01"],[UIImage imageNamed:@"award_02" ],[UIImage imageNamed:@"award_03" ],[UIImage imageNamed:@"award_04" ],[UIImage imageNamed:@"award_05" ],[UIImage imageNamed:@"award_06" ],[UIImage imageNamed:@"award_07" ],[UIImage imageNamed:@"award_08" ],[UIImage imageNamed:@"award_09" ],[UIImage imageNamed:@"award_10" ],[UIImage imageNamed:@"award_11" ],[UIImage imageNamed:@"award_12" ],[UIImage imageNamed:@"award_13" ],[UIImage imageNamed:@"award_14" ],[UIImage imageNamed:@"award_15" ],[UIImage imageNamed:@"award_16" ],[UIImage imageNamed:@"award_17" ],[UIImage imageNamed:@"award_18" ],[UIImage imageNamed:@"award_19" ]];
    [_animationView startAnimating];
    
    UIButton *erweiMa = [UIButton buttonWithType:UIButtonTypeCustom];
    erweiMa.frame = CGRectMakeNew(SCREENWIDTH-30, 7, 25, 25);
    //    [erweiMa setImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:erweiMa];
    self.erweimaBtn = erweiMa;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    self.allDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *allCityKeys = [self.allDic allKeys];
    
    NSMutableArray *cities = [[NSMutableArray alloc]init];
    NSMutableDictionary *allCityss = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < [self.allDic count]; i++) {
        [allCityss addEntriesFromDictionary:[self.allDic objectForKey:[allCityKeys objectAtIndex:i]]];
    }

    for (int i = 0; i < [self.allDic count]; i++) {
        

        
        [cities addObject:[self.allDic objectForKey:[allCityKeys objectAtIndex:i]]];
    }
    self.areaListArray = [[NSArray alloc] initWithArray: [allCityss objectForKey: self.cityChoice]];
    for (int i=0; i<[self.areaListArray count]; i++)
    {
        //        NSLog(@"self.areaListArray%@",self.areaListArray[i]);
    }
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appdelegate.areaListArray = self.areaListArray;
    //    NSArray *citiesAll =[[NSArray alloc] initWithArray: [self.allDic objectForKey: @"北京"]];
    //    NSLog(@"dddd%@",allCityss);
  
    
    UIButton *weizhiBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    weizhiBtn.frame = CGRectMakeNew(10, 5, 90, 30);
    //weizhiBtn.backgroundColor = [UIColor yellowColor];
    self.cityBtn = weizhiBtn;
    [weizhiBtn setTitle:appdelegate.districtString forState:UIControlStateNormal];
    [weizhiBtn setImage:[UIImage imageNamed:@"首页最上面"] forState:UIControlStateNormal];
    //设置标题的偏移量
    [weizhiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    //设置图片的偏移量
    [weizhiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    [weizhiBtn addTarget:self action:@selector(weizhiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:weizhiBtn];
    self.dizhiBtn = weizhiBtn;
    
    //    UISearchBar *seach = [[UISearchBar alloc]initWithFrame:CGRectMakeNew(90, 5, 190, 30)];
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMakeNew(120, 5, 190, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 12;
    
    [self.view addSubview:searchView];
    [self.navigationController.navigationBar addSubview:searchView];
    self.searchView  = searchView;
    UIImageView *souImg = [[UIImageView alloc]initWithFrame:CGRectMakeNew(5, 5, 20, 20)];
    souImg.image = [UIImage imageNamed:@"sousuo"];
    [searchView addSubview:souImg];
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMakeNew(35, 5, 150, 20)];
    text.placeholder = @"点击搜索";
    //text.delegate = self;
    text.textAlignment = NSTextAlignmentLeft;
    text.clearButtonMode = UITextFieldViewModeWhileEditing;
    text.tintColor=[UIColor blueColor];
    //    if (iOS7) {
    //        [text setTintColor:[UIColor blueColor]];
    //    }
    
    text.font = [UIFont systemFontOfSize:13];
    
    text.delegate = self;
    [searchView addSubview:text];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //#import "SearchTableViewController.h"
    SearchTableViewController *searchView = [[SearchTableViewController alloc]init];
    [self.navigationController pushViewController:searchView animated:YES];
    return YES;
}
-(NSArray *)data
{
    if (_data == nil) {
        _data = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    }return _data;
}
//背景的滑动视图
-(void)_initBjs
{
    UIScrollView *bjsc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH , SCREENHEIGHT+25)];
    bjsc.alwaysBounceVertical = YES;
    [self.view addSubview:bjsc];
    bjsc.backgroundColor = [UIColor whiteColor];
    //    bjsc.contentSize = CGSizeMake(375, 1050);
    bjsc.contentOffset = CGPointMake(0, 0);
    //bjsc.bounces = NO;
    bjsc.pagingEnabled = NO;
    bjsc.showsVerticalScrollIndicator = NO;
    //    topView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, bjsc.bounds.size.width, 200)];
    //    [topView setBackgroundColor:[UIColor brownColor]];
    //    inset= topView.alignmentRectInsets;
    //    [bjsc addSubview:topView];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    bjsc.delegate=self;
    [bjsc addSubview:refreshControl];
    [self.view addSubview:bjsc];
    self.bjsc = bjsc;
    UISwipeGestureRecognizer *singleTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}
//点击空白收起键盘X
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    
    [self.view endEditing:YES];
    
    
}
//顶部按钮的视图
-(void)_initTopsc
{
    UIScrollView *Topsc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    if(SCREENWIDTH>400)
    {
        Topsc.frame = CGRectMake(0, 0, SCREENWIDTH, 200);
    }
    //    Topsc.backgroundColor = [UIColor orangeColor];
    [self.bjsc addSubview:Topsc];
    Topsc.contentSize = CGSizeMake(Topsc.width*3, 0);
    Topsc.contentOffset = CGPointMake(0, 0);
    Topsc.bounces = NO;
    Topsc.pagingEnabled = YES;
    Topsc.showsHorizontalScrollIndicator = NO;
    self.TopSc = Topsc;
    self.TopSc.delegate = self;
    
    
    //    第一页图标的视图
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.TopSc.width, 150)];
    if(SCREENWIDTH>400)
    {
        topView.frame = CGRectMake(0, 0, self.TopSc.width, 200);
    }
    [self.TopSc addSubview:topView];
    self.TopView = topView;
    //    第一行
    //    第一行
    NSArray *oneImg = @[@"图标-01new",@"图标-18new",@"图标-20new",@"图标-03new",@"图标-21new"];
    
    for (int i = 0; i < 5; i++) {
        UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        oneBtn.frame = CGRectMake(BUTTONOFFSET+(BUTTONOFFSET+60)*i, 15, 60,60);
        if(SCREENWIDTH>400)
        {
            oneBtn.frame = CGRectMake(BUTTONOFFSETT+(BUTTONOFFSETT+80)*i, 15, 80,80);
        }
        oneBtn.tag = i+0;
        //        oneBtn.backgroundColor = [UIColor blueColor];
        [oneBtn setBackgroundImage:[UIImage imageNamed:oneImg[i]] forState:UIControlStateNormal];
        [oneBtn addTarget:self action:@selector(TopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.TopView addSubview:oneBtn];
    }
    //    第二行
    NSArray *twoImg = @[@"图标-02new",@"图标-04new",@"图标-07new",@"图标-24new",@"图标-25new"];
    for (int i = 0; i < 5; i++) {
        UIButton *twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        twoBtn.frame = CGRectMake(BUTTONOFFSET+(BUTTONOFFSET+60)*i, 85, 60, 60);
        if(SCREENWIDTH>400)
        {
            twoBtn.frame = CGRectMake(BUTTONOFFSETT+(BUTTONOFFSETT+80)*i, 105, 80,80);
        }
        //        twoBtn.backgroundColor = [UIColor blueColor];
        twoBtn.tag = 5+i;
        [twoBtn setBackgroundImage:[UIImage imageNamed:twoImg[i]] forState:UIControlStateNormal];
        [twoBtn addTarget:self action:@selector(TopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.TopView addSubview:twoBtn];
    }
    //滑动视图第二页视图
    
    UIView *ToptwoView = [[UIView alloc]initWithFrame:CGRectMake(self.TopView.width, 0, self.TopView.width, 150)];
    if(SCREENWIDTH>400)
    {
        ToptwoView.frame = CGRectMake(self.TopView.width, 0, self.TopView.width, 200);
    }
    //    ToptwoView.backgroundColor = [UIColor blueColor];
    [self.TopSc addSubview:ToptwoView];
    self.ToptwoView = ToptwoView;
    //   第二页第一行按钮
    NSArray *threeImg = @[@"图标-14new",@"图标-23new",@"图标-08new",@"图标-06new",@"图标-15new"];
    
    for (int i = 0; i < 5; i++) {
        UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        threeBtn.frame = CGRectMake(BUTTONOFFSET+(BUTTONOFFSET+60)*i, 15, 60,60);
        if(SCREENWIDTH>400)
        {
            threeBtn.frame = CGRectMake(BUTTONOFFSETT+(BUTTONOFFSETT+80)*i, 15, 80,80);
        }
        //        twoBtn.backgroundColor = [UIColor blueColor];
        threeBtn.tag = 10+i;
        [threeBtn setBackgroundImage:[UIImage imageNamed:threeImg[i]] forState:UIControlStateNormal];
        [threeBtn addTarget:self action:@selector(TopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.ToptwoView addSubview:threeBtn];
    }
    //    第二页第二行按钮
    NSArray *fourImg = @[@"图标-12new",@"图标-05new",@"图标-11new",@"图标-13new",@"图标-19new"];
    
    for (int i = 0; i < 5; i++) {
        UIButton *fourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fourBtn.frame = CGRectMake(BUTTONOFFSET+(BUTTONOFFSET+60)*i, 85, 60, 60);
        if(SCREENWIDTH>400)
        {
            fourBtn.frame = CGRectMake(BUTTONOFFSETT+(BUTTONOFFSETT+80)*i, 105, 80, 80);
        }
        fourBtn.tag = 15 + i;
        //        fourBtn.backgroundColor = [UIColor blueColor];
        [fourBtn setBackgroundImage:[UIImage imageNamed:fourImg[i]] forState:UIControlStateNormal];
        [fourBtn addTarget:self action:@selector(TopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.ToptwoView addSubview:fourBtn];
    }
    
    //滑动视图第三页视图
    
    UIView *TopthreeView = [[UIView alloc]initWithFrame:CGRectMake(self.ToptwoView.width*2, 0, self.TopView.width, 150)];
    if(SCREENWIDTH>400)
    {
        TopthreeView.frame = CGRectMake(self.ToptwoView.width*2, 0, self.TopView.width, 200);
    }
    //    ToptwoView.backgroundColor = [UIColor blueColor];
    [self.TopSc addSubview:TopthreeView];
    self.TopthreeView = TopthreeView;
    //   第叁页第一行按钮
    //   第叁页第一行按钮
    NSArray *fiveImg = @[@"图标-22new",@"图标-10new",@"图标-09new",@"图标-17new",@"图标-16new"];
    for (int i = 0; i < 5; i++) {
        UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        threeBtn.frame = CGRectMake(BUTTONOFFSET+(BUTTONOFFSET+60)*i, 15, 60,60);
        if(SCREENWIDTH>400)
        {
            threeBtn.frame = CGRectMake(BUTTONOFFSETT+(BUTTONOFFSETT+80)*i, 15, 80,80);
        }
        //        twoBtn.backgroundColor = [UIColor blueColor];
        threeBtn.tag = 20+i;
        [threeBtn setBackgroundImage:[UIImage imageNamed:fiveImg[i]] forState:UIControlStateNormal];
        [threeBtn addTarget:self action:@selector(TopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.TopthreeView addSubview:threeBtn];
    }
    
#pragma mark -pageController
    
    //    滑动下面的分页视图
    UIView *fenyeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.TopSc.height, SCREENWIDTH, 22)];
    //    fenyeView.backgroundColor = [UIColor greenColor];
    self.fenyeView = fenyeView;
    [self.bjsc addSubview:fenyeView];
    UIImageView *fenyeImg = [[UIImageView alloc]initWithFrame:CGRectMake(fenyeView.width/2 - 15, 5, 30, 10)];
    //    fenyeImg.backgroundColor = [UIColor redColor];
    [fenyeImg setImage:[UIImage imageNamed:@"index2"]];
    self.fenyeImg = fenyeImg;
    //    [fenyeView addSubview:fenyeImg];
    //pageController;
    _btnPage = [[UIPageControl alloc]init];
    _btnPage.center = CGPointMake(self.fenyeView.size.width/2, self.fenyeView.size.height/2);
    _btnPage.bounds = CGRectMakeNew(0, 0, SCREENWIDTH, 22);
    _btnPage.currentPage = 0;//当前page
    _btnPage.numberOfPages = 3;//总共page
    // 设置未选中页的圆点颜色
    _btnPage.pageIndicatorTintColor = [UIColor grayColor];
    // 设置选中页的圆点颜色
    _btnPage.currentPageIndicatorTintColor = [UIColor redColor];
    //    _btnPage.enabled = NO;
    
    [fenyeView addSubview:_btnPage];
    
    
    
    UIView *scline = [[UIView alloc]initWithFrame:CGRectMake(0, fenyeView.height - 1 , fenyeView.width , 10)];
    scline.backgroundColor = BackColor;
    scline.alpha = 0.3;
    [fenyeView addSubview:scline];
}

//分类按钮事件

-(void)TopBtnAction:(UIButton *)btn
{
    
    //    if (btn.tag - 100 == 0) {
    //        NSLog(@"点击了第%ld个",btn.tag - 100);
    //    }
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //ShoppingViewController *shopView = [[ShoppingViewController alloc]init];
    appdelegate.menuString = @"";
    appdelegate.menuString = [self.allClassArray objectAtIndex:btn.tag];
    NSLog(@"appdelegate.menuString%@",appdelegate.menuString);
    //    self.tabBarController.selectedIndex = 1;
    NSLog(@"%ld",btn.tag);
    self.tabBarController.selectedIndex =1;
    
    
}

//中间广告的视图
-(void)_initCent
{
    UIView *CentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.TopSc.height+self.fenyeView.height+10, SCREENWIDTH,SCREENWIDTH/4+170)];
    //        CentView.backgroundColor = [UIColor yellowColor];
    self.CentView = CentView;
    
    [self.bjsc addSubview:self.CentView];
    
    //    线和箭头
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.TopSc.width, 1)];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.3;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.CentView.height-1, self.CentView.width, 1)];
    view1.backgroundColor = [UIColor grayColor];
    view1.alpha = 0.3;
    [CentView addSubview:view1];
    [CentView addSubview:view];
    //    上部广告
#pragma mark 广告
    guanggao = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CentView.width, SCREENWIDTH/4)];
    //        guanggao.backgroundColor = [UIColor redColor];
    [CentView addSubview:guanggao];
    guanggao.contentSize = CGSizeMake(CentView.width*3, guanggao.height);
    guanggao.bounces = NO;
    guanggao.pagingEnabled = YES;
    guanggao.showsHorizontalScrollIndicator = NO;
    guanggao.showsVerticalScrollIndicator = NO;
    /*
     address = "null";
     content = "7.15全场折上折";
     merchant = "m_6d4e76ca04";
     image_url = "liuxbo.png";
     latitude = "34.224576";
     longtitude = "108.884076";
     store = "金柜";
     */
    
    //广告按钮显示的图片
//    NSLog(@"self.advArray1self.advArray1%@",self.advArray1);
    for (int i = 0; i < 3; i++)
    {
        UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        oneBtn.frame = CGRectMake(guanggao
                                  .width*i, 1, guanggao.width,guanggao.height-2);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(guanggao.width*i, 1, guanggao.width,guanggao.height-2)];
        //        [oneBtn addSubview:imageView];
        if (self.advArray1.count>0) {
            

            NSString *imageString =[ADVERTIMAGE stringByAppendingString:[[self.advArray1 objectAtIndex:i] objectForKey:@"advert_url"]];

            NSLog(@"%@",imageString);
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"icon1.png"] options:SDWebImageRetryFailed];
        }
        oneBtn.tag = i;
        
        [oneBtn addTarget:self action:@selector(guanggaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [guanggao addSubview:imageView];
        [guanggao addSubview:oneBtn];
        
    }
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, guanggao.height, guanggao.width, 1)];
    view2.backgroundColor  = [UIColor grayColor];
    view2.alpha = 0.3;
    [CentView addSubview:view2];
    //颜色数组
    NSArray *colorArray = @[LabelTextColor1,LabelTextColor2,LabelTextColor3,LabelTextColor4,LabelTextColor5,LabelTextColor6,LabelTextColor7,LabelTextColor8];
    // 下部广告
    guanggao1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, guanggao.height+1, CentView.width, CentView.height-guanggao.height-2)];
    guanggao1.delegate = self;
    //        guanggao1.backgroundColor = [UIColor orangeColor];
    guanggao1.contentSize = CGSizeMake(guanggao1.width*2, guanggao1.height);
    guanggao1.bounces = NO;
    guanggao1.showsHorizontalScrollIndicator = NO;
    guanggao1.showsVerticalScrollIndicator = NO;
    guanggao1.pagingEnabled = YES;
    [CentView addSubview:guanggao1];
    //新加pagecontrol
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"index2"]];
    imageView.bounds=CGRectMake(0, 0, 53/2.5, 18/2.5);
    imageView.center=CGPointMake(guanggao1.center.x, CGRectGetMaxY(guanggao1.frame)-18/2.5);
    [CentView addSubview:imageView];
    self.imgView=imageView;
    
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
//    NSLog(@"---%@",_advArray2);
    for (int i=0; i<self.advArray2.count; i++) {
        NSString *imageStr =[SHOPIMAGE_ADDIMAGE stringByAppendingString:[[self.advArray2 objectAtIndex:i] objectForKey:@"image_url"]];

        [imageArr addObject:imageStr];
        NSLog(@"%@",imageStr);
    }
//    NSLog(@"%ld",imageArr.count);
    NSMutableArray *shopNameArr = [[NSMutableArray alloc]init];
    for (int i=0; i<self.advArray2.count; i++) {
        NSString *nameStr =[[self.advArray2 objectAtIndex:i] objectForKey:@"store"];
        [shopNameArr addObject:nameStr];
    }
    NSMutableArray *contentArr = [[NSMutableArray alloc]init];
    for (int i=0; i<self.advArray2.count; i++) {
        NSString *contentStr =[[self.advArray2 objectAtIndex:i] objectForKey:@"content"];
        [contentArr addObject:contentStr];
    }
//    NSLog(@"imageArr.count%ld",imageArr.count);
    if (self.advArray2.count<5&&self.advArray2.count>0)
    {
        guanggao1.contentSize = CGSizeMake(guanggao1.width, guanggao1.height);
        for (int i = 0; i < self.advArray2.count; i++) {
            int  yushu = i%4;
            UIButton *oneView = [[UIButton alloc]init];
            
            if (yushu<2) {
                oneView.frame = CGRectMake(guanggao1.width/2 * i, 0, guanggao1.width/2, guanggao1.height/2);
            }else{
                int j =i%2;
                oneView.frame = CGRectMake(guanggao1.width/2 * j, guanggao1.height/2, guanggao1.width/2, guanggao1.height/2);
            }
            
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(oneView.width-1, 0, 0.3, oneView.height)];
            line.backgroundColor = [UIColor redColor];
            line.alpha = 0.3;
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMakeNew(5, 7, 55 , 55)];
            imageView.layer.cornerRadius = imageView.width/2;
            imageView.layer.masksToBounds = YES;
            
            if (imageArr.count>0) {
                
                [imageView sd_setImageWithURL: [NSURL URLWithString:[imageArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
            }
            oneView.tag = i;
            [oneView addTarget:self action:@selector(secendGuanggaoAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMakeNew(85, 7, 90, 30)];
            if (shopNameArr.count>0){
                label.text = shopNameArr[i];
            }
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = colorArray[i];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:14];
            
            UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMakeNew(85, 35, 90, 30)];
            
            label1.textColor = [UIColor grayColor];
            if (shopNameArr.count>0){
                label1.text = contentArr[i];
            }
            
            label1.numberOfLines = 0;
            label1.textAlignment = NSTextAlignmentLeft;
            label1.font = [UIFont systemFontOfSize:12];
            
            [oneView addSubview:label1];
            [oneView addSubview:label];
            [oneView addSubview:imageView];
            [oneView addSubview:line];
            [guanggao1 addSubview:oneView];
            
        }
        
    }
    
    //    第二行
    else if (self.advArray2.count>4&&self.advArray2.count<9)
    {
        
        for (int i = 0; i < self.advArray2.count; i++) {
            
            if (i<4) {
                for (int i = 0; i < 4; i++) {
                    int  yushu = i%4;
                    UIButton *oneView = [[UIButton alloc]init];
                    if (yushu<2) {
                        oneView.frame = CGRectMake(guanggao1.width/2 * i, 0, guanggao1.width/2, guanggao1.height/2);
                    }else{
                        int j =i%2;
                        oneView.frame = CGRectMake(guanggao1.width/2 * j, guanggao1.height/2, guanggao1.width/2, guanggao1.height/2);
                    }
                    
                    //        oneView.backgroundColor = [UIColor redColor];
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(oneView.width-1, 0, 0.3, oneView.height)];
                    line.backgroundColor = [UIColor grayColor];
                    line.alpha = 0.3;
                    
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMakeNew(5, 7, 55 , 55)];
                    imageView.layer.cornerRadius = imageView.width/2.0;
                    imageView.clipsToBounds = YES;
                    
                    if (imageArr.count>0) {
                        
                        [imageView sd_setImageWithURL: [NSURL URLWithString:[imageArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                        
                    }
                    oneView.tag = i;
                    [oneView addTarget:self action:@selector(secendGuanggaoAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMakeNew(85, 7, 90, 30)];
                    if (shopNameArr.count>0){
                        label.text = shopNameArr[i];
                    }
                    label.textAlignment = NSTextAlignmentLeft;
                    label.numberOfLines = 0;
                    label.textColor = colorArray[i];
                    label.font = [UIFont systemFontOfSize:14];
                    
                    UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMakeNew(85, 35, 90, 30)];
                    
                    label1.textColor = [UIColor grayColor];
                    if (shopNameArr.count>0){
                        label1.text = contentArr[i];
                    }
                    
                    label1.numberOfLines = 0;
                    label1.textAlignment = NSTextAlignmentLeft;
                    label1.font = [UIFont systemFontOfSize:12];
                    
                    [oneView addSubview:label1];
                    [oneView addSubview:label];
                    [oneView addSubview:imageView];
                    [oneView addSubview:line];
                    [guanggao1 addSubview:oneView];
                    
                }
            }
            else {
                for (int i = 4; i < self.advArray2.count; i++) {
                    int  yushu = i%4;
                    UIButton *oneView = [[UIButton alloc]init];
                    if (yushu<2) {
                        oneView.frame = CGRectMake(guanggao1.width/2 * (yushu+2), 0, guanggao1.width/2, guanggao1.height/2);
                    }else{
                        int j =i%2;
                        oneView.frame = CGRectMake(guanggao1.width/2 * (j+2), guanggao1.height/2, guanggao1.width/2, guanggao1.height/2);
                    }
                    
                    //        oneView.backgroundColor = [UIColor redColor];
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(oneView.width-1, 0, 0.3, oneView.height)];
                    line.backgroundColor = [UIColor grayColor];
                    line.alpha = 0.3;
                    
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMakeNew(5, 7, 55 , 55)];
                    imageView.layer.cornerRadius = imageView.width/2;
                    
                    imageView.layer.masksToBounds = YES;
                    
                    if (imageArr.count>0) {
                        
                        [imageView sd_setImageWithURL: [NSURL URLWithString:[imageArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                        
                    }
                    oneView.tag = i;
                    [oneView addTarget:self action:@selector(secendGuanggaoAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMakeNew(85, 7, 90, 30)];
                    if (shopNameArr.count>0){
                        label.text = shopNameArr[i];
                    }
                    label.textAlignment = NSTextAlignmentLeft;
                    label.numberOfLines = 0;
                    label.textColor = colorArray[i];
                    label.font = [UIFont systemFontOfSize:14];
                    
                    UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMakeNew(85, 35, 90, 30)];
                    
                    label1.textColor = [UIColor grayColor];
                    if (shopNameArr.count>0){
                        label1.text = contentArr[i];
                    }
                    
                    label1.numberOfLines = 0;
                    label1.textAlignment = NSTextAlignmentLeft;
                    label1.font = [UIFont systemFontOfSize:12];
                    
                    [oneView addSubview:label1];
                    [oneView addSubview:label];
                    [oneView addSubview:imageView];
                    [oneView addSubview:line];
                    [guanggao1 addSubview:oneView];
                    
                }
                
            }
            
        }
    }
    
}
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
//底部的列表头
-(void)_initBtm
{
    UIView *littleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.TopSc.height + self.CentView.height +self.fenyeView.height+10, self.TopSc.width, 10)];
    littleView.backgroundColor = BackColor;
    littleView.alpha =0.3;
    [self.bjsc addSubview:littleView];
    UIView *BtmView = [[UIView alloc]initWithFrame:CGRectMake(0, self.TopSc.height + self.CentView.height +self.fenyeView.height + 20, self.TopSc.width, 30)];
    //    UIView *viewLiness = [[UIView alloc]initWithFrame:CGRectMake(0, self.TopSc.height + self.CentView.height +self.fenyeView.height + 10, self.TopSc.width, 10)];
    //    viewLiness.backgroundColor = [UIColor grayColor];
    //    viewLiness.alpha = 0.3;
    //    [BtmView addSubview:viewLiness];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.TopSc.width, 1)];
    viewLine.backgroundColor = [UIColor grayColor];
    viewLine.alpha = 0.3;
    UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, BtmView.height-1, BtmView.width, 1)];
    viewLine1.backgroundColor = [UIColor grayColor];
    viewLine1.alpha = 0.3;
    //    BtmView.backgroundColor = [UIColor greenColor];
    [BtmView addSubview:viewLine];
    //    [BtmView addSubview:viewLine1];
    [self.bjsc addSubview:BtmView];
    self.BtmView = BtmView;
    
    UILabel *likeLbel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5,55 , 20)];
    //    likeLbel.backgroundColor = [UIColor greenColor];
    likeLbel.text = @"猜你喜欢";
    likeLbel.font = [UIFont systemFontOfSize:13];
    [self.BtmView addSubview:likeLbel];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 6, 6)];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 3;
    [self.BtmView addSubview:view];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(75, 12, 6, 6)];
    view2.backgroundColor = [UIColor redColor];
    view2.layer.cornerRadius = 3;
    [self.BtmView addSubview:view2];
}


//底部列表
-(void)_iniTable
{
    NSInteger count = self.shopArray.count;
    UITableView *btmTab = [[UITableView alloc]initWithFrame:CGRectMake(0, self.TopSc.height + self.CentView.height +self.BtmView.height +self.fenyeView.height+20, self.bjsc.width, count*91) style:UITableViewStylePlain];
    btmTab.delegate = self;
    btmTab.dataSource = self;
    btmTab.rowHeight = 85;
    btmTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    btmTab.scrollEnabled = NO;
    btmTab.showsVerticalScrollIndicator = NO;
    [self.bjsc addSubview:btmTab];
    self.btmTab = btmTab;
    //    self.btmTab.scrollEnabled = NO;
    self.btmTab.bounces = NO;
    self.bjsc.contentSize = CGSizeMake(SCREENWIDTH, self.TopSc.height+self.CentView.height+self.BtmView.height+self.btmTab.height+self.fenyeView.height+110);
    
}
//点击事件
-(void)guanggaoAction:(UIButton *)btn
{
    NSMutableDictionary *shopInfoDic = [self.advArray1 objectAtIndex:btn.tag];
    //[self startSellerView:shopInfoArray];
    SellerViewController *vc= [self startSellerView:shopInfoDic];
    vc.videoID=@"";
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"%@",result);
         if (result.count>0) {
             __block FirstViewController* tempSelf = self;
             vc.videoID=result[0][@"video"];
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }else{
             __block FirstViewController* tempSelf = self;
             vc.videoID=@"";
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         __block FirstViewController* tempSelf = self;
         vc.videoID=@"";
         [tempSelf.navigationController pushViewController:vc animated:YES];
     }];
    
    //[self.navigationController pushViewController:vc animated:YES];
    NSLog(@"广告");
}
-(void)secendGuanggaoAction:(UIButton *)view
{
    NSMutableDictionary *shopInfoDic = [self.advArray2 objectAtIndex:view.tag];
    
    //[self startSellerView:shopInfoArray];
    SellerViewController *vc= [self startSellerView:shopInfoDic];
    vc.videoID=@"";
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"%@",result);
         if (result.count>0) {
             __block FirstViewController* tempSelf = self;
             vc.videoID=result[0][@"video"];
             
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }else{
             __block FirstViewController* tempSelf = self;
             vc.videoID=@"";
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         __block FirstViewController* tempSelf = self;
         vc.videoID=@"";
         [tempSelf.navigationController pushViewController:vc animated:YES];
     }];
    
    //[self.navigationController pushViewController:vc animated:YES];
    NSLog(@"广告");
}

-(void)LookAllaction
{
    NSLog(@"查看全部");
}
-(void)weizhiBtnAction:(UIButton *)btn
{
    btn.selected =! btn.selected;
    self.ifOpen = !self.ifOpen;
    if (btn.selected==NO) {
        [self.areaView removeFromSuperview];
    }else
        [self choiceArea];
    //    加动画旋转
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform;
    if (btn.selected) {
        transform = CGAffineTransformRotate(btn.imageView.transform, M_PI);
    } else {
        transform = CGAffineTransformRotate(btn.imageView.transform, -270*M_PI/90);
    }
    
    btn.imageView.transform = transform;
    
    [UIView commitAnimations];
    
}
-(void)choiceArea
{
    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/2)];
    self.areaView = newView;
    newView.backgroundColor = [UIColor lightGrayColor];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
    NSInteger count = [self.areaListArray count];
    NSInteger height = 0;
    //    if (count%3==0) {
    //        height =  35*(count/3)+10*(count/3);
    //    }
    //    else
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
    
    //        [self.collectionView set:<#(CGFloat)#>:<#(UIView *)#>];
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
    UILabel *labelCity = [[UILabel alloc]initWithFrame:CGRectMake(70,0,40,30)];
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
    //    choseBtn.backgroundColor = [UIColor redColor];
    [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
    [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
    
    //    self.boyBtn = boyBtn;
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
    //    UICollectionViewCell *cell=[[UICollectionViewCell alloc] init];
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
    NSLog(@"cccc%ld",(unsigned long)[self.areaListArray count]);
    NSString *item = [self.areaListArray objectAtIndex:(long)indexPath.row];
    NSArray *areaArr = [self.areaListArray objectAtIndex:0];
    NSLog(@"areaArr = %@",areaArr);
    NSLog(@"areaListArray = %@",self.areaListArray);
    //[NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hour,(long)minute,(long)second];
    label.text = item;
    label.textAlignment = NSTextAlignmentCenter;
    NSLog(@"indexPath.item1 = %@",label.text);
    
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
    [self.dizhiBtn setTitle:appdelegate.districtString forState:UIControlStateNormal];
    self.dizhiBtn.selected =! self.dizhiBtn.selected;
    self.ifOpen = !self.ifOpen;
    [self.areaView removeFromSuperview];
    
    //[self _initItem];
}

//猜你喜欢的列表的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.shopArray.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    // 定义唯一标识
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, SCREENWIDTH/3, 80)];
    [cell addSubview:shopImageView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+SCREENWIDTH/3, 6, SCREENWIDTH/3, 30)];
    nameLabel.numberOfLines = 0;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.tag = 1000;
    [cell addSubview:nameLabel];
    UILabel *descripLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+SCREENWIDTH/3, 45, SCREENWIDTH/2, 40)];
    descripLabel.numberOfLines = 0;
    descripLabel.backgroundColor = [UIColor clearColor];
    descripLabel.textAlignment = NSTextAlignmentLeft;
    descripLabel.font = [UIFont systemFontOfSize:12];
    descripLabel.tag = 1000;
    [cell addSubview:descripLabel];
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+(SCREENWIDTH/3)*2, 6, SCREENWIDTH/4, 30)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.tag = 1000;
    [cell addSubview:distanceLabel];
    
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    [cell addSubview:line];
    
    nameLabel.text =[[self.shopArray objectAtIndex:indexPath.row] objectForKey:@"store"];
    descripLabel.text =[[self.shopArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    CLLocationCoordinate2D c1 = (CLLocationCoordinate2D){[[[self.shopArray objectAtIndex:indexPath.row] objectForKey:@"latitude"] doubleValue], [[[self.shopArray objectAtIndex:indexPath.row] objectForKey:@"longtitude"] doubleValue]};
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    CLLocationCoordinate2D c2 = appdelegate.userLocation.location.coordinate;
    BMKMapPoint a=BMKMapPointForCoordinate(c1);
    BMKMapPoint b=BMKMapPointForCoordinate(c2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(a,b);

    
    int meter = (int)distance;
    if (meter>1000) {
        distanceLabel.text = [[NSString alloc]initWithFormat:@"%.1fkm",meter/1000.0];
    }else
        distanceLabel.text = [[NSString alloc]initWithFormat:@"%dm",meter];
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[[self.shopArray objectAtIndex:indexPath.row] objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.TopSc.width, 1)];
    viewLine.backgroundColor = [UIColor grayColor];
    viewLine.alpha = 0.3;
    [cell addSubview:viewLine];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 进入下层入口
    NSLog(@"%@",self.shopArray);
    NSMutableDictionary *shopInfoDic = [self.shopArray objectAtIndex:indexPath.row];
    
    SellerViewController *vc= [self startSellerView:shopInfoDic];
    vc.videoID=@"";
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/videoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取商家手机号
    
    [params setObject:shopInfoDic[@"muid"] forKey:@"merchant"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"%@",result);
         if (result.count>0) {
             __block FirstViewController* tempSelf = self;
             vc.videoID=result[0][@"video"];
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }else{
             __block FirstViewController* tempSelf = self;
             vc.videoID=@"";
             [tempSelf.navigationController pushViewController:vc animated:YES];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         __block FirstViewController* tempSelf = self;
         vc.videoID=@"";
         [tempSelf.navigationController pushViewController:vc animated:YES];
     }];
    
    
}
-(SellerViewController *)startSellerView:(NSMutableDictionary*)dic{
    
    SellerViewController *controller = [[SellerViewController alloc]init];
    
    controller.infoDic = dic;

    controller.title = @"商铺信息";
//    NSLog(@"navigationController%@",self.navigationController);
    
    return controller;
    
}

//顶部分类滑动视图的代理方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView==self.bjsc) {
        //        bjscOffset = self.bjsc.contentOffset.y;
//        NSLog(@"便宜量%f",bjscOffset);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView!=guanggao1) {
        int page = scrollView.contentOffset.x/scrollView.frame.size.width;//分页
        _btnPage.currentPage = page;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.bjsc) {
//        NSLog(@"便宜量%f",bjscOffset);
        if (bjscOffset>SCREENHEIGHT+200||bjscOffset<-100) {
            [self testRefresh:refreshControl];
        }
        
    }
    if (scrollView==guanggao1) {
        if (guanggao1.contentOffset.x==SCREENWIDTH) {
            self.imgView.image=[UIImage imageNamed:@"index1"];
        }else{
            self.imgView.image=[UIImage imageNamed:@"index2"];
        }
    }
}

-(void)testRefresh:(UIRefreshControl *)control{
    NSLog(@"可以执行刷新的逻辑");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            //self.bjsc.contentInset = inset;
            //[self.bjsc setContentOffset:CGPointMake(0, 0) animated:NO];
        } completion:^(BOOL finished) {
            //执行
            [self postRequestAdv1];
            //inset=topView.alignmentRectInsets;
        }];
    });
    //    self.bjsc.contentSize =CGSizeMake(SCREENWIDTH, self.TopSc.height+self.CentView.height+self.BtmView.height+self.btmTab.height+110);
    
}
-(void)postRequestAdv3
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/AdvertLay3/get",BASEURL];
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
//         NSLog(@"%@",result);
         /*
          address = "陕西省西安市雁塔区电子五路金泰假日花成46号楼10103商铺";
          content = "陕西省西安市雁塔区电子五路金泰假日花成46号楼10103商铺";
          muid = "m_6d4e76ca12";
          phone = "18700923119";
          image_url = "九郡弘商贸璟泰烟酒茶商行.png";
          latitude = "34.203058";
          longtitude = "108.904779";
          store = "璟泰烟酒茶商行";
          */
         [refreshControl endRefreshing];
         self.shopArray = [result copy];
//         NSLog(@"self.shopArray33%@", self.shopArray);
         [self.CentView removeFromSuperview];
         [self _initCent];
         
         NSInteger count = self.shopArray.count;
         
         CGRect oldframe = self.btmTab.frame;
         oldframe.size.height =count*91;
         self.btmTab.frame = oldframe;
         self.bjsc.contentSize = CGSizeMake(0, self.btmTab.bottom+110);
         [_btmTab reloadData];
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         [refreshControl endRefreshing];
         
         NSLog(@"%@", error);
     }];
    
}
-(void)postRequestAdv2
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/AdvertLay2/get",BASEURL];
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
//         NSLog(@"%@",result);
         self.advArray2 = [result copy];
//         NSLog(@"self.advArray2%@", self.advArray2);
         [self postRequestAdv3];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
-(void)postRequestAdv1
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/AdvertLay1/get",BASEURL];
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
//         NSLog(@"%@",result);
         self.advArray1 = [result copy];
//         NSLog(@"self.advArray1%@", self.advArray1);
         [self postRequestAdv2];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}


//一元夺宝
-(void)noticeActionClick{
    ActiveViewController *activeVC=[[ActiveViewController alloc]init];
    [self.navigationController pushViewController:activeVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)autoAuth{
    VCOPClient *client = [self VCOPClientInstance];
    client.accessToken=kQIYIAppKey;
    client.appSecret=kQIYIAppSecret;
    NSLog(@"%@",client.accessToken);
    __block FirstViewController* tempSelf = self;
    [client authorizeWithSuccess:^(NSString* queryKey, id responseObjct){
        NSLog(@"success!");
        NSLog(@"%@",responseObjct);
        client.accessToken=[responseObjct objectForKey:@"access_token"];
        client.expirationDate=[responseObjct objectForKey:@"expires_in"];
        client.refreshToken=[responseObjct objectForKey:@"refresh_token"];
        [tempSelf storeAuthData];
    }
                         failure:^(NSString* queryKey, NSError* error) {
                             NSLog(@"error.useinfo=%@",error.userInfo);
                             //[tempSelf alertViewShow:[tempSelf getAccessTokenInfo:client] andError:error];
                         }];
    return;
}
- (VCOPClient *)VCOPClientInstance
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.VCOPClientInstance;
}
- (void)storeAuthData
{
    VCOPClient *client = [self VCOPClientInstance];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              client.accessToken, @"AccessTokenKey",
                              client.expirationDate, @"ExpirationDateKey",
                              client.refreshToken,@"FefreshTokenKey",
                              nil
                              ];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"VCOPAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
