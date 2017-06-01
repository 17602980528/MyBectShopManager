//
//  WelcomViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/18.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "WelcomViewController.h"

@interface WelcomViewController ()
{
    NSArray* imageArray;
}
@end

@implementation WelcomViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScollView];
    [self makeBannerView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isShowNavInfo = YES;
    [defaults setBool:isShowNavInfo forKey:@"isHideNavInfo"];
    [defaults synchronize];
}
-(void)initScollView
{
    UIScrollView *myView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    myView.backgroundColor = [UIColor whiteColor];
    self.scrollView = myView;
    [self.view addSubview:myView];
   }
-(void)firstView
{
    [self.scrollView removeFromSuperview];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate _initChose];
}
-(void)makeBannerView{
     imageArray = @[@"引导页1",@"引导页2",@"引导页3"];
//    imageArray = @[@"引导页-01",@"引导页-02",@"引导页-03-01"];

    _scrollView.contentSize = CGSizeMake(SCREENWIDTH*imageArray.count,_scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    for (int i = 0; i<imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+SCREENWIDTH*i, 0, SCREENWIDTH, _scrollView.frame.size.height)];
        imageView.tag = 2000+i;
        
        NSString* imageStr = imageArray[i];
        imageView.image = [UIImage imageNamed:imageStr];
        [_scrollView addSubview:imageView];
        
        if (i==imageArray.count-1) {
            imageView.userInteractionEnabled = YES;
            _loginBt = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH-105)/2, SCREENHEIGHT-103, 105, 30)];
//            [_loginBt setBackgroundImage:[UIImage imageNamed:@"entrance_selected"] forState:UIControlStateNormal];
//            [_loginBt setBackgroundImage:[UIImage imageNamed:@"entrance_default"] forState:UIControlStateSelected];
//            _loginBt.layer.borderColor =[UIColor colorWithHexString:@"f29118"].CGColor;
//            _loginBt.layer.borderWidth = 1;
//            _loginBt.backgroundColor = NavBackGroundColor;
            _loginBt.layer.borderColor = RGB(238, 179, 152).CGColor;
            _loginBt.layer.borderWidth = 1;

            _loginBt.layer.cornerRadius = 15;
            [_loginBt setTitle:@"GO" forState:0];
            [_loginBt setTitleColor:RGB(238, 179, 152) forState:0];
            _loginBt.titleLabel.font = [UIFont systemFontOfSize:18];
            
            [_loginBt addTarget:self action:@selector(firstView) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:_loginBt];

        }
    }
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40)];
    pageControl.numberOfPages = imageArray.count;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = NavBackGroundColor;
    pageControl.userInteractionEnabled = NO;
    pageControl.tag = 200;
    
//    [self.view addSubview:pageControl];
}

#pragma ScrollView delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        
    }else
    {
        int current = scrollView.contentOffset.x/SCREENWIDTH;
        UIPageControl* pageContrl = (UIPageControl*)[self.view viewWithTag:200];
        pageContrl.currentPage = current;
        NSLog(@"scrollViewDidEndDecelerating----%f",scrollView.contentOffset.x);

        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidScroll----%f",scrollView.contentOffset.x);

    
    if (scrollView.contentOffset.x > (imageArray.count-1)*SCREENWIDTH+50) {
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdelegate _initChose];
        
        [UIView animateWithDuration:2 animations:^{
                       CGRect frame =  self.scrollView.frame;
                       frame.origin.x = SCREENWIDTH;
                       self.scrollView.frame = frame;
            
                   } completion:^(BOOL finished) {
                       [self.scrollView removeFromSuperview];
            
         }];

    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewWillBeginDragging----%f",scrollView.contentOffset.x);
//    if (scrollView.contentOffset.x >= (imageArray.count-1)*SCREENWIDTH) {
//        
//        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        [appdelegate _initChose];
//        
//        
//       [UIView animateWithDuration:2 animations:^{
//           CGRect frame =  self.scrollView.frame;
//           frame.origin.x = SCREENWIDTH;
//           self.scrollView.frame = frame;
//           
//       } completion:^(BOOL finished) {
//           [self.scrollView removeFromSuperview];
//
//       }];
//    
//        
//
//    
//    }

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
