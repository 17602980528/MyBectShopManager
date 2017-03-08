//
//  CommenDataViewController.m
//  BletcShop
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CommenDataViewController.h"
#import "UIImageView+WebCache.h"
#import "PersonDetailViewController.h"
#import "JHChartHeader.h"
@interface CommenDataViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIButton *today_btn;
    NSString *type_date;
    int page;
    NSArray *record_type_A;
    UIScrollView *scroll_View;
    
    UIButton *detailBtn;
    UIButton *checkBtn;
    NSString *lzdunit;
}


@property(nonatomic,strong)UILabel *totalMoney;
@property(nonatomic,strong)UILabel *totalCount;
@property(nonatomic,strong)NSMutableArray *mutableArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *btnView;
@property(nonatomic)BOOL isOpen;
@property(nonatomic,strong)NSArray *dateArray;
@property(nonatomic,strong)UIView *tongjiView;
@end

@implementation CommenDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _dateArray=@[@"month",@"year"];
    record_type_A = @[@"buy",@"renew",@"upgrade",@"consum"];
    page = 0;
    type_date =@"month";
    lzdunit = @"天";
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    backView.backgroundColor=NavBackGroundColor;
    [self.view addSubview:backView];
    
    today_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    today_btn.frame=CGRectMake(10, 30, 100, 40);
    today_btn.layer.borderWidth=0.5;
    today_btn.layer.borderColor=[[UIColor whiteColor]CGColor];
    [today_btn setTitle:@"本月" forState:UIControlStateNormal];
    [today_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [today_btn addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:today_btn];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(130, 10, 1, 80)];
    lineView.backgroundColor=[UIColor whiteColor];
    [backView addSubview:lineView];
    
    UILabel *moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(140, 15, (SCREENWIDTH-140)/2, 25)];
    moneyLab.text=@"金额";
    moneyLab.textColor=[UIColor whiteColor];
    moneyLab.textAlignment=1;
    [backView addSubview:moneyLab];
    
    _totalMoney=[[UILabel alloc]initWithFrame:CGRectMake(140, 50, (SCREENWIDTH-140)/2, 40)];

    _totalMoney.text=@"0";
    _totalMoney.textAlignment=1;
    _totalMoney.textColor=[UIColor whiteColor];
    _totalMoney.font=[UIFont systemFontOfSize:18.0f];

   
    [backView addSubview:_totalMoney];
    
    UILabel *countLab=[[UILabel alloc]initWithFrame:CGRectMake(140+(SCREENWIDTH-140)/2, 15, (SCREENWIDTH-140)/2, 25)];
    countLab.text=@"笔数";
    countLab.textColor=[UIColor whiteColor];
    countLab.textAlignment=1;
    [backView addSubview:countLab];
    
    _totalCount=[[UILabel alloc]initWithFrame:CGRectMake(140+(SCREENWIDTH-140)/2, 50, (SCREENWIDTH-140)/2, 40)];
    _totalCount.textColor=[UIColor whiteColor];
    _totalCount.textAlignment=1;
    _totalCount.font=[UIFont systemFontOfSize:21.0f];
    _totalCount.text=@"0";
    [backView addSubview:_totalCount];
    
     detailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:@"明细" forState:UIControlStateNormal];
    [detailBtn setBackgroundColor:[UIColor whiteColor]];
    [detailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    detailBtn.frame=CGRectMake(0, 100, SCREENWIDTH/2, 40);
    [self.view addSubview:detailBtn];
    [detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    checkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setTitle:@"统计" forState:UIControlStateNormal];
    [checkBtn setBackgroundColor:[UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0]];
    [checkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    checkBtn.frame=CGRectMake(SCREENWIDTH/2, 100, SCREENWIDTH/2, 40);
    [self.view addSubview:checkBtn];
    [checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     scroll_View=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, SCREENHEIGHT-140-64)];
    scroll_View.pagingEnabled=YES;
    scroll_View.bounces=NO;
    scroll_View.delegate = self;
    scroll_View.contentSize=CGSizeMake(SCREENWIDTH*2, SCREENHEIGHT-140-64);
    scroll_View.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll_View];
    
    
    self.tongjiView=[[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-140-64)];
    [scroll_View addSubview:self.tongjiView];

    
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-140-64)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [scroll_View addSubview:self.tableView];
    
    self.mutableArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    if (self.tag==1) {
        self.navigationItem.title=@"办卡记录";
    }else if (self.tag==2){
        self.navigationItem.title=@"续卡记录";
    }else if (self.tag==3){
        self.navigationItem.title=@"升级记录";
    }else if (self.tag==4){
        self.navigationItem.title=@"消费记录";
    }
    
    [self totalDataRequest:record_type_A[self.tag-1] dateType:type_date page:@"0"];
    
    //创建一个view，放日，月，年 等
    NSArray *array=@[@"本月",@"本年"];
    _btnView=[[UIView alloc]initWithFrame:CGRectMake(10, 70, 100, 0)];
    _btnView.backgroundColor=[UIColor whiteColor];
    _btnView.clipsToBounds=YES;
    for (int i=0; i<array.count; i++) {
        UIButton *dateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        dateBtn.tag=i+10;
        dateBtn.frame=CGRectMake(0, i*40, 100, 40);
        [dateBtn setTitle:array[i] forState:UIControlStateNormal];
        [dateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [dateBtn addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:dateBtn];
    }
    [self.view addSubview:_btnView];
    
    [self getReportDataWithDate_type:self.tag-1];

    
}
-(void)detailBtnClick:(UIButton*)sender{
    NSLog(@"=====明细");
    
    checkBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0];
    sender.backgroundColor =[UIColor whiteColor];

    
   
    scroll_View.contentOffset = CGPointMake(0, 0);
    
}
-(void)checkBtnClick:(UIButton*)sender{
    detailBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0];
    sender.backgroundColor =[UIColor whiteColor];
    
    scroll_View.contentOffset = CGPointMake(SCREENWIDTH, 0);

    NSLog(@"=====统计");

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mutableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 50, 50)];
        imageView.tag=100;
        [cell addSubview:imageView];
        
        UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 7, 180, 25)];
        topLabel.tag=200;
        [cell addSubview:topLabel];
        
        UILabel *bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 32, 180, 25)];
        bottomLabel.textColor=[UIColor grayColor];
        bottomLabel.tag=300;
        [cell addSubview:bottomLabel];
        
        UILabel *rightLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-80, 12, 80, 40)];
        rightLable.textAlignment=1;
        rightLable.tag=400;
        [cell addSubview:rightLable];
    }
    UIImageView *imgView=[cell viewWithTag:100];
    UILabel *topLab=[cell viewWithTag:200];
    UILabel *bottomLab=[cell viewWithTag:300];
    UILabel *rightLab=[cell viewWithTag:400];
    
    if (self.mutableArray.count>0) {

        NSString *imgStr =_mutableArray[indexPath.row][@"headimage"];
        
        
        NSURL * url=[[NSURL alloc] initWithString:[[HEADIMAGE stringByAppendingString:imgStr]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user.png"] options:SDWebImageRetryFailed];
        topLab.text=_mutableArray[indexPath.row][@"order_code"];
        bottomLab.text=_mutableArray[indexPath.row][@"datetime"];
        rightLab.text=_mutableArray[indexPath.row][@"sum"];
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
//请求各时间段消费情况数据
-(void)totalDataRequest:(NSString *)record_type dateType:(NSString *)type page:(NSString *)pag{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/record/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:record_type forKey:@"record_type"];
    [params setObject:type forKey:@"date_type"];
    [params setObject:pag forKey:@"page"];
    
    DebugLog(@"params----%@",params);
    __block CommenDataViewController *tempSelf=self;
    
    if ([pag intValue]==0) {
        [tempSelf.mutableArray removeAllObjects];

    }
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {

         NSLog(@"result===%@",result);
         
         tempSelf.totalCount.text= [NSString getTheNoNullStr:[result objectForKey:@"count"] andRepalceStr:@"0"];
      
             ;

         tempSelf.totalMoney.text= [NSString stringWithFormat:@"%.2f元",[[NSString getTheNoNullStr:result[@"sum"] andRepalceStr:@"0"]floatValue]];
         
         
         if ([[result objectForKey:@"info"] count]>0) {
             
             for (NSDictionary *dic in [result objectForKey:@"info"]) {
                 [tempSelf.mutableArray addObject:dic];

             }
             
         }
         
         [tempSelf.tableView reloadData];
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         
     }];
    
}
// 上拉加载的原理
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    NSLog(@"%f",scrollView.contentOffset.y);
    NSLog(@"%f",scrollView.frame.size.height);
    NSLog(@"%f",scrollView.contentSize.height);
    
    /**
     *  关键-->
     *  scrollView一开始并不存在偏移量,但是会设定contentSize的大小,所以contentSize.height永远都会比contentOffset.y高一个手机屏幕的
     *  高度;上拉加载的效果就是每次滑动到底部时,再往上拉的时候请求更多,那个时候产生的偏移量,就能让contentOffset.y + 手机屏幕尺寸高大于这
     *  个滚动视图的contentSize.height
     */
    
    if (scrollView.contentOffset.y >64*7) {
        //        static int page=0;
        page++;
        NSString *pageStr=[NSString stringWithFormat:@"%d",page];
        
        NSLog(@"%d %s",__LINE__,__FUNCTION__);
        [UIView commitAnimations];
        
        [UIView animateWithDuration:1.0 animations:^{
            //  frame发生的偏移量,距离底部往上提高60(可自行设定)
            //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            
            /**
             *  发起网络请求,请求加载更多数据
             *  然后在数据请求回来的时候,将contentInset改为(0,0,0,0)
             */
            
            [self totalDataRequest:record_type_A[self.tag-1] dateType:type_date page:pageStr];
            
            
        }];
        
    }
}
//选取某个时间段的统计数据
-(void)chooseDate{
    
    if (!self.isOpen) {
        [UIView animateWithDuration:0.5 animations:^{
            _btnView.frame=CGRectMake(10, 70, 100, 80);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _btnView.frame=CGRectMake(10, 70, 100, 0);
        }];
    }
    self.isOpen=!self.isOpen;
    
}
-(void)dateSelect:(UIButton *)sender{
    self.isOpen=!self.isOpen;
    [UIView animateWithDuration:0.5 animations:^{
        _btnView.frame=CGRectMake(10, 70, 100, 0);
    }];
    
    [today_btn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    
    [self.mutableArray removeAllObjects];
    type_date =_dateArray[sender.tag-10];
    
    [self totalDataRequest:record_type_A[self.tag-1] dateType:type_date page:@"0"];
    
    [self getReportDataWithDate_type:self.tag-1];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag==1) {
        
        PersonDetailViewController *PDVC=[[PersonDetailViewController alloc]init];
        PDVC.title=@"买卡";
        PDVC.titleArray=@[@"会员卡编号",@"会员卡级别",@"会员卡类型",@"办卡日期",@"记录编号"];
        NSMutableArray *newArray=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<5; i++) {
            if (i==0) {
                [newArray addObject:self.mutableArray[indexPath.row][@"card_code"]];
            }else if (i==1){
                [newArray addObject:self.mutableArray[indexPath.row][@"card_level"]];
            }else if (i==2){
                [newArray addObject:self.mutableArray[indexPath.row][@"card_type"]];
            }else if (i==3){
                [newArray addObject:self.mutableArray[indexPath.row][@"datetime"]];
            }else if (i==4){
                [newArray addObject:self.mutableArray[indexPath.row][@"order_code"]];
            }
        }
        PDVC.array=newArray;
        PDVC.totalMoney=self.mutableArray[indexPath.row][@"sum"];
        [self.navigationController pushViewController:PDVC animated:YES];
    }else if (self.tag==2){
        
        PersonDetailViewController *PDVC=[[PersonDetailViewController alloc]init];
        PDVC.title=@"续卡";
        PDVC.titleArray=@[@"会员卡编号",@"会员卡级别",@"续卡日期",@"记录编号"];
        NSMutableArray *newArray=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<4; i++) {
            if (i==0) {
                [newArray addObject:self.mutableArray[indexPath.row][@"card_code"]];
            }else if (i==1){
                [newArray addObject:self.mutableArray[indexPath.row][@"card_level"]];
            }else if (i==2){
                [newArray addObject:self.mutableArray[indexPath.row][@"datetime"]];
            }else if (i==3){
                [newArray addObject:self.mutableArray[indexPath.row][@"order_code"]];
            }
        }
        PDVC.array=newArray;
        PDVC.totalMoney=self.mutableArray[indexPath.row][@"sum"];
        [self.navigationController pushViewController:PDVC animated:YES];
    }else if (self.tag==3){
        
        PersonDetailViewController *PDVC=[[PersonDetailViewController alloc]init];
        PDVC.title=@"升级";
        PDVC.titleArray=@[@"会员卡编号",@"会员卡旧级别",@"会员卡新级别",@"升级日期",@"记录编号"];
        NSMutableArray *newArray=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<5; i++) {
            if (i==0) {
                [newArray addObject:self.mutableArray[indexPath.row][@"card_code"]];
            }else if (i==1){
                [newArray addObject:self.mutableArray[indexPath.row][@"old_card_level"]];
            }else if (i==2){
                [newArray addObject:self.mutableArray[indexPath.row][@"new_card_level"]];
            }else if (i==3){
                [newArray addObject:self.mutableArray[indexPath.row][@"datetime"]];
            }else if (i==4){
                [newArray addObject:self.mutableArray[indexPath.row][@"order_code"]];
            }
        }
        PDVC.array=newArray;
        PDVC.totalMoney=self.mutableArray[indexPath.row][@"sum"];
        [self.navigationController pushViewController:PDVC animated:YES];
    }else if (self.tag==4){

        PersonDetailViewController *PDVC=[[PersonDetailViewController alloc]init];
        PDVC.title=@"消费";
        NSMutableArray *newArray=[[NSMutableArray alloc]initWithCapacity:0];
        NSMutableArray *nameArray=[[NSMutableArray alloc]initWithObjects:@"消费日期",@"记录编号", nil];
        for (int i=0; i<3; i++) {
            if (i==0) {
                [newArray addObject:self.mutableArray[indexPath.row][@"datetime"]];
            }else if (i==1){
                [newArray addObject:self.mutableArray[indexPath.row][@"order_code"]];
            }else if (i==2){
                NSString *wholeInfo = self.mutableArray[indexPath.row][@"content"];
                NSArray *array=[wholeInfo componentsSeparatedByString:PAY_USCS];
                
                NSString *string=array[1];
                if ([string isContainSubString:PAY_UORC]) {
                    NSArray *moreOrderInfo=[string componentsSeparatedByString:PAY_UORC];
                    for (int j=0; j<moreOrderInfo.count; j++) {
                        NSString *shopAndPrice=moreOrderInfo[j];
                        NSArray *resultArray=[shopAndPrice componentsSeparatedByString:PAY_NP];
                        [newArray addObject:resultArray[1]];
                        [nameArray addObject:resultArray[0]];
                    }
                }else{
                    NSArray * merAndPri = [string componentsSeparatedByString:PAY_NP];
                    [newArray addObject:merAndPri[1]];
                    [nameArray addObject:merAndPri[0]];
                }
            }
        }
        PDVC.titleArray = nameArray;
        PDVC.array=newArray;
        
        PDVC.totalMoney=self.mutableArray[indexPath.row][@"sum"];
        [self.navigationController pushViewController:PDVC animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x==0) {
        
        checkBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0];
        detailBtn.backgroundColor =[UIColor whiteColor];
    }else{
        
        detailBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:247/255.0 alpha:1.0];
        checkBtn.backgroundColor =[UIColor whiteColor];
    }
}

-(void)initlineChartWithArray:(NSArray*)vareArr andDateArray:(NSArray*)dateA{
    
    for (UIView *view in self.tongjiView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *date_a = [NSMutableArray array];
    
    for (int i =1; i <=vareArr.count; i ++) {
        [date_a addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
//    NSLog(@"-----%@===%@",date_a,vareArr);
    
    /*     Create object        */
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(5, 40, kWeChatScreenWidth-10, self.tongjiView.height-100) andLineChartType:JHChartLineValueNotForEveryX];
    
    /* The scale value of the X axis can be passed into the NSString or NSNumber type and the data structure changes with the change of the line chart type. The details look at the document or other quadrant X axis data source sample.*/
    
    lineChart.xLineDataArr = date_a;
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    /* The different types of the broken line chart, according to the quadrant division, different quadrant correspond to different X axis scale data source and different value data source. */
    
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    NSMutableArray *d_a = [NSMutableArray array];
    
    for (int i =1; i <=vareArr.count; i ++) {
        [d_a addObject:[NSString stringWithFormat:@"%d",arc4random()%50]];
        
    }
    
    
    lineChart.valueArr = @[d_a];
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.valueFontSize = 9.0;
    lineChart.backgroundColor = [UIColor whiteColor];
    /* Line Chart colors */
    lineChart.valueLineColorArr =@[[UIColor greenColor]];
    /* Colors for every line chart*/
    lineChart.pointColorArr = @[[UIColor orangeColor]];
    /* color for XY axis */
    lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    lineChart.positionLineColorArr = @[[UIColor blueColor]];
    /*        Set whether to fill the content, the default is False         */
    lineChart.contentFill = NO;
    /*        Set whether the curve path         */
    lineChart.pathCurve = YES;
    /*        Set fill color array         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468]];
    [self.tongjiView addSubview:lineChart];
    /*       Start animation        */
    [lineChart showAnimation];
    

    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, lineChart.bottom-10, lineChart.width-10, 15)];
    lable.text = [NSString stringWithFormat:@"单位(%@)",lzdunit];
    lable.textColor = RGB(51, 51, 51);
    lable.font = [UIFont systemFontOfSize:9];
    lable.textAlignment = NSTextAlignmentRight;
    [self.tongjiView addSubview:lable];
    
    
    UILabel *shu_lable = [[UILabel alloc]initWithFrame:CGRectMake(-18, lineChart.top+20, 50, 10)];
    shu_lable.text = @"单位(元)";
    shu_lable.textColor = RGB(51, 51, 51);
    shu_lable.transform =CGAffineTransformMakeRotation(-M_PI_2);
    
    shu_lable.font = [UIFont systemFontOfSize:9];
    [self.tongjiView addSubview:shu_lable];


}

-(void)getReportDataWithDate_type:(NSInteger)index{
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/record/getSortChart",BASEURL];
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSArray *arr = @[@"buy",@"renew",@"upgrade",@"tally"];
    
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];

    NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc]init];

    
    if ([type_date isEqualToString:@"month"]) {
        [formatter setDateFormat:@"yyyy-MM"];
        
        [nowDateFormatter setDateFormat:@"dd"];
        lzdunit = @"天";

        

    }else{
        [formatter setDateFormat:@"yyyy"];
        [nowDateFormatter setDateFormat:@"MM"];
        lzdunit = @"月";

           }
    
    
    NSString *nowDate = [formatter stringFromDate:date];;
    
    //截止几天(含今天)/或截止本月;
    NSString *jiezhiDate = [nowDateFormatter stringFromDate:date];
    
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];
    [paramer setValue:arr[index] forKey:@"type"];
    [paramer setValue:nowDate forKey:@"date"];
    [paramer setValue:type_date forKey:@"date_type"];

    
    NSLog(@"----paramer%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"===%@===%@",[result class],result);
        
        
        if (result){
            NSMutableArray *mutable_A = [NSMutableArray arrayWithArray:result];
            
            NSArray *vule_A =  [mutable_A subarrayWithRange:NSMakeRange(0, [jiezhiDate intValue])];
            
            [self initlineChartWithArray:vule_A andDateArray:nil];
            
        }else{
            
            [self showHint:@"请求失败"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"=====%@",error);
    }];
    
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
