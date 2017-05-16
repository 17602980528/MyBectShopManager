//
//  ChangeVipCardInfoVC.m
//  BletcShop
//
//  Created by apple on 2017/5/3.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChangeVipCardInfoVC.h"
#import "UIImageView+WebCache.h"
#import "ChoiceCardPictureViewController.h"
#import "ValuePickerView.h"
@interface ChangeVipCardInfoVC ()<ChoiceCardDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIToolbar *toolView;
    NSData *imageData;
    NSData *imageData2;
}
@property (nonatomic, strong) ValuePickerView *pickerView;
@end

@implementation ChangeVipCardInfoVC
-(NSArray*)deadLine_A{
    if (!_deadLine_A) {
        _deadLine_A = @[@"半年",@"一年",@"两年",@"三年",@"无限期"];
    }
    return _deadLine_A;
}
-(NSDictionary *)deadLine_dic{
    if (!_deadLine_dic) {
        _deadLine_dic = @{@"半年":@"0.5",@"一年":@"1",@"两年":@"2",@"三年":@"3",@"无限期":@"0"};
    }
    
    return _deadLine_dic;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSInteger additon=[self.codeDic[@"addition_sum"] integerValue];
    if (additon!=0) {
        [self boyBtnAction];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.navigationItem.title = @"编辑会员卡";
    self.cardTypeString = self.codeDic[@"type"];
    self.cardLevelString = @"";
    self.typeArray= @[@"储值卡",@"计次卡"];
    self.levelArray= @[@"普卡",@"银卡",@"金卡",@"白金卡",@"钻卡",@"黑金卡"];
    self.choiceType = 1;
    self.isOpen=NO;
    self.isOpen2=NO;
    [self _initTable];
    self.pickerView = [[ValuePickerView alloc]init];
}

-(void)_initTable
{
    UITableView *mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    mytable.backgroundColor = [UIColor whiteColor];
    mytable.dataSource = self;
    mytable.delegate = self;
    mytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytable.showsVerticalScrollIndicator = NO;
    mytable.bounces = NO;
    self.MyAddtable = mytable;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.MyAddtable addGestureRecognizer:singleTap];
    [self.view addSubview:mytable];
//
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    UIView * view = textField.superview;//我创建的textField是直接放在cell上的
    UITableViewCell * cell = (UITableViewCell *)view;
    CGRect rect = [textField convertRect:cell.frame toView:self.view];
    float interY = rect.origin.y/2;//（通过输出，发现这样计算出来的坐标y和实际比较多了一倍，这一点希望懂的同行给解释一下）。
    if (self.view.frame.size.height-interY < 240)//216
    {
        self.MyAddtable.frame = CGRectMake(0, 64 - 240-cell.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 64);//这里为了简单，键盘高度我写死了（实际高度自己可以通过键盘的代理方法获得）。
    }
    
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.MyAddtable endEditing:YES];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.MyAddtable endEditing:YES];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, SCREENHEIGHT-64);
    
    self.MyAddtable.frame = rect;
    
    [UIView commitAnimations];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 50;
    }else if(indexPath.section==1||indexPath.section==2){
        return 50;
    }else if(indexPath.section==3){
        
        return 120;
        
        
    }
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (self.okButton.selected) {
            return 7;
        }else
            return 6;
    }else if (section==1||section ==2){
        return 1;
    }else if (section==3){
        return 2;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = RGB(240, 240, 240);
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    view.backgroundColor = RGB(240, 240, 240);
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        if (self.okButton.selected) {
            if (indexPath.row==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                label.text = @"会员卡编号:";
                label.font = [UIFont systemFontOfSize:14];
                [cell addSubview:label];
            
                UILabel *codeLable=[[UILabel alloc]initWithFrame:CGRectMake(90, 5, SCREENWIDTH-100, 40)];
                codeLable.font=[UIFont systemFontOfSize:14.0f];
                codeLable.text=self.codeDic[@"code"];
                [cell addSubview:codeLable];
                
            }
            else if (indexPath.row==1) {
                //会员卡类型
                UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                typeLabel.text = @"会员卡类型:";
                typeLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:typeLabel];
                UILabel *cardTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 80, 30)];
                cardTypeLabel.text=self.codeDic[@"type"];
                self.cardTypeLabel=cardTypeLabel;
                cardTypeLabel.textAlignment = NSTextAlignmentCenter;
               
                NSLog(@"%@",cardTypeLabel.text);
                cardTypeLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:cardTypeLabel];
                
            }else if (indexPath.row==2) {
                //会员卡级别
                UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                levelLabel.text = @"会员卡级别:";
                levelLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:levelLabel];
                UILabel *cardLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 80, 30)];
                cardLevelLabel.textAlignment = NSTextAlignmentCenter;
                cardLevelLabel.text = self.cardLevelLabel.text;
                self.cardLevelLabel=cardLevelLabel;
                if ([self.cardLevelString isEqualToString:@""]) {
                    cardLevelLabel.text = self.codeDic[@"level"];
                }
                else
                {
                    cardLevelLabel.text = @"";
                    cardLevelLabel.text = self.cardLevelString;
                }
                NSLog(@"%@",cardLevelLabel.text);
                cardLevelLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:cardLevelLabel];
                
                //箭头
                UIButton *choiceBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                choiceBtn1.frame = CGRectMake(90, 15, 190, 20);
                
                [choiceBtn1 setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
                [choiceBtn1 setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
                [choiceBtn1 addTarget:self action:@selector(choiceLevelAction:) forControlEvents:UIControlEventTouchUpInside];
                //    self.boyBtn = boyBtn;
                [cell addSubview:choiceBtn1];
                
                
            }else if (indexPath.row==3) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                label.text = @"价格:";
                label.font = [UIFont systemFontOfSize:14];
                [cell addSubview:label];
                UITextField *priceText = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, SCREENWIDTH-100, 40)];
                priceText.delegate = self;
                
                [priceText setInputAccessoryView:toolView];
               
                if (self.priceText.text&&![self.priceText.text isEqualToString:@""]) {
                     priceText.text = self.priceText.text;
                }else{
                     priceText.text = self.codeDic[@"price"];
                }
                self.priceText = priceText;
                priceText.placeholder = @"请输入会员卡价格";
                priceText.font = [UIFont systemFontOfSize:14];
                
                priceText.keyboardType = UIKeyboardTypeNumberPad;
                
                [cell addSubview:priceText];
                
            }
            else if (indexPath.row==4)
            {
                //是否赠送金额
                UILabel *iflabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 50)];
                iflabel.text = @"是否赠送金额:";
                iflabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:iflabel];
                //男
                UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
                okButton.frame = CGRectMake(100, 15, 20, 20);
                //    choseBtn.backgroundColor = [UIColor redColor];
                [okButton setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
                [okButton setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
                [okButton addTarget:self action:@selector(boyBtnAction) forControlEvents:UIControlEventTouchUpInside];
                okButton.selected=YES;
                self.okButton = okButton;
                [cell addSubview:okButton];
                //
                UILabel *oklabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 20, 50)];
                oklabel.text = @"是";
                oklabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:oklabel];
                ////女
                UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
                noButton.frame = CGRectMake(160, 15, 20, 20);
                //noButton.selected=YES;
                //    choseBtn.backgroundColor = [UIColor redColor];
                [noButton setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
                [noButton setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
                [noButton addTarget:self action:@selector(girlBtnAction) forControlEvents:UIControlEventTouchUpInside];
                self.noButton = noButton;
                [cell addSubview:noButton];
                //
                UILabel *nolabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 20, 50)];
                nolabel.text = @"否";
                nolabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:nolabel];
            }else if (indexPath.row==5)
            {
                //金额
                UILabel *addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                addresslabel.text = @"金额:";
                addresslabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:addresslabel];
                UITextField *addressText = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, SCREENWIDTH-100, 40)];
                addressText.delegate = self;
                [addressText setInputAccessoryView:toolView];
                if (self.otherMoneyText.text&&[self.otherMoneyText.text isEqualToString:@""]) {
                    addressText.text=self.otherMoneyText.text;
                }else{
                    addressText.text=self.codeDic[@"addition_sum"];
                }
                self.otherMoneyText = addressText;
                
                addressText.placeholder = @"请输入赠送金额";
                addressText.font = [UIFont systemFontOfSize:14];
                addressText.clearButtonMode = UITextFieldViewModeWhileEditing;
                addressText.keyboardType = UIKeyboardTypeNumberPad;
                [cell addSubview:addressText];
                
            }else if (indexPath.row==6)
            {
                //折扣率
                
                UILabel *zhekoulabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                self.zhekouLabel = zhekoulabel;
                zhekoulabel.text = @"折扣率:";
                zhekoulabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:zhekoulabel];
                
                UITextField *zhekouText = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, 120, 40)];
                zhekouText.delegate = self;
                [zhekouText setInputAccessoryView:toolView];
                zhekouText.keyboardType = UIKeyboardTypeNumberPad;
                zhekouText.font = [UIFont systemFontOfSize:14];
                [cell addSubview:zhekouText];
                if (self.zhekouText.text&&![self.zhekouText.text isEqualToString:@""]) {
                    zhekouText.text= self.zhekouText.text;
                }else{
                    zhekouText.text=self.codeDic[@"rule"];
                }
                self.zhekouText = zhekouText;
                
                UILabel *zhekoulabel1 = [[UILabel alloc]initWithFrame:CGRectMake(210, 5, 30, 40)];
                self.zhekouLabel1 = zhekoulabel1;
                
                zhekoulabel1.text = @"%";
                zhekoulabel1.font = [UIFont systemFontOfSize:14];
                [cell addSubview:zhekoulabel1];
                if([self.cardTypeString isEqualToString:@"储值卡"])
                {
                    self.zhekouLabel.text = @"折扣率:";
                    self.zhekouLabel1.text = @"%";
                    self.zhekouText.placeholder = @"请输入折扣率";
                    
                }else{
                    self.zhekouLabel.text = @"使用次数:";
                    self.zhekouLabel1.text = @"次";
                    self.zhekouText.placeholder = @"请输入可使用次数";
                    
                }
                
            }
            if (indexPath.row<8) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                line.backgroundColor = [UIColor grayColor];
                line.alpha = 0.3;
                [cell addSubview:line];
            }else if (indexPath.row==8)
            {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
                line.backgroundColor = [UIColor grayColor];
                line.alpha = 0.3;
                [cell addSubview:line];
            }
        }
        else{
            if (indexPath.row==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                label.text = @"会员卡编号:";
                label.font = [UIFont systemFontOfSize:14];
                [cell addSubview:label];
                
                UILabel *codeLable=[[UILabel alloc]initWithFrame:CGRectMake(90, 5, SCREENWIDTH-100, 40)];
                codeLable.font=[UIFont systemFontOfSize:14.0f];
                codeLable.text=self.codeDic[@"code"];
                [cell addSubview:codeLable];
                
            }
            else if (indexPath.row==1) {
                //会员卡类型
                UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                typeLabel.text = @"会员卡类型:";
                typeLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:typeLabel];
                UILabel *cardTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 80, 40)];
                cardTypeLabel.text=self.codeDic[@"type"];//self.cardTypeLabel.text;
                self.cardTypeLabel=cardTypeLabel;
                //                cardTypeLabel.layer.borderWidth = 0.3;
                cardTypeLabel.textAlignment = NSTextAlignmentCenter;
                NSLog(@"%@",cardTypeLabel.text);
                cardTypeLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:cardTypeLabel];
                
            }else if (indexPath.row==2) {
                //会员卡级别
                UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                levelLabel.text = @"会员卡级别:";
                levelLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:levelLabel];
                UILabel *cardLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 80, 40)];
                cardLevelLabel.textAlignment = NSTextAlignmentCenter;
                cardLevelLabel.text = self.cardLevelLabel.text;
                self.cardLevelLabel=cardLevelLabel;
                if ([self.cardLevelString isEqualToString:@""]) {
                    cardLevelLabel.text = self.codeDic[@"level"];
                }
                else
                {
                    cardLevelLabel.text = @"";
                    cardLevelLabel.text = self.cardLevelString;
                }
                NSLog(@"%@",cardLevelLabel.text);
                cardLevelLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:cardLevelLabel];
                
                //箭头
                UIButton *choiceBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                choiceBtn1.frame = CGRectMake(90, 15, 190, 20);
                //    choseBtn.backgroundColor = [UIColor redColor];
                [choiceBtn1 setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
                [choiceBtn1 setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
                [choiceBtn1 addTarget:self action:@selector(choiceLevelAction:) forControlEvents:UIControlEventTouchUpInside];
                //    self.boyBtn = boyBtn;
                [cell addSubview:choiceBtn1];
                
                
            }else if (indexPath.row==3) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                label.text = @"价格:";
                label.font = [UIFont systemFontOfSize:14];
                [cell addSubview:label];
                UITextField *priceText = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, SCREENWIDTH-100, 40)];
                priceText.delegate = self;
                [priceText setInputAccessoryView:toolView];
                
                if (self.priceText.text&&![self.priceText.text isEqualToString:@""]) {
                    priceText.text = self.priceText.text;
                }else{
                    priceText.text = self.codeDic[@"price"];
                }
                self.priceText = priceText;
                priceText.placeholder = @"请输入会员卡价格";
                priceText.font = [UIFont systemFontOfSize:14];
                priceText.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:priceText];
                priceText.keyboardType = UIKeyboardTypeNumberPad;
                
                
            }else if (indexPath.row==4)
            {
                //是否赠送金额
                UILabel *iflabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 150, 50)];
                iflabel.text = @"是否赠送金额:";
                iflabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:iflabel];
                //男
                UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
                okButton.frame = CGRectMake(100, 15, 20, 20);
                //    choseBtn.backgroundColor = [UIColor redColor];
                [okButton setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
                [okButton setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
                [okButton addTarget:self action:@selector(boyBtnAction) forControlEvents:UIControlEventTouchUpInside];
                self.okButton = okButton;
                [cell addSubview:okButton];
                //
                UILabel *oklabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 20, 50)];
                oklabel.text = @"是";
                oklabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:oklabel];
                ////女
                UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
                noButton.frame = CGRectMake(160, 15, 20, 20);
                noButton.selected=YES;
                //    choseBtn.backgroundColor = [UIColor redColor];
                [noButton setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
                [noButton setImage:[UIImage imageNamed:@"gouxuan@"] forState:UIControlStateSelected];
                [noButton addTarget:self action:@selector(girlBtnAction) forControlEvents:UIControlEventTouchUpInside];
                self.noButton = noButton;
                [cell addSubview:noButton];
                //
                UILabel *nolabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 20, 50)];
                nolabel.text = @"否";
                nolabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:nolabel];
            }else if (indexPath.row==5)
            {
                //折扣率
                
                UILabel *zhekoulabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
                self.zhekouLabel = zhekoulabel;
                zhekoulabel.text = @"折扣率:";
                zhekoulabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:zhekoulabel];
                UITextField *zhekouText = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, 120, 40)];
                zhekouText.delegate = self;
                [zhekouText setInputAccessoryView:toolView];
                zhekouText.keyboardType = UIKeyboardTypeNumberPad;
                zhekouText.font = [UIFont systemFontOfSize:14];
                zhekouText.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:zhekouText];
                
                if (self.zhekouText.text&&![self.zhekouText.text isEqualToString:@""]) {
                    zhekouText.text= self.zhekouText.text;
                }else{
                    zhekouText.text=self.codeDic[@"rule"];
                }
                 self.zhekouText = zhekouText;
                
                UILabel *zhekoulabel1 = [[UILabel alloc]initWithFrame:CGRectMake(210, 5, 30, 40)];
                self.zhekouLabel1 = zhekoulabel1;
                zhekoulabel1.text = @"%";
                zhekoulabel1.font = [UIFont systemFontOfSize:14];
                [cell addSubview:zhekoulabel1];
                if([self.cardTypeString isEqualToString:@"储值卡"])
                {
                    self.zhekouLabel.text = @"折扣率:";
                    self.zhekouLabel1.text = @"%";
                    self.zhekouText.placeholder = @"请输入折扣率";
                    
                }else{
                    self.zhekouLabel.text = @"使用次数:";
                    self.zhekouLabel1.text = @"次";
                    self.zhekouText.placeholder = @"请输入可使用次数";
                    
                }
            }
            if (indexPath.row<7) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.3)];
                line.backgroundColor = [UIColor grayColor];
                line.alpha = 0.3;
                [cell addSubview:line];
            }else if (indexPath.row==7)
            {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 0.3)];
                line.backgroundColor = [UIColor grayColor];
                line.alpha = 0.3;
                [cell addSubview:line];
            }
        }
        
    }else if (indexPath.section==1){
        //优惠内容
        UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
        descriptionLabel.text = @"优惠内容";
        descriptionLabel.font = [UIFont systemFontOfSize:14];
        [cell addSubview:descriptionLabel];
        
        UITextField *descriptionText = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, SCREENWIDTH-100, 40)];
        descriptionText.delegate = self;
        [descriptionText setInputAccessoryView:toolView];
        descriptionText.placeholder = @"请输入卡的优惠内容";
        descriptionText.font = [UIFont systemFontOfSize:14];
        descriptionText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell addSubview:descriptionText];
        if (self.contentText.text&&![self.contentText.text isEqualToString:@""]) {
            descriptionText.text=self.contentText.text;
        }else{
            descriptionText.text=self.codeDic[@"content"];
        }
        self.contentText = descriptionText;
        
    }else if(indexPath.section==2){
        //优惠内容
        UILabel *deadLine_Label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 50)];
        deadLine_Label.text = @"有效期:";
        deadLine_Label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:deadLine_Label];
        
        UITextField *deadLineText = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, SCREENWIDTH-100, 40)];
        deadLineText.delegate = self;
        deadLineText.userInteractionEnabled = NO;
        deadLineText.font = [UIFont systemFontOfSize:14];
        deadLineText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell addSubview:deadLineText];
        if (self.deadLineText.text&&![self.deadLineText.text isEqualToString:@""]) {
            deadLineText.text=self.deadLineText.text;
        }else{
            if ([self.codeDic[@"indate"]integerValue]==0) {
                 deadLineText.text=@"无限期";
            }else if ([self.codeDic[@"indate"]integerValue]==0.5){
                 deadLineText.text=@"半年";
            }else if ([self.codeDic[@"indate"]integerValue]==1){
                 deadLineText.text=@"一年";
            }else if ([self.codeDic[@"indate"]integerValue]==2){
                 deadLineText.text=@"两年";
            }else if ([self.codeDic[@"indate"]integerValue]==3){
                 deadLineText.text=@"三年";
            }
        }
        self.deadLineText = deadLineText;
        
        //箭头
        UIButton *choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceBtn.frame = CGRectMake(90, 15, 190, 20);
        //    choseBtn.backgroundColor = [UIColor redColor];
        [choiceBtn setImage:[UIImage imageNamed:@"arraw_right"] forState:UIControlStateNormal];
        [choiceBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateSelected];
        [choiceBtn addTarget:self action:@selector(choiceDeadLine:) forControlEvents:UIControlEventTouchUpInside];
        //    self.boyBtn = boyBtn;
        [cell addSubview:choiceBtn];
        
        
    }else
        
        if (indexPath.section==3){
            if (indexPath.row==0) {
                //上传卡片
                UILabel *uploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 20)];
                uploadLabel.text = @"上传卡片:";
                uploadLabel.font = [UIFont systemFontOfSize:14];
                [cell addSubview:uploadLabel];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(27, 30, 120, 80)];
                imageView.backgroundColor=RGB(240, 240, 240);
                imageView.image = [UIImage imageNamed:@""];
                //imageView.backgroundColor = [UIColor grayColor];
                imageView.userInteractionEnabled = YES;
                imageView.layer.borderWidth=0.5;
                imageView.layer.borderColor=[[UIColor grayColor]CGColor];
                self.imageView = imageView;
                UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choicePicture)];
                [imageView addGestureRecognizer:tapGesture];
                [cell addSubview:imageView];
                
                if (self.choiceCard || self.codeDic) {
//                    NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:self.choiceCard[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//                    [self.imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
                   
                    
                    NSString *colorString=self.choiceCard[@"color"]?self.choiceCard[@"color"]:self.codeDic[@"card_temp_color"];
                    
                    imageView.backgroundColor=[UIColor colorWithHexString:colorString];
                    
                    
                    UIView *bot_view = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 120, 30)];
                    bot_view.backgroundColor = [UIColor whiteColor];
                    [imageView addSubview:bot_view];
                    
                    UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
                    vipLab.text = [NSString stringWithFormat:@"VIP%@",self.cardLevelLabel.text];
                    vipLab.textAlignment = NSTextAlignmentCenter;
                    vipLab.textColor = [UIColor whiteColor];
                    [imageView addSubview:vipLab];
                    
                    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:vipLab.text];
                    
                    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,171,65),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(0, 3)];
                    
                    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(3, vipLab.text.length-3)];
                    
                    vipLab.attributedText = attr;

                }else{
                    UIImageView *defaultImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 40, 40)];
                    defaultImageView.image=[UIImage imageNamed:@"vip_pic_n"];
                    [imageView addSubview:defaultImageView];
                    
                    UILabel *addLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 80, 15)];
                    addLabel.text=@"添加图片";
                    addLabel.textAlignment=1;
                    addLabel.font=[UIFont systemFontOfSize:13.0f];
                    addLabel.textColor=[UIColor grayColor];
                    [imageView addSubview:addLabel];
                }
                
            }else if (indexPath.row==1){
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
                view.backgroundColor=RGB(240, 240, 240);
                [cell addSubview:view];
                
                UIButton *LandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                LandBtn.frame = CGRectMake(12, 35, SCREENWIDTH-24, 50);
                [LandBtn setTitle:@"确定" forState:UIControlStateNormal];
                [LandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [LandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                [LandBtn setBackgroundColor:NavBackGroundColor];
                LandBtn.layer.cornerRadius = 5.0f;
                [LandBtn addTarget:self action:@selector(addVipCardAction) forControlEvents:UIControlEventTouchUpInside];
                LandBtn.titleLabel.font = [UIFont systemFontOfSize:20];
                [view addSubview:LandBtn];
            }
        }
    return cell;
}
-(void)addVipCardAction
{
    [self postRequestAddVipCard];
}
-(void)postRequestAddVipCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/mod",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:self.codeDic[@"code"] forKey:@"code"];
    [params setObject:self.codeDic[@"type"] forKey:@"type"];
    [params setObject:self.cardLevelLabel.text forKey:@"level"];
    [params setObject:self.contentText.text forKey:@"content"];
    [params setObject:self.priceText.text forKey:@"price"];
    if ([self.zhekouText.text floatValue]==0||[self.zhekouText.text floatValue]>=100||[self.zhekouText.text isEqualToString:@""]) {
        self.zhekouText.text=@"100";
    }
    [params setObject:self.zhekouText.text forKey:@"rule"];
    NSLog(@"%@",self.deadLine_dic);
    [params setObject:[self.deadLine_dic objectForKey:self.deadLineText.text] forKey:@"indate"];
    
    //addition
    if(self.okButton.selected)
    {
        [params setObject:self.otherMoneyText.text forKey:@"addition"];
    }else
    {
        [params setObject:@"0" forKey:@"addition"];
    }
    [params setObject:[[NSString alloc] initWithFormat:@"%d",self.choiceType]
               forKey:@"image_type"];
    NSString *imageUrl = [NSString stringWithFormat:@"%@_%@_%@_%@.png",appdelegate.shopInfoDic[@"name"],appdelegate.shopInfoDic[@"phone"],self.cardLevelLabel.text,self.codeDic[@"code"]];
    
    if (self.choiceType==1)
    {
        NSString *colorString=self.choiceCard[@"color"]?self.choiceCard[@"color"]:self.codeDic[@"card_temp_color"];
        [params setObject:colorString forKey:@"color"];
    }else
        [params setObject:imageUrl forKey:@"image_url"];
    
    
    NSLog(@"params===%@", params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        if ([result[@"result_code"]intValue]==1) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"修改成功,是否返回上一层?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alertView show];
            
        }
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)boyBtnAction
{
    self.okButton.selected=YES;
    self.noButton.selected=NO;
    [self.MyAddtable reloadData];
    
}
-(void)girlBtnAction
{
    self.noButton.selected=YES;
    self.okButton.selected=NO;
    [self.MyAddtable reloadData];
    
}
#pragma mark------cardType
-(void)choiceLevelAction:(UIButton *)sender
{
    self.pickerView.dataSource =self.levelArray;
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        
        
        weakSelf.cardLevelLabel.text = [[value componentsSeparatedByString:@"/"] firstObject];
        
        weakSelf.cardLevelString = weakSelf.cardLevelLabel.text;
    };
    
    
    [self.pickerView show];
    
}




-(void)choicePicture
{
    [self.MyAddtable endEditing:YES];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, SCREENHEIGHT-64);
    
    self.MyAddtable.frame = rect;
    UIActionSheet *sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"默认图片", nil];
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255)
    {
            if (buttonIndex == 0)
            {
                return;
            }else
            {
                ChoiceCardPictureViewController *pictureView = [[ChoiceCardPictureViewController alloc]init];
                pictureView.delegate = self;
                [self.navigationController pushViewController:pictureView animated:YES];
                return;
            }
    }
}
- (void)sendCardValue:(NSDictionary *)value
{
    self.choiceCard = [[NSDictionary alloc]initWithDictionary:value];
    self.choiceType = 1;
    
    for (UIView *view in self.imageView.subviews) {
        [view removeFromSuperview];
    }
    
    NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:self.choiceCard[@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self.imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    
    
}

-(void)choiceDeadLine:(UIButton*)sender{
    
    self.pickerView.dataSource =self.deadLine_A;
    __weak typeof(self) weakSelf= self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        
        NSLog(@"------------%@",value);
        weakSelf.deadLineText.text = [[value componentsSeparatedByString:@"/"] firstObject];
        
    };
    
    
    [self.pickerView show];
    
    
}


@end
