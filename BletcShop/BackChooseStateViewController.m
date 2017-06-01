//
//  BackChooseStateViewController.m
//  BletcShop
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "BackChooseStateViewController.h"

@interface BackChooseStateViewController ()

@end

@implementation BackChooseStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatSubviews];
    
    
    
    
    [self performSelector:@selector(loadChooseView) withObject:nil afterDelay:0.6];
}

-(void)creatSubviews{
    
    
    UIView *choseView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    choseView.backgroundColor = RGB(242, 241, 241);
    [self.view addSubview:choseView];
    //    self.choseView = choseView;
    //
    //    UIImageView *backImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    //    backImg.image = [UIImage imageNamed:@"登陆-01(2)"];
    //    [choseView addSubview:backImg];
    //
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor = NavBackGroundColor;
    [choseView addSubview:topView];
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 44)];
    label.text=@"选择身份";
    label.font=[UIFont systemFontOfSize:19];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [topView addSubview:label];
    
    
    UIButton *interBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    interBtn.frame = CGRectMake(92, SCREENHEIGHT-44-20, SCREENWIDTH-92*2, 44);
    interBtn.frame = CGRectMake((SCREENWIDTH-(479/2))/2, SCREENHEIGHT-42-20, 479/2, 42);

//    interBtn.backgroundColor = NavBackGroundColor;
//    [interBtn setTitle:@"进入商消乐" forState:0];
    [interBtn setImage:[UIImage imageNamed:@"choseImg"] forState:0];
    [interBtn setImage:[UIImage imageNamed:@"choseImg"] forState:1];

//    interBtn.layer.cornerRadius =interBtn.height/2;
//    interBtn.layer.masksToBounds = YES;
//    
    //    [interBtn addTarget:self action:@selector(interClick) forControlEvents:UIControlEventTouchUpInside];
    [choseView addSubview:interBtn];
    
    CGFloat height_v = (interBtn.top-(topView.bottom+25.5))/2;
    
    //    whichInter = 0;
    
    for (int i = 0; i <2; i ++) {
        UIView *view_two = [[UIView alloc]initWithFrame:CGRectMake(0, topView.bottom+25.5+height_v*i, SCREENWIDTH, height_v)];
        view_two.tag = i;
        [choseView addSubview:view_two];
        
        //用户
        //        CGFloat weithImg = height_v/3*2;
        
        CGFloat weithImg = height_v-36-20;
        
        
        //        CGFloat weithImg = 148*SCREENWIDTH/320;
        UIImageView *userImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-weithImg)/2, 0, weithImg, weithImg)];
        userImg.layer.cornerRadius = userImg.width/2;
        userImg.layer.masksToBounds = YES;
        [view_two addSubview:userImg];
        UILabel *name_lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-30, userImg.bottom+16, 200, 20)];
        name_lab.font = [UIFont systemFontOfSize:18];
        name_lab.textColor = RGB(51, 51, 51);
        [view_two addSubview:name_lab];
        
        UIImageView*select_img = [[UIImageView alloc]initWithFrame:CGRectMake(name_lab.left-25, name_lab.top, 20, 20)];
        select_img.layer.cornerRadius = select_img.width/2;
        [view_two addSubview:select_img];
        
        
        if (i==0) {
            userImg.image = [UIImage imageNamed:@"user_s"];
//            name_lab.text = @"我是消费者";
//            select_img.image = [UIImage imageNamed:@"登陆-04"];
            //            upImg = select_img;
            UIImageView *selectImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, userImg.bottom+(view_two.height-userImg.bottom-30*(SCREENWIDTH-10)/1100)/2 ,SCREENWIDTH-10 , 30*(SCREENWIDTH-10)/1100)];
            selectImg.image = [UIImage imageNamed:@"select_img"];
            [view_two addSubview:selectImg];

        }else{
            userImg.image = [UIImage imageNamed:@"shoper_n"];
//            name_lab.text = @"我是商户";
//            select_img.image = [UIImage imageNamed:@"登陆-05"];
            //            downImg = select_img;
            
        }
        
        
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choiceWhichTag:)];
        //        [view_two addGestureRecognizer:tap];
        
        
    }
    
    
    
    
}
//-(void)creatSubviews{
//    
//    
//    UIView *choseView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    choseView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:choseView];
//    //    self.choseView = choseView;
//    //
//    //    UIImageView *backImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    //    backImg.image = [UIImage imageNamed:@"登陆-01(2)"];
//    //    [choseView addSubview:backImg];
//    //
//    
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
//    topView.backgroundColor =NavBackGroundColor;
//    [choseView addSubview:topView];
//    
//    
//    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 44)];
//    label.text=@"选择身份";
//    label.font=[UIFont systemFontOfSize:19];
//    label.textAlignment=NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    [topView addSubview:label];
//    
//    
//    UIButton *interBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    interBtn.frame = CGRectMake(92, SCREENHEIGHT-44-20, SCREENWIDTH-92*2, 44);
//    interBtn.backgroundColor = NavBackGroundColor;
//    [interBtn setTitle:@"进入商消乐" forState:0];
//    interBtn.layer.cornerRadius =interBtn.height/2;
//    interBtn.layer.masksToBounds = YES;
//    
//    //    [interBtn addTarget:self action:@selector(interClick) forControlEvents:UIControlEventTouchUpInside];
//    [choseView addSubview:interBtn];
//    
//    CGFloat height_v = (interBtn.top-(topView.bottom+25.5))/2;
//    
//    //    whichInter = 0;
//    
//    for (int i = 0; i <2; i ++) {
//        UIView *view_two = [[UIView alloc]initWithFrame:CGRectMake(0, topView.bottom+25.5+height_v*i, SCREENWIDTH, height_v)];
//        view_two.tag = i;
//        [choseView addSubview:view_two];
//        
//        //用户
//        //        CGFloat weithImg = height_v/3*2;
//        
//        CGFloat weithImg = height_v-36-20;
//        
//        
//        //        CGFloat weithImg = 148*SCREENWIDTH/320;
//        UIImageView *userImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-weithImg)/2, 0, weithImg, weithImg)];
//        userImg.layer.cornerRadius = userImg.width/2;
//        userImg.layer.masksToBounds = YES;
//        [view_two addSubview:userImg];
//        UILabel *name_lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-30, userImg.bottom+16, 200, 20)];
//        name_lab.font = [UIFont systemFontOfSize:18];
//        name_lab.textColor = RGB(51, 51, 51);
//        [view_two addSubview:name_lab];
//        
//        UIImageView*select_img = [[UIImageView alloc]initWithFrame:CGRectMake(name_lab.left-25, name_lab.top, 20, 20)];
//        select_img.layer.cornerRadius = select_img.width/2;
//        [view_two addSubview:select_img];
//        
//        
//        if (i==0) {
//            userImg.image = [UIImage imageNamed:@"登陆  头像-01"];
//            name_lab.text = @"我是消费者";
//            select_img.image = [UIImage imageNamed:@"登陆-04"];
//            //            upImg = select_img;
//            
//        }else{
//            userImg.image = [UIImage imageNamed:@"登陆  头像-02"];
//            name_lab.text = @"我是商户";
//            select_img.image = [UIImage imageNamed:@"登陆-05"];
//            //            downImg = select_img;
//            
//        }
//        
//        
//        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choiceWhichTag:)];
//        //        [view_two addGestureRecognizer:tap];
//        
//        
//    }
//    
//    
//    
//    
//}

-(void)loadChooseView{
    for (UIView *View in self.view.subviews) {
        [View removeFromSuperview];
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app _initChose];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
