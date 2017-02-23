//
//  PointConvertViewController.m
//  BletcShop
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "PointConvertViewController.h"
#import "THProgressView.h"
#import "LandingController.h"
#import "UIImageView+WebCache.h"
#import "GetDiscountCouponVC.h"
@interface PointConvertViewController ()<UIScrollViewDelegate>

@end

@implementation PointConvertViewController
{
    NSTimer* _timer;
    
    NSArray* _adverImages;
    
    UIScrollView* _scrollView;
    
    //当前展示的页码。
    NSInteger _pageIndex;
    
    UILabel *convertLabel;
    UIImageView *headImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"积分商城";
    //图像
    headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 10, 44, 44)];
    headImageView.image=[UIImage imageNamed:@"3.1-02"];
    headImageView.layer.cornerRadius=22.0f;
    headImageView.clipsToBounds=YES;
    headImageView.userInteractionEnabled=YES;
    [self.view addSubview:headImageView];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLandingOrNot)];
    [headImageView addGestureRecognizer:tapGesture];
    //积分
    convertLabel=[[UILabel alloc]initWithFrame:CGRectMake(76, 20, 120, 13)];
    convertLabel.textAlignment=NSTextAlignmentLeft;
    convertLabel.font=[UIFont systemFontOfSize:16.0f];
    convertLabel.textColor=NavBackGroundColor;//RGB(66, 170, 250);
    convertLabel.text=@"0积分";
    [self.view addSubview:convertLabel];
    //累计签到天数
    UILabel *dayCountLable=[[UILabel alloc]initWithFrame:CGRectMake(76, 40, 120, 13)];
    dayCountLable.font=[UIFont systemFontOfSize:13.0f];
    dayCountLable.textAlignment=NSTextAlignmentLeft;
    dayCountLable.textColor=[UIColor grayColor];
    dayCountLable.text=@"已累计签到2天";
    [self.view addSubview:dayCountLable];
    //签到按钮
    UIButton *signBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame=CGRectMake(SCREENWIDTH-128, 15, 120, 30);
    signBtn.backgroundColor=NavBackGroundColor;//RGB(66, 170, 250);
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    signBtn.layer.cornerRadius=15;
    signBtn.clipsToBounds=YES;
    [self.view addSubview:signBtn];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 63, SCREENWIDTH, 1)];
    lineView.backgroundColor=RGB(234, 234, 234);
    [self.view addSubview:lineView];
    
    UIImageView *ConvertImageView=[[UIImageView alloc]initWithFrame:CGRectMake(58-8, 118-44-8, 30, 30)];
    ConvertImageView.image=[UIImage imageNamed:@"vip_exchangel_n"];
    
    [self.view addSubview:ConvertImageView];
    
    UILabel *detailConvert=[[UILabel alloc]initWithFrame:CGRectMake(85, 118-44, SCREENWIDTH/2-85, 13)];
    detailConvert.font=[UIFont systemFontOfSize:13.0f];
    detailConvert.textColor=[UIColor grayColor];
    detailConvert.textAlignment=NSTextAlignmentLeft;
    detailConvert.text=@"积分明细";
    [self.view addSubview:detailConvert];
    
    UIImageView *recordImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+50, 118-44-8, 30, 30)];
    recordImageView.image=[UIImage imageNamed:@"vip_integral_n"];
    [self.view addSubview:recordImageView];
    
    UILabel *recordConvert=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+50+35, 118-44, SCREENWIDTH-SCREENWIDTH/2-85, 13)];
    recordConvert.font=[UIFont systemFontOfSize:13.0f];
    recordConvert.textColor=[UIColor grayColor];
    recordConvert.textAlignment=NSTextAlignmentLeft;
    recordConvert.text=@"兑换记录";
    [self.view addSubview:recordConvert];
    
    UIView *slipBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 191-94, SCREENWIDTH, 94)];
    slipBackView.backgroundColor=RGB(240, 240, 240);
    [self.view addSubview:slipBackView];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 9, SCREENWIDTH, 76)];
    
    _adverImages = @[[UIImage imageNamed:@"points.jpg"], [UIImage imageNamed:@"coupon.jpeg"], [UIImage imageNamed:@"points2.jpg"]];
    
    //只创建 3 张图片。
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *adversImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH * i, 0, self.view.frame.size.width, 76)];
        adversImageView.tag=i+1;
        adversImageView.userInteractionEnabled=YES;
        [scrollView addSubview:adversImageView];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getDiskCountCoupon)];
        [adversImageView addGestureRecognizer:tap];
        
    }
    
    scrollView.pagingEnabled = YES;
    
    scrollView.contentSize = CGSizeMake(SCREENWIDTH * 3, 76);
    
    scrollView.bounces = NO;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.delegate = self;
    
    //显示中间这张图片。
    scrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    
    [self setContentInScrollView:scrollView];
    
    [slipBackView addSubview:scrollView];
    _scrollView = scrollView;
    
    UILabel *memberLabel=[[UILabel alloc]initWithFrame:CGRectMake(23, 191+11, SCREENWIDTH-23, 15)];
    memberLabel.font=[UIFont systemFontOfSize:15.0f];
    memberLabel.text=@"会员兑换专区";
    memberLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:memberLabel];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 191+36, SCREENWIDTH, 1)];
    lineView2.backgroundColor=RGB(234, 234, 234);
    [self.view addSubview:lineView2];
    
    UIScrollView *goodsScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 191+36+1, SCREENWIDTH, SCREENHEIGHT-191-37-64)];
    goodsScrollView.contentSize=CGSizeMake(0, SCREENWIDTH*5/2);
    [self.view addSubview:goodsScrollView];
    
    UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, -80, SCREENWIDTH, 20)];
    noticeLabel.textAlignment=1;
    noticeLabel.textColor=[UIColor grayColor];
    noticeLabel.text=@"没有更多内容了";
    [goodsScrollView addSubview:noticeLabel];
    
    UILabel *bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*5/2+40, SCREENWIDTH, 20)];
    bottomLabel.textAlignment=1;
    bottomLabel.textColor=[UIColor grayColor];
    bottomLabel.text=@"我是有底线的";
    [goodsScrollView addSubview:bottomLabel];
    NSArray*_imageNameArray=@[@"tempProducts_01.jpeg",@"tempProducts_02.jpg",@"tempProducts_03.jpg",@"tempProducts_04.jpg",@"tempProducts_05.jpg",@"tempProducts_06.jpg",@"tempProducts_07.jpg",@"tempProducts_08.png",@"tempProducts_09.jpg"];
    NSArray *productNameArray=@[@"爱国者Mini移动电源",@"懒人手机支架",@"时尚拉杆箱",@"日本印象保温杯",@"陶瓷水具七件套",@"荣事达加湿器",@"罗马假日四件套",@"R9s杨幂定制版",@"小米平衡车"];
    for (int i=0; i<9; i++) {
        UIView *rewardView=[[UIView alloc]initWithFrame:CGRectMake(i%2*SCREENWIDTH/2, i/2*(SCREENWIDTH/2), SCREENWIDTH/2, SCREENWIDTH/2)];
        
        rewardView.layer.borderWidth=0.3;
        rewardView.layer.borderColor=[RGB(234, 234, 234)CGColor];
        [goodsScrollView addSubview:rewardView];
        
        UIImageView *rewardImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4-40, 10, 80, 80)];
        rewardImageView.image=[UIImage imageNamed:_imageNameArray[i]];
        [rewardView addSubview:rewardImageView];
        
        UILabel *rewardNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 99, SCREENWIDTH/2, 13)];
        rewardNameLabel.textAlignment=NSTextAlignmentCenter;
        rewardNameLabel.font=[UIFont systemFontOfSize:13.0f];
        rewardNameLabel.text=productNameArray[i];
        [rewardView addSubview:rewardNameLabel];
        
        UIView *progressBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH/2, 10)];
        [rewardView addSubview:progressBackView];
        
        THProgressView *ProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(42,122,70,5)];
        ProgressView.borderTintColor =[UIColor grayColor];
        ProgressView.progressTintColor = [UIColor redColor];
        ProgressView.progress= 0.53;
        [rewardView addSubview:ProgressView];
        
        UILabel *overLabel=[[UILabel alloc]initWithFrame:CGRectMake(118, 120, SCREENWIDTH/2-118, 10)];
        overLabel.textAlignment=NSTextAlignmentLeft;
        overLabel.font=[UIFont systemFontOfSize:10.0f];
        overLabel.text=@"剩余47%";
        overLabel.textColor=[UIColor grayColor];
        [rewardView addSubview:overLabel];
        
        UIImageView *moneyImage=[[UIImageView alloc]initWithFrame:CGRectMake(44, 135, 15, 15)];
        moneyImage.image=[UIImage imageNamed:@"s_money_n"];
        [rewardView addSubview:moneyImage];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 135, SCREENWIDTH/2-65, 15)];
        priceLabel.textAlignment=NSTextAlignmentLeft;
        priceLabel.font=[UIFont systemFontOfSize:13.0f];
        priceLabel.text=@"2500";
        [rewardView addSubview:priceLabel];
        priceLabel.textColor=RGB(226, 47, 50);
        
    }
}
- (void)setContentInScrollView:(UIScrollView* )scrollView {
    UIImageView * view = [scrollView viewWithTag:1];
    view.image = _adverImages[_pageIndex - 1 < 0 ? _adverImages.count - 1 : _pageIndex - 1];
    
    view = [scrollView viewWithTag:2];
    view.image = _adverImages[_pageIndex];
    
    view = [scrollView viewWithTag:3];
    view.image = _adverImages[_pageIndex + 1 == _adverImages.count ? 0 : _pageIndex + 1];
}
//timer 要在 viewDidAppear 中创建，viewDidDisappear 中销毁。
- (void)viewDidAppear:(BOOL)animated {
    
    _timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(autoScroll:) userInfo:_scrollView repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    //timer 必须在 viewDidDisappear 进行销毁，才能正确的释放 self。
    [_timer invalidate];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        
        if (scrollView.contentOffset.x == self.view.frame.size.width * 2) {
            
            scrollView.contentOffset = CGPointMake(self.view.frame.size.width * 1, 0);
            
            _pageIndex++;
            
            if (_pageIndex == _adverImages.count) {
                _pageIndex = 0;
            }
            
            [self setContentInScrollView:scrollView];
        }else if (scrollView.contentOffset.x == 0) {
            
            scrollView.contentOffset = CGPointMake(self.view.frame.size.width * 1, 0);
            
            _pageIndex--;
            
            if (_pageIndex == -1) {
                _pageIndex = _adverImages.count - 1;
            }
            
            [self setContentInScrollView:scrollView];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        
        if (scrollView.contentOffset.x == self.view.frame.size.width * 2) {
            
            scrollView.contentOffset = CGPointMake(self.view.frame.size.width * 1, 0);
            
            _pageIndex++;
            
            if (_pageIndex == _adverImages.count) {
                _pageIndex = 0;
            }
            
            [self setContentInScrollView:scrollView];
        }else if (scrollView.contentOffset.x == 0) {
            
            scrollView.contentOffset = CGPointMake(self.view.frame.size.width * 1, 0);
            
            _pageIndex--;
            
            if (_pageIndex == -1) {
                _pageIndex = _adverImages.count - 1;
            }
            
            [self setContentInScrollView:scrollView];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    //开始拖动 scrollView。
    
    //设置启动时间为很久后的一个时间，永远也到不了的时间。
    
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        
        _timer.fireDate = [NSDate distantFuture];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //结束拖动 scrollView。
    
    //取消暂停。
    
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        
        _timer.fireDate = [NSDate distantPast];
    }
}

#pragma mark - action

- (void)autoScroll:(NSTimer* )timer {
    
    if (_scrollView.contentOffset.x>=SCREENWIDTH) {
        [timer.userInfo setContentOffset:CGPointMake(self.view.frame.size.width * 2, 0) animated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //根据是否登录去请求积分等数据
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.IsLogin)
    {
        //请求积分等
        NSLog(@"%@",delegate.userInfoDic);
        [self postRequestPointWithString:delegate.userInfoDic[@"uuid"] WithKind:@"integral"];
        NSURL * nurl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,[delegate.userInfoDic objectForKey:@"headimage"]]];
        
        [headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"3.1-02.png"] options:SDWebImageRetryFailed];
        
    }else{
        //去登录页
        
    }
    
}
-(void)postRequestPointWithString:(NSString *)uuid WithKind:(NSString *)kind{
    
    //请求乐点数
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uuid forKey:@"uuid"];
    [params setObject:kind forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        if (result) {
            convertLabel.text=[NSString getTheNoNullStr:[NSString stringWithFormat:@"%@ 积分",result[@"integral"]] andRepalceStr:@"0积分"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)getDiskCountCoupon{
    NSLog(@"%ld",(long)_pageIndex);
    GetDiscountCouponVC *disctountCounponVC=[[GetDiscountCouponVC alloc]init];
    [self.navigationController pushViewController:disctountCounponVC animated:YES];
    
}
-(void)goLandingOrNot{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!delegate.IsLogin)
    {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
