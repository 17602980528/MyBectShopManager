//
//  IntegralMallViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/3/17.
//  Copyright © 2017年 bletc. All rights reserved.
//


#import "IntegralMallViewController.h"
#import "THProgressView.h"
#import "LandingController.h"
#import "UIImageView+WebCache.h"
#import "GetDiscountCouponVC.h"
#import "PointRuleViewController.h"
#import "ConvertRecordVC.h"//兑换记录
#import "PointAllGetAndCostsVC.h"//积分明细
#import "ConvertCostVC.h"
#import "SDCycleScrollView.h"
@interface IntegralMallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

{
    UIImageView *headImageView;
    UILabel *convertLabel;
    UIView *slipBackView;
    NSString *pointInt;
    
    NSMutableArray* _adverImages;


    MBProgressHUD *hud;


}
@end

@implementation IntegralMallViewController

static NSString *const cellId = @"cellId";
static NSString *const headId = @"headId";
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(234, 234, 234);
    _adverImages = [NSMutableArray array];
    _adverImages = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    
    
    [self createCollectionView];

    [self getLunBoAdvert];

}

-(void)createCollectionView{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40-64) collectionViewLayout:layout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = RGB(234, 234, 234);
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    
    [self.view addSubview:collectionView];
    
    
    self.collectionView = collectionView;
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data_A.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
   
    cell.backgroundColor =[UIColor whiteColor];
    if (_data_A.count!=0) {
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        NSDictionary *dic = _data_A[indexPath.row];
        
        UIImageView *rewardImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4-40, 10, 80, 80)];
        rewardImageView.userInteractionEnabled=YES;
        rewardImageView.image=[UIImage imageNamed:dic[@"image_url"]];
        [cell.contentView addSubview:rewardImageView];
        
        NSURL * nurl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",POINT_GOODS,dic[@"image_url"]]];
        [rewardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
              
        UILabel *rewardNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 99, SCREENWIDTH/2, 13)];
        rewardNameLabel.textAlignment=NSTextAlignmentCenter;
        rewardNameLabel.font=[UIFont systemFontOfSize:13.0f];
        rewardNameLabel.text=dic[@"name"];
        [cell.contentView addSubview:rewardNameLabel];
        
        UIView *progressBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREENWIDTH/2, 10)];
        [cell.contentView addSubview:progressBackView];
        
        THProgressView *ProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(42,122,70,5)];
        ProgressView.borderTintColor =[UIColor grayColor];
        ProgressView.progressTintColor = [UIColor redColor];
        ProgressView.progress= [dic[@"remain"]floatValue]/[dic[@"sum"]floatValue];
        [cell.contentView addSubview:ProgressView];
        
        UILabel *overLabel=[[UILabel alloc]initWithFrame:CGRectMake(118, 120, SCREENWIDTH/2-118, 10)];
        overLabel.textAlignment=NSTextAlignmentLeft;
        overLabel.font=[UIFont systemFontOfSize:10.0f];
        overLabel.text=[NSString stringWithFormat:@"剩余%.1f%%",ProgressView.progress*100];
        overLabel.textColor=[UIColor grayColor];
        [cell.contentView addSubview:overLabel];
        
        UIImageView *moneyImage=[[UIImageView alloc]initWithFrame:CGRectMake(44, 135, 15, 15)];
        moneyImage.image=[UIImage imageNamed:@"s_money_n"];
        [cell.contentView addSubview:moneyImage];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 135, SCREENWIDTH/2-65, 15)];
        priceLabel.textAlignment=NSTextAlignmentLeft;
        priceLabel.font=[UIFont systemFontOfSize:13.0f];
        priceLabel.text=dic[@"price"];
        [cell.contentView addSubview:priceLabel];
        priceLabel.textColor=RGB(226, 47, 50);
        
    }

    
    

    return cell;
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat item_w = (SCREENWIDTH -3)/2;
    
    return  CGSizeMake(item_w, item_w);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 1, 0, 1);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0f;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREENWIDTH, 191+37);
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind ==UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
        
        headView.backgroundColor = [UIColor whiteColor];
        
        for (UIView *view in headView.subviews) {
            [view removeFromSuperview];
        }
        
        headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 10, 44, 44)];
        headImageView.image=[UIImage imageNamed:@"3.1-02"];
        headImageView.layer.cornerRadius=22.0f;
        headImageView.clipsToBounds=YES;
        headImageView.userInteractionEnabled=YES;
        [headView addSubview:headImageView];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        if (delegate.IsLogin)
        {
            //请求积分等
            NSLog(@"%@",delegate.userInfoDic);
            NSURL * nurl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,[delegate.userInfoDic objectForKey:@"headimage"]]];
            
            [headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            
        }
        
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLandingOrNot)];
        [headImageView addGestureRecognizer:tapGesture];
        
        //积分
        convertLabel=[[UILabel alloc]initWithFrame:CGRectMake(76, 20, 120, 13)];

        convertLabel.textAlignment=NSTextAlignmentLeft;
        convertLabel.font=[UIFont systemFontOfSize:16.0f];
        convertLabel.textColor=NavBackGroundColor;//RGB(66, 170, 250);
        convertLabel.text= [NSString stringWithFormat:@"%ld积分",[pointInt integerValue] ];
        [headView addSubview:convertLabel];
        
        UIButton *signBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        signBtn.frame=CGRectMake(SCREENWIDTH-128, 15, 120, 30);
        signBtn.backgroundColor=NavBackGroundColor;//RGB(66, 170, 250);
        [signBtn setTitle:@"积分规则" forState:UIControlStateNormal];
        [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        signBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        signBtn.layer.cornerRadius=15;
        signBtn.clipsToBounds=YES;
        [headView addSubview:signBtn];
        [signBtn addTarget:self action:@selector(pointUseRule) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 63, SCREENWIDTH, 1)];
        lineView.backgroundColor=RGB(234, 234, 234);
        [headView addSubview:lineView];
        
        UIImageView *ConvertImageView=[[UIImageView alloc]initWithFrame:CGRectMake(58-8, 118-44-8, 30, 30)];
        ConvertImageView.image=[UIImage imageNamed:@"vip_exchangel_n"];
        
        [headView addSubview:ConvertImageView];
        
        UILabel *detailConvert=[[UILabel alloc]initWithFrame:CGRectMake(85, 118-44, SCREENWIDTH/2-85, 13)];
        detailConvert.font=[UIFont systemFontOfSize:13.0f];
        detailConvert.textColor=[UIColor grayColor];
        detailConvert.textAlignment=NSTextAlignmentLeft;
        detailConvert.text=@"积分明细";
        [headView addSubview:detailConvert];
        
        UIButton *detailCvBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        detailCvBtn.frame=CGRectMake(50, 118-44-8, SCREENWIDTH/2-85+35, 30);
        [detailCvBtn addTarget:self action:@selector(pointAllUseInfo) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:detailCvBtn];
        
        UIImageView *recordImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+50, 118-44-8, 30, 30)];
        recordImageView.image=[UIImage imageNamed:@"vip_integral_n"];
        [headView addSubview:recordImageView];
        
        UILabel *recordConvert=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+50+35, 118-44, SCREENWIDTH-SCREENWIDTH/2-85, 13)];
        recordConvert.font=[UIFont systemFontOfSize:13.0f];
        recordConvert.textColor=[UIColor grayColor];
        recordConvert.textAlignment=NSTextAlignmentLeft;
        recordConvert.text=@"兑换记录";
        [headView addSubview:recordConvert];
        
        UIButton *recordCvBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        recordCvBtn.frame=CGRectMake(SCREENWIDTH/2+50, 118-44-8, SCREENWIDTH-SCREENWIDTH/2-85+35, 30);
        [recordCvBtn addTarget:self action:@selector(exchangeRecord) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:recordCvBtn];
        
        slipBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 191-94, SCREENWIDTH, 94)];
        slipBackView.backgroundColor=RGB(240, 240, 240);
        [headView addSubview:slipBackView];
        
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 9, SCREENWIDTH, 76) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        cycleScrollView2.imageURLStringsGroup = _adverImages;
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //    cycleScrollView2.titlesGroup = titles;
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        [slipBackView addSubview:cycleScrollView2];

//        [self getLunBoAdvert];
//        [self getShopList];
        
        UILabel *memberLabel=[[UILabel alloc]initWithFrame:CGRectMake(23, 191+11, SCREENWIDTH-23, 15)];
        memberLabel.font=[UIFont systemFontOfSize:15.0f];
        memberLabel.text=@"会员兑换专区";
        memberLabel.textAlignment=NSTextAlignmentLeft;
        [headView addSubview:memberLabel];
        
        UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 191+36, SCREENWIDTH, 1)];
        lineView2.backgroundColor=RGB(234, 234, 234);
        [headView addSubview:lineView2];
        
        return headView;
    }else{
        
        return nil;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ConvertCostVC *pointCostVC=[[ConvertCostVC alloc]init];
    pointCostVC.infoDic=_data_A[indexPath.row];
    
    pointCostVC.imageNameString=_data_A[indexPath.row][@"image_url"];//图片名
    pointCostVC.shopNameString=_data_A[indexPath.row][@"name"];
    pointCostVC.shopNeedPoint=_data_A[indexPath.row][@"price"];
    NSInteger sum=[_data_A[indexPath.row][@"sum"] integerValue];
    NSInteger remain=[_data_A[indexPath.row][@"remain"] integerValue];
    pointCostVC.converRecordCount=[NSString stringWithFormat:@"%ld",(sum-remain)];
    pointCostVC.totalPoint=pointInt;
    [self.navigationController pushViewController:pointCostVC animated:YES];

}
//获取轮播广告接口
-(void)getLunBoAdvert{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/getAdverts",BASEURL ];
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);//POINT_LUNBO
        
        if (result) {
            [_adverImages removeAllObjects];
            for (int i=0; i<[result count]; i++) {
                [_adverImages addObject:[NSString stringWithFormat:@"%@%@",POINT_LUNBO,result[i][@"image_url"]]];
            }
            
            [self getShopList];

            // 网络加载 --- 创建带标题的图片轮播器
            
            //         --- 模拟加载延迟
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                cycleScrollView2.imageURLStringsGroup = _adverImages;
//            });
            
            
        }
        
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES];

        NSLog(@"%@", error);
        
    }];
}

-(void)getShopList{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/mall/getGoods",BASEURL ];
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);//POINT_LUNBO
        if (result) {
            
            [hud hideAnimated:YES];
            self.data_A = (NSArray*)result;
            [self.collectionView reloadData];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES];

        NSLog(@"%@", error);
        
    }];
    
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
        
        [headImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        
    }else{
        
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
            pointInt=[NSString getTheNoNullStr:[NSString stringWithFormat:@"%@",result[@"integral"]] andRepalceStr:@"0"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(void)getDiskCountCoupon{
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
//积分使用规
-(void)pointUseRule{
    
    PointRuleViewController *pointRuleVC=[[PointRuleViewController alloc]init];
    pointRuleVC.type=99;
    [self.navigationController pushViewController:pointRuleVC animated:YES];
}
//积分明细
-(void)pointAllUseInfo{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!delegate.IsLogin)
    {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else{
        PointAllGetAndCostsVC *recordVC=[[PointAllGetAndCostsVC alloc]init];
        [self.navigationController pushViewController:recordVC animated:YES];
    }
    
}
//兑换记录
-(void)exchangeRecord{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!delegate.IsLogin)
    {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else{
        ConvertRecordVC *recordVC=[[ConvertRecordVC alloc]init];
        [self.navigationController pushViewController:recordVC animated:YES];
        
    }
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
//    GetDiscountCouponVC *disctountCounponVC=[[GetDiscountCouponVC alloc]init];
//    [self.navigationController pushViewController:disctountCounponVC animated:YES];
}
@end
