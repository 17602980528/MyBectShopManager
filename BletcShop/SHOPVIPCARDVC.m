//
//  SHOPVIPCARDVC.m
//  BletcShop
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "SHOPVIPCARDVC.h"
#import "GeneralCardSeriseListVC.h"
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
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return cardKindArray.count;
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIView *view=[cell.contentView viewWithTag:1];
    if (view==nil) {
        view=[[UIView alloc]initWithFrame:cell.contentView.bounds];
        view.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
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
    
    GeneralCardSeriseListVC* vc = [[GeneralCardSeriseListVC alloc] init];
    vc.titleDic=cardKindArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
