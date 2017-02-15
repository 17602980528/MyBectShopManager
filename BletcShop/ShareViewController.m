//
//  ShareViewController.m
//  BletcShop
//
//  Created by Bletc on 16/8/15.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShareViewController.h"
//#import "UMSocial.h"
#import "QRcodeUIViewController.h"
@interface ShareViewController ()
{
    NSArray *array_p;
    
}



@end

@implementation ShareViewController

-(NSDictionary *)data_A{
    if (!_data_D) {
        _data_D = [[NSDictionary alloc]init];
    }
    return _data_D;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"推荐给好友";
   
    
    


    [self getData];
    
    

}

-(void)getData{
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/source/share",BASEURL];
    NSLog(@"---%@",url);
    

    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        self.data_D = (NSDictionary*)result;
        
//        [self _initSubViews];

        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
//-(void)_initSubViews{
//    
//    UIImageView *back_img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
//    back_img.image = [UIImage imageNamed:@"注册-01"];
//    [self.view addSubview:back_img];
//    
//    array_p = [NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina, nil];
//    NSArray *plat_A = @[@"二维码",@"微信好友",@"朋友圈",@"新浪微博"];
//    
//    for (int i = 0 ; i< plat_A.count; i ++) {
//        
//        
//        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [Btn setTitleColor:[UIColor blackColor] forState:0];
//        Btn.tag = i ;
//        [Btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:Btn];
//        
//        // 二维码
//        if (i==0) {
//            Btn.frame = CGRectMake(20, 66, 64, 68);
//            if (SCREENHEIGHT==667) {
//                Btn.frame = CGRectMake(20, 66+30, 64, 68);
//
//
//            }
//            if (SCREENHEIGHT==736) {
//                Btn.frame = CGRectMake(20,  66+50, 64, 68);
//
//                
//            }
//
//            [Btn setImage:[UIImage imageNamed:@"注册-04"] forState:UIControlStateNormal];
//            [Btn setImage:[UIImage imageNamed:@"注册-05"] forState:UIControlStateHighlighted];
//        }else if (i==1){
//            //微信好友
//            Btn.frame = CGRectMake(73, 135, 65, 64);
//            if (SCREENHEIGHT==667) {
//                Btn.frame = CGRectMake(83+10, 135+30, 65, 64);
//                
//            }
//            if (SCREENHEIGHT==736) {
//                Btn.frame = CGRectMake(90+10, 135+50, 65, 64);
//                
//            }
//
//            [Btn setImage:[UIImage imageNamed:@"注册-08"] forState:UIControlStateNormal];
//            [Btn setImage:[UIImage imageNamed:@"注册-09"] forState:UIControlStateHighlighted];
//        }else if (i==2){
//            //朋友圈
//            Btn.frame = CGRectMake(148, 76, 60, 59);
//            if (SCREENHEIGHT==667) {
//                Btn.frame = CGRectMake(175+10, 76+30, 60, 59);
//                
//            }
//            if (SCREENHEIGHT==736) {
//                Btn.frame = CGRectMake(193,  76+50, 60, 59);
//
//                
//            }
//
//            [Btn setImage:[UIImage imageNamed:@"注册-02"] forState:UIControlStateNormal];
//            [Btn setImage:[UIImage imageNamed:@"注册-03"] forState:UIControlStateHighlighted];
//        }
//        else if (i==3){
//            //新浪
//            Btn.frame = CGRectMake(214, 120, 61, 63);
//            if (SCREENHEIGHT==667) {
//                Btn.frame = CGRectMake(252+10,120+30, 61, 63);
//                
//            }
//            if (SCREENHEIGHT==736) {
//                Btn.frame = CGRectMake(277+10,120+50, 61, 63);
//                
//            }
//
//            [Btn setImage:[UIImage imageNamed:@"注册-06"] forState:UIControlStateNormal];
//            [Btn setImage:[UIImage imageNamed:@"注册-07"] forState:UIControlStateHighlighted];
//        }
//
//    }
//    
//    
//    
//}

//-(void)shareClick:(UIButton*)button{
//    
//    
//    NSLog(@"---%@===",_data_D);
//    
//
//    [UMSocialData defaultData].extConfig.title = [NSString getTheNoNullStr:_data_D[@"title"] andRepalceStr:@"分享的title"];
//
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//
//        NSString *codeString = [NSString stringWithFormat:@"%@?phone=%@",_data_D[@"link_add"],appdelegate.userInfoDic[@"phone"]];
//    
////   NSString *codeString = _data_D[0][0];
//    NSLog(@"-----%@",codeString);
//    
//    if (button.tag == 0) {
//        QRcodeUIViewController *VC= [[QRcodeUIViewController alloc]init];
//        [self.navigationController pushViewController:VC animated:YES];
//
//
//    }else  if (button.tag == 1) {
//        
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = codeString;
//
//    }else if (button.tag == 2) {
//
//        
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = codeString;
//
//
//    }else if (button.tag == 3) {
//
//        [UMSocialData defaultData].extConfig.sinaData.shareText=[NSString stringWithFormat:@"%@\n%@",_data_D[@"content"],codeString];
//
//    }
//
//   
//    NSLog(@"===%ld",button.tag);
//
//    
//    if (button.tag > 0 ) {
//        
//       UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_data_D[@"image"]]]];
//        
//        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:nil];
//        
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[array_p[button.tag]] content:_data_D[@"content"] image:image location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//        }];
//
//    }
//  
//}
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
