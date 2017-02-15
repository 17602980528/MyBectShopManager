//
//  ActiveMoreRuleViewController.m
//  BletcShop
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ActiveMoreRuleViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LandingController.h"
#import "GoShopViewController.h"
@interface ActiveMoreRuleViewController ()<UITableViewDelegate,UITableViewDataSource,GoShopViewControllerDelegate>
{
    NSInteger count;
    UILabel *countLab;
    UIView *backgroundView;
    NSMutableArray *_myNewArray;
    UITableView *_tableView;
    NSMutableArray *recordArray;
    UILabel *lastTimeLabel;
    NSArray *infoArray;
    
    UIView *noticeView;
}
@end

@implementation ActiveMoreRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"宝贝详情";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    _myNewArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray *arr=self.array[_index];
    for (int i=0; i<arr.count; i++) {
        [_myNewArray addObject:arr[i]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self lastPersonRequest];
    [self recordRequest];
    recordArray=[[NSMutableArray alloc]initWithCapacity:0];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section!=2){
        return 1;
    }else{
        return recordArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/2-60)];
        imageView.tag=100;
        [cell addSubview:imageView];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, SCREENHEIGHT/2-60, SCREENWIDTH-10, 60)];
        nameLabel.font=[UIFont systemFontOfSize:13.0f];
        nameLabel.numberOfLines=0;
        nameLabel.tag=200;
        [cell addSubview:nameLabel];
        //一元夺宝
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 30)];
        label1.text=@"乐点挖宝";
        label1.tag=300;
        label1.font=[UIFont systemFontOfSize:15.0f];
        [cell addSubview:label1];
        //只需要1元就有机会获得商品!
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, SCREENWIDTH/2+40, 20)];
        label2.text=@"只需要10乐点就有机会获得商品!";
        label2.tag=400;
        label2.font=[UIFont systemFontOfSize:13.0f];
        label2.textColor=[UIColor grayColor];
        [cell addSubview:label2];
        //期号
        UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(10, 95, 150, 20)];
        label3.textColor=[UIColor grayColor];
        label3.tag=500;
        label3.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:label3];
        //进度条
        UIProgressView *gressView=[[UIProgressView alloc]initWithFrame:CGRectMake(10, 120, SCREENWIDTH/2+40, 2)];
        gressView.progressTintColor=[UIColor orangeColor];
        gressView.tag=600;
        [cell addSubview:gressView];
        //总需人次
        UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, 100, 20)];
        label4.textColor=[UIColor grayColor];
        label4.font=[UIFont systemFontOfSize:13.0f];
        label4.tag=700;
        [cell addSubview:label4];
        //剩余人次
        UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(130, 130, 100, 20)];
        label5.textColor=[UIColor blueColor];
        label5.font=[UIFont systemFontOfSize:13.0f];
        label5.tag=800;
        [cell addSubview:label5];
        //底部提示文本
        UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, SCREENWIDTH-20, 40)];
        label6.tag=900;
        label6.textAlignment=1;
        label6.backgroundColor=[[UIColor alloc]initWithRed:240/255.0 green:215/255.0 blue:48/255.0 alpha:1.0];
        [cell addSubview:label6];
        label6.text=@"想要这样的好运气？快来参与挖宝吧!";
        label6.font=[UIFont systemFontOfSize:13.0f];
        //立即购买按钮
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(SCREENWIDTH-110, 45, 100, 50);
        button.tag=1000;
        //button.backgroundColor=NavBackGroundColor;
        //[button setTitle:@"马上挖" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"wa-02"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"wa-01"] forState:UIControlStateHighlighted];
        //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell addSubview:button];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //抽奖人信息
        UIImageView *recImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        recImage.layer.cornerRadius=30;
        recImage.clipsToBounds=YES;
        recImage.tag=1100;
        [cell addSubview:recImage];
        
        UILabel *nickNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, SCREENWIDTH-80, 30)];
        nickNameLabel.tag=1200;
        nickNameLabel.font=[UIFont systemFontOfSize:13.0f];
        nickNameLabel.textColor=[UIColor blueColor];
        [cell addSubview:nickNameLabel];
        
        UILabel *takeCount=[[UILabel alloc]initWithFrame:CGRectMake(80, 40, 100, 30)];
        takeCount.tag=1300;
        takeCount.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:takeCount];
        
        UILabel *takeTime=[[UILabel alloc]initWithFrame:CGRectMake(180, 40, SCREENWIDTH-180, 30)];
        takeTime.tag=1400;
        takeTime.textColor=[UIColor grayColor];
        takeTime.font=[UIFont systemFontOfSize:13.0f];
        [cell addSubview:takeTime];
    }
   
    UIImageView *imageView=[cell viewWithTag:100];
    NSURL * nurl1=[[NSURL alloc] initWithString:[[DUOBAOIMAGE stringByAppendingString:[_array  objectAtIndex:_index][2]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    UILabel *nameLab = [cell viewWithTag:200];
    nameLab.text=_array[_index][0];
    UILabel *nameLab2=[cell viewWithTag:300];
    UILabel *nameLab3=[cell viewWithTag:400];
    UILabel *nameLab4=[cell viewWithTag:500];
    UIProgressView *proView=[cell viewWithTag:600];
    float totalPerson = [self.array[_index][4] floatValue];
    float lastPerson = [self.array[_index][5] floatValue];
    CGFloat scale =(totalPerson-lastPerson)/totalPerson*100;
    proView.progress=scale/100;
    nameLab4.text=[[NSString alloc]initWithFormat:@"%@期",self.array[_index][3]];
    UILabel *nameLab5=[cell viewWithTag:700];
    nameLab5.text=[[NSString alloc]initWithFormat:@"总需%@人次",self.array[_index][4]];
    UILabel *nameLab6=[cell viewWithTag:800];
    nameLab6.text=[[NSString alloc]initWithFormat:@"剩余%@",_myNewArray[5]];
    UILabel *nameLab7=[cell viewWithTag:900];
    UIButton *button=(UIButton *)[cell viewWithTag:1000];
    UIImageView *recordImage=[cell viewWithTag:1100];
    UILabel *nickLable=[cell viewWithTag:1200];
    UILabel *takeCont=[cell viewWithTag:1300];
    UILabel *timeLabel=[cell viewWithTag:1400];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.section==0) {
        imageView.hidden=NO;
        nameLab.hidden=NO;
        nameLab2.hidden=YES;
        nameLab3.hidden=YES;
        nameLab4.hidden=YES;
        proView.hidden=YES;
        nameLab5.hidden=YES;
        nameLab6.hidden=YES;
        nameLab7.hidden=YES;
        button.hidden=YES;
        recordImage.hidden=YES;
        nickLable.hidden=YES;
        takeCont.hidden=YES;
        timeLabel.hidden=YES;
    }else if(indexPath.section==1){
        imageView.hidden=YES;
        nameLab.hidden=YES;
        nameLab2.hidden=NO;
        nameLab3.hidden=NO;
        nameLab4.hidden=NO;
        proView.hidden=NO;
        nameLab5.hidden=NO;
        nameLab6.hidden=NO;
        nameLab7.hidden=NO;
        button.hidden=NO;
        recordImage.hidden=YES;
        nickLable.hidden=YES;
        takeCont.hidden=YES;
        timeLabel.hidden=YES;
    }else{
        imageView.hidden=YES;
        nameLab.hidden=YES;
        nameLab2.hidden=YES;
        nameLab3.hidden=YES;
        nameLab4.hidden=YES;
        nameLab5.hidden=YES;
        nameLab6.hidden=YES;
        nameLab7.hidden=YES;
        proView.hidden=YES;
        button.hidden=YES;
        recordImage.hidden=NO;
        NSURL * nurl2=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:recordArray[indexPath.row][3]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [recordImage sd_setImageWithURL:nurl2 placeholderImage:[UIImage imageNamed:@"头像.png"] options:SDWebImageRetryFailed];
        nickLable.hidden=NO;
        nickLable.text=recordArray[indexPath.row][0];
        
        takeCont.hidden=NO;
        timeLabel.hidden=NO;
        takeCont.text=[[NSString alloc]initWithFormat:@"参与了%@人次",recordArray[indexPath.row][2]];
        timeLabel.text=[[NSString alloc]initWithFormat:@"%@",recordArray[indexPath.row][1]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return SCREENHEIGHT/2;
    }else if(indexPath.section==1){
        return 220;
    }else{
        return 80;
    }
    return 220;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0.01;
    }else{
        return 10;
    }
    return 10;
}

-(void)btnClick:(UIButton *)sender{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (delegate.IsLogin) {
        //如果是登录状态,执行相关逻辑
        //背景view
        backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT-64)];
        backgroundView.backgroundColor=[UIColor whiteColor];
        backgroundView.alpha=0.9;
        UIView *upView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-200)];
        upView.backgroundColor=[UIColor blackColor];
        upView.alpha=0.3;
        [backgroundView addSubview:upView];
        //下部的白色的view
        UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-200, SCREENWIDTH, 200)];
        downView.backgroundColor=[UIColor whiteColor];
        [backgroundView addSubview:downView];
        [self.view addSubview:backgroundView];
        //参与人次
        UILabel *centerLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, 20, 100, 30)];
        centerLabel.text=@"参与人次";
        centerLabel.textAlignment=1;
        centerLabel.font=[UIFont systemFontOfSize:17.0f];
        [downView addSubview:centerLabel];
        //左减
        UIButton *redBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [redBtn setImage:[UIImage imageNamed:@"grey_red"] forState:UIControlStateNormal];
        redBtn.frame=CGRectMake(40, 75, 50, 50);
        redBtn.layer.borderWidth=1.0;
        redBtn.layer.borderColor=[[UIColor grayColor]CGColor];
        [redBtn addTarget:self action:@selector(redBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:redBtn];
        //右加
        UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"grey_add"] forState:UIControlStateNormal];
        addBtn.frame=CGRectMake(SCREENWIDTH-40-50, 75, 50, 50);
        addBtn.layer.borderWidth=1.0;
        addBtn.layer.borderColor=[[UIColor grayColor]CGColor];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:addBtn];
        //立即购买
        UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.frame=CGRectMake(0, 160, SCREENWIDTH, 40);
        buyBtn.backgroundColor=NavBackGroundColor;
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [downView addSubview:buyBtn];
        //显示次数的label
        countLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-25, 75, 50, 50)];
        countLab.textColor=[UIColor redColor];
        countLab.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
        countLab.font=[UIFont systemFontOfSize:20.0f];
        countLab.textAlignment=1;
        [downView addSubview:countLab];
        
        [UIView animateWithDuration:0.4 animations:^{
            backgroundView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
        } completion:^(BOOL finished) {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [backgroundView addGestureRecognizer:tap];
            //动画结束后，请求最新剩余人数
        }];
        
        
    }else{
        LandingController *landViewController=[[LandingController alloc]init];
        [self .navigationController pushViewController:landViewController animated:YES];
    }
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    UIView *view=[tap view];
    [UIView animateWithDuration:0.6 animations:^{
        view.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

-(void)redBtnClick{
    if (count!=0) {
        count--;
        countLab.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    }
}
-(void)addBtnClick{
    int lastPerson = [self.array[_index][5] intValue];
    if (count<lastPerson) {
        count++;
        countLab.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    }
}
//店家立即购买，去选择何种支付
-(void)buyClick{
    GoShopViewController *shopVC=[[GoShopViewController alloc]init];
    shopVC.counts=count;
    shopVC.imageName=_array[_index][1];
    shopVC.shopName =_array[_index][0];
    shopVC.issue=_array[_index][3];
    shopVC.delegate=self;
    [self.navigationController pushViewController:shopVC animated:YES];
    backgroundView.hidden=YES;
}
//请求最新剩余次数
-(void)lastPersonRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/award_remain_get.php"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.array[_index][3] forKey:@"issue"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         if (result.count>0) {
             NSNumber *lastCount=result[0];
             [_myNewArray replaceObjectAtIndex:5 withObject:lastCount];
             if (_tableView) {
                 [_tableView reloadData];
             }
         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

}
//查询本次参与纪录
-(void)recordRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"http://101.201.100.191/VipCard/award_current_query.php"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.array[_index][3] forKey:@"issue"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray* result)
     {
         NSLog(@"%@",result);
         if (result.count>0) {
             for (int i=0; i<result.count; i++) {
                 [recordArray addObject:result[i]];
             }
             if (_tableView) {
                 [_tableView reloadData];
             }
        }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];

}
#pragma mark -- GoShopViewControllerDelegate
-(void)awardResult:(NSArray *)awardArr{
    infoArray=awardArr;
    noticeView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT/2-50, SCREENWIDTH, 100)];
    noticeView.backgroundColor=[UIColor whiteColor];
    [self.view  addSubview:noticeView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 30)];
    label.text=@"活动已结束，即将揭晓中奖名单";
    label.textAlignment=1;
    label.textColor=[UIColor grayColor];
    [noticeView addSubview:label];
    if (lastTimeLabel==nil) {
        lastTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 40)];
        lastTimeLabel.text=@"5";
        lastTimeLabel.textAlignment=1;
        [noticeView addSubview:lastTimeLabel];
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeTime:) userInfo:lastTimeLabel repeats:YES];
        [timer fire];
    }
}

-(void)changeTime:(NSTimer *)timer{
    static int num = 9;
    num--;
    lastTimeLabel.text=[[NSString alloc]initWithFormat:@"%ld",(long)num];
    if (num==-1) {
        [timer invalidate];
        timer=nil;
        [noticeView removeFromSuperview];
        //中奖名单的view
        UIView *awardResultView=[[UIView alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT/2-100, SCREENWIDTH-20, 200)];
        awardResultView.backgroundColor=[UIColor cyanColor];
        [self.view addSubview:awardResultView];
        //背景view绑定电击手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipClick:)];
        [awardResultView addGestureRecognizer:tap];

        UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 40)];
        topLabel.text=@"本期获奖者";
        topLabel.textAlignment=1;
        topLabel.font=[UIFont systemFontOfSize:20.0f];
        [awardResultView addSubview:topLabel];
        //图像
        UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 80, 80)];
        NSURL * nurl=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:infoArray[4]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [headImage sd_setImageWithURL:nurl placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        [awardResultView addSubview:headImage];
        //昵称
        UILabel *nickLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 60, SCREENWIDTH-100, 40)];
        nickLabel.text=infoArray[1];
        [awardResultView addSubview:nickLabel];
        //抽奖时间
        UILabel *awardTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(100, 110, SCREENWIDTH-100, 40)];
        awardTimeLab.text=infoArray[2];
        [awardResultView addSubview:awardTimeLab];
        //抽奖次数
        UILabel *countLabs=[[UILabel alloc]initWithFrame:CGRectMake(100, 160, SCREENWIDTH-100, 40)];
        countLabs.text=[[NSString alloc]initWithFormat:@"抽奖次数%@",infoArray[3]];
        [awardResultView addSubview:countLabs];
    }
}

-(void)tipClick:(UITapGestureRecognizer *)tap{
    UIView *backView=[tap view];
    [backView removeFromSuperview];
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
