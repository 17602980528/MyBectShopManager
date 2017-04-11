//
//  OtherApplyViewController.m
//  BletcShop
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "OtherApplyViewController.h"
#import "UIImageView+WebCache.h"
#import "LZDButton.h"
@interface OtherApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    LZDButton *current_btn;
}
@property (nonatomic,strong)NSArray *applyArray;
@end

@implementation OtherApplyViewController
{
    UITableView *_tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"店铺申请列表";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [self postApplyRequest];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.applyArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 7, 50, 50)];
        imageView.tag=100;
        [cell addSubview:imageView];
        
        UILabel *shopNameLable=[[UILabel alloc]initWithFrame:CGRectMake(70, 7, SCREENWIDTH-60-60-70-5, 50)];
        shopNameLable.font=[UIFont systemFontOfSize:17.0f];
        shopNameLable.numberOfLines = 2;
        shopNameLable.tag=200;
        
        [cell addSubview:shopNameLable];
        
        
        
        LZDButton *confuse_Btn=[LZDButton creatLZDButton];
        confuse_Btn.frame=CGRectMake(SCREENWIDTH-60-60, 32-15, 50, 30);
        [confuse_Btn setTitle:@"拒绝" forState:UIControlStateNormal];
        confuse_Btn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [confuse_Btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        confuse_Btn.backgroundColor = [UIColor whiteColor];
        confuse_Btn.layer.cornerRadius = 3;
        confuse_Btn.layer.borderWidth =1;
        confuse_Btn.layer.borderColor = RGB(153,153,153).CGColor;
        confuse_Btn.layer.masksToBounds= YES;
        confuse_Btn.tag=301;

        [cell addSubview:confuse_Btn];
        
        
        LZDButton *agreeBtn=[LZDButton creatLZDButton];
        agreeBtn.frame=CGRectMake(SCREENWIDTH-60, 32-15, 50, 30);
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        agreeBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [agreeBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        agreeBtn.backgroundColor = RGB(241,122,18);
        agreeBtn.layer.cornerRadius = 3;
        agreeBtn.layer.borderWidth =1;
        agreeBtn.layer.borderColor = RGB(153,153,153).CGColor;
        agreeBtn.layer.masksToBounds= YES;

        [cell addSubview:agreeBtn];
        agreeBtn.tag=300;


    }
    LZDButton *agree_button=(LZDButton*)[cell viewWithTag:300];
    agree_button.row=indexPath.row;
    agree_button.section=1;
    
    [agree_button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    LZDButton *confuse_button=(LZDButton*)[cell viewWithTag:301];
    confuse_button.row=indexPath.row;
    confuse_button.section = 0;
    [confuse_button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    

    
    UILabel *label=[cell viewWithTag:200];
    label.text=self.applyArray[indexPath.row][@"store"];
    
    UIImageView *imageView=[cell viewWithTag:100];
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[[self.applyArray objectAtIndex:indexPath.row] objectForKey:@"image_url"] andRepalceStr:@"asda"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/**
 获取申请里列表
 */
-(void)postApplyRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/appGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.shopInfoDic[@"phone"] forKey:@"phone"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        
        self.applyArray = [result copy];
        
        if (_tableView) {
            [_tableView reloadData];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(void)btnAction:(LZDButton*)sender{
    
    current_btn = sender;
    
    if (sender.section ==0) {
        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要拒绝该店铺的管理申请?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        altView.tag = sender.row;
        [altView show];

    }
    if (sender.section ==1) {
        
        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定同意该店铺的管理申请?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        altView.tag = sender.row;
        [altView show];
    }
}
/**
 不同意管理店铺
 */
-(void)noAgreeBtnAction:(LZDButton *)btn
{
    
    NSDictionary*dic = [self.applyArray objectAtIndex:btn.row];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/set",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:appdelegate.shopInfoDic[@"phone"] forKey:@"phone"];
    
    [params setObject:@"fail" forKey:@"state"];
    [params setObject:dic[@"muid"] forKey:@"store"];
    
    DebugLog(@"params==no=%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        
        DebugLog(@"result=====%@",result);
        if ([result[@"result_code"] intValue]==1) {
            
            
            [self tishi:@"拒绝管理"];
            
            [self postApplyRequest];
            
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

/**
 同意管理店铺
 */
-(void)agreeBtnAction:(LZDButton *)btn
{
    
  
    
    
    NSDictionary *dic = [self.applyArray objectAtIndex:btn.row];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/store/set",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:appdelegate.shopInfoDic[@"phone"] forKey:@"phone"];
    [params setObject:@"access" forKey:@"state"];
    [params setObject:dic[@"muid"] forKey:@"store"];
    
    DebugLog(@"params==yes=%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        DebugLog(@"result==yes=%@",result);
        
        if ([result[@"result_code"] intValue]==1) {
            [self tishi:@"同意管理"];

            [self postApplyRequest];
            
        }else if([result[@"result_code"] integerValue]==1062){
            
            [self tishi:@"数据重复!"];

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        if (current_btn.section==1) {
            
            [self agreeBtnAction:current_btn];
        }
        if (current_btn.section==0) {
            [self noAgreeBtnAction:current_btn];

        }

    }
    
}

-(void)tishi:(NSString*)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:3.f];
    
}



@end
