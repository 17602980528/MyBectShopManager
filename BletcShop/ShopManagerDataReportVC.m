//
//  ShopManagerDataReportVC.m
//  BletcShop
//
//  Created by Bletc on 2017/4/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShopManagerDataReportVC.h"
#import "JHChartHeader.h"
@interface ShopManagerDataReportVC ()
{
    NSArray *title_array;
}
@end

@implementation ShopManagerDataReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"数据报表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    title_array=@[@"办卡",@"续卡",@"升级",@"现金支付"];
    
    
    [self getData];
    
    
    
    
}

-(void)getData{
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/record/getMainChart",BASEURL];
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];
    
    
    NSLog(@"----paramer%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"===%@",result);
        
        if (result){
            [self creatColumnChartWithDic:result[@"income"]];
            
        }else{
            
            [self showHint:@"请求失败"];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"=====%@",error);
    }];
    
}

-(void)creatColumnChartWithDic:(NSDictionary*)dic{
    
    
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 50, kWeChatScreenWidth, SCREENHEIGHT *2/5)];
    
    NSString * renew = [NSString getTheNoNullStr:dic[@"renew"] andRepalceStr:@"0"];
    
    NSString * upgrade = [NSString getTheNoNullStr:dic[@"upgrade"] andRepalceStr:@"0"];
    
    NSString * tally = [NSString getTheNoNullStr:dic[@"tally"] andRepalceStr:@"0"];
    
    NSString * buy = [NSString getTheNoNullStr:dic[@"buy"] andRepalceStr:@"0"];
    
    
    column.valueArr = @[
                        @[buy],
                        @[renew],
                        @[upgrade],
                        @[tally],
                        
                        ];
    
    column.drawFromOriginX = 20;
    column.isShowYLine = NO;
    column.columnWidth = SCREENWIDTH*0.133;
    
    column.typeSpace = (SCREENWIDTH  -column.columnWidth*(column.valueArr.count+1)) /(column.valueArr.count +1 );
    
    
    
    //    CGFloat originX = (SCREENWIDTH-column.typeSpace*(column.valueArr.count+1)-column.columnWidth*column.valueArr.count)/2;
    
    column.originSize = CGPointMake(30, 20);
    
    
    column.bgVewBackgoundColor = [UIColor whiteColor];
    column.drawTextColorForX_Y = [UIColor blackColor];
    column.colorForXYLine = [UIColor darkGrayColor];
    column.columnBGcolorsArr = @[[UIColor colorWithRed:72/256.0 green:200.0/256 blue:255.0/256 alpha:1],[UIColor greenColor],[UIColor orangeColor]];
    column.xShowInfoText = title_array;
    column.xDescTextFontSize = 10;
    [column showAnimation];
    [self.view addSubview:column];
    
}

@end
