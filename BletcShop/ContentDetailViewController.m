//
//  ContentDetailViewController.m
//  BletcShop
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ContentDetailViewController.h"

@interface ContentDetailViewController ()

@end

@implementation ContentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    float height= [self.content getTextHeightWithShowWidth:SCREENWIDTH-40 AndTextFont:[UIFont systemFontOfSize:16.0f] AndInsets:5];
    UILabel *label=[[UILabel alloc]init];
    label.bounds=CGRectMake(20, 0, SCREENWIDTH-40, height);
    label.layer.cornerRadius=5.0f;
    label.clipsToBounds=YES;
    label.textAlignment=1;
    label.center=self.view.center;
    label.numberOfLines=0;
    label.text=self.content;
    label.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:label];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
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
