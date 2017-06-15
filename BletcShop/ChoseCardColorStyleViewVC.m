//
//  ChoseCardColorStyleViewVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChoseCardColorStyleViewVC.h"

@interface ChoseCardColorStyleViewVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collection_View;

@end

@implementation ChoseCardColorStyleViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选卡";
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.itemSize = CGSizeMake((SCREENWIDTH-30)/2, (SCREENWIDTH-30)/2);
    flowlayout.minimumLineSpacing = 10;
    flowlayout.minimumInteritemSpacing =10;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collection_View.collectionViewLayout = flowlayout;
    
    [self.collection_View registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCellID"];
    

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 20;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellID" forIndexPath:indexPath];
   
    cell.backgroundColor = [UIColor redColor];
    return cell;
}




@end
