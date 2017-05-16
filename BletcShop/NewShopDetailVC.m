//
//  NewShopDetailVC.m
//  BletcShop
//
//  Created by Bletc on 2017/5/12.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "NewShopDetailVC.h"
#import "UIImageView+WebCache.h"
#import "DLStarRatingControl.h"
#import "LandingController.h"
#import "NewBuyCardViewController.h"
#import "BDMapViewController.h"
#import "NewShopCardListCell.h"
#import "SRVideoPlayer.h"
#import "ApriseVC.h"
@interface NewShopDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIWebViewDelegate>
{
    UIButton *collectBtn;
    NSDictionary *wholeInfoDic;
    UIButton *title_old_btn;
    float           _webHight;

    UIWebView *web_view;
    

}
@property BOOL state;
@property(nonatomic,strong)NSMutableArray *cardArray;//卡
@property(nonatomic,strong) UITableView *shopTableView;
@property(nonatomic,strong)NSArray *pictureAndTextArray;

@property (nonatomic, strong) SRVideoPlayer *videoPlayer;
@property(strong,nonatomic)UIButton *playImageView;

@end

@implementation NewShopDetailVC
-(NSArray *)pictureAndTextArray{
    if (!_pictureAndTextArray) {
        _pictureAndTextArray = [NSArray array];
    }
    return _pictureAndTextArray;
}
-(NSMutableArray *)cardArray{
    if (!_cardArray) {
        _cardArray = [NSMutableArray array];
    }
    return _cardArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.state = NO;
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appdelegate.IsLogin) {
        [self postRequestState];
    }
    else
    {
        self.state = NO;
    }
    
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_videoPlayer destroyPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _webHight = 0.0f;
    
    
    web_view = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 755)];
    web_view.delegate = self;
    web_view.scrollView.bounces=NO;
    web_view.scrollView.scrollEnabled = NO;
    
    NSString *urlStr =[[NSString alloc]init];
    urlStr = [[NSString alloc]initWithFormat:@"http://%@/VipCard/risk_control.html",SOCKETHOST ];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [web_view loadRequest:request];

    
    [self initTableView];

    [self initFootView];

    
    [self postRequestWholeInfo];
}

-(void)initTableView{
    
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    table.showsVerticalScrollIndicator = NO;
    self.shopTableView = table;
    [self.view addSubview:table];
}
-(void)initFootView{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-49, SCREENWIDTH, 49)];
    footView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:footView];
    
    collectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame=CGRectMake(0, 0, (SCREENWIDTH)/2, 49);
    [collectBtn setTitle:@"立即收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footView addSubview:collectBtn];
    [collectBtn addTarget:self action:@selector(favorateAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame=CGRectMake((SCREENWIDTH)/2, 0, (SCREENWIDTH)/2, 49);
    buyBtn.backgroundColor=NavBackGroundColor;
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        
        if (self.cardArray.count>0)
        {
            
            return 70+1;
        }else
            return 40+1;

    }else if(indexPath.section==1){
        NSArray *arr = wholeInfoDic[@"commodity_list"];
        if (arr.count!=0) {
            return 150;
        }else{
            return 40;
            
        }
    }else if (indexPath.section==2){
         UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;
    }
    else if(indexPath.section==3){
        if (title_old_btn.tag==1) {
            
            UIView *content_View = [self initcontentView];

            return content_View.height;
        }else if (title_old_btn.tag ==2){
           
            
//            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//            
//            return cell.frame.size.height;
            return _webHight;
        
        }else{
            if (indexPath.row!=0) {
                NSString *str = self.pictureAndTextArray[indexPath.row-1][@"type"];
                if ([str isEqualToString:@"1"]) {
                    return SCREENWIDTH*2/3;
                }else if([str isEqualToString:@"0"]||[str isEqualToString:@"2"]){
                    return (SCREENWIDTH/2-10)*2/3+10;
                }
                return SCREENWIDTH*2/3;
            }else{
                if (_pictureAndTextArray.count==0) {
                    return 40;
                }else{
                    return SCREENWIDTH*2/3;
 
                }
                
            }

        }
        
        
    }else if(indexPath.section==4)
    
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        NSArray *arr = wholeInfoDic[@"evaluate_list"];
        if(arr.count>0) {
            return cell.frame.size.height;
        }else{
            return 40;
        }
    }
    else return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.cardArray.count ?self.cardArray.count:1;
    }else if (section==1 ||section==2){
        return 1;
    }else  if(section==3){
        
        if (title_old_btn.tag==1) {
            
            
            return 1;
        }else if (title_old_btn.tag ==2){
            return 1;
        }else{
            return self.pictureAndTextArray.count? _pictureAndTextArray.count+1:1;
 
        }
    }else if(section==4){
        NSArray *evaluate_list = wholeInfoDic[@"evaluate_list"];
        
        return evaluate_list.count ?evaluate_list.count:1;

    }else
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }

    for (UIView *vw in cell.subviews) {
        if ([vw isKindOfClass:[UIWebView class]]) {
            
            vw.hidden = YES;
        }else{
            [vw removeFromSuperview];

        }
    }

    if (indexPath.section==0) {
        
      if (_cardArray.count!=0) {
          
          NewShopCardListCell *card_cell = [self creatCardListCell:indexPath];
          
          
          
          return card_cell;


        }else{
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
            [cell addSubview:label];
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"本店暂无可购买的卡";
            return cell;
        }
    }else if(indexPath.section==1){
        
        UIView *productView = [self creatproductView];
        
        [cell addSubview:productView];
      
        return cell;
    }else if (indexPath.section==2){
        
        UILabel *label2=[[UILabel alloc]init];
        label2.numberOfLines=0;
        label2.font = [UIFont systemFontOfSize:13.0];
        [cell addSubview:label2];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = RGB(225, 225, 225);
        [cell addSubview:line];
        
        NSString *inroString=[NSString getTheNoNullStr:wholeInfoDic[@"intro"] andRepalceStr:@"暂无介绍!"];
        
        if (inroString.length == 0 )
        {
            label2.hidden=YES;
            line.frame = CGRectMake(10, 0, SCREENWIDTH-20, 1);
            
        }else{
            label2.hidden=NO;
            label2.text=inroString;
            
            CGFloat labelHeight = [label2.text getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:label2.font AndInsets:5];
            
            NSLog(@"labelHeight===%f",labelHeight);
            label2.frame=CGRectMake(10, 12,SCREENWIDTH-20 , labelHeight);
            line.frame = CGRectMake(10, label2.bottom, SCREENWIDTH, 1);
            
        }
        CGRect frame = [cell frame];
        frame.size.height = line.bottom+5;
        cell.frame = frame;
        
        return cell;
        
    }
    
    else if (indexPath.section==3){
        UITableViewCell *DetailCell;
        
        if (title_old_btn.tag ==1) {
            
            UIView *content_View = [self initcontentView];
            
            [cell addSubview:content_View];
            DetailCell = cell;
            
        }else if (title_old_btn.tag ==2){
            
            
            [cell addSubview:web_view];
            web_view.hidden = NO;
           
            
            DetailCell = cell;
        }else{
            if (_pictureAndTextArray.count!=0) {
                DetailCell = [self creatCellWith:indexPath];

            }else{
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
                [cell addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                label.text = @"暂无详情，敬请期待";
                
                DetailCell = cell;
                
            }

            
        }
        
        
        return DetailCell;
    }else if(indexPath.section==4){
        {
            NSArray *evaluate_list = wholeInfoDic[@"evaluate_list"];
            if (evaluate_list.count==0)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
                [cell addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                label.text = @"本店暂无评价";
            }
            if(evaluate_list.count>0){
                
                NSDictionary *dic = evaluate_list[indexPath.row];
                
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 30, 30)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"3.1-02"]];
                imageView.contentMode=UIViewContentModeScaleAspectFill;
                imageView.layer.cornerRadius = imageView.width/2;
                imageView.layer.masksToBounds = YES;
                [cell addSubview:imageView];
                
                UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(53, 18, SCREENWIDTH-53, 13)];
                nameLabel.text=dic[@"nickname"];
                nameLabel.textAlignment=NSTextAlignmentLeft;
                nameLabel.font=[UIFont systemFontOfSize:13.0f];
                [cell addSubview:nameLabel];
                
                UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, SCREENWIDTH-20, 20)];
                [contentLb setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
                contentLb.numberOfLines = 0;
                [contentLb setLineBreakMode:NSLineBreakByWordWrapping];
                contentLb.text =dic[@"content"];
                CGRect frame = [cell frame];
                CGRect labelSize = [contentLb.text boundingRectWithSize:CGSizeMake(contentLb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:13.0f],NSFontAttributeName, nil] context:nil];
                contentLb.frame = CGRectMake(contentLb.frame.origin.x, contentLb.frame.origin.y, labelSize.size.width, labelSize.size.height);
                
                frame.size.height = contentLb.bottom+5;
                cell.frame = frame;
                [cell addSubview:contentLb];
                
                if (indexPath.row!=evaluate_list.count-1) {
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, contentLb.bottom+4, SCREENWIDTH, 1)];
                    line.backgroundColor = RGB(225, 225, 225);
                    [cell addSubview:line];
                }
                
                
            }
            
        }
        
        
        return cell;
    }else
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==4) {
        
        NSArray *arr = wholeInfoDic[@"evaluate_list"];
        if(arr.count>0) {
            return 40;
        }else{
            return 0.1;
        }

        
    }else
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return SCREENWIDTH*9/16+45+6+44+48+45-20;
    }else if (section==1 ||section==2||section==3||section==4){
        return 41;
    }else{
        return 10;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==4) {
        
       

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(0, 0, SCREENWIDTH, 40);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"查看更多评价" forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:RGB(51, 51, 51) forState:0];
        [button addTarget:self action:@selector(scanMoreInfo) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(225, 225, 225);
        [button addSubview:line];
        
        NSArray *arr = wholeInfoDic[@"evaluate_list"];
        if(arr.count>0) {
            return button;
        }else{
            return nil;
        }
    }else
        return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = RGB(225, 225, 225);
        [backView addSubview:line];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.numberOfLines = 0;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:17];
        nameLabel.tag = 1000;
        [backView addSubview:nameLabel];
        
        if ([self.videoID isEqualToString:@""]) {
            UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*9/16)];
            [backView addSubview:shopImageView];

            NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[wholeInfoDic  objectForKey:@"image_url"] andRepalceStr:@""]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
            
           
        }else{
            UIView *playerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*9/16)];
            [backView addSubview:playerView];

            NSString *url = [NSString stringWithFormat:@"%@%@",VEDIO_URL,self.videoID];
            NSLog(@"VEDIO_URL===%@",url);
            self.videoPlayer = [SRVideoPlayer playerWithVideoURL:[NSURL URLWithString:url] playerView:playerView playerSuperView:playerView.superview];
            _videoPlayer.videoName = @"";
            _videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
            [_videoPlayer pause];
        }
        
        nameLabel.frame=CGRectMake(12, SCREENWIDTH*9/16+5, SCREENWIDTH-12, 40);
        line.frame=CGRectMake(10, nameLabel.bottom+5, SCREENWIDTH, 1);
        
        nameLabel.text = [wholeInfoDic objectForKey:@"store"];
        
       //评价星星
        UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, line.bottom+7, 110, 30)];
        starLabel.backgroundColor = [UIColor clearColor];
        starLabel.textAlignment = NSTextAlignmentLeft;
        starLabel.font = [UIFont systemFontOfSize:15];
        starLabel.tag = 1000;
        DLStarRatingControl* dlCtrl = [[DLStarRatingControl alloc]initWithFrame:CGRectMake(0, 7, 110, 35) andStars:5 isFractional:YES star:[UIImage imageNamed:@"result_small_star_disable_iphone"] highlightStar:[UIImage imageNamed:@"redstar"]];
        dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        dlCtrl.userInteractionEnabled = NO;
        
          dlCtrl.rating = [[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"stars"] andRepalceStr:@"0"] floatValue];
        
        [starLabel addSubview:dlCtrl];
        [backView addSubview:starLabel];
        
        
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(200,line.bottom+15, SCREENWIDTH-200, 14)];
        lab1.textAlignment=NSTextAlignmentLeft;
        lab1.text=[[NSString alloc]initWithFormat:@"已售:%@",[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"sold"] andRepalceStr:@"0"]];
        lab1.font=[UIFont systemFontOfSize:13.0f];
        [backView addSubview:lab1];

        UILabel *points=[[UILabel alloc]initWithFrame:CGRectMake(150, line.bottom+7, 50, 30)];
        points.textColor=[UIColor redColor];
        points.font=[UIFont systemFontOfSize:15.0f];
        points.text=[NSString stringWithFormat:@"%.1f",dlCtrl.rating];
        [backView addSubview:points];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, line.bottom+43, SCREENWIDTH, 1)];
        line1.backgroundColor = RGB(225, 225, 225);
        [backView addSubview:line1];
        
        
        UIImageView *addressimg = [[UIImageView alloc]initWithFrame:CGRectMake(13, line1.bottom+15, 13, 16)];
        addressimg.image = [UIImage imageNamed:@"location"];
        [backView addSubview:addressimg];
        
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, line1.bottom+17, SCREENWIDTH-30, 14)];
        addressLabel.font = [UIFont systemFontOfSize:13];
        addressLabel.text = [wholeInfoDic objectForKey:@"address"];
        addressLabel.userInteractionEnabled = YES;
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMapView)];
        [addressLabel addGestureRecognizer:tapGesture];
        [backView addSubview:addressLabel];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, line1.bottom+43, SCREENWIDTH, 1)];
        line2.backgroundColor = RGB(225, 225, 225);
        [backView addSubview:line2];
        
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, line2.bottom, SCREENWIDTH, 40)];
        titlelabel.textAlignment=NSTextAlignmentCenter;
        titlelabel.font = [UIFont systemFontOfSize:15.0];
        titlelabel.text=@"会员卡";

        [backView addSubview:titlelabel];
        
        backView.frame = CGRectMake(0, 0, SCREENWIDTH, titlelabel.bottom+5);
        return backView;
        
    }else if(section==1||section==4 ||section==2){
        
        UIView *backView = [[UIView alloc]init];
        backView.frame = CGRectMake(0, 0, SCREENWIDTH, 41);

        backView.backgroundColor = [UIColor whiteColor];
        
        

        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        titlelabel.textAlignment=NSTextAlignmentCenter;
        titlelabel.font = [UIFont systemFontOfSize:15.0];
        titlelabel.text=@"全部商品";
        [backView addSubview:titlelabel];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = RGB(225, 225, 225);
        line.frame= CGRectMake(10, titlelabel.bottom, SCREENWIDTH, 1);
        [backView addSubview:line];
        
        
        if (section==2) {
            titlelabel.text = @"商家详情";
        }
        if (section==4) {
            titlelabel.text = @"会员评价";
        }
        return backView;
    } else if(section==3){
        
        UIView *backView = [[UIView alloc]init];
        backView.frame = CGRectMake(0, 0, SCREENWIDTH, 41);
        
        backView.backgroundColor = [UIColor whiteColor];
        NSArray *arr = @[@"图文详情",@"购买须知",@"安全保障"];
        for (int i = 0; i <arr.count; i ++) {
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           titleBtn.frame = CGRectMake(SCREENWIDTH/arr.count*i, 0, SCREENWIDTH/arr.count, 40);
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [titleBtn setTitleColor:RGB(51, 51, 51) forState:0];
            [titleBtn setTitle:arr[i] forState:0];
            titleBtn.tag = i;
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:titleBtn];
            
             if (i==title_old_btn.tag) {
                    title_old_btn = titleBtn;
                    [titleBtn setTitleColor:NavBackGroundColor forState:0];
                }
            }
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = RGB(225, 225, 225);
        line.frame= CGRectMake(10, 40, SCREENWIDTH, 1);
        [backView addSubview:line];
        
        
        return backView;
    }else{
        return nil;
    }
    
}

-(void)titleBtnClick:(UIButton*)sender{
    
    if (title_old_btn !=sender) {
        [sender setTitleColor:NavBackGroundColor forState:0];
        [title_old_btn setTitleColor:RGB(51, 51, 51) forState:0];
        title_old_btn = sender;
    }
    
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:3];
    [self.shopTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
}
-(UIView*)initcontentView{
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(13, 10, 3, 15)];
    view1.backgroundColor=[UIColor colorWithRed:66/255.0 green:170/255.0 blue:250/255.0 alpha:1.0f];
    [backView addSubview:view1];
    
    UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(22, 10, SCREENWIDTH-13, 13)];
    timeLable.textAlignment=NSTextAlignmentLeft;
    timeLable.text=@"使用时间:";
    timeLable.font=[UIFont systemFontOfSize:15.0f];
    [backView addSubview:timeLable];
    NSString *time=[NSString getTheNoNullStr:wholeInfoDic[@"time"] andRepalceStr:@"周一到周日  遇到节假日工作时间会有调整"];
    
    CGFloat labelHeight = [time getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:15.0] AndInsets:5];
    
    UILabel *timeContent=[[UILabel alloc]initWithFrame:CGRectMake(13, 34, SCREENWIDTH-13, labelHeight)];
    timeContent.numberOfLines=0;
    timeContent.font=[UIFont systemFontOfSize:15.0f];
    timeContent.textAlignment=NSTextAlignmentLeft;
    timeContent.textColor=[UIColor grayColor];
    timeContent.text=time;
    [backView addSubview:timeContent];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(13, 34+labelHeight+13, 3, 15)];
    view2.backgroundColor=[UIColor colorWithRed:66/255.0 green:170/255.0 blue:250/255.0 alpha:1.0f];
    [backView addSubview:view2];
    
    NSString *notice=[NSString getTheNoNullStr:wholeInfoDic[@"notice"] andRepalceStr:@"本店会员卡优惠多多"];
    
    CGFloat labelHeight2 = [notice getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:15.0] AndInsets:5];
    
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(22, 34+labelHeight+13, SCREENWIDTH-13, 13)];
    noticeLable.textAlignment=NSTextAlignmentLeft;
    noticeLable.text=@"注意事项";
    noticeLable.font=[UIFont systemFontOfSize:15.0f];
    [backView addSubview:noticeLable];
    
    UILabel *noticeContent=[[UILabel alloc]initWithFrame:CGRectMake(13, 34+labelHeight+13+13+11, SCREENWIDTH-26, labelHeight2)];
    noticeContent.numberOfLines=0;
    noticeContent.font=[UIFont systemFontOfSize:15.0f];
    noticeContent.text=notice;
    noticeContent.textAlignment=NSTextAlignmentLeft;
    noticeContent.textColor=[UIColor grayColor];
    [backView addSubview:noticeContent];
    
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(noticeContent.frame)+11, 3, 15)];
    view3.backgroundColor=[UIColor colorWithRed:66/255.0 green:170/255.0 blue:250/255.0 alpha:1.0f];
    [backView addSubview:view3];
    
    UILabel *phoneLable=[[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(noticeContent.frame)+11, SCREENWIDTH-13, 13)];
    phoneLable.textAlignment=NSTextAlignmentLeft;
    phoneLable.text=@"商家电话:";
    phoneLable.font=[UIFont systemFontOfSize:15.0f];
    [backView addSubview:phoneLable];
    
    UILabel *phoneContent=[[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(noticeContent.frame)+11+13+11, SCREENWIDTH-13, 13)];
    phoneContent.font=[UIFont systemFontOfSize:15.0f];
    phoneContent.numberOfLines=0;
    phoneContent.textAlignment=NSTextAlignmentLeft;
    phoneContent.textColor=[UIColor grayColor];
    phoneContent.text=[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[wholeInfoDic objectForKey:@"phone"]];
    [backView addSubview:phoneContent];
    
    UIButton *contactBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.frame=CGRectMake(13, CGRectGetMaxY(phoneContent.frame)+30, SCREENWIDTH-26, 45);
    [contactBtn setTitle:@"联系商家" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contactBtn.layer.borderColor=[[UIColor grayColor]CGColor];
    contactBtn.titleLabel.font=[UIFont systemFontOfSize:17.0f];
    contactBtn.layer.borderWidth=1.0f;
    [backView addSubview:contactBtn];
    [contactBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];

    
    backView.frame = CGRectMake(0, 0, SCREENWIDTH, contactBtn.bottom +20);
    return backView;
}
//创建我的商品view
-(UIView*)creatproductView{
    
    
    NSArray* commodity_list = wholeInfoDic[@"commodity_list"];
    
    if (commodity_list.count==0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"本店暂无商品";
        
        return label;
    }else{
        
        UIScrollView *commodity_scroView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 140)];
        commodity_scroView.showsVerticalScrollIndicator = NO;
        commodity_scroView.showsHorizontalScrollIndicator = NO;
        commodity_scroView.contentSize = CGSizeMake(commodity_list.count*110+10, 0);
        
        
        for (int i = 0; i < commodity_list.count; i ++) {
            NSDictionary *dic_comm = commodity_list[i];
            UIView *b_v = [[UIView alloc]initWithFrame:CGRectMake(110*i+10, 0, 100, 140)];
            [commodity_scroView addSubview:b_v];
            
            UIImageView *ImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, b_v.width, b_v.width)];
            NSURL * nurl1=[[NSURL alloc] initWithString:[[SOURCE_PRODUCT stringByAppendingString:dic_comm[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [ImgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3"]];
            [b_v addSubview:ImgView];
            
            
            UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, ImgView.bottom, ImgView.width, 20)];
            title_lab.text =dic_comm[@"name"];
            title_lab.textAlignment =NSTextAlignmentCenter;
            title_lab.textColor = RGB(51, 51, 51);
            title_lab.font = [UIFont systemFontOfSize:12];
            [b_v addSubview:title_lab];
            
            UILabel *price_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, title_lab.bottom, ImgView.width, 15)];
            price_lab.text =[NSString stringWithFormat:@"¥%@",dic_comm[@"price"]];
            price_lab.textAlignment =NSTextAlignmentCenter;
            price_lab.textColor = RGB(253,89,88);
            price_lab.font = [UIFont systemFontOfSize:11];
            [b_v addSubview:price_lab];
            
            
        }
        
        return commodity_scroView;
    }
    
    
}
#pragma mark 会员卡列表cell
-(NewShopCardListCell*)creatCardListCell:(NSIndexPath*)indexPath
{
    NewShopCardListCell *card_cell = [self.shopTableView dequeueReusableCellWithIdentifier:@"NewShopCardListCell"];
    if (!card_cell) {
        card_cell = [[NewShopCardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewShopCardListCell"];
        card_cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary  *dic = _cardArray[indexPath.row];
    card_cell.cardImg.backgroundColor=[UIColor colorWithHexString:[dic objectForKey:@"card_temp_color"]];
    
    card_cell.vipLab.text = [NSString stringWithFormat:@"VIP%@",[dic objectForKey:@"level"]];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:card_cell.vipLab.text];
    
    [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,171,65),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(0, 3)];
    
    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(3, card_cell.vipLab.text.length-3)];
    
    card_cell.vipLab.attributedText = attr;
    card_cell.content_lab.text= [NSString getTheNoNullStr:[dic objectForKey:@"content"] andRepalceStr:@"暂无优惠!"];
    
    
    card_cell.cardPriceLable.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
    
    
    NSString *discounts=[NSString getTheNoNullStr:[dic objectForKey:@"rule"] andRepalceStr:@"0"];
    CGFloat dis=[discounts floatValue]/10.0f;
    card_cell.discountLable.text=[NSString stringWithFormat:@"%.1f折",dis];
    
    
    if ([[dic objectForKey:@"type"] isEqualToString:@"计次卡"]) {
        card_cell.discountLable.text=[NSString stringWithFormat:@"%@次",discounts];
    }
    
    if ([[NSString getTheNoNullStr:[dic objectForKey:@"indate"] andRepalceStr:@"0"] isEqualToString:@"0"]) {
        card_cell.timeLable.text=[NSString stringWithFormat:@"有效期: 无期限(%@)",[NSString getTheNoNullStr:[dic objectForKey:@"type"] andRepalceStr:@"---"]];
    }else{
        card_cell.timeLable.text=[NSString stringWithFormat:@"有效期: %@年(%@)",[NSString getTheNoNullStr:[dic objectForKey:@"indate"] andRepalceStr:@"0"],[NSString getTheNoNullStr:[dic objectForKey:@"type"] andRepalceStr:@"---"]];
    }
    
    return card_cell;
}

#pragma mark 图文详情cell
-(UITableViewCell*)creatCellWith:(NSIndexPath*)indexPath{
    UITableViewCell *cell=[self.shopTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREENWIDTH, SCREENWIDTH*2/3-10)];
        imageView.tag=100;
        [cell addSubview:imageView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,(SCREENWIDTH*2/3)-80 , SCREENWIDTH, 100)];
        label.tag=200;
        label.alpha=0.5;
        label.font=[UIFont systemFontOfSize:13.0f];
        label.numberOfLines=0;
        label.backgroundColor=[UIColor blackColor];
        label.textColor=[UIColor whiteColor];
        [cell addSubview:label];
        UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREENWIDTH/2, 140)];
        imageView2.tag=300;
        [cell addSubview:imageView2];
    }
    UIImageView *imgView=[cell viewWithTag:100];
    UILabel *label=[cell viewWithTag:200];
    UIImageView *imgView2=[cell viewWithTag:300];
    if (indexPath.row==0) {
        label.hidden=NO;
        imgView2.hidden=YES;
        imgView.hidden=NO;
        imgView.image=[UIImage imageNamed:@"icon3"];
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[self.infoDic objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        NSString *newStr=[self.infoDic objectForKey:@"store"];
        CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        label.text=newStr;
        label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight-5, SCREENWIDTH, lableHeight);
    }else{
        NSDictionary *dic = self.pictureAndTextArray[indexPath.row-1];
        
        NSString *newStr=dic[@"content"];
        CGFloat lableHeight=[newStr getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        CGFloat labelHeight2=[newStr getTextHeightWithShowWidth:SCREENWIDTH/2 AndTextFont:[UIFont systemFontOfSize:13.0f] AndInsets:5];
        label.text=newStr;
        label.frame=CGRectMake(0, SCREENWIDTH*2/3-lableHeight-5, SCREENWIDTH, lableHeight);
        
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:dic[@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [imgView2 sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];

        
        if([dic[@"type"] isEqualToString:@"0"]){
            label.hidden=NO;
            imgView2.hidden=NO;
            imgView.hidden=YES;
            imgView2.frame=CGRectMake(5, 5, SCREENWIDTH/2-10, (SCREENWIDTH/2-10)*2/3);
            if (labelHeight2<(SCREENWIDTH/2-10)*2/3) {
                label.frame=CGRectMake(SCREENWIDTH/2, (SCREENWIDTH/2-10)*1/3-labelHeight2/2+5, SCREENWIDTH/2, labelHeight2);
            }else{
                label.frame=CGRectMake(SCREENWIDTH/2, 5, SCREENWIDTH/2, (SCREENWIDTH/2-10)*2/3);
            }
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
           
        }else if ([dic[@"type"] isEqualToString:@"1"]){
            imgView2.hidden=YES;
            imgView.hidden=NO;
            label.hidden=NO;
        }else if ([dic[@"type"] isEqualToString:@"2"]){
            label.hidden=NO;
            imgView2.hidden=NO;
            imgView.hidden=YES;
            imgView2.frame=CGRectMake(SCREENWIDTH/2+5, 5, SCREENWIDTH/2-10,(SCREENWIDTH/2-10)*2/3);
            if (labelHeight2<(SCREENWIDTH/2-10)*2/3) {
                label.frame=CGRectMake(0, (SCREENWIDTH/2-10)*1/3-labelHeight2/2+5, SCREENWIDTH/2, labelHeight2);
            }else{
                label.frame=CGRectMake(0, 5, SCREENWIDTH/2, (SCREENWIDTH/2-10)*2/3);
            }
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor blackColor];
            
        }else if ([dic[@"type"] isEqualToString:@"3"]){
            
            imgView2.hidden=YES;
            imgView.hidden=NO;
            label.hidden=YES;
        }
    }
    return cell;
}
-(void)gotoMapView
{
    
    
    BDMapViewController *controller = [[BDMapViewController alloc]init];
    controller.title = @"查看位置";
    controller.latitude = [[self.infoDic objectForKey:@"latitude"] doubleValue];
    controller.longitude = [[self.infoDic objectForKey:@"longtitude"] doubleValue];
    controller.infoDic= self.infoDic;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)scanMoreInfo{
    
    ApriseVC *vc=[[ApriseVC alloc]init];
    vc.muid=wholeInfoDic[@"muid"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)call{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[wholeInfoDic objectForKey:@"phone"]] otherButtonTitles:nil, nil];
    [sheet showInView:self.shopTableView];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"%@",self.infoDic);
        NSMutableString* telStr = [[NSMutableString alloc]initWithString:@"tel://"];
        [telStr appendString:[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[wholeInfoDic objectForKey:@"phone"]]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
    }
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
//        CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
    
//    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    CGFloat documentWidht = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth"] floatValue];
    
//    documentHeight = documentHeight/documentWidht*SCREENWIDTH;
    
   CGFloat documentHeight =webView.scrollView.contentSize.height;
    NSLog(@"webViewDidFinishLoad------%lf",documentHeight);
    
    if (_webHight != (float)documentHeight) {
        _webHight=(float)documentHeight;
        
        web_view.frame = CGRectMake(0, 0, SCREENWIDTH, _webHight);
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:3];
        [self.shopTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];

    }

  }

//获取商家所有信息
-(void)postRequestWholeInfo{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/infoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:@"1" forKey:@"index"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result====%@", result);
         self.cardArray=result[@"card_list"];
         wholeInfoDic=[result copy];
//         [self.shopTableView reloadData];
         
         [self postRequestGetInfo];
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}


//立即购买
-(void)buyBtnClick{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landVc = [[LandingController alloc]init];
        [self.navigationController pushViewController:landVc animated:YES];
    }else
    {
        if (self.cardArray.count>0) {
            NewBuyCardViewController *buyVC=[[NewBuyCardViewController alloc]init];
            buyVC.cardListArray=self.cardArray;
            buyVC.shop_name =[wholeInfoDic objectForKey:@"store"];
            [self.navigationController pushViewController:buyVC animated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"本店暂无卡出售", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:2.f];
        }
        
    }
    
}


//收藏点击

-(void)favorateAction
{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (!appdelegate.IsLogin) {
        LandingController *landingView = [[LandingController alloc]init];
        [self.navigationController pushViewController:landingView animated:YES];
    }else{
        NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/collect/stateSet",BASEURL];
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"user"];
        [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"merchant"];
        
        if (self.state==YES) {
            [params setObject:@"false" forKey:@"state"];
        }else{
            [params setObject:@"true" forKey:@"state"];
        }
        
        NSLog(@"%@",params);
        [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
         {
             NSLog(@"%@", result);
             NSDictionary *dic = [result copy];
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.mode = MBProgressHUDModeText;
             ;
             if (self.state==YES)
             {
                 if ([dic[@"result_code"] isEqualToString:@"false"])
                 {
                     hud.label.text = NSLocalizedString(@"取消收藏成功", @"HUD message title");
                     [collectBtn setTitle:@"立即收藏" forState:0];
                     self.state = NO;
                     hud.label.font = [UIFont systemFontOfSize:13];
                     //    [hud setColor:[UIColor blackColor]];
                     hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                     hud.userInteractionEnabled = YES;
                     
                     [hud hideAnimated:YES afterDelay:2.f];
                 }
                 else
                 {
                     hud.label.text = NSLocalizedString(@"请求失败", @"HUD message title");
                     
                     hud.label.font = [UIFont systemFontOfSize:13];
                     //    [hud setColor:[UIColor blackColor]];
                     hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                     hud.userInteractionEnabled = YES;
                     
                     [hud hideAnimated:YES afterDelay:2.f];
                 }
             }else
             {
                 if ([dic[@"result_code"] isEqualToString:@"true"])
                 {
                     hud.label.text = NSLocalizedString(@"收藏成功", @"HUD message title");
                     [collectBtn setTitle:@"取消收藏" forState:0];
                     
                     self.state = YES;
                     hud.label.font = [UIFont systemFontOfSize:13];
                     //    [hud setColor:[UIColor blackColor]];
                     hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                     hud.userInteractionEnabled = YES;
                     
                     [hud hideAnimated:YES afterDelay:2.f];
                 }
                 else
                 {
                     hud.label.text = NSLocalizedString(@"请求失败", @"HUD message title");
                     
                     hud.label.font = [UIFont systemFontOfSize:13];
                     //    [hud setColor:[UIColor blackColor]];
                     hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
                     hud.userInteractionEnabled = YES;
                     
                     [hud hideAnimated:YES afterDelay:2.f];
                 }
                 
             }
         } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
             //         [self noIntenet];
             NSLog(@"%@", error);
         }];
    }
}


//获取图文介绍
-(void)postRequestGetInfo
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        self.pictureAndTextArray = result;
        
        [self.shopTableView reloadData];

    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
//获取收藏状态
-(void)postRequestState
{
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/collect/stateGet",BASEURL];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[appdelegate.userInfoDic objectForKey:@"uuid"] forKey:@"user"];
    [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"merchant"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result====%@", result);
         NSDictionary *dic = [result copy];
         if ([dic[@"result_code"] isEqualToString:@"true"]) {
             self.state = YES;
             
             [collectBtn setTitle:@"取消收藏" forState:0];
         }else if ([dic[@"result_code"] isEqualToString:@"false"]) {
             self.state = NO;
             [collectBtn setTitle:@"立即收藏" forState:0];
             
         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}

@end