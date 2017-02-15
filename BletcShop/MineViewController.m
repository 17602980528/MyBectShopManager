//
//  MineViewController.m
//  BletcShop
//
//  Created by wuzhengdong on 16/1/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MineViewController.h"
#import "Mygroup.h"
#import "Myitem.h"
#import "Mycell.h"
#import "CardVipController.h"
#import "MyOderController.h"
#import "MyPointController.h"
#import "MyMoneybagController.h"
#import "NoEvaluateController.h"
#import "FriendController.h"
#import "LookAgoController.h"
#import "LandingController.h"
#import "UserInfoViewController.h"
#import "MyMoneybagController.h"
#import "FavorateViewController.h"
#import "NoEvaluateController.h"
#import "RegisterController.h"//测试
#import "MyOderController.h"
#import "UIImageView+WebCache.h"
#import "MyCashCouponViewController.h"
#import "PointRuleViewController.h"
#import "EndOrBeginningViewController.h"

#import "UIButton+WebCache.h"

#import "ShareViewController.h"
#import "LZDBASEViewController.h"


//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>
#import "QRcodeUIViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *shareView;
    NSArray *array_p;

}
@property(nonatomic,weak)UITableView *Mytable;
@property(nonatomic,strong)NSMutableArray *data;
@property (nonatomic , strong) NSDictionary *data_D;//分享的数据

@end

@implementation MineViewController
-(NSDictionary *)data_A{
    if (!_data_D) {
        _data_D = [[NSDictionary alloc]init];
    }
    return _data_D;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.view.backgroundColor= [UIColor whiteColor];
    [self _initTable];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"signNotice" object:nil];
   
    [self getData];
    
   
    
}
-(void)getData{
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/source/share",BASEURL];
    NSLog(@"---%@",url);
    
    
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"------%@",result);
        self.data_D = (NSDictionary*)result;
        
        [self creatShareView];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

-(void)postRequestPoints
{
    //请求乐点数
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/accountGet",BASEURL];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:@"integral" forKey:@"type"];

    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        self.allPoint = [NSString getTheNoNullStr:result[@"integral"] andRepalceStr:@"0"];
        NSLog(@"%@", self.allPoint);
        [self.Mytable reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.allPoint = @"0";
    [self _loading];
    
}
-(void)_loading
{

    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
   
    if (appdelegate.IsLogin) {
        [self postRequestPoints];
    }else{
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:0];
        
        [self.Mytable reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
    }
      

}
//添加下部的TableView
-(void)_initTable
{
    UITableView *mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    mytable.dataSource = self;
    mytable.delegate = self;
    mytable.showsVerticalScrollIndicator = NO;
    mytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.Mytable = mytable;
    [self.view addSubview:mytable];
    
}
-(NSMutableArray *)data{
    _data=nil;
    if (_data==nil) {
        _data = [NSMutableArray array];
        
        //创建cell模型
        //零区
        Mygroup *group_header = [[Mygroup alloc] init];
        [_data addObject:group_header];

        
        //一区
        Myitem *item10 = [Myitem itemsWithImg:@"mine_vip_n" title:@"我的会员卡" vcClass:[CardVipController class]];
        Myitem *item11 = [Myitem itemsWithImg:@"mine_money_n" title:@"我的钱包" vcClass:[MyMoneybagController class]];
        
//        NSString *jifen = [[NSString alloc]initWithFormat:@"我的乐点(%@)",self.allPoint];
//
//        Myitem *item12 = [Myitem itemsWithImg:@"mine_m_n" title:jifen vcClass:[PointRuleViewController class]];
        
        Myitem *item13 = [Myitem itemsWithImg:@"mine_vou_n" title:@"我的代金券" vcClass:[MyCashCouponViewController class]];
        Myitem *item14 = [Myitem itemsWithImg:@"mine_cust_n" title:@"我的消费" vcClass:[MyOderController class]];
        
        Mygroup *group1 = [[Mygroup alloc] init];
        group1.items = @[item10,item11,item13,item14];
        [_data addObject:group1];

        
        //二区
        
        Myitem *item20 = [Myitem itemsWithImg:@"mine_collect_n" title:@"我的收藏" vcClass:[FavorateViewController class]];
        
        Myitem *item21 = [Myitem itemsWithImg:@"mine_ea_n" title:@"我的评价" vcClass:[NoEvaluateController class]];

        
        Mygroup *group2 = [[Mygroup alloc] init];
        group2.items = @[item20,item21];
        [_data addObject:group2];
        

        //三区
        
        Myitem *item30 = [Myitem itemsWithImg:@"mine_re_n" title:@"我的推荐" vcClass:[FriendController class]];
        Myitem *item31 = [Myitem itemsWithImg:@"mine_comm_n" title:@"乐社区" vcClass:[LZDBASEViewController class]];
        Myitem *item32 = [Myitem itemsWithImg:@"mine_inva_n" title:@"邀请好友使用" vcClass:[ShareViewController class]];
        Mygroup *group3 = [[Mygroup alloc]init];
        group3.items = @[item30,item31,item32];
        [_data addObject:group3];

       
      
    }
    
    return _data;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.data.count;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        Mygroup *group = self.data[section];
        return group.items.count;
 
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 106+20;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *cellIndentifier = @"cellIndentifier";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
        
        UIView *HeadView0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
        HeadView0.backgroundColor = NavBackGroundColor;//[UIColor whiteColor];
        [cell addSubview:HeadView0];
        
        UIView *HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 106)];
        HeadView.backgroundColor = NavBackGroundColor;//[UIColor whiteColor];
        [cell addSubview:HeadView];
        
        //    头像 名 字
        UIButton *headImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [headImage setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        headImage.frame = CGRectMake(12, 17, 72, 72);
        headImage.imageView.layer.cornerRadius = headImage.width/2;
        [headImage addTarget:self action:@selector(HeadImageAction) forControlEvents:UIControlEventTouchUpInside];
        headImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [HeadView addSubview:headImage];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 32, SCREENWIDTH-100, 20)];
        nameLabel.text = @"未登录";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font  =[UIFont systemFontOfSize:18];
        [HeadView addSubview:nameLabel];
        
//        UILabel *describe_lab = [[UILabel alloc]initWithFrame:CGRectMake(95, 62, SCREENWIDTH-100, 14)];
//        describe_lab.textColor = RGB(51,51,51);
//        describe_lab.font  =[UIFont systemFontOfSize:13];
//        describe_lab.text = @"个性签名未设置";
//
//        [HeadView addSubview:describe_lab];
        
        UIImageView *user_levelImg = [[UIImageView alloc]initWithFrame:CGRectMake(95, 62, 36, 15)];
      
        [HeadView addSubview:user_levelImg];


        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        if (appdelegate.IsLogin) {
            [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,[appdelegate.userInfoDic  objectForKey:@"headimage"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像.png"]];
            
            if ([[appdelegate.userInfoDic  objectForKey:@"user_level"] isEqualToString:@"VIP"]) {
                user_levelImg.image = [UIImage imageNamed:@"my_vip_n"];

            }else if ([[appdelegate.userInfoDic  objectForKey:@"user_level"] isEqualToString:@"SVIP"]){
                user_levelImg.image = [UIImage imageNamed:@"my_svip_n"];

            }
                
            nameLabel.text = [NSString getTheNoNullStr:appdelegate.userInfoDic[@"nickname"] andRepalceStr:@"未设置"];

//            NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
//            NSString *sign=[NSString getTheNoNullStr:[df objectForKey:@"specialSign"] andRepalceStr:@"未设置"];
//            describe_lab.text = sign;

        }

       
        
        
        return cell;
    }else{
        
    Mycell *cell = [Mycell cellForTableView:tableView];
    Mygroup *group = self.data[indexPath.section];
    Myitem *myItem = group.items[indexPath.row];
    cell.cellItem = myItem;
        
        if (group.items.count>0) {
            if (indexPath.row != group.items.count-1) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, cell.height-1, SCREENWIDTH, 1)];
                line.backgroundColor = RGB(234,234,234);
                [cell addSubview:line];
                
            }
 
        }
        
       return cell;
        
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        [self HeadImageAction];
    }else{
        
    
    Mygroup *group = self.data[indexPath.section];
    Myitem *item = group.items[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else
    {
        
        if ([item.vcClass isSubclassOfClass:[UIViewController class]]) {
            UIViewController *vc = [[item.vcClass alloc]init];
            vc.title = item.title;
            
            if ([vc isKindOfClass:[PointRuleViewController class]]) {
                
                PointRuleViewController *PointRuleView = [[PointRuleViewController alloc]init];
                PointRuleView.type = 99;
                [self.navigationController pushViewController:PointRuleView animated:YES];
                
            }else if([vc isKindOfClass:[ShareViewController class]]){

                    shareView.hidden = NO;

            }else{
                [self.navigationController pushViewController:vc animated:YES];

            }
            
            }
        }
    }
        
        

}

//头像的点击事件
-(void)HeadImageAction
{
    NSLog(@"头像");

    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (appdelegate.IsLogin) {
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc]init];
        
        [self.navigationController pushViewController:userInfoVC animated:YES];;
    }
    else{
        LandingController *LandVC = [[LandingController alloc]init];
        
        [self.navigationController pushViewController:LandVC animated:YES];;
    }
}

-(void)postRequestEvaluate
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/listGet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result==%@", result);
         
         NSMutableArray *evaluateArray = [result copy];
         if (evaluateArray.count>0) {
             [self startEvaluateView];
         }else{
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             //            hud.frame = CGRectMake(0, 64, 375, 667);
             // Set the annular determinate mode to show task progress.
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"无未评价订单", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             // Move to bottm center.
             //    hud.offset = CGPointMake(0.f, );
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
-(void)startEvaluateView{
    NoEvaluateController *controller = [[NoEvaluateController alloc]init];
    
    
    controller.title = @"未评价";
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)creatShareView{
    
    
//    array_p = [NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina, nil];
   
    
    
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    shareView.hidden= YES;
    shareView.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:0.7];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleClick)];
    [shareView addGestureRecognizer:tap];
    
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *curent_window = [windows lastObject];
    
    [curent_window addSubview: shareView];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-201, SCREENWIDTH, 201)];
    backview.backgroundColor = RGB(240,240,240);
    [shareView addSubview:backview];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, SCREENWIDTH, 14)];
    lable.text =@"分享到";
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = RGB(51,51,51);
    lable.textAlignment = NSTextAlignmentCenter;
    [backview addSubview:lable];
    NSArray *arr = @[@"扫一扫",@"微信好友",@"朋友圈",@"微博"];
    for (int i = 0; i < arr.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 0;
        if (SCREENWIDTH <= 320) {
            width = 50;
        }else{
            width = 63;

        }
        CGFloat bod = (SCREENWIDTH-18*2-width*4)/3;
        
        btn.tag = i;
        [btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(18+(width+bod)*i, 50, width, width);
        [btn setImage:[UIImage imageNamed:arr[i]] forState:0];
        [backview addSubview:btn];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(btn.left, btn.bottom+13, btn.width, 12)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = RGB(51,51,51);
        lab.font = [UIFont systemFontOfSize:12];
        lab.text  = arr[i];
        [backview addSubview:lab];
        
        
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, SCREENHEIGHT-49, SCREENWIDTH, 49);
    [button setTitle:@"取消" forState:0];
    [button setTitleColor:RGB(51,51,51) forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:button];
    
    
}
-(void)shareClick:(UIButton*)sender{
    
    shareView.hidden =YES;
    NSLog(@"---%@===",_data_D);
    
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    NSString *share_title = [NSString getTheNoNullStr:_data_D[@"title"] andRepalceStr:@"分享的title"];
    
    NSString *share_text =[NSString getTheNoNullStr:_data_D[@"content"] andRepalceStr:@"分享的text"];
    
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_data_D[@"image"]]]];

    
    UMShareWebpageObject *shareObj = [UMShareWebpageObject shareObjectWithTitle:share_title descr:share_text thumImage:image];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    
    NSString *codeString = [NSString stringWithFormat:@"%@?phone=%@",_data_D[@"link_add"],appdelegate.userInfoDic[@"phone"]];
    
    shareObj.webpageUrl = codeString;
    messageObj.shareObject = shareObj;
   
//    array_p = [[NSArray alloc]initWithObjects:@[[UMSocialPlatformType_QQ n]] count:4];
    
    
    //   NSString *codeString = _data_D[0][0];
    NSLog(@"-----%@",codeString);
    
    if (sender.tag == 0) {
        QRcodeUIViewController *VC= [[QRcodeUIViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }else  if (sender.tag == 1) {
        
        [self shareTo:UMSocialPlatformType_WechatSession withMessageObj:messageObj];


        
    }else if (sender.tag == 2) {
        
        
        
        [self shareTo:UMSocialPlatformType_WechatTimeLine withMessageObj:messageObj];


    }else if (sender.tag == 3) {
        
        
        messageObj.text = [NSString stringWithFormat:@"%@\n%@\n%@",share_title,share_text,codeString];
        
        UMShareImageObject *shareImgObj = [[UMShareImageObject alloc]init];
        [shareImgObj setShareImage:image];
        
        messageObj.shareObject = shareImgObj;
        
        
        [self shareTo:UMSocialPlatformType_Sina withMessageObj:messageObj];
        


    }
    
    
    NSLog(@"===%ld",sender.tag);
    
    
    
}

-(void)shareTo:(UMSocialPlatformType)platforeType withMessageObj:(UMSocialMessageObject*)messageObj{
    
    [[UMSocialManager defaultManager]shareToPlatform:platforeType messageObject:messageObj currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",result);
        }
    }];
    
}
-(void)cancleClick{
    shareView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)notice:(id)sender{
    NSDictionary *dic=[sender userInfo];
    NSLog(@"%@",dic[@"1"]);
    [self.Mytable reloadData];
}
-(void)dealloc{
    [shareView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
