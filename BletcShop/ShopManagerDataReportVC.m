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
@end

@implementation ShopManagerDataReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"数据报表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.data_A.count!=0) {
        
        NSMutableArray *mutab_A = [NSMutableArray array];
        NSMutableArray *mutab_A_X = [NSMutableArray array];
        NSMutableArray *mutab_A_Y = [NSMutableArray array];


        for (NSDictionary *dic in self.data_A) {
            
            NSMutableArray *mutab_A_YY = [NSMutableArray array];
            [mutab_A_X addObject:dic[@"store"]];
            
            [mutab_A_YY addObject:dic[@"sum"]];

            [mutab_A_Y addObject:mutab_A_YY];

        }
        
        [mutab_A addObject:mutab_A_X];
        [mutab_A addObject:mutab_A_Y];
        
        [self creatColumnChartWithArray:mutab_A];

    }
    
    
    
    
    
    
}

-(void)creatColumnChartWithArray:(NSMutableArray*)array{
    
    
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 50, kWeChatScreenWidth, SCREENHEIGHT *2/5)];
    
    
    column.valueArr = array[1] ;
    
    column.drawFromOriginX = 20;
    column.isShowYLine = NO;
    column.columnWidth = SCREENWIDTH*0.133;
    
    column.typeSpace = (SCREENWIDTH  -column.columnWidth*(column.valueArr.count+1)) /(column.valueArr.count +1 );
    
    
    
    //    CGFloat originX = (SCREENWIDTH-column.typeSpace*(column.valueArr.count+1)-column.columnWidth*column.valueArr.count)/2;
    
    column.originSize = CGPointMake(30, 17);
    
    
    column.bgVewBackgoundColor = [UIColor whiteColor];
    column.drawTextColorForX_Y = [UIColor blackColor];
    column.colorForXYLine = [UIColor darkGrayColor];
    column.columnBGcolorsArr = @[[UIColor colorWithRed:72/256.0 green:200.0/256 blue:255.0/256 alpha:1],[UIColor greenColor],[UIColor orangeColor]];
    column.xShowInfoText = array[0];
    column.xDescTextFontSize = 9;
    [column showAnimation];
    [self.view addSubview:column];
    
}

@end
