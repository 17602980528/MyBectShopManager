//
//  ConvertCostVC.m
//  BletcShop
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ConvertCostVC.h"
<<<<<<< HEAD

#import "OrderDetailViewController.h"

=======
#import "UIImageView+WebCache.h"
>>>>>>> f1739cf65bef5be0fff97147c933ac658d698ec8
@interface ConvertCostVC ()

@end

@implementation ConvertCostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(238, 238, 238);
    self.navigationItem.title=@"积分兑换";
    UIScrollView *_scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-100)];
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, 336+SCREENWIDTH*3370/790.0);
    [self.view addSubview:_scrollView];
    
    //top
    UIView *topBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 326)];
    topBgView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:topBgView];
    
    UIImageView *shopImageView=[[UIImageView alloc]init];
    //NSLog(@"%@",[NSString stringWithFormat:@"%@%@",POINT_GOODS,self.imageNameString]);
    NSURL * nurl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POINT_GOODS,self.imageNameString]];
    [shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    shopImageView.frame=CGRectMake((SCREENWIDTH-200)/2, 15, 200, 200);
    [topBgView addSubview:shopImageView];
    
    UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 230, SCREENWIDTH-40, 30)];
    shopNameLable.text=[NSString stringWithFormat:@"%@  %@积分",self.shopNameString,self.shopNeedPoint];
    shopNameLable.font=[UIFont systemFontOfSize:24.0f];
    [topBgView addSubview:shopNameLable];
    
//    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 260, SCREENWIDTH-40, 30)];
//    detailLabel.text=@"3款颜色随机发放";
//    detailLabel.backgroundColor=[UIColor whiteColor];
//    detailLabel.textColor=[UIColor grayColor];
//    [topBgView addSubview:detailLabel];
//    detailLabel.font=[UIFont systemFontOfSize:13.0f];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 290, SCREENWIDTH, 1)];
    lineView.backgroundColor=RGB(238, 238, 238);
    [topBgView addSubview:lineView];
    
    UILabel *totalPointLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 291, SCREENWIDTH/2, 35)];
    totalPointLable.text=[NSString stringWithFormat:@"我的积分:%@",_totalPoint];
    totalPointLable.textAlignment=1;
    totalPointLable.font=[UIFont systemFontOfSize:15.0f];
    [topBgView addSubview:totalPointLable];
    
    UILabel *allConvertCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 291, SCREENWIDTH/2, 35)];
    allConvertCountLabel.textAlignment=1;
    allConvertCountLabel.text=[NSString stringWithFormat:@"已兑出:%@件",self.converRecordCount];
    allConvertCountLabel.font=[UIFont systemFontOfSize:15.0f];
    [topBgView addSubview:allConvertCountLabel];
    //bottom
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-100, SCREENWIDTH, 100)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    noticeLabel.textAlignment=1;
    noticeLabel.textColor=[UIColor redColor];
    noticeLabel.font=[UIFont systemFontOfSize:13.0f];
    [bottomView addSubview:noticeLabel];
    
    UIButton *convertButton=[UIButton buttonWithType:UIButtonTypeCustom];
    convertButton.frame=CGRectMake(20, 40, SCREENWIDTH-40, 40);
    [convertButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    convertButton.layer.cornerRadius=20;
    convertButton.clipsToBounds=YES;
    [bottomView addSubview:convertButton];
    if ([self.totalPoint floatValue]<[self.shopNeedPoint floatValue]) {
        noticeLabel.text=@"亲！您的积分还不够哦～";
        convertButton.backgroundColor=[UIColor lightGrayColor];
        [convertButton setTitle:@"积分不够" forState:UIControlStateNormal];
    }else{
        noticeLabel.text=@"恭喜！积分可兑换该商品";
        convertButton.backgroundColor=[UIColor orangeColor];
        [convertButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        [convertButton addTarget:self action:@selector(costPoint:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIImageView *scanImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 336, SCREENWIDTH, SCREENWIDTH*3370/790.0)];
    scanImageView.image=[UIImage imageNamed:@"timg-3.jpeg"];
    [_scrollView addSubview:scanImageView];
    
//    UIImageView *
    
}
-(void)costPoint:(UIButton *)sender{
    //
    NSLog(@"积分可用");
    
    OrderDetailViewController *VC= [[OrderDetailViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
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
