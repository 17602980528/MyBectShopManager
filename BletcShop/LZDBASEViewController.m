//
//  LZDBASEViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/2.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDBASEViewController.h"
#import "LZDConversationViewController.h"
#import "LZDContactViewController.h"
#import "AddFriendTableViewController.h"
#import "LZDButton.h"
@interface LZDBASEViewController ()<UIScrollViewDelegate>
{
    UIButton *oldBtn;
    NSArray *title_A;
    
    UIImageView *img1;
    UIImageView *img2;
    UILabel *lab1;
    UILabel *lab2;
    LZDButton *rightBtn;
    UILabel*rednumbel;

}
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property(nonatomic,strong) NSMutableDictionary *dicFriendRequest;

@end

@implementation LZDBASEViewController

-(NSDictionary *)dicFriendRequest{
    if (!_dicFriendRequest) {
        _dicFriendRequest = [NSMutableDictionary dictionary];
        
    }
    return _dicFriendRequest;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:@"FriendRequest"];
    self.dicFriendRequest =[NSMutableDictionary dictionaryWithDictionary:dic];
    
   
    NSLog(@"-dicFriendRequest---%ld",self.dicFriendRequest.count);
    rednumbel.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.dicFriendRequest.count];
    rednumbel.textColor= [UIColor whiteColor];
    
    if ([rednumbel.text intValue]==0) {
        rednumbel.hidden=YES;
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"会话列表";
    title_A = @[@"会话列表",@"通讯录"];

    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:@"FriendRequest"];
    self.dicFriendRequest =[NSMutableDictionary dictionaryWithDictionary:dic];
    
    rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 0, 30, 30);
    
    [rightBtn setTitle:@"+" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    __weak typeof(self) weakSelf = self;
    rightBtn.block = ^(LZDButton *btn){
        
        AddFriendTableViewController *VC = [[AddFriendTableViewController alloc]init];
        [weakSelf.navigationController pushViewController:VC animated:YES];
        
       
    };
    

    
    self.bottomScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-44)];
    self.bottomScrollView.backgroundColor = [UIColor purpleColor];
    self.bottomScrollView.contentSize = CGSizeMake(520, 0);
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate= self;

    [self.view addSubview:self.bottomScrollView];
    
    
    
    [self setUpScrollView];
    
    [self creatFootView];
    
    
}

-(void)creatFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-44-64, SCREENWIDTH, 44)];
    footView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbarBkg"]];
    [self.view addSubview:footView];
    for (int i =0; i <2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [footView addSubview:button];
        button.frame = CGRectMake(i*SCREENWIDTH/2, 0, SCREENWIDTH/2, 44);
        
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame =CGRectMake((SCREENWIDTH/2-27)/2, 2, 27, 27);
        [button addSubview:imageV];
        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(0, imageV.bottom-1, SCREENWIDTH/2, 44-imageV.bottom)];
        labe.text = title_A[i];
        labe.textAlignment = NSTextAlignmentCenter;
        labe.textColor = [UIColor lightGrayColor];
        labe.font =[UIFont systemFontOfSize:10];
        [button addSubview:labe];
        
        
        if (i==0) {
            img1 = imageV;
            lab1 = labe;
            oldBtn = button;

        }
        if (i==1) {
            img2 = imageV;
            lab2 = labe;
            
            rednumbel=[[UILabel alloc]initWithFrame:CGRectMake(imageV.width-15, 0, 15, 15)];
            rednumbel.backgroundColor=[UIColor redColor];
            rednumbel.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.dicFriendRequest.count];
            rednumbel.textColor= [UIColor whiteColor];
            if ([rednumbel.text intValue]==0) {
                rednumbel.hidden=YES;
            }
            rednumbel.font=[UIFont systemFontOfSize:13];
            rednumbel.layer.cornerRadius=7.5;
            rednumbel.clipsToBounds=YES;
            rednumbel.textAlignment=NSTextAlignmentCenter;
            [imageV addSubview:rednumbel];

            NSLog(@"rednumbel.text=======%@",rednumbel.text);
 
        }
        img1.image = [UIImage imageNamed:@"icontabbar_mainframeHL"];
        lab1.textColor = NavBackGroundColor;
        img2.image = [UIImage imageNamed:@"联系人"];
        lab2.textColor = [UIColor lightGrayColor];

        button.tag =i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setUpScrollView{
    
    
        LZDConversationViewController *conversationVC = [[LZDConversationViewController alloc] init];
    
        [conversationVC.view setFrame:CGRectMake(0,0 , SCREENWIDTH, SCREENHEIGHT-44 - 64)];
        [self addChildViewController:conversationVC];
    
    
    LZDContactViewController *contactVC = [[LZDContactViewController alloc] init];
    
    [contactVC.view setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44 - 64)];
    [self addChildViewController:contactVC];

    
    
    
//        CGFloat VCViewW = self.bottomScrollView.frame.size.width;
//        CGFloat VCViewH = self.bottomScrollView.frame.size.height;
//        CGFloat VCViewY = 0;
//    
//        //一开始，默认添加第一个控制器的view到scrollView中，其他view在滚动时动态添加
//        CGFloat VCViewX = 0;
//        contactVC.view.frame = CGRectMake(VCViewX, VCViewY, VCViewW, VCViewH);

    
        [self.bottomScrollView addSubview:conversationVC.view];
    
//    [self.bottomScrollView addSubview:contactVC.view];

        //设置contentSize
        self.bottomScrollView.contentSize = CGSizeMake( SCREENWIDTH, 0);
    
        //取消水平滚动条
        self.bottomScrollView.showsHorizontalScrollIndicator = NO;
        self.bottomScrollView.showsVerticalScrollIndicator = NO;
    
        //设置分页
        self.bottomScrollView.pagingEnabled = YES;
    
    
    
}

//滚动动画停止的时候调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

    
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
    
        if (nextIndex < 2)
        {
            UIViewController *vc = (UIViewController *)self.childViewControllers[nextIndex];
    
            //        当用户滚动的时候，才将控制器的view添加到scrollView中
            if (vc.view.superview == nil)
            {
                vc.view.frame = CGRectMake(nextIndex * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
                
    
                [scrollView addSubview:vc.view];
            }
    
        }
    

    
}


-(void)buttonClick:(UIButton*)sender{
    
    if (sender !=oldBtn) {
        UIViewController *vc = (UIViewController *)self.childViewControllers[sender.tag];
        UIViewController *oldvc = (UIViewController *)self.childViewControllers[oldBtn.tag];

        oldBtn = sender;
    
//        [self.bottomScrollView setContentOffset:CGPointMake((sender.tag) * self.bottomScrollView.frame.size.width, 0) animated:YES];
        
        

        
        NSLog(@"---%@==%@",vc,oldvc);
        
        //        当用户滚动的时候，才将控制器的view添加到scrollView中
        if (vc.view.superview == nil)
        {

            [self.bottomScrollView addSubview:vc.view];
            [oldvc.view removeFromSuperview];

            
        }

        
    }

    self.title  = title_A [sender.tag];

    
    if (sender.tag==0) {
        self.navigationItem.rightBarButtonItem = nil;
        
        
        img1.image = [UIImage imageNamed:@"icontabbar_mainframeHL"];
        lab1.textColor = NavBackGroundColor;
        img2.image = [UIImage imageNamed:@"联系人"];
        lab2.textColor = [UIColor lightGrayColor];
        
    }else if(sender.tag==1){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        
        img1.image = [UIImage imageNamed:@"消息"];
        lab1.textColor = [UIColor lightGrayColor];
        img2.image = [UIImage imageNamed:@"iconfont-icontongxunlu"];
        lab2.textColor = NavBackGroundColor;
        
    }


}


@end
