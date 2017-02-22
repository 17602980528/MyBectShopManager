//
//  SurroundingAreaVC.m
//  BletcShop
//
//  Created by apple on 17/2/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "SurroundingAreaVC.h"

@interface SurroundingAreaVC ()

@end

@implementation SurroundingAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"发布周边广告";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitInfo)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    [self initTopView];
    [self initBottomView];
    
}
-(void)initTopView{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 133)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(19, 15, SCREENWIDTH-19, 16)];
    label.text=@"添加广告图片";
    label.font=[UIFont systemFontOfSize:16.0f];
    [topView addSubview:label];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adver_sample"]];
    imageView.frame=CGRectMake(27, 36, 90, 90);
    [topView addSubview:imageView];
    
    
}
-(void)initBottomView{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 143, SCREENWIDTH, 273)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(13, 197, SCREENWIDTH-26, 1)];
    lineView.backgroundColor=RGB(234, 234, 234);
    [bottomView addSubview:lineView];
    
    UILabel *otherOption=[[UILabel alloc]initWithFrame:CGRectMake(19, 0, SCREENWIDTH-38, 47)];
    otherOption.text=@"其他选项";
    otherOption.font=[UIFont systemFontOfSize:16.0f];
    [bottomView addSubview:otherOption];
    
    UILabel *chooseArea=[[UILabel alloc]initWithFrame:CGRectMake(19, 47, 80, 50)];
    chooseArea.text=@"选择地区:";
    chooseArea.font=[UIFont systemFontOfSize:16.0f];
    [bottomView addSubview:chooseArea];
    
    UILabel *areaLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 47, SCREENWIDTH-99-27, 50)];
    areaLable.font=[UIFont systemFontOfSize:16.0f];
    areaLable.textColor=RGB(153, 153, 153);
    areaLable.text=@"西安市高新区富鱼路99号";
    [bottomView addSubview:areaLable];
    
    UIImageView *detailImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27, 47+17, 8, 16)];
    detailImage.image=[UIImage imageNamed:@"arraw_right"];
    [bottomView addSubview:detailImage];
    
    UILabel *timeOnline=[[UILabel alloc]initWithFrame:CGRectMake(19, 47+50, 80, 50)];
    timeOnline.text=@"在线时间:";
    timeOnline.font=[UIFont systemFontOfSize:16.0f];
    [bottomView addSubview:timeOnline];
    
    UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 47+50, SCREENWIDTH-99-27, 50)];
    timeLable.font=[UIFont systemFontOfSize:16.0f];
    timeLable.textColor=RGB(153, 153, 153);
    timeLable.text=@"07:00-23:00";
    [bottomView addSubview:timeLable];
    
    UIImageView *detailImage2=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27, 50+47+17, 8, 16)];
    detailImage2.image=[UIImage imageNamed:@"arraw_right"];
    [bottomView addSubview:detailImage2];
    
    UILabel *adverPosition=[[UILabel alloc]initWithFrame:CGRectMake(19, 47+50+50, 80, 50)];
    adverPosition.text=@"广告位置:";
    adverPosition.font=[UIFont systemFontOfSize:16.0f];
    [bottomView addSubview:adverPosition];
    
    UIImageView *detailImage3=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27, 50+47+17+50, 8, 16)];
    detailImage3.image=[UIImage imageNamed:@"arraw_right"];
    [bottomView addSubview:detailImage3];
}
//数据请求上传服务器部分
-(void)submitInfo{
    
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
