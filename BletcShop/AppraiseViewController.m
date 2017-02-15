//
//  AppraiseViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AppraiseViewController.h"
#import "DLStarRatingControl.h"
@interface AppraiseViewController ()

@property (retain, nonatomic)UITableView *appraiseTable;
@property (retain, nonatomic)UITextView *textView;
@property (retain, nonatomic)UILabel *placeholder;
@property (retain, nonatomic)UITextField *contactText;
@property CGFloat indoorStars;//


@property (nonatomic) DLStarRatingControl* dlCtrl;


@property BOOL isUseName;

@end

@implementation AppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"评价";
    self.view.backgroundColor = [UIColor whiteColor];
    _indoorStars=5.0;
    
    [self _inittable];

}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.textView resignFirstResponder];
    [self.appraiseTable endEditing:YES];
    
    
}


//然后根据具体的业务场景去写逻辑就可以了,比如
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    NSLog(@"%@",touch.view);
    if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
}
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
    
    self.appraiseTable = table;
    [self.view addSubview:table];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];

    [self.appraiseTable addGestureRecognizer:singleTap];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [self.appraiseTable resignFirstResponder];
    return YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 140;
    }else if (indexPath.section==1) {
        return 50;
    }else if (indexPath.section==2) {
        return 80;
    }
    else
        return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        self.view.backgroundColor = tableViewBackgroundColor;
        //反馈匡
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 120)];
        _textView.delegate = self;
        //提示语
        _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 30)];
        _placeholder.font = [UIFont systemFontOfSize:13];
        _placeholder.textColor = [UIColor grayColor];
        _placeholder.text = @"请在此输入您对店铺的评价";
        _placeholder.enabled = YES;
        _placeholder.backgroundColor = [UIColor clearColor];
        [self.textView addSubview:_placeholder];
        [cell addSubview:self.textView];
    }else if (indexPath.section==1)
    {
        UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 65, 40)];
        starLabel.text = @"店铺评分";
        starLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:starLabel];
        self.dlCtrl = [[DLStarRatingControl alloc]initWithFrameNoEdgeInset:CGRectMake(80, 0, 150,45) andStars:5 isFractional:YES star:[UIImage imageNamed:@"star_default.png"] highlightStar:[UIImage imageNamed:@"star_selected.png"]];
        self.dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.dlCtrl.userInteractionEnabled = YES;
        self.dlCtrl.rating = _indoorStars;
        self.dlCtrl.delegate = self;
        self.dlCtrl.tag = 100;
        //[starLabel addSubview:self.dlCtrl];
        [cell addSubview:self.dlCtrl];
    }else if (indexPath.section==2)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 20, 20)];
        imageView.image = [UIImage imageNamed:@"checkbox_ture"];
        [cell addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35, 60, 60, 20)];
        label.text = @"匿名评价";
        label.font = [UIFont systemFontOfSize: 12];
        //imageView.image = [UIImage imageNamed:@"checkbox_ture"];
        [cell addSubview:label];
        UIButton* submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-70, 50, 60, 30)];
        submitBtn.backgroundColor = [UIColor orangeColor];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize: 10];
        [submitBtn setTitle:@"发布评价" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(postSocketAppraise) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:submitBtn];
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 90, SCREENWIDTH, 1)];
        line1.backgroundColor = [UIColor grayColor];
        line1.alpha = 0.3;
        [cell addSubview:line1];

    }
    return cell;
}
- (void)newRating:(DLStarRatingControl *)control :(float)rating{
    
    _indoorStars = rating;
}

-(void)changeContentViewPoint:(NSNotification *)sender{
    NSDictionary *userInfo = [sender userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];        // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.view.center = CGPointMake(self.view.center.x, keyBoardEndY - self.view.bounds.size.height/2.0);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
    }
     ];
}

-(void)restoreContentViewPoint:(NSNotification*)sender{
    NSDictionary *userInfo = [sender userInfo];
    //NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = SCREENHEIGHT;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];        // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.view.center = CGPointMake(self.view.center.x, keyBoardEndY - self.view.bounds.size.height/2.0);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
    }
     ];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeholder.text = @"请输入您的反馈意见,不超过200字";
    }else{
        _placeholder.text = @"";
    }
}

/**
 发布评论
 */
-(void)postSocketAppraise
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/evaluate/commit",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:self.evaluate_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.textView.text forKey:@"content"];
    NSString *stars = [[NSString alloc]initWithFormat:@"%f",_indoorStars];
    [params setObject:stars forKey:@"stars"];
    [params setObject:self.evaluate_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.evaluate_dic[@"card_level"] forKey:@"cardLevel"];
    [params setObject:self.evaluate_dic[@"card_type"] forKey:@"cardType"];
    [params setObject:self.evaluate_dic[@"card_remain"] forKey:@"price"];
    [params setObject:self.evaluate_dic[@"card_temp_color"] forKey:@"card_temp_color"];
    
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"date"];
    NSLog(@"%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result====%@",result);
         
         if ([result[@"result_code"] intValue]==1) {
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"评价成功", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];
             
             [self performSelector:@selector(popVC) withObject:nil afterDelay:3];
             
         }else{
             
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             
             hud.label.text = NSLocalizedString(@"评价失败", @"HUD message title");
             hud.label.font = [UIFont systemFontOfSize:13];
             hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
             [hud hideAnimated:YES afterDelay:3.f];

             
         }
         
     
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {

         NSLog(@"%@", error);
     }];

}





-(void)popVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
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
