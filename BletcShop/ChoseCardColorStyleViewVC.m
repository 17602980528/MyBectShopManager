//
//  ChoseCardColorStyleViewVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChoseCardColorStyleViewVC.h"

@interface ChoseCardColorStyleViewVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIButton *oldBtn;
    UIButton *otherOldbtn;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collection_View;
@property (weak, nonatomic) IBOutlet UIView *resetColorView;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *card_set_Img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetColor_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetColor_bottom;
@property (weak, nonatomic) IBOutlet UIView *scrollView_BG;
@property (weak, nonatomic) IBOutlet UIButton *changeColorBtn;

@end

@implementation ChoseCardColorStyleViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选卡";
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.itemSize = CGSizeMake((SCREENWIDTH-35)/2, (SCREENWIDTH-35)/2);
    flowlayout.minimumLineSpacing = 10;
    flowlayout.minimumInteritemSpacing =15;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collection_View.collectionViewLayout = flowlayout;
    
    [self.collection_View registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCellID"];
    

    self.resetColor_top.constant = SCREENHEIGHT;
    self.resetColor_bottom.constant = -SCREENHEIGHT;
    [self.view layoutIfNeeded];
    
    
    oldBtn = self.changeColorBtn;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.scrollView_BG.height)];
    
    [self.scrollView_BG addSubview:scrollView];
    

    for (int i = 0; i <6; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7+(61+15)*i, 20, 61, 61);
        btn.backgroundColor = RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        [btn addTarget:self action:@selector(setCardColor:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        scrollView.contentSize = CGSizeMake(btn.right+7, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(61-11, 61-11, -7, -7);
    
        [btn setImage:[UIImage imageNamed:@"abc_select"] forState:UIControlStateSelected];
        
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

        
        if (i==0) {
            btn.selected = YES;
            otherOldbtn = btn;
        }
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 11;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellID" forIndexPath:indexPath];
   
    cell.backgroundColor = RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    self.card_set_Img.backgroundColor = cell.backgroundColor;
[UIView animateWithDuration:0.5 animations:^{
   
    self.resetColor_top.constant = 0;
    self.resetColor_bottom.constant = 0;
    [self.view layoutIfNeeded];

}];
    
}
- (IBAction)cancleBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        
        self.resetColor_top.constant = SCREENHEIGHT;
        self.resetColor_bottom.constant = -SCREENHEIGHT;

        [self.view layoutIfNeeded];
    }];
    
}
- (IBAction)twoBtn:(UIButton *)sender {
    
    
    if (oldBtn !=sender) {
        
        oldBtn.backgroundColor = RGB(166,166,166);
        [oldBtn setTitleColor:RGB(255,255,255) forState:0];
        
        sender.backgroundColor = RGB(244,240,121);
        [sender setTitleColor:RGB(51,51,51) forState:0];
        oldBtn = sender;
    }
}

-(void)setCardColor:(UIButton*)sender{
    
    otherOldbtn.selected= NO;
    sender.selected = YES;
    otherOldbtn = sender;
    
    self.card_set_Img.backgroundColor  = sender.backgroundColor;
}


@end
