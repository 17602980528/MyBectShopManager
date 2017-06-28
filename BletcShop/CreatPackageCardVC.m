//
//  CreatPackageCardVC.m
//  BletcShop
//
//  Created by apple on 2017/6/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CreatPackageCardVC.h"
#import "PublishPackageCardTableViewCell.h"
#import "ChooseProductVC.h"
#import "ChoiceCardPictureViewController.h"
#import "UIImageView+WebCache.h"
@interface CreatPackageCardVC ()<UITableViewDelegate,UITableViewDataSource,ChoiceCardDelegate,UITextFieldDelegate,ChooseProductVCDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    CGFloat tabelViewOffsetY;

}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headViewXib;
@property (strong, nonatomic) IBOutlet UITextField *cardNameTF;
@property (strong, nonatomic) IBOutlet UITextField *discountPrice;
@property (strong, nonatomic) IBOutlet UIView *headXib;
@property (strong, nonatomic) IBOutlet UIView *footXib;
@property (strong, nonatomic) IBOutlet UIView *footSectionXib;
@property (strong, nonatomic) IBOutlet UILabel *autoTotalMoney;

@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong,nonatomic)NSMutableArray *dataSourceArray;
@property (strong,nonatomic)NSDictionary *colorDic;
@property (nonatomic)NSInteger optionsum;
@property (weak, nonatomic) IBOutlet UILabel *placeHoderLab;//占位字符串

@property (weak, nonatomic) IBOutlet UITextView *text_View;//优惠内容


@end

@implementation CreatPackageCardVC
- (IBAction)chooseCardBtnClick:(id)sender {
    ChoiceCardPictureViewController *pictureView = [[ChoiceCardPictureViewController alloc]init];
    pictureView.delegate = self;
    [self.navigationController pushViewController:pictureView animated:YES];
}
- (IBAction)goNextVC:(id)sender {
    ChooseProductVC *chooseProductVC=[[ChooseProductVC alloc]init];
    chooseProductVC.delegate=self;
    chooseProductVC.normalArray=_dataSourceArray;
    chooseProductVC.recArray=_dataSourceArray;
    [self.navigationController pushViewController:chooseProductVC animated:YES];
}
- (IBAction)addPackageCardBtnClick:(id)sender {
    if ([_cardNameTF.text isEqualToString:@""]) {
        [self showTishi:@"请输入套餐卡名称" dele:nil cancel:nil operate:@"确认"];
    }else if ([_discountPrice.text isEqualToString:@""]){
        [self showTishi:@"请输入套餐卡优惠价格" dele:nil cancel:nil operate:@"确认"];
    }else if (_dataSourceArray.count==0){
         [self showTishi:@"请选择具体套餐项目" dele:nil cancel:nil operate:@"确认"];
    }else if(!_colorDic){
        [self showTishi:@"请选择套餐卡样式" dele:nil cancel:nil operate:@"确认"];
    }else if(_text_View.text.length ==0){
        [self showTishi:@"请输入套餐说明" dele:nil cancel:nil operate:@"确认"];

    }else{
        [self postRequestAddPackageCard];

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _optionsum=0;
    _dataSourceArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    headView.backgroundColor=RGB(235, 235, 235);
    
    _tableView.tableHeaderView=_headViewXib;
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
    footView.backgroundColor=[UIColor orangeColor];
    
    _tableView.tableFooterView=_footXib;
    _tableView.rowHeight=50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString   * CellIdentiferId =  @"PublishPackageCardCell";
        PublishPackageCardTableViewCell  * cell = [tableView  dequeueReusableCellWithIdentifier :CellIdentiferId];
        if (!cell){
            NSArray  * nibs = [[ NSBundle mainBundle ] loadNibNamed :@"PublishPackageCardTableViewCell" owner :self options :nil ];
            cell = [  nibs lastObject ];
        };
    NSDictionary *dic=[_dataSourceArray[indexPath.row] allValues][0];
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",PRODUCT_IMAGE,dic[@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [cell.productImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    cell.productName.text=dic[@"name"];
    cell.productPrice.text=[NSString stringWithFormat:@"%@元/次",dic[@"price"]];
    cell.countLable.text=[NSString stringWithFormat:@"%ld次",cell.productCount];
    
    [cell.decreseButton addTarget:self action:@selector(decreseProdcutCount:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton addTarget:self action:@selector(addProdcutCount:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)decreseProdcutCount:(UIButton *)sender{
    PublishPackageCardTableViewCell *cell=(PublishPackageCardTableViewCell *)sender.superview.superview;
    if (cell.productCount>1) {
        cell.productCount--;
    }
    [_tableView reloadData];
     [self receiveTotalPrice];
}
-(void)addProdcutCount:(UIButton *)sender{
    PublishPackageCardTableViewCell *cell=(PublishPackageCardTableViewCell *)sender.superview.superview;
    cell.productCount++;
    [_tableView reloadData];
     [self receiveTotalPrice];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headXib;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footSectionXib;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
#pragma mark --ChoiceCardDelegate
- (void)sendCardValue:(NSDictionary *)value
{
    _colorDic=[NSDictionary dictionaryWithDictionary:value];
    NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",SOURCECARD,value[@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self.cardImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)weChoosedPruductDic:(NSArray *)array{
    //
    [_dataSourceArray removeAllObjects];
    for (int i=0; i<array.count; i++) {
        [_dataSourceArray addObject:array[i]];
    }
    [_tableView reloadData];
    [self receiveTotalPrice];
}
-(void)postRequestAddPackageCard{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/MealCard/add",BASEURL];
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [parmer setValue:_cardNameTF.text forKey:@"name"];
    [parmer setValue:_colorDic[@"color"] forKey:@"template"];
    [parmer setValue:_discountPrice.text forKey:@"price"];
    [parmer setValue:[NSString stringWithFormat:@"%ld",(long)_optionsum] forKey:@"option_sum"];
    [parmer setValue:[NSString stringWithFormat:@"%lu",(unsigned long)_dataSourceArray.count] forKey:@"option_num"];

    NSMutableArray *optionsArray=[[NSMutableArray alloc]initWithCapacity:0];

    for (int i=0; i<_dataSourceArray.count; i++) {
        NSDictionary *dic=[_dataSourceArray[i] allValues][0];
        
        PublishPackageCardTableViewCell *cell = [_tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        NSDictionary *newDic=@{@"id":dic[@"id"],@"count":[NSString stringWithFormat:@"%ld",(long)cell.productCount]};
        [optionsArray addObject:newDic];
        

        
    }
     [parmer setValue:_text_View.text forKey:@"des"];
    NSString * jsonStr = [self arrayToJSONString:optionsArray];
    NSLog(@"%@",jsonStr);
     [parmer setValue:jsonStr forKey:@"options"];
    
    //[parmer setValue:appdelegate.shopInfoDic[@"muid"] forKey:@"indate"];
    NSLog(@"0-----%@",parmer);
    
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result===%@", result);
        if([result[@"result_code"]integerValue]==1){
            [self showTishi:@"恭喜您，发布会员卡成功！" dele:self cancel:nil operate:@"确认"];
        }
    
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error-----%@",error.description);
        
    }];
}
-(void)showTishi:(NSString *)mess dele:(id) delegate cancel:(NSString *)cancel operate:(NSString *)operate{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:mess message:nil delegate:delegate cancelButtonTitle:cancel otherButtonTitles:operate, nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)receiveTotalPrice{
    NSInteger totalMoney=0;
    for (int i=0; i<_dataSourceArray.count; i++) {
    PublishPackageCardTableViewCell *cell = [_tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    NSDictionary *dic=[_dataSourceArray[i] allValues][0];
        NSInteger price=[dic[@"price"]integerValue];
        NSInteger singlePrpductMoney=price*cell.productCount;
        totalMoney+=singlePrpductMoney;
    }
    _optionsum=totalMoney;
    self.autoTotalMoney.text=[NSString stringWithFormat:@"合计：%ld元",(long)totalMoney];
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        [_dataSourceArray removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
        [self receiveTotalPrice];
    }];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
    
}
- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGRect frame = [textView convertRect:textView.frame toView:self.view];
    
    CGFloat h =SCREENHEIGHT-(frame.origin.y+frame.size.height+64);
    tabelViewOffsetY =_tableView.contentOffset.y;
    
    if (h<216) {
        [UIView animateWithDuration:0.3 animations:^{
            [_tableView setContentOffset:CGPointMake(0,  tabelViewOffsetY+216-h)];
            
        }];
    }
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.3 animations:^{
        [_tableView setContentOffset:CGPointMake(0, tabelViewOffsetY)];
        
    }];
    if (textView.text.length>0) {
        
//        [self.cardInfo_dic setValue:textView.text forKey:@"content"];
        
    }
    
    
    
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length==0) {
        self.placeHoderLab.hidden = NO;
    }else{
        self.placeHoderLab.hidden = YES;
        
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
    }
    
    return YES;
}



@end
