//
//  ChoseSeriesVC.m
//  BletcShop
//
//  Created by Bletc on 2017/5/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChoseSeriesVC.h"
#import "ChoseSeriesCellT.h"
#import "AddSeriesViewController.h"
@interface ChoseSeriesVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@end

@implementation ChoseSeriesVC

-(void)rightClcik{
    
    AddSeriesViewController *VC = [[AddSeriesViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择系列";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClcik)];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoseSeriesCellT *cell = [tableView dequeueReusableCellWithIdentifier:@"choseSeriesID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChoseSeriesCellT" owner:self options:nil] firstObject];
        
    }
    
    return cell;
    
    
}



@end
