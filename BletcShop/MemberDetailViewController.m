//
//  memberDetailViewController.m
//  BletcShop
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "LZDChartViewController.h"
@interface MemberDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *data_Dic;
    NSArray *headArr;
}
@end

@implementation MemberDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"会员详情";
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-40, 10, 80, 80)];
    imageView.layer.cornerRadius=40;
    imageView.clipsToBounds=YES;
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    NSString *imgStr =[[self.array objectAtIndex:self.index] objectForKey:@"headimage"];
    

    

    NSURL * nurl1=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:imgStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"mhead_default.png"] options:SDWebImageRetryFailed];
    [self.view addSubview:imageView];
    data_Dic=[[NSDictionary alloc]init];
    headArr=@[@"昵称：",@"性别：",@"电话：",@"卡号：",@"会员卡级别：",@"地址：",@"会员卡余额：",@""];
    data_Dic =[self.array objectAtIndex:self.index];
    //    DebugLog(@"self.array----%@",dataArr);
    
    UITableView *tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 90, SCREENWIDTH, SCREENHEIGHT-90-49) style:UITableViewStylePlain];
    tabView.dataSource=self;
    tabView.delegate=self;
    tabView.bounces=NO;
    tabView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tabView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data_Dic.allKeys.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row==data_Dic.allKeys.count-1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50, 5, SCREENWIDTH-100, 44-10);
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.backgroundColor = NavBackGroundColor;
        [btn setTitle:@"联系用户" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(connectClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
    }else{
        
        NSString *headStr = headArr[indexPath.row];
        if (indexPath.row==0) {
            NSString *lastStr = data_Dic[@"user"];
            
            NSString *newStr=[NSString stringWithFormat:@"%@%@",headStr,lastStr];
            cell.textLabel.text=newStr;
            
        }
        if (indexPath.row==1) {
            NSString *lastStr = data_Dic[@"sex"];
            
            NSString *newStr=[NSString stringWithFormat:@"%@%@",headStr,lastStr];
            cell.textLabel.text=newStr;
            
        } if (indexPath.row==2) {
            NSString *lastStr = data_Dic[@"phone"];
            
            NSString *newStr=[NSString stringWithFormat:@"%@%@",headStr,lastStr];
            cell.textLabel.text=newStr;
            
        } if (indexPath.row==3) {
            NSString *lastStr = data_Dic[@"card_code"];
            
            NSString *newStr=[NSString stringWithFormat:@"%@%@",headStr,lastStr];
            cell.textLabel.text=newStr;
            
        } if (indexPath.row==4) {
            NSString *lastStr = data_Dic[@"card_level"];
            
            NSString *newStr=[NSString stringWithFormat:@"%@%@",headStr,lastStr];
            cell.textLabel.text=newStr;
            
        }
        if (indexPath.row==5) {
            NSString *lastStr = data_Dic[@"address"];
            
            NSString *newStr=[NSString stringWithFormat:@"%@%@",headStr,lastStr];
            cell.textLabel.text=newStr;
            
        }else if (indexPath.row==6){
            NSString *lastStr=data_Dic[@"remain"];
            
            NSString *newStr=[NSString stringWithFormat:@"%@%@",headStr,lastStr];
            cell.textLabel.text=newStr;
        }
        
    }
    return cell;
}

-(void)connectClick{
    NSLog(@"data_Dic--%@",data_Dic);
    

        LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
        [chatCtr setHidesBottomBarWhenPushed:YES];
        chatCtr.username = data_Dic[@"uuid"];
        
        NSLog(@"chatCtr.username---%@",chatCtr.username);
        chatCtr.title = data_Dic[@"user"];
        chatCtr.chatType = EMChatTypeChat;
        
            [self.navigationController pushViewController:chatCtr animated:YES];

    
 

}



@end
