//
//  PublishAdvertSecondVC.m
//  BletcShop
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PublishAdvertSecondVC.h"
#import "PublishTopScrollAdvertVC.h"
@interface PublishAdvertSecondVC ()

@end

@implementation PublishAdvertSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"发布广告";
    self.view.backgroundColor=RGB(238, 238, 238);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-74)];
    bgview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgview];
    //row1
    UILabel *chooseArea=[[UILabel alloc]initWithFrame:CGRectMake(19, 0, 80, 49)];
    chooseArea.text=@"选择地区";
    chooseArea.textColor=RGB(102, 102, 102);
    chooseArea.font=[UIFont systemFontOfSize:16.0f];
    [bgview addSubview:chooseArea];
    
    UILabel *areaLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 0, SCREENWIDTH-99-27, 49)];
    areaLable.font=[UIFont systemFontOfSize:16.0f];
    areaLable.text=@"西安";
    [bgview addSubview:areaLable];
    
    UIImageView *detailImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27, 16.5, 8, 16)];
    detailImage.image=[UIImage imageNamed:@"arraw_right"];
    [bgview addSubview:detailImage];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(13, 49, SCREENWIDTH-26, 1)];
    lineView.backgroundColor=RGB(234, 234, 234);
    [bgview addSubview:lineView];
    //row2
    UILabel *advertStyle=[[UILabel alloc]initWithFrame:CGRectMake(19, 50, 80, 49)];
    advertStyle.text=@"活动类型";
    advertStyle.textColor=RGB(102, 102, 102);
    advertStyle.font=[UIFont systemFontOfSize:16.0f];
    [bgview addSubview:advertStyle];
    
    UILabel *advertStyleLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 50, SCREENWIDTH-99-27, 49)];
    advertStyleLable.font=[UIFont systemFontOfSize:16.0f];
    advertStyleLable.text=@"饮食类";
    [bgview addSubview:advertStyleLable];
    
    UIImageView *detailImage2=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27,50+16.5, 8, 16)];
    detailImage2.image=[UIImage imageNamed:@"arraw_right"];
    [bgview addSubview:detailImage2];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(13, 49+50, SCREENWIDTH-26, 1)];
    lineView2.backgroundColor=RGB(234, 234, 234);
    [bgview addSubview:lineView2];
    //row3
    UILabel *advertPosition=[[UILabel alloc]initWithFrame:CGRectMake(19, 50+50, 80, 49)];
    advertPosition.text=@"广告位置";
    advertPosition.textColor=RGB(102, 102, 102);
    advertPosition.font=[UIFont systemFontOfSize:16.0f];
    [bgview addSubview:advertPosition];
    
    UILabel *advertPositionLable=[[UILabel alloc]initWithFrame:CGRectMake(99, 50+50, SCREENWIDTH-99-27, 49)];
    advertPositionLable.font=[UIFont systemFontOfSize:16.0f];
    advertPositionLable.text=@"";
    [bgview addSubview:advertPositionLable];
    
    UIImageView *detailImage3=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-27,50+16.5+50, 8, 16)];
    detailImage3.image=[UIImage imageNamed:@"arraw_right"];
    [bgview addSubview:detailImage3];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(13, 49+50+50, SCREENWIDTH-26, 1)];
    lineView3.backgroundColor=RGB(234, 234, 234);
    [bgview addSubview:lineView3];
    
    

}
-(void)goNextVC{
    PublishTopScrollAdvertVC *nextVC=[[PublishTopScrollAdvertVC alloc]init];
    [self.navigationController pushViewController:nextVC animated:YES];
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
