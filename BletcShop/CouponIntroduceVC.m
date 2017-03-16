//
//  CouponIntroduceVC.m
//  BletcShop
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CouponIntroduceVC.h"
#import "ShaperView.h"
#import "UIImageView+WebCache.h"
#import "SweetNoticeVC.h"
#import "MyPch.pch"
//#import "BindCustomView.h"
@interface CouponIntroduceVC ()
//{
//    BindCustomView *alertView;
//}
@end

@implementation CouponIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(238, 238, 238);
    self.navigationItem.title=@"代金券";
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 60, SCREENWIDTH-20, SCREENHEIGHT*0.6)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.cornerRadius=5.0f;
    bgView.clipsToBounds=YES;
    [self.view addSubview:bgView];
    
    UIImageView *shopHead=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-25, 35, 50, 50)];
    shopHead.layer.cornerRadius=25.0f;
    shopHead.clipsToBounds=YES;
    [self.view addSubview:shopHead];
    
    UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREENWIDTH-20, 15)];
    
    shopNameLable.textColor=[UIColor lightGrayColor];
    shopNameLable.textAlignment=1;
    shopNameLable.font=[UIFont systemFontOfSize:13.0f];
    [bgView addSubview:shopNameLable];
    
    UILabel *couponFaceValue=[[UILabel alloc]initWithFrame:CGRectMake(0, shopNameLable.bottom+15, SCREENWIDTH-20, 30)];
    
    couponFaceValue.textAlignment=1;
    couponFaceValue.font=[UIFont systemFontOfSize:24.0f];
    [bgView addSubview:couponFaceValue];
    
    UIButton *buyCardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyCardBtn.frame=CGRectMake((SCREENWIDTH-20)/2-75,couponFaceValue.bottom+15 , 150, 40);
    buyCardBtn.layer.cornerRadius=5.0f;
    buyCardBtn.clipsToBounds=YES;
    buyCardBtn.backgroundColor=NavBackGroundColor;
    [buyCardBtn setTitle:@"去办卡" forState:UIControlStateNormal];
    [buyCardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:buyCardBtn];
    [buyCardBtn addTarget:self action:@selector(buyCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ShaperView *viewr=[[ShaperView alloc]initWithFrame:CGRectMake(5, bgView.height/2, SCREENWIDTH-30, 1)];
    ShaperView *viewt= [viewr drawDashLine:viewr lineLength:3 lineSpacing:3 lineColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    [bgView addSubview:viewt];
    
    UILabel *deadTime=[[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-20)/2-90, buyCardBtn.bottom+5, 180, 40)];
    deadTime.textColor=[UIColor lightGrayColor];
    deadTime.numberOfLines=0;
    deadTime.textAlignment=1;
    deadTime.font=[UIFont systemFontOfSize:12.0f];
    [bgView addSubview:deadTime];
    
    UIView *noticeView=[[UIView alloc]initWithFrame:CGRectMake(0, bgView.height/2+1, SCREENWIDTH-20, bgView.height/4)];
    noticeView.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:noticeView];
    NSString *useLimit=[NSString stringWithFormat:@"订单每满%@元可用，最高优惠%@元",self.infoDic[@"pri_condition"],self.infoDic[@"sum"]];
    NSArray *noticeArray=@[@"可在线上办理本店会员卡时使用",useLimit,@"每周一、二、三、四、五、六、日00:00-23:59可用"];
    for (int i=0; i<3; i++) {
        UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(23, i*bgView.height/12, SCREENWIDTH-20-23, bgView.height/12)];
        noticeLable.font=[UIFont systemFontOfSize:11.0f];
        noticeLable.text=noticeArray[i];
        [noticeView addSubview:noticeLable];
        
        UIView *tipView=[[UIView alloc]init];
        tipView.backgroundColor=[UIColor lightGrayColor];
        tipView.bounds=CGRectMake(0, 0, 4, 4);
        tipView.center=CGPointMake(15, noticeLable.center.y);
        tipView.layer.cornerRadius=2.0f;
        tipView.clipsToBounds=YES;
        [noticeView addSubview:tipView];
        
    }
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(5, bgView.height*3/4+1, SCREENWIDTH-30, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    [bgView addSubview:lineView];
    
    UIView *useNoticeView=[[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom, SCREENWIDTH-20, bgView.height*1/4-2)];
    [bgView addSubview:useNoticeView];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREENWIDTH-35-30, (bgView.height*1/4-2)/2)];
    lab.text=@"使用须知";
    lab.font=[UIFont systemFontOfSize:16.0f];
    [useNoticeView addSubview:lab];
    
    UIImageView *arraw1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20-30, (lab.height-20)/2, 10, 20)];
    arraw1.image=[UIImage imageNamed:@"arraw_right"];
    [useNoticeView addSubview:arraw1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(5, lab.bottom, SCREENWIDTH-30, 1)];
    lineView2.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    [useNoticeView addSubview:lineView2];
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(15, lineView2.bottom, SCREENWIDTH-35-30, (bgView.height*1/4-2)/2-1)];
    lab2.font=[UIFont systemFontOfSize:16.0f];
    lab2.text=@"适用门店";
    [useNoticeView addSubview:lab2];
    
    UIImageView *arraw2=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20-30,lineView2.bottom+(lab2.height-20)/2, 10, 20)];
    arraw2.backgroundColor=[UIColor clearColor];
    arraw2.image=[UIImage imageNamed:@"arraw_right"];
    [useNoticeView addSubview:arraw2];
    
    UIButton *useNoticeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    useNoticeButton.frame=CGRectMake(0, 0, SCREENWIDTH, useNoticeView.height/2);
    useNoticeButton.backgroundColor=[UIColor clearColor];
    [useNoticeView addSubview:useNoticeButton];
    [useNoticeButton addTarget:self action:@selector(notice) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *adjustShopButton=[UIButton buttonWithType:UIButtonTypeCustom];
    adjustShopButton.frame=CGRectMake(0, useNoticeView.height/2, SCREENWIDTH, useNoticeView.height/2);
    adjustShopButton.backgroundColor=[UIColor clearColor];
    [useNoticeView addSubview:adjustShopButton];
    [adjustShopButton addTarget:self action:@selector(adjustShop) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.index==0) {
        [shopHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,self.infoDic[@"image_url"]]]];
        shopNameLable.text=self.infoDic[@"store"];
        couponFaceValue.text=[NSString stringWithFormat:@"%@元代金券",self.infoDic[@"sum"]];
        deadTime.text=[NSString stringWithFormat:@"有效期：%@～%@",self.infoDic[@"date_start"],self.infoDic[@"date_end"]];
    }else if(self.index==1){
        [shopHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,self.infoDic[@"image_url"]]]];
        shopNameLable.text=self.infoDic[@"store"];
        couponFaceValue.text=[NSString stringWithFormat:@"%@元代金券",self.infoDic[@"sum"]];
        deadTime.text=[NSString stringWithFormat:@"有效期：%@～%@",self.infoDic[@"date_start"],self.infoDic[@"date_end"]];
    }
    
    
}
-(void)buyCardBtnClick:(UIButton *)sender{
    NSLog(@"goBuyCard");
}
-(void)notice{
    NSLog(@"notice");
    SweetNoticeVC *vc=[[SweetNoticeVC alloc]init];
    vc.infoDic=self.infoDic;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)adjustShop{
    
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
