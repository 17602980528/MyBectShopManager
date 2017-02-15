//
//  NewModelImageViewController.m
//  BletcShop
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewModelImageViewController.h"

@interface NewModelImageViewController ()
{
    UIImageView *imageView;
    UIScrollView *scrollView;
}
@end

@implementation NewModelImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"系统头像";
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-40, 20, 80, 80)];
    imageView.image=self.image;
    imageView.layer.borderWidth=1;
    imageView.layer.borderColor=[[UIColor grayColor]CGColor];
    [self.view addSubview:imageView];
    
    scrollView=[[UIScrollView alloc]init];
    if (SCREENHEIGHT==480) {
        scrollView.frame=CGRectMake(0, 120, SCREENWIDTH, 240);
    }else if (SCREENHEIGHT==568){
        scrollView.frame=CGRectMake(0, 120, SCREENWIDTH, 300);
    }else if (SCREENHEIGHT==667){
        scrollView.frame=CGRectMake(0, 130, SCREENWIDTH, 360);
    }else if (SCREENHEIGHT==736){
        scrollView.frame=CGRectMake(0, 130, SCREENWIDTH, 360);
    }
    scrollView.contentSize=CGSizeMake(SCREENWIDTH, 360);
    [self.view addSubview:scrollView];
    
    for (int i=0; i<30; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake((SCREENWIDTH-250)/6+i%5*((SCREENWIDTH-250)/6+50), i/5*60, 50, 50);
        
        NSString * imageName=[[NSString alloc]initWithFormat:@"头像-%d.png",(i+1)];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.tag=i;
        [button addTarget:self action:@selector(previousClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame=CGRectMake(SCREENWIDTH/2-100-10, scrollView.bottom+10, 100, 40);
    leftBtn.layer.borderWidth=0.6;
    leftBtn.layer.cornerRadius=8;
    [leftBtn setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
    leftBtn.layer.borderColor=[NavBackGroundColor CGColor];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame=CGRectMake(SCREENWIDTH/2+10, scrollView.bottom+10, 100, 40);
    [rightBtn setTitleColor:NavBackGroundColor forState:UIControlStateNormal];
    rightBtn.layer.borderWidth=0.6;
    rightBtn.layer.cornerRadius=8;
    rightBtn.layer.borderColor=[NavBackGroundColor CGColor];
    [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(certifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
}
-(void)previousClick:(UIButton *)sender{
    imageView.image=sender.currentImage;
}
-(void)cancelClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)certifyClick:(UIButton *)sender{
    //将选定的图像上传到服务器
    if ([_delegate respondsToSelector:@selector(changeUserImage:)]) {
        [_delegate changeUserImage:imageView.image];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
