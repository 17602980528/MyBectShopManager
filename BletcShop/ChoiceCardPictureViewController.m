//
//  ChoiceCardPictureViewController.m
//  BletcShop
//
//  Created by Bletc on 16/8/1.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ChoiceCardPictureViewController.h"
#import "UIImageView+WebCache.h"
@interface ChoiceCardPictureViewController ()

@end

@implementation ChoiceCardPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择会员卡";
    [self postRequestGetCard];
    
}
-(void)postRequestGetCard
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/card/cardTempGet",BASEURL];

    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"%@", result);
        NSArray *arr = [[NSArray alloc]init];
        arr = result;
        
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"CARDIMGTEMP"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        for (int i=0; i<arr.count; i++) {
            
            [self.allCards addObject:[arr objectAtIndex:i]];
        }
        [self downLoadImage];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

}
-(void)downLoadImage
{
    // 1.创建9个UIImageView
    //    NSLog(@"self.urls = %ld",[self.urls count]);
    
    CGFloat width = (SCREENWIDTH-60)/2;
    CGFloat height = 120;
    if (SCREENWIDTH>320) {
        height = 120;
    }else
        height = 90;
    CGFloat margin = 20;
    CGFloat startX = 20;
    CGFloat startY = 20;
    for (int i = 0; i<[self.allCards count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        self.scrollView.contentSize = imageView.image.size;
        imageView.frame = CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height);
        // 计算位置
        int row = i/2;
        int column = i%2;
        CGFloat x = startX + column * (width + margin);
        CGFloat y = startY + row * (height + margin);
        imageView.frame = CGRectMake(x, y, width, height);
        
        // 下载图片
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCECARD stringByAppendingString:self.allCards[i][@"image"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [imageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"timeline_image_loading.png"] options:SDWebImageRetryFailed];

        // 事件监听
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        // 内容模式
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}
-(void)viewWillAppear:(BOOL)animated
{


    self.allCards = [[NSMutableArray alloc]init];
    [self _initScolleView];
    //[self getImage];
}
-(void)_initScolleView
{
    UIScrollView *mytable = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    mytable.backgroundColor = [UIColor lightGrayColor];
    self.scrollView = mytable;
    //self.view.backgroundColor = tableViewBackgroundColor;
    [self.view addSubview:mytable];
}
-(void)viewDidAppear:(BOOL)animated
{
    if(self.allCards.count%2==1)
    {
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, (self.allCards.count/2+1
                                                           )*(120+20)+64);
    }else{
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, (self.allCards.count/2)*(120+20)+64);
    }//((unsigned long)([self.urls count])/15)
    _scrollView.scrollEnabled = YES;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    [self.delegate sendCardValue:self.allCards[tap.view.tag]];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
