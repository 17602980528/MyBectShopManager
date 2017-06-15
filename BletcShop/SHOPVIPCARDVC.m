//
//  SHOPVIPCARDVC.m
//  BletcShop
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "SHOPVIPCARDVC.h"
#import "GeneralCardSeriseListVC.h"
#import "TimeLimitCardHomeVC.h"//限时卡&体验卡
#import "PackageServiceVC.h"//套餐卡
@interface SHOPVIPCARDVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    NSArray *cardKindArray;
}
@end

@implementation SHOPVIPCARDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"会员卡管理";
    self.view.backgroundColor=[UIColor whiteColor];
    cardKindArray=@[@{@"imageName":@"money_1",@"cardName":@"储值卡"},@{@"imageName":@"count_1",@"cardName":@"计次卡"},@{@"imageName":@"parcel_1",@"cardName":@"套餐卡"},@{@"imageName":@"experience_1",@"cardName":@"体验卡"},@{@"imageName":@"timelimit_1",@"cardName":@"限时卡"}];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(145, 169);
    layout.sectionInset=UIEdgeInsetsMake(24, (SCREENWIDTH-290)/3, 0, (SCREENWIDTH-290)/3);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 6.0f;
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) collectionViewLayout:layout];
    collectionView.backgroundColor=[UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    
    [self postRequestGetCard];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return cardKindArray.count;
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIView *view=[cell.contentView viewWithTag:1];
    if (view==nil) {
        view=[[UIView alloc]initWithFrame:cell.contentView.bounds];
        view.backgroundColor = RGB(234,234,234);
        view.tag=1;
        view.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:view];
        
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(24, 36, view.frame.size.width-48, view.frame.size.height-72-24)];
        [view addSubview:imageView];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 145, 145, 24)];
        label.font=[UIFont systemFontOfSize:10.0f];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor whiteColor];
        [view addSubview:label];
    }
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *img=(UIImageView *)subView;
            img.image=[UIImage imageNamed:cardKindArray[indexPath.row][@"imageName"]];
        }
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *lab=(UILabel *)subView;
            lab.text=cardKindArray[indexPath.row][@"cardName"];
        }
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0||indexPath.row==1) {
        GeneralCardSeriseListVC* vc = [[GeneralCardSeriseListVC alloc] init];
        vc.titleDic=cardKindArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self showHint:@"技术人员正在努力中..."];
    }
   
}

//保存会员卡模板
-(void)postRequestGetCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/cardTempGet",BASEURL];
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *arr = [[NSArray alloc]init];
        arr = result;
        
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"CARDIMGTEMP"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
       
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
