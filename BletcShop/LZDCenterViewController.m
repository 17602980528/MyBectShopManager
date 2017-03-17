//
//  LZDCenterViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/3/13.
//  Copyright © 2017年 bletc. All rights reserved.
//


#define NUMM 100000

#define HH 40

#import "LZDCenterViewController.h"

//#import "PointConvertViewController.h"

#import "GetDiscountCouponVC.h"


#import "IntegralMallViewController.h"

@interface LZDCenterViewController ()<UIScrollViewDelegate>
{
    UIButton *oldBtn;
    UIView *lineView;
    UIView *topView;
}
@property(nonatomic,strong) IntegralMallViewController *pointVC;
@property(nonatomic,strong)GetDiscountCouponVC *getDiscountVC;
@property (nonatomic, strong) NSArray *headArray;
@property (nonatomic, strong) UIScrollView *bottomScrollView;



@end

@implementation LZDCenterViewController

//-(void)goclick{
//    IntegralMallViewController *VC = [[IntegralMallViewController alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(234, 234, 234);
    self.navigationItem.title=@"会员中心";

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(goclick)];

    self.headArray = @[@"积分商城",@"优惠券"];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
     topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 32)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    for (int i = 0; i <self.headArray.count; i ++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50+i*(SCREENWIDTH-100)/_headArray.count, 0, (SCREENWIDTH-100)/_headArray.count, topView.height-2)];
        
        [btn setTitle:self.headArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [btn setTitleColor:NavBackGroundColor forState:UIControlStateSelected];
        btn.tag = i+NUMM;
        //        btn.BtnArray = data_A;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [topView addSubview:btn];
        if (i==0) {
            btn.selected = YES;
            oldBtn = btn;
            
            lineView = [[UIView alloc]init];
            lineView.bounds = CGRectMake(0, 0, btn.width/2, 2);
            lineView.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame)+1);
            lineView.backgroundColor = NavBackGroundColor;
            [topView addSubview:lineView];
        }
    }

    
 
    
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HH, SCREENWIDTH, SCREENHEIGHT-HH-64)];
    self.bottomScrollView.backgroundColor = [UIColor purpleColor];
    self.bottomScrollView.contentSize = CGSizeMake(520, 0);
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate= self;
    //    self.bottomScrollView.pagingEnabled = YES;
    [self.view addSubview:_bottomScrollView];
    
    
    [self setUpBottomScrollView];



}

//顶部三个分类对应的点击事件
-(void)btnClick:(UIButton*)sender{
    if (sender !=oldBtn) {
        sender.selected = YES;
        oldBtn.selected = NO;
        oldBtn = sender;
        [UIView animateWithDuration:0.5 animations:^{
            lineView.center = CGPointMake(sender.center.x, CGRectGetMaxY(sender.frame)+1);
        }];
        [self.bottomScrollView setContentOffset:CGPointMake((sender.tag-NUMM) * self.bottomScrollView.frame.size.width, 0) animated:YES];
        
    }
    
    
    
}
-(void)setUpBottomScrollView{
    
    self.pointVC = [[IntegralMallViewController alloc] init];
    [self.pointVC.view setFrame:CGRectMake(0, HH, SCREENWIDTH, self.bottomScrollView.height)];
    [self addChildViewController:self.pointVC];
    
    self.getDiscountVC = [[GetDiscountCouponVC alloc] init];
    [self.getDiscountVC.view setFrame:CGRectMake(0, HH, SCREENWIDTH, self.bottomScrollView.height)];
    [self addChildViewController:_getDiscountVC];
    
    
    
    
    
    CGFloat VCViewW = self.bottomScrollView.frame.size.width;
    CGFloat VCViewH = self.bottomScrollView.frame.size.height;
    CGFloat VCViewY = 0;
    
    //一开始，默认添加第一个控制器的view到scrollView中，其他view在滚动时动态添加
    CGFloat VCViewX = 0;
    self.pointVC.view.frame = CGRectMake(VCViewX, VCViewY, VCViewW, VCViewH);
    [self.bottomScrollView addSubview:self.pointVC.view];
    
    
    //设置contentSize
    self.bottomScrollView.contentSize = CGSizeMake(_headArray.count * SCREENWIDTH, 0);
    
    //取消水平滚动条
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    
    //设置分页
    self.bottomScrollView.pagingEnabled = YES;
    
    
    
}
//滚动动画停止的时候调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger idx = self.bottomScrollView.contentOffset.x / self.bottomScrollView.frame.size.width;
    
    UIButton *button = (UIButton*)[topView viewWithTag:idx+NUMM];
    
    if (button !=oldBtn) {
        button.selected = YES;
        oldBtn.selected = NO;
        oldBtn = button;
        [UIView animateWithDuration:0.5 animations:^{
            lineView.center = CGPointMake(button.center.x, CGRectGetMaxY(button.frame)+1);
        }];
    }
    
    
}

//减速完毕调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

//滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat index = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSInteger currentIndex = (NSInteger)index;
    
    NSInteger nextIndex = currentIndex + 1;
    
    if (nextIndex < self.headArray.count)
    {
        UIViewController *vc = (UIViewController *)self.childViewControllers[nextIndex];
        
        
//        NSLog(@"==========%ld===%@",nextIndex,vc.view.superview);
        
        //        当用户滚动的时候，才将控制器的view添加到scrollView中
        if (vc.view.superview == nil)
        {
            vc.view.frame = CGRectMake(nextIndex * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
            
            [scrollView addSubview:vc.view];
        }
        
    }
    
}


@end
