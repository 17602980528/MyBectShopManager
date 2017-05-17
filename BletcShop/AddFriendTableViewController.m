//
//  AddFriendTableViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AddFriendTableViewController.h"
#import "AddFriendCell.h"
#import "UIImageView+WebCache.h"
@interface AddFriendTableViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSArray *friendList;

@property(nonatomic,strong)UITextField *textFiled;
@end

@implementation AddFriendTableViewController

-(instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    return self;
}
-(NSArray *)friendList{
    if (!_friendList) {
        _friendList = [NSArray array];
    }
    return _friendList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 240;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorColor =[UIColor clearColor];
    
    LZDButton *rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 0, 40, 30);
    
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    rightBtn.block = ^(LZDButton *btn){
        NSLog(@"搜所");
        [self getData];
    };
    
    [self getRecommendFriendList];
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"搜所Return");
    [self getData];
    
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40+2*kWeChatPadding;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = RGB(224, 224, 224);
    UITextField *textFiled = [[UITextField alloc]initWithFrame:CGRectMake(kWeChatPadding, kWeChatPadding, kWeChatScreenWidth-2*kWeChatPadding, 40)];
    textFiled.backgroundColor = [UIColor whiteColor];
    textFiled.textColor = [UIColor blackColor];
    textFiled.font = [UIFont systemFontOfSize:15];
    textFiled.placeholder = @"输入要查找的好友";
    textFiled.delegate = self;
    textFiled.returnKeyType = UIReturnKeySearch;
    [view addSubview:textFiled];
    self.textFiled = textFiled;
    return view;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addFriendCellID"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddFriendCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.acceptBtn setTitle:@"添加" forState:UIControlStateNormal];
    cell.acceptBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cell.acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.acceptBtn setBackgroundColor:NavBackGroundColor];

    [cell.acceptBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    cell.acceptBtn.tag = indexPath.row;
    
    
    if (self.friendList.count!=0) {
        
           cell.titlelab.text = self.friendList[indexPath.row][@"nickname"];
        
        NSString *header_S = [[self.friendList[indexPath.row][@"account"] componentsSeparatedByString:@"_"] firstObject];
        

        
        if ([header_S isEqualToString:@"m"]) {

            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:self.friendList[indexPath.row][@"headimage"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"user"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"=%@==%@",cell.titlelab.text,[SHOPIMAGE_ADDIMAGE stringByAppendingString:self.friendList[indexPath.row][@"headimage"]]);

//        NSLog(@"-error---%@",error.description);
        
    }];
//            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[SHOPIMAGE_ADDIMAGE stringByAppendingString:self.friendList[indexPath.row][2]]] placeholderImage:[UIImage imageNamed:@"user"]];
            
        }else{
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[[HEADIMAGE stringByAppendingString:self.friendList[indexPath.row][@"headimage"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"user"]];
            NSLog(@"=%@==%@",cell.titlelab.text,[HEADIMAGE stringByAppendingString:self.friendList[indexPath.row][@"headimage"]]);

        }
        

        
    }
    
    
    
    return cell;
}
//添加好友
-(void)addFriend:(UIButton*)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"说点什么吧" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // 请求信息
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"";
    }];
    
    // 获取alert中的文本输入框
    UITextField *descriptionFiled = [alert.textFields lastObject];
    
    // 添加按钮
    UIAlertAction *comitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               // 如果附带信息输入为空,那么就自定义一个
        NSString *message = (descriptionFiled.text.length == 0)?@"我想加你":descriptionFiled.text;
        // 发送好友请求
        
        NSLog(@"=self.friendList[sender.tag]===%@",self.friendList[sender.tag]);
        [[EMClient sharedClient].contactManager addContact:self.friendList[sender.tag][@"account"] message:message completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                NSLog(@"添加成功");
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"添加失败");

            }
            
        }];
              
        
    }];
    // 取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    // 添加两个按钮
    [alert addAction:cancelAction];
    [alert addAction:comitAction];

    [self presentViewController:alert animated:YES completion:nil];
}
//获取好友数据
-(void)getData{
    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/search",BASEURL];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:self.textFiled.text forKey:@"account"];
    
    if ([self isPureInt:self.textFiled.text]) {
        [mdic setValue:@"phone" forKey:@"type"];
    }else{
        [mdic setValue:@"name" forKey:@"type"];

    }
    NSLog(@"=mdic==%@\n url = %@",mdic,url);
    [KKRequestDataService requestWithURL:url params:mdic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        self.friendList = (NSArray*)result;
        
        if (self.friendList.count!=0) {
            [self.tableView reloadData];

        }
        NSLog(@"result===%@",result);
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-error--%@",error.description);
    }];
    
}

//获取推荐好友列表
-(void)getRecommendFriendList{
    NSString *url = [NSString stringWithFormat:@"%@Extra/IM/getRec",BASEURL];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:appdelegate.userInfoDic[@"uuid"] forKey:@"account"];
    
       NSLog(@"=mdic==%@\n url = %@",mdic,url);
    [KKRequestDataService requestWithURL:url params:mdic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        self.friendList = (NSArray*)result;
        
        if (self.friendList.count!=0) {
            [self.tableView reloadData];
            
        }
        NSLog(@"result===%@",result);
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-error--%@",error.description);
    }];
    
}


/**
 *  判断是不是数字,是返回yes
 */
- (BOOL)isPureInt:(NSString *)string{
    
　　NSScanner* scan = [NSScanner scannerWithString:string];
　　int val;
　　return [scan scanInt:&val] && [scan isAtEnd];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
