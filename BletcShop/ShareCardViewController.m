//
//  ShareCardViewController.m
//  BletcShop
//
//  Created by Bletc on 2016/11/2.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShareCardViewController.h"
#import "UIImageView+WebCache.h"
#import "ShareCardCell.h"
#import "shareCardModel.h"

@interface ShareCardViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIView *back_View;
    NSInteger index_m;

}
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong) NSArray *data_A;

@end

@implementation ShareCardViewController
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
        
    }
    return _data_A;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"共享会员卡";

        LZDButton *rightBtn = [LZDButton creatLZDButton];
        rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 20,40, 30);
    [rightBtn setTitle:@"添加" forState:0];
//    [rightBtn setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
//    [rightBtn setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    
    
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem=rightButton;
    
    
        rightBtn.block = ^(LZDButton *btn){
            UIAlertView *aletView = [[UIAlertView alloc]initWithTitle:@"设置共享人" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [aletView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            

            
            UITextField *nameField = [aletView textFieldAtIndex:0];
            nameField.placeholder = @"请输入共享人姓名";
            nameField.delegate = self;
            
            UITextField *phoneField = [aletView textFieldAtIndex:1];
            phoneField.placeholder = @"请输入共享人手机号";
            phoneField.keyboardType = UIKeyboardTypeNumberPad;
            phoneField.secureTextEntry = NO;
            phoneField.delegate = self;
            
            [aletView show];
            
        };
    
    [self creatSubViews];
    [self creatbackView];
    [self postRequest];

    
}
-(void)creatSubViews{
   
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource =self;
    tableView.rowHeight = 70;
    tableView.separatorStyle= UITableViewCellSeparatorStyleNone;

    self.tableView = tableView;
    [self.view addSubview:tableView];
    

}
#pragma mark UITableViewDelegate 和 UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data_A.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier= @"cellID";
    ShareCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ShareCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (self.data_A.count>0) {
        shareCardModel *model = [[shareCardModel alloc] initModelWithDictionary:self.data_A[indexPath.row]];
        ;
        cell.model = model;
//        cell.choseBtn.hidden = YES;
        cell.choseBtn.tag = indexPath.row;
        
       [cell.choseBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        ShareCardCell *cell = (ShareCardCell*)[tableView cellForRowAtIndexPath:indexPath];
        

        [self deleteClick:cell.choseBtn];
    }
}
-(void)deleteClick:(UIButton*)sender{
    NSLog(@"删除");
    
    index_m = sender.tag;
    
    UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该共享人?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    altview.tag = 999;
    
    [altview show];
    
    
}


//数据请求
-(void)postRequest
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/share_list",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"card_code"];
    [params setObject:self.card_dic[@"card_level"] forKey:@"card_level"];

    NSLog(@"pareamer==%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"share_list===%@",result);
        
        self.data_A = (NSArray*)result;
        [self.tableView reloadData];
        
        
        if (self.data_A.count==0) {
            back_View.hidden =NO;
            
            
        }else{
            back_View.hidden =YES;
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error.description);
    }];
    
}
-(void)creatbackView{
    back_View = [[UIView alloc]init];
    back_View.bounds= CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH);
    back_View.center = CGPointMake(SCREENWIDTH/2, (SCREENHEIGHT-64)/2-32);
    back_View.hidden= YES;
    [self.view addSubview:back_View];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3, SCREENWIDTH/3-50, SCREENWIDTH/3, SCREENWIDTH/3)];
    imgV.image = [UIImage imageNamed:@"tanhao"];
    [back_View addSubview:imgV];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgV.bottom, SCREENWIDTH, 30)];
    lab.text = @"您还没有设置共享人!";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font= [UIFont systemFontOfSize:15];
    [back_View addSubview:lab];
    
    
}
#pragma mark alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==999) {
        //删除共享人
        if (buttonIndex==1) {
            
            NSDictionary *dic = self.data_A[index_m];
            
            NSString *url = [NSString stringWithFormat:@"%@UserType/card/share_del",BASEURL];
            NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            
            [paramer setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
            [paramer setObject:dic[@"uuid"] forKey:@"share_id"];
            [paramer setObject:self.card_dic[@"merchant"] forKey:@"muid"];
            [paramer setObject:self.card_dic[@"card_code"] forKey:@"card_code"];
            [paramer setObject:self.card_dic[@"card_level"] forKey:@"card_level"];
            
            NSLog(@"pareamer==%@",paramer);
            
            [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                NSLog(@"result==%@",result);
                
                if ([result[@"result_code"] intValue]==1) {
                    
                    
                    [self postRequest];
                }
                
                
            } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        }

        
    }else{
        
        //添加共享人
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            UITextField *nameField = [alertView textFieldAtIndex:0];
            UITextField *phoneField = [alertView textFieldAtIndex:1];
            
            if (nameField.text.length==0||phoneField.text.length==0) {
                
            }else{
                
                
                
                NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/share",BASEURL];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                
                
                [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
                
                [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
                [params setObject:self.card_dic[@"card_code"] forKey:@"card_code"];
                [params setObject:self.card_dic[@"card_level"] forKey:@"card_level"];
                [params setObject:phoneField.text forKey:@"phone"];
                [params setObject:nameField.text forKey:@"name"];
                
                
                NSLog(@"pareamer==%@",params);
                [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                    NSLog(@"===%@",result);
                    if ([result[@"result_code"] intValue]==1) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        
                        hud.label.text = NSLocalizedString(@"设置成功", @"HUD message title");
                        hud.label.font = [UIFont systemFontOfSize:13];
                        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                        [hud hideAnimated:YES afterDelay:3.f];
                        [self postRequest];
                    }
                    
                    
                } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error.description);
                    
                    
                }];
                
            }
            
        }

    }
    
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
