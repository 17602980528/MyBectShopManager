//
//  AddAdminVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/30.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AddAdminVC.h"
#import "AddAdminCell.h"
#import "ValuePickerView.h"

@interface AddAdminVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *table_View;
    NSArray *sex_A;
    NSArray *admin_A;
}
@property(nonatomic,strong)NSArray *title_A;
@property (nonatomic,copy)NSString *clerkString;
@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic,strong)UITextField *nameText;
@property (nonatomic,strong)UITextField *passText;
@property (nonatomic,strong)UITextField *phoneText;
@property (nonatomic,copy)NSString *sexString;

@end

@implementation AddAdminVC

-(NSArray *)title_A{
    if (!_title_A) {
        _title_A = @[@"管理员帐号",@"密码",@"权限",@"性别",@"联系方式"];
    }
    return _title_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.navigationItem.title = @"添加管理员";

    if (self.editTag==1) {
        self.navigationItem.title = @"编辑管理员";

    }
    sex_A = @[@"男",@"女"];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"register"])
    {
        admin_A= @[@"经营者",@"店长",@"店员"];
    }else if([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"operator"])
    {
        admin_A= @[@"店长",@"店员"];
    }else if([[appdelegate.shopInfoDic objectForKey:@"privi"] isEqualToString:@"shopMg"])
    {
        admin_A= @[@"店员"];
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    
    
    table_View = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-64-10) style:UITableViewStylePlain];
    table_View.bounces= NO;
    table_View.separatorStyle = UITableViewCellSeparatorStyleNone;
    table_View.backgroundColor = [UIColor whiteColor];
    table_View.delegate = self;
    table_View.dataSource = self;
    
    [self.view addSubview:table_View];
    
    self.pickerView = [[ValuePickerView alloc]init];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.title_A.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddAdminCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddAdminCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textFileld.placeholder = @"";

    }
    
    cell.textFileld.tag = indexPath.row;
    cell.textFileld.keyboardType = UIKeyboardTypeEmailAddress;
    cell.title_lab.text= self.title_A[indexPath.row];
    if (indexPath.row ==0) {
        cell.textFileld.placeholder = @"请输入管理员帐号";

        cell.textFileld.text = [NSString getTheNoNullStr:self.edit_dic[@"account"] andRepalceStr:@""];
        self.nameText = cell.textFileld;
        
    }
    
    if (indexPath.row ==1) {
        cell.textFileld.text = [NSString getTheNoNullStr:self.edit_dic[@"passwd"] andRepalceStr:@""];
        cell.textFileld.placeholder = @"请输入密码";
        self.passText = cell.textFileld;

    }
    if (indexPath.row ==2) {
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        cell.textFileld.userInteractionEnabled = NO;
        cell.textFileld.placeholder = @"请选择权限";

            cell.textFileld.text = [NSString getTheNoNullStr:self.edit_dic[@"position"] andRepalceStr:@""];
        
        self.clerkString = cell.textFileld.text;
    }
    if (indexPath.row ==3) {
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        cell.textFileld.userInteractionEnabled = NO;
        cell.textFileld.placeholder = @"请选择性别";

        cell.textFileld.text = [NSString getTheNoNullStr:self.edit_dic[@"sex"] andRepalceStr:@""];

        
        self.sexString =cell.textFileld.text;

        
    }
    if (indexPath.row ==4) {
        cell.textFileld.text = [NSString getTheNoNullStr:self.edit_dic[@"phone"] andRepalceStr:@""];

        self.phoneText = cell.textFileld;

        cell.textFileld.placeholder = @"请输入手机号";
    }

    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    [self.view endEditing:YES];
    if (indexPath.row == 2) {
        self.pickerView.dataSource =admin_A;

    }
    
    if (indexPath.row == 3) {
        self.pickerView.dataSource =sex_A;
        
    }
    __weak typeof(self) weakSelf = self;

    if (indexPath.row ==2 ||indexPath.row==3) {
        self.pickerView.valueDidSelect = ^(NSString *value){
            
            AddAdminCell *cell = (AddAdminCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            cell.textFileld.text = [[value componentsSeparatedByString:@"/"] firstObject];
            if (indexPath.row==2) {
                weakSelf.clerkString= cell.textFileld.text;

            }
            if (indexPath.row==3) {
                weakSelf.sexString= cell.textFileld.text;
                
            }

            
        };
        
        
        [self.pickerView show];
    }
    
    
        
}

-(void)sureClick{
    [self.view endEditing:YES];
    NSLog(@"完成");
    
  
    
    
    if(self.nameText.text.length==0 )
    {

        
        [self tishi:@"请填写账号"];
    }else if(self.passText.text.length==0)
    {
        [self tishi:@"请填写密码"];

       
    }else if(self.clerkString.length==0)
    {
        [self tishi:@"请填加权限"];
        
        
    }else if(self.sexString.length==0)
    {
        [self tishi:@"请选择性别"];
        
        
    }else if(self.phoneText.text.length==0)
    {
        [self tishi:@"请填写联系方式"];

       
    }else{
        if (self.editTag ==1) {
            [self postRequestEditAdmin];
        }
        if (self.editTag ==0) {
            [self postAddAdmin];

        }

    }
    
    
}

/**
 编辑管理员信息
 */
-(void)postRequestEditAdmin
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/admin/mod",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:self.nameText.text forKey:@"account"];
    [params setObject:self.passText.text forKey:@"passwd"];
    [params setObject:self.sexString forKey:@"sex"];
    
    if ([self.clerkString isEqualToString:@"经营者"]) {
        [params setObject:@"operator" forKey:@"privi"];
    }else if ([self.clerkString isEqualToString:@"店长"]) {
        [params setObject:@"shopMg" forKey:@"privi"];
    }else if ([self.clerkString isEqualToString:@"店员"]) {
        [params setObject:@"shopAs" forKey:@"privi"];
    }
    [params setObject:self.clerkString forKey:@"position"];
    [params setObject:self.phoneText.text forKey:@"phone"];
    [params setObject:self.edit_dic[@"account"] forKey:@"eaccount"];
    
    NSLog(@"paremer==%@", params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result==%@", result);
        NSDictionary *result_dic = (NSDictionary*)result;
        if ([result_dic[@"result_code"] intValue]==1) {
        
            
            [self tishi:@"修改成功"];
            [self performSelector:@selector(popView) withObject:nil afterDelay:1];
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(void)postAddAdmin{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/admin/add",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:self.nameText.text forKey:@"account"];
    [params setObject:self.passText.text forKey:@"passwd"];
    [params setObject:self.sexString forKey:@"sex"];
    
    if ([self.clerkString isEqualToString:@"经营者"]) {
        [params setObject:@"operator" forKey:@"privi"];
    }else if ([self.clerkString isEqualToString:@"店长"]) {
        [params setObject:@"shopMg" forKey:@"privi"];
    }else if ([self.clerkString isEqualToString:@"店员"]) {
        [params setObject:@"shopAs" forKey:@"privi"];
    }
    [params setObject:self.clerkString forKey:@"position"];
    
    [params setObject:self.phoneText.text forKey:@"phone"];
    
    NSLog(@"----paramer==%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {

        NSLog(@"postRequestAddAdmin==%@", result);
        NSDictionary *result_dic = (NSDictionary*)result;


        if ([result_dic[@"result_code"]intValue]==1) {
         
            
            [self tishi:@"添加成功"];
            [self performSelector:@selector(popView) withObject:nil afterDelay:1];


            
        }
        else
        {
            [self tishi:@"添加出错,请重新添加"];

        }

    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"%@", error);
        [self tishi:@"添加出错,请重新添加"];
        
        
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)popView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadAPI)]) {
        [self.delegate reloadAPI];
        
    }

    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)tishi:(NSString*)ts{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.frame = CGRectMake(0, 64, 375, 667);
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(ts, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, );
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:1.f];

}
@end
