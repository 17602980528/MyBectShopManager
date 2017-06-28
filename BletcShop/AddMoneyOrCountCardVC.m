//
//  AddMoneyOrCountCardVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddMoneyOrCountCardVC.h"
#import "AddMoneyOrCountCell.h"
#import "ValuePickerView.h"
#import "ChoiceCardPictureViewController.h"
#import "UIImageView+WebCache.h"

#import "ChoseCardColorStyleViewVC.h"

@interface AddMoneyOrCountCardVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,ChoiceCardDelegate>{
    UIButton *oldbtn;
    
   CGFloat tabelViewOffsetY;
}
@property (weak, nonatomic) IBOutlet UITableView *table_View;
@property(nonatomic,strong)NSMutableDictionary *title_Dic;
@property(nonatomic,strong)NSMutableDictionary *placeHoder_Dic;
@property (nonatomic , strong) NSMutableDictionary *cardInfo_dic;// 会员卡的信息,添加修改会员卡时用来保存会员卡信息

@property(nonatomic,strong)NSArray *title_A;
@property(nonatomic,assign)BOOL giveIf;
//优惠内容
@property (strong, nonatomic) IBOutlet UIView *contentHeaderView;
@property (weak, nonatomic) IBOutlet UITextView *text_View;
@property (weak, nonatomic) IBOutlet UILabel *textPlacehoder;
@property (weak, nonatomic) IBOutlet UIImageView *cardImgType;//卡的模板
@property (strong, nonatomic) IBOutlet UIView *cardimgheaderView;
@property (nonatomic, strong) ValuePickerView *pickerView;
@property (nonatomic , strong) NSArray *deadLine_A;//有效期数组

@property (nonatomic , strong) NSDictionary *deadLine_dic;// <#Description#>
@property (nonatomic , strong) NSDictionary *lineDead_dic;// <#Description#>

@property (nonatomic,strong)NSArray *levelArray;


@end

@implementation AddMoneyOrCountCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@",self.whoPush,self.cardTypeName];
   

    self.pickerView = [[ValuePickerView alloc]init];
    
    
    self.giveIf = [_card_dic[@"addition_sum"] boolValue];
    
    if ([self.whoPush isEqualToString:@"编辑"]) {
        self.text_View.text =_card_dic[@"content"];
        self.textPlacehoder.hidden = self.text_View.text.length ? YES:NO;
        self.cardImgType.image = [UIImage imageNamed:@""];
        self.cardImgType.backgroundColor = [UIColor colorWithHexString:_card_dic[@"card_temp_color"]];
        
   
        NSArray *cardTemp_A = [[NSUserDefaults standardUserDefaults]objectForKey:@"CARDIMGTEMP"];
        
        for (NSDictionary *tim_dic in cardTemp_A) {
            if ([tim_dic[@"color"] isEqualToString:_card_dic[@"card_temp_color"]]) {
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:tim_dic[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                
                [self.cardImgType sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
                self.cardImgType.backgroundColor = [UIColor whiteColor];

                break ;
            }
        }

        
        
        [self.cardInfo_dic setValue:_card_dic[@"addition_sum"] forKey:@"addition"];
        [self.cardInfo_dic setValue:_card_dic[@"level"] forKey:@"level"];
        [self.cardInfo_dic setValue:_card_dic[@"level"] forKey:@"new_level"];

        [self.cardInfo_dic setValue:_card_dic[@"price"] forKey:@"price"];
        [_cardInfo_dic setObject:self.card_dic[@"merchant"] forKey:@"muid"];
        [self.cardInfo_dic setValue:_card_dic[@"indate"] forKey:@"indate"];
        [self.cardInfo_dic setValue:_card_dic[@"content"] forKey:@"content"];

        [self.cardInfo_dic setValue:_card_dic[@"card_temp_color"] forKey:@"card_temp_color"];
        [self.cardInfo_dic setValue:_card_dic[@"rule"] forKey:@"rule"];


    }
    

    self.table_View.estimatedRowHeight = 100;
    self.table_View.rowHeight = UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 11;
    }else if(section==1){
        return self.text_View.bottom+11;
    }else if(section ==2){
        return self.cardimgheaderView.height;
    }
        return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.title_A.count;
        
    }else
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        AddMoneyOrCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMoneyOrCountCellID"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddMoneyOrCountCell" owner:self options:nil]firstObject];
        }
    
        /****************  控件的显示与隐藏 **********************/
        cell.textTF.delegate = self;
        cell.textTF.tag = indexPath.row;

        cell.titleLab.text = _title_A[indexPath.row];
        cell.textTF.placeholder = [self.placeHoder_Dic objectForKey:[NSString stringWithFormat:@"%d",self.giveIf]][indexPath.row];
        
        if (indexPath.row ==1 ||indexPath.row ==_title_A.count-1) {
            cell.xiaojiantou.hidden = NO;
        }else{
           
            cell.xiaojiantou.hidden = YES;
        }

       
        cell.unitLab.hidden= indexPath.row==3?NO:YES;
        
        if ([self.cardTypeName isEqualToString:@"计次卡"]) {
            cell.unitLab.text = @"次";
        }else{
            cell.unitLab.text = @"%";

        }
        
        if (indexPath.row==4) {
            cell.btnBackView.hidden =NO;
            cell.textTF.hidden = YES;
            cell.btn_yes.selected = _giveIf;
            cell.btn_no.selected = !_giveIf;

            [cell.btn_yes addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_no addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (!oldbtn && !_giveIf) {
                oldbtn = cell.btn_no;

            }else{
                oldbtn = cell.btn_yes;
 
            }

        
        }else{
            cell.btnBackView.hidden =YES;
            cell.textTF.hidden = NO;

        }
        /*********************** 根据数据赋值 **********************/

        
       
        
        if (indexPath.row==0) {
            cell.textTF.text = self.series_dic[@"series_name"];
        }else if(indexPath.row==1){
            cell.textTF.text = self.cardInfo_dic[@"level"];

        }else if(indexPath.row==2){
            cell.textTF.text = self.cardInfo_dic[@"price"];
            
        }else if(indexPath.row==3){
            cell.textTF.text = self.cardInfo_dic[@"rule"];
            
        }else if( _giveIf && indexPath.row==5){
            cell.textTF.text = [self.cardInfo_dic[@"addition"] intValue]? self.cardInfo_dic[@"addition"]:@"";
            
        }else if (indexPath.row == _title_A.count-1){
            cell.textTF.text = self.lineDead_dic[self.cardInfo_dic[@"indate"]];

        }
        
        
        
        
        
        
        return cell;
    }else{
        return nil;

    }

    
   
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return self.contentHeaderView;
    }else if(section ==2){
        return self.cardimgheaderView;
    }else
        return nil;
}
//选择卡的样式
- (IBAction)selectCardImgType:(UITapGestureRecognizer *)sender {
    PUSH(ChoiceCardPictureViewController);
    vc.delegate = self;
    
    
//    PUSH(ChoseCardColorStyleViewVC)

    
}
#pragma mark ChoiceCardDelegate
-(void)sendCardValue:(NSDictionary *)value{
    NSLog(@"=====%@",value);
    [_cardInfo_dic setValue:value[@"color"] forKey:@"card_temp_color"];
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:value[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    [self.cardImgType sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
}
//是否附赠金额
-(void)btnClick:(UIButton*)btn{
    NSLog(@"------%d",_giveIf);
    if (oldbtn !=btn) {
       
        
        if (btn.tag ==0) {
            self.giveIf = YES;
            //附赠金额
            self.title_A = self.title_Dic[@"1"];
        }else{
            self.giveIf = NO;
            _title_A = _title_Dic[@"0"];
            [_cardInfo_dic setValue:@"0" forKey:@"addition"];
          
            //不附赠金额
        }
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:0];
        
        [_table_View reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
        
    
        
        oldbtn = btn;

    }
}
//完成添加
- (IBAction)sureBtnClick:(id)sender {
    NSLog(@"_cardInfo_dic===%@", _cardInfo_dic);
/**
 muid = m_d7c116a9cc,
	content = 测试结果是什么鬼,
	indate = 0.5,
 
	addition = 10,
	code = vipc_58babbfcad,
	level = 金卡,
 
	price = 200,
	image_type = 1,
	color = #dad6c0,
 
	type = 储值卡,
	rule = 99
 
 
 
 
 muid = m_d7c116a9cc,
	content = 哦泼猴,
	indate = 0,
	addition = 0,
	code = vipc_58babbfcad,
	level = 银卡,
	price = 300,
	image_type = 1,
	color = #cccdce ,
	type = 储值卡,
	rule = 95
 
 
 
 */
    
    if (!_cardInfo_dic[@"level"]) {
        [self showHint:@"请选择会员卡级别"];
    }else if (!_cardInfo_dic[@"price"]){
        [self showHint:@"请输入会员卡价格"];

    }else if (!_cardInfo_dic[@"rule"]){
        if ([self.cardTypeName isEqualToString:@"计次卡"]) {
            [self showHint:@"请输入可使用次数"];

        }else{
            [self showHint:@"请输入会员卡折扣率"];

        }
        
    }else if (!_cardInfo_dic[@"indate"]){
        [self showHint:@"请选择会员卡有效期"];
        
    }else if (!_cardInfo_dic[@"content"]){
        [self showHint:@"请输入优惠内容"];
        
    }else if (!_cardInfo_dic[@"card_temp_color"]){
        [self showHint:@"请选择板式"];
        
    }else{
        
        if ([self.cardTypeName isEqualToString:@"储值卡"]) {
            
            if (0 <[_cardInfo_dic[@"rule"] intValue] &&[_cardInfo_dic[@"rule"] intValue]<=100) {
                [self postRequestAddCard];

            }else{
                [self showHint:@"请输入1-100的整数"];
            }
            
        }else{
            [self postRequestAddCard];
            
        }
        
    }


    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==0 || textField.tag==1 || textField.tag ==_title_A.count-1) {
        __block typeof(self) blockSelf = self;
        if (textField.tag==1) {
            self.pickerView.dataSource =self.levelArray;
            _pickerView.valueDidSelect = ^(NSString *value) {
                textField.text = [[value componentsSeparatedByString:@"/"] firstObject];
                
                if ([blockSelf.whoPush isEqualToString:@"编辑"]) {
                    [blockSelf.cardInfo_dic setValue:textField.text forKey:@"new_level"];

                }else{
                    [blockSelf.cardInfo_dic setValue:textField.text forKey:@"level"];

                }
                
            };

            
        }else if (textField.tag ==_title_A.count-1){
            self.pickerView.dataSource = self.deadLine_A;
            _pickerView.valueDidSelect = ^(NSString *value) {
                textField.text = [[value componentsSeparatedByString:@"/"] firstObject];
                
                [blockSelf.cardInfo_dic setValue:blockSelf.deadLine_dic[textField.text] forKey:@"indate"];

            };

           
        }
        if (textField.tag!=0) {
                      [_pickerView show];
            
            [self.view endEditing:YES];
        }
       

        return NO;
    }else{
        
        return YES;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==2) {
        [self.cardInfo_dic setValue:textField.text forKey:@"price"];
   
    }
    if (textField.tag==3) {
        [self.cardInfo_dic setValue:textField.text forKey:@"rule"];
        
    }
    if (_giveIf && textField.tag==5) {
        [self.cardInfo_dic setValue:[NSString stringWithFormat:@"%d",[textField.text intValue]] forKey:@"addition"];
        
    }
    
    NSLog(@"textField.text----%@",textField.text);
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
   CGRect frame = [textView convertRect:textView.frame toView:self.view];
    
    CGFloat h =SCREENHEIGHT-(frame.origin.y+frame.size.height+64);
    tabelViewOffsetY =_table_View.contentOffset.y;
   
    if (h<216) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.table_View setContentOffset:CGPointMake(0,  tabelViewOffsetY+216-h)];
 
        }];
    }
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.table_View setContentOffset:CGPointMake(0, tabelViewOffsetY)];

    }];
    if (textView.text.length>0) {
        [self.cardInfo_dic setValue:textView.text forKey:@"content"];

    }
    


}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length==0) {
        self.textPlacehoder.hidden = NO;
    }else{
        self.textPlacehoder.hidden = YES;

    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (IBAction)endEditClick:(UITapGestureRecognizer *)sender {
    [self.view endEditing: YES];

}


#pragma mark 数据加载请求
-(void)postRequestAddCard
{
    NSString *url;
    if ([_cardTypeName isEqualToString:@"计次卡"]) {
        url= [[NSString alloc]initWithFormat:@"%@MerchantType/CountCard/add",BASEURL];
        if ([self.whoPush isEqualToString:@"编辑"]) {
            url = [[NSString alloc]initWithFormat:@"%@MerchantType/CountCard/mod",BASEURL];
          

        }

    }else{
        url= [[NSString alloc]initWithFormat:@"%@MerchantType/ValueCard/add",BASEURL];
        if ([self.whoPush isEqualToString:@"编辑"]) {
            url = [[NSString alloc]initWithFormat:@"%@MerchantType/ValueCard/mod",BASEURL];
           
        }
    }
    
    
    
    
    [KKRequestDataService requestWithURL:url params:_cardInfo_dic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"url=%@==result=%@", url,result);
        if ([result[@"result_code"]intValue]==1) {
            
            if ([self.whoPush isEqualToString:@"编辑"]) {
                [self showHint:@"修改成功"];

            }else{
                [self showHint:@"添加成功"];
                
            }
            self.block();
            
            [self.navigationController popViewControllerAnimated:YES];
        }else if([result[@"result_code"]intValue]==0){
            
            if ([self.whoPush isEqualToString:@"编辑"]) {
                [self showHint:@"修改成功"];
                
            }
            self.block();

            [self.navigationController popViewControllerAnimated:YES];
            
        }else if([result[@"result_code"]intValue]==1062){
            
            [self showHint:@"重复添加,请选择其他级别"];
        }else {
            
                [self showHint:@"请求失败"];
                
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

#pragma mark 懒加载

-(NSArray*)deadLine_A{
    if (!_deadLine_A) {
        _deadLine_A = @[@"半年",@"一年",@"两年",@"三年",@"无限期"];
    }
    return _deadLine_A;
}

-(NSDictionary *)lineDead_dic{
    if (!_lineDead_dic) {
        _lineDead_dic = @{@"0.5":@"半年",@"1":@"一年",@"2":@"两年",@"3":@"三年",@"0":@"无限期"};
    }
    
    return _lineDead_dic;
}
-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"半年":@"0.5",@"一年":@"1",@"两年":@"2",@"三年":@"3",@"无限期":@"0"};
    }
    
    return _deadLine_dic;
}
-(NSArray *)levelArray{
    if (!_levelArray) {
        _levelArray = @[@"普卡",@"银卡",@"金卡",@"白金卡",@"钻卡",@"黑金卡"];
    }
    return _levelArray;
}
-(NSMutableDictionary *)title_Dic{
    if (!_title_Dic) {
        _title_Dic = [NSMutableDictionary dictionary];
        if ([self.cardTypeName isEqualToString:@"计次卡"]) {
            
            [_title_Dic setObject:@[@"系列",@"会员卡级别",@"价格",@"使用次数",@"是否附赠",@"有效期"] forKey:@"0"];
            [_title_Dic setObject:@[@"系列",@"会员卡级别",@"价格",@"使用次数",@"是否附赠",@"附赠金额",@"有效期"] forKey:@"1"];
            
            
        }else{
            [_title_Dic setObject:@[@"系列",@"会员卡级别",@"价格",@"折扣率",@"是否附赠",@"有效期"] forKey:@"0"];
            [_title_Dic setObject:@[@"系列",@"会员卡级别",@"价格",@"折扣率",@"是否附赠",@"附赠金额",@"有效期"] forKey:@"1"];
            
            
        }
    }
    
    return _title_Dic;
    
}
-(NSMutableDictionary *)placeHoder_Dic{
    if (!_placeHoder_Dic) {
        _placeHoder_Dic = [NSMutableDictionary dictionary];
        
        if ([self.cardTypeName isEqualToString:@"计次卡"]) {
            [_placeHoder_Dic setObject:@[@"",@"请选择会员卡级别",@"请输入会员卡价格",@"请输入可使用次数",@"",@"请选择有效期"] forKey:@"0"];
            [_placeHoder_Dic setObject:@[@"",@"请选择会员卡级别",@"请输入会员卡价格",@"请输入可使用次数",@"",@"请输入附赠金额",@"请选择有效期"] forKey:@"1"];
            
            
        }else{
            [_placeHoder_Dic setObject:@[@"",@"请选择会员卡级别",@"请输入会员卡价格",@"请输入折扣率",@"",@"请选择有效期"] forKey:@"0"];
            [_placeHoder_Dic setObject:@[@"",@"请选择会员卡级别",@"请输入会员卡价格",@"请输入折扣率",@"",@"请输入附赠金额",@"请选择有效期"] forKey:@"1"];
            
            
        }
    }
    
    return _placeHoder_Dic;
    
}
-(NSArray *)title_A{
    if (!_title_A) {
        if (_giveIf) {
            _title_A =[NSArray arrayWithArray:self.title_Dic[@"1"]];

        }else{
            _title_A =[NSArray arrayWithArray:self.title_Dic[@"0"]];

        }
    }
    return _title_A;
}

-(NSMutableDictionary *)cardInfo_dic{
    if (!_cardInfo_dic) {
        _cardInfo_dic = [NSMutableDictionary dictionary];
        
        [self.cardInfo_dic setValue:self.series_dic[@"series_id"] forKey:@"code"];
        [self.cardInfo_dic setValue:self.cardTypeName forKey:@"type"];
        [self.cardInfo_dic setValue:@"0" forKey:@"addition"];
        [self.cardInfo_dic setValue:@"1" forKey:@"image_type"];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [_cardInfo_dic setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];


    }
    return _cardInfo_dic;
}
@end
