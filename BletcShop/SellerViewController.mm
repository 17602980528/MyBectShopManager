//
//  SellerViewController.m
//  BletcShop
//
//  Created by Bletc on 16/3/31.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "SellerViewController.h"
#import "ShopImageTableViewCell.h"
#import "ShopInfoTableViewCell.h"
#import "AddressTableViewCell.h"
#import "CardTableViewCell.h"
#import "DLStarRatingControl.h"
#import "BDMapViewController.h"
#import "CardInfoViewController.h"
#import "LandingController.h"
#import "GraphicDetailsViewController.h"
#import "PointRuleViewController.h"
#import "NewBuyCardViewController.h"

#import "UILabel+extension.h"
#import "SRVideoPlayer.h"
@interface SellerViewController ()
//视频播放器
{
    NSMutableString *str;
    NSArray *_infoArrays;
    CGFloat height1;
    CGFloat height2;
    CGFloat height3;
    CGFloat height4;
    CGFloat height5;
    NSDictionary *wholeInfoDic;
    UIButton *collectBtn;
}
@property (nonatomic, strong) SRVideoPlayer *videoPlayer;
@end

@implementation SellerViewController

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
        [_rightdBt setBackgroundImage:[UIImage imageNamed:@"c_de"] forState:UIControlStateNormal];
    }
    
    if (![self.videoID isEqualToString:@""]) {
        if (self.shopTableView) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.shopTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*9/16)];
            [self.view addSubview:playerView];
            NSString *url = [NSString stringWithFormat:@"%@%@",VEDIO_URL,self.videoID];
            NSLog(@"VEDIO_URL===%@",url);
            _videoPlayer = [SRVideoPlayer playerWithVideoURL:[NSURL URLWithString:url] playerView:playerView playerSuperView:playerView.superview];
            _videoPlayer.videoName = @"";
            _videoPlayer.playerEndAction = SRVideoPlayerEndActionStop;
            [_videoPlayer pause];
            
            
        }

    }
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_videoPlayer destroyPlayer];
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
             [_rightdBt setBackgroundImage:[UIImage imageNamed:@"c_se"] forState:UIControlStateNormal];
             
             [collectBtn setTitle:@"取消收藏" forState:0];
         }else if ([dic[@"result_code"] isEqualToString:@"false"]) {
             self.state = NO;
             [_rightdBt setBackgroundImage:[UIImage imageNamed:@"c_de"] forState:UIControlStateNormal];
             [collectBtn setTitle:@"立即收藏" forState:0];
             
         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.playUrl=@"";
    self.appraiseArray = [[NSMutableArray alloc]init];
    wholeInfoDic=[[NSDictionary alloc]init];
    
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    //    UIButton *rightdBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    //
    //    self.rightdBt = rightdBt;
    //    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightdBt];
    //
    //    [rightdBt addTarget:self action:@selector(favorateAction) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.rightBarButtonItem = item1;
    
    self.cardArray = [[NSMutableArray alloc]init];
    [self initTableView];
    [self initFootView];
    
    
    [self postRequestWholeInfo];
    
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
                     [_rightdBt setBackgroundImage:[UIImage imageNamed:@"c_de"] forState:UIControlStateNormal];
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
                     [_rightdBt setBackgroundImage:[UIImage imageNamed:@"c_se"] forState:UIControlStateNormal];
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
-(void)initTableView
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 104;
    table.bounces = NO;
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

//代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 1;
            break;
        case 2:
            row =1;
            break;
        case 3:
        {
            
            if (self.cardArray!=nil&&self.cardArray.count>0) {
                return self.cardArray.count;
            }else
                return 1;
        }
            break;
        case 4:
            
            return 1;
            break;
        case 5:
            
            return 1;
            break;
        case 6:
            NSLog(@"%ld",self.appraiseArray.count);
            if (self.appraiseArray!=nil&&self.appraiseArray.count>0) {
                if (self.appraiseArray.count<=2) {
                    return self.appraiseArray.count;
                }else if(self.appraiseArray.count>2){
                    return 2;
                }
                
            }else
                return 1;
            break;
        case 7:
            return 1;
            
            break;
    }
    
    return row;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 4||section == 6||section == 3||section == 5||section == 7){
        return 40;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==3||section==4||section==5||section==6||section==7) {
        return 10;
    }
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    label.userInteractionEnabled=YES;
    label.textAlignment=NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:label];
    if (section==4) {
        label.text = @"全部商品";
    }
    if (section==5) {
        label.text =@"商家详情";
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToShopPicture)];
        [label addGestureRecognizer:tapGesture];
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-23, 12, 8, 16)];
        imgView.image=[UIImage imageNamed:@"arraw_right"];
        [view addSubview:imgView];
        
        
    }else if (section==3){
        label.text=@"会员卡";
    }else if (section==6){
        label.text=@"会员口碑";
        
    }else if (section==7) {
        label.text = @"购买需知";
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
            return SCREENWIDTH*9/16+50+1;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 44;
            break;
        case 3:
        {
            if (self.cardArray!=nil&&self.cardArray.count>0)
            {
                
                return 70+1;
            }else
                return 40+1;
            break;
        }
        case 4:
        {
            NSArray *arr = wholeInfoDic[@"commodity_list"];
            if (arr.count!=0) {
                return 150;
            }else{
                return 40;
  
            }
        }
            break;
        case 5:
            return height1;
            break;
        case 6:
        {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            if(self.appraiseArray.count>0) {
                return cell.frame.size.height;
            }else{
                return 40;
            }
            
        }
            break;
        case 7:
        {
            return height2+49;
        }
            break;
            
        default:
            break;
    }
    return 44;
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
        if (self.pictureAndTextArray.count>0) {
            GraphicDetailsViewController *graphicView = [[GraphicDetailsViewController alloc]init];
            graphicView.pictureAndContentArray = self.pictureAndTextArray;
            graphicView.infoDic = self.infoDic;
            
            [self.navigationController pushViewController:graphicView animated:YES];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无详情，敬请期待" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
        }
        NSLog(@"postRequestGetInfo%@", self.pictureAndTextArray);
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
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




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        //[self gotoMapView];
    }
    else if (indexPath.section==5)
    {
        PointRuleViewController *PointRuleView = [[PointRuleViewController alloc]init];
        PointRuleView.type = 9999;
        [self.navigationController pushViewController:PointRuleView animated:YES];
        
        
    }else if (indexPath.section==3)
    {
        //        if (self.cardArray!=nil&&self.cardArray.count>0)
        //        {
        //            NSDictionary *dic = [self.cardArray objectAtIndex:indexPath.row];
        //
        //            [self startCardInfoView:dic];
        //        }
        
    }
    
}

-(void)startCardInfoView:(NSDictionary*)dic{
    CardInfoViewController *controller = [[CardInfoViewController alloc]init];
    
    controller.card_dic = dic;
    
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)NavigateFrom:(CLLocationCoordinate2D)from  to:(CLLocationCoordinate2D)to{
    BMKNaviPara * para = [BMKNaviPara alloc];
    para.isSupportWeb = YES;
    //CLLocationCoordinate2D startPt = (CLLocationCoordinate2D){34.229849,108.970386};
    //CLLocationCoordinate2D endPt = (CLLocationCoordinate2D){34.267509,108.953567};
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = from;
    start.name = nil;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = to;
    end.name = @"111";
    
    para.startPoint = start;
    para.endPoint = end;
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        
        [self openBaiDuMap];
    }else{
        para.naviType = BMK_NAVI_TYPE_WEB;
        [BMKNavigation openBaiduMapNavigation:para];
        
    }
    
}
- (void)openBaiDuMap{
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",appdelegate.userLocation.location.coordinate.latitude, appdelegate.userLocation.location.coordinate.longitude,[wholeInfoDic[@"latitude"] doubleValue],[wholeInfoDic[@"longtitude"] doubleValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
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

-(void)goToShopPicture
{
    [self postRequestGetInfo];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    for(UIView * view in cell.subviews){
        
        [view removeFromSuperview];
        
    }
    switch (indexPath.section) {
        case 0:
            
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = RGB(225, 225, 225);
            [cell addSubview:line];
            
            UILabel *nameLabel = [[UILabel alloc]init];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.numberOfLines = 0;
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont systemFontOfSize:17];
            nameLabel.tag = 1000;
            [cell addSubview:nameLabel];
            
            if ([self.videoID isEqualToString:@""]) {
                UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*9/16)];
                [cell addSubview:shopImageView];
                NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[wholeInfoDic  objectForKey:@"image_url"] andRepalceStr:@""]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [shopImageView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                line.frame=CGRectMake(10, SCREENWIDTH*9/16+50, SCREENWIDTH, 1);
                
                nameLabel.frame=CGRectMake(12, SCREENWIDTH*9/16+5, SCREENWIDTH-12, 40);
                nameLabel.text = [wholeInfoDic objectForKey:@"store"];
            }
            
            if (![self.videoID isEqualToString:@""]) {
                
                                line.frame=CGRectMake(10, SCREENWIDTH*9/16+50, SCREENWIDTH, 1);
                
                nameLabel.frame=CGRectMake(12, SCREENWIDTH*9/16+5, SCREENWIDTH-12, 40);
                nameLabel.text = [wholeInfoDic objectForKey:@"store"];
            }
            
        }
            break;
        case 1:
        {
            
            UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(200,15, SCREENWIDTH-200, 14)];
            lab1.textAlignment=NSTextAlignmentLeft;
            lab1.text=[[NSString alloc]initWithFormat:@"已售:%@",[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"sold"] andRepalceStr:@"0"]];
            lab1.font=[UIFont systemFontOfSize:13.0f];
            [cell addSubview:lab1];
            
            UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 110, 30)];
            starLabel.backgroundColor = [UIColor clearColor];
            starLabel.textAlignment = NSTextAlignmentLeft;
            starLabel.font = [UIFont systemFontOfSize:15];
            starLabel.tag = 1000;
            DLStarRatingControl* dlCtrl = [[DLStarRatingControl alloc]initWithFrame:CGRectMake(0, 7, 110, 35) andStars:5 isFractional:YES star:[UIImage imageNamed:@"result_small_star_disable_iphone"] highlightStar:[UIImage imageNamed:@"redstar"]];
            dlCtrl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            dlCtrl.userInteractionEnabled = NO;
            if(self.appraiseArray.count>0&&![[wholeInfoDic objectForKey:@"stars"]isEqual:[NSNull null]]&&![[wholeInfoDic objectForKey:@"stars"]isEqual:@"null"]&&![[wholeInfoDic objectForKey:@"stars"]isEqual:@""])
            {
                dlCtrl.rating = [[wholeInfoDic objectForKey:@"stars"] floatValue];
            }else
                dlCtrl.rating =0.0;
            [starLabel addSubview:dlCtrl];
            [cell addSubview:starLabel];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 43, SCREENWIDTH, 1)];
            line.backgroundColor = RGB(225, 225, 225);
            [cell addSubview:line];
            
            UILabel *points=[[UILabel alloc]initWithFrame:CGRectMake(150, 7, 50, 30)];
            points.textColor=[UIColor redColor];
            points.font=[UIFont systemFontOfSize:15.0f];
            points.text=[NSString stringWithFormat:@"%.1f",dlCtrl.rating];
            [cell addSubview:points];
        }
            break;
        case 2:
        {
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            UIImageView *shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 15, 13, 16)];
            shopImageView.image = [UIImage imageNamed:@"location"];
            [cell addSubview:shopImageView];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 17, SCREENWIDTH-30, 14)];
            nameLabel.numberOfLines = 0;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont systemFontOfSize:13];
            nameLabel.tag = 1000;
            nameLabel.text = [wholeInfoDic objectForKey:@"address"];
            nameLabel.userInteractionEnabled = YES;
            UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMapView)];
            [nameLabel addGestureRecognizer:tapGesture];
            [cell addSubview:nameLabel];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 43, SCREENWIDTH, 1)];
            line.backgroundColor = RGB(225, 225, 225);
            [cell addSubview:line];
            
        }
            break;
        case 3:
        {
            if (self.cardArray.count==0||self.cardArray==nil)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
                [cell addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                label.text = @"本店暂无可购买的卡";
                
            }else{
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 80, 50)];
                imageView.layer.cornerRadius = 5;
                imageView.layer.masksToBounds = YES;
                imageView.layer.borderWidth = 0.5;
                imageView.layer.borderColor = RGB(180, 180, 180).CGColor;
                
                
                imageView.backgroundColor=[UIColor colorWithHexString:[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"card_temp_color"]];
                [cell addSubview:imageView];
                
                UIView *bot_view = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 80, 15)];
                bot_view.backgroundColor = [UIColor whiteColor];
                [imageView addSubview:bot_view];
                
                UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
                vipLab.text = [NSString stringWithFormat:@"VIP%@",[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"level"]];
                vipLab.textAlignment = NSTextAlignmentCenter;
                vipLab.textColor = [UIColor whiteColor];
                [imageView addSubview:vipLab];
                
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:vipLab.text];
                
                [attr setAttributes:@{NSForegroundColorAttributeName:RGB(253,171,65),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(0, 3)];
                
                [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(3, vipLab.text.length-3)];
                
                vipLab.attributedText = attr;
                
                UILabel *content_lab = [[UILabel alloc]init];
                content_lab.text =[NSString getTheNoNullStr:[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"content"] andRepalceStr:@"暂无优惠!"];
                content_lab.font = [UIFont systemFontOfSize:14];
                content_lab.numberOfLines = 2;
                CGFloat height_lab =  [UILabel getSizeWithLab:content_lab andMaxSize:CGSizeMake(SCREENWIDTH-85-70, 50)].height;
                content_lab.frame = CGRectMake(imageView.right+10, imageView.top, SCREENWIDTH-85-70, height_lab+2);
                [cell addSubview:content_lab];
                
                UILabel *cardPriceLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-120-15, 23-5, 120, 14)];
                cardPriceLable.textAlignment=NSTextAlignmentRight;
                cardPriceLable.font=[UIFont systemFontOfSize:14.0f];
                cardPriceLable.text=[NSString stringWithFormat:@"￥%@",[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
                cardPriceLable.textColor=[UIColor redColor];
                [cell addSubview:cardPriceLable];
                
                NSString *discounts=[NSString getTheNoNullStr:[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"rule"] andRepalceStr:@"0"];
                CGFloat dis=[discounts floatValue]/10.0f;
                
                
                UILabel *discountLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-120-15, cardPriceLable.bottom+5, 120, 14)];
                discountLable.font=[UIFont systemFontOfSize:13.0f];
                discountLable.textColor=[UIColor grayColor];
                discountLable.textAlignment=NSTextAlignmentRight;
                discountLable.text=[NSString stringWithFormat:@"%.1f折",dis];
                [cell addSubview:discountLable];
                if ([[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"计次卡"]) {
                    discountLable.text=[NSString stringWithFormat:@"%@次",[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"rule"]];
                }
                UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, content_lab.bottom+3, content_lab.width, 20)];
                timeLable.font=[UIFont systemFontOfSize:13.0f];
                timeLable.textColor=[UIColor grayColor];
                if ([[NSString getTheNoNullStr:[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"indate"] andRepalceStr:@"0"] isEqualToString:@"0"]) {
                    timeLable.text=[NSString stringWithFormat:@"有效期: 无期限(%@)",[NSString getTheNoNullStr:[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"type"] andRepalceStr:@"---"]];
                }else{
                    timeLable.text=[NSString stringWithFormat:@"有效期: %@年(%@)",[NSString getTheNoNullStr:[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"indate"] andRepalceStr:@"0"],[NSString getTheNoNullStr:[[self.cardArray objectAtIndex:indexPath.row] objectForKey:@"type"] andRepalceStr:@"---"]];
                }
                [cell addSubview:timeLable];
                
            }
            
        }
            break;
            
            case 4:
        {
            
            NSArray* commodity_list = wholeInfoDic[@"commodity_list"];
            
            if (commodity_list.count==0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
                [cell addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                label.text = @"本店暂无商品";
            }else{
                
                UIScrollView *commodity_scroView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 140)];
                [cell addSubview:commodity_scroView];
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
                
                
            }
            
            UIView *line = [[UIView alloc]init];
            line.frame = CGRectMake(10,0, SCREENWIDTH, 1);
            line.backgroundColor = RGB(225, 225, 225);
            [cell addSubview:line];
        }
            break;
        case 5:
        {
            UILabel *label2=[[UILabel alloc]init];
            label2.numberOfLines=0;
            label2.font = [UIFont systemFontOfSize:13.0];
            [cell addSubview:label2];
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = RGB(225, 225, 225);
            [cell addSubview:line];
            
            for (int i=0; i<3; i++) {
                UIView *view=[[UIView alloc]initWithFrame:CGRectMake(i%3*SCREENWIDTH/3, 13, SCREENWIDTH/3, 14)];
                view.backgroundColor=[UIColor whiteColor];
                view.tag=5173+i;
                [cell addSubview:view];
                
                
                UIImageView *tipImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 14, 14)];
                tipImageView.image=[UIImage imageNamed:@"勾选"];
                
                [view addSubview:tipImageView];
                
                UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(24,0,SCREENWIDTH/3-24,14)];
                contentLable.textAlignment=NSTextAlignmentLeft;
                contentLable.font=[UIFont systemFontOfSize:11.0f];
                [view addSubview:contentLable];
                
                if (i==0) {
                    contentLable.text=@"消协全面监督";
                }else if (i==1){
                    contentLable.text=@"第三方资金托管";
                }else if (i==2){
                    contentLable.text=@"中国人保财险保障";
                }
            }
            height1=35;
            
            if (indexPath.row==0)
            {
                NSString *inroString=[NSString getTheNoNullStr:wholeInfoDic[@"intro"] andRepalceStr:@"hehe"];
                if ([inroString isEqualToString:@"hehe"])
                {
                    label2.hidden=YES;
                    line.frame = CGRectMake(10, 0, SCREENWIDTH-20, 1);
                    
                }else{
                    label2.hidden=NO;
                    label2.text=inroString;
                    
                    CGFloat labelHeight = [label2.text getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:label2.font AndInsets:5];
                    
                    NSLog(@"labelHeight===%f",labelHeight);
                    label2.frame=CGRectMake(10, 12,SCREENWIDTH-20 , labelHeight);
                    height1=labelHeight+35+12;
                    line.frame = CGRectMake(10, height1-35, SCREENWIDTH, 1);
                    
                }
                
                for (int i=0; i<3; i++) {
                    UIView *View=[cell viewWithTag:5173+i];
                    View.frame=CGRectMake(16+i*(14+104), height1-35+13, 14, 14);
                }
                
            }
            
        }
            break;
            
        case 6:
        {
            if ([self.appraiseArray count]== 0||self.appraiseArray==nil)
            {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 40)];
                [cell addSubview:label];
                label.font = [UIFont systemFontOfSize:14];
                label.text = @"本店暂无评价";
            }
            if(self.appraiseArray.count>0){
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 30, 30)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.appraiseArray[indexPath.row][@"headimage"]]] placeholderImage:[UIImage imageNamed:@"3.1-02"]];
                imageView.layer.cornerRadius = imageView.width/2;
                imageView.layer.masksToBounds = YES;
                [cell addSubview:imageView];
                
                UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(53, 18, SCREENWIDTH-53, 13)];
                nameLabel.text=self.appraiseArray[indexPath.row][@"nickname"];
                nameLabel.textAlignment=NSTextAlignmentLeft;
                nameLabel.font=[UIFont systemFontOfSize:13.0f];
                [cell addSubview:nameLabel];
                
                UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, SCREENWIDTH-20, 20)];
                [contentLb setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
                contentLb.numberOfLines = 0;
                [contentLb setLineBreakMode:NSLineBreakByWordWrapping];
                contentLb.text =self.appraiseArray[indexPath.row][@"content"];
                CGRect frame = [cell frame];
                CGRect labelSize = [contentLb.text boundingRectWithSize:CGSizeMake(contentLb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:13.0f],NSFontAttributeName, nil] context:nil];
                contentLb.frame = CGRectMake(contentLb.frame.origin.x, contentLb.frame.origin.y, labelSize.size.width, labelSize.size.height);
                
                frame.size.height = contentLb.bottom+5;
                cell.frame = frame;
                [cell addSubview:contentLb];
                
                if (indexPath.row!=self.appraiseArray.count-1) {
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, contentLb.bottom+4, SCREENWIDTH, 1)];
                    line.backgroundColor = RGB(225, 225, 225);
                    [cell addSubview:line];
                }
                
                
            }
            
        }
            break;
        case 7:
        {
            UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(13, 10, 3, 15)];
            view1.backgroundColor=[UIColor colorWithRed:66/255.0 green:170/255.0 blue:250/255.0 alpha:1.0f];
            [cell addSubview:view1];
            
            UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(22, 10, SCREENWIDTH-13, 13)];
            timeLable.textAlignment=NSTextAlignmentLeft;
            timeLable.text=@"使用时间:";
            timeLable.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:timeLable];
            NSString *time=[NSString getTheNoNullStr:wholeInfoDic[@"time"] andRepalceStr:@"周一到周日  遇到节假日工作时间会有调整"];
            
            CGFloat labelHeight = [time getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:15.0] AndInsets:5];
            
            UILabel *timeContent=[[UILabel alloc]initWithFrame:CGRectMake(13, 34, SCREENWIDTH-13, labelHeight)];
            timeContent.numberOfLines=0;
            timeContent.font=[UIFont systemFontOfSize:15.0f];
            timeContent.textAlignment=NSTextAlignmentLeft;
            timeContent.textColor=[UIColor grayColor];
            timeContent.text=time;
            [cell addSubview:timeContent];
            
            UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(13, 34+labelHeight+13, 3, 15)];
            view2.backgroundColor=[UIColor colorWithRed:66/255.0 green:170/255.0 blue:250/255.0 alpha:1.0f];
            [cell addSubview:view2];
            
            NSString *notice=[NSString getTheNoNullStr:wholeInfoDic[@"notice"] andRepalceStr:@"本店会员卡优惠多多"];
            
            CGFloat labelHeight2 = [notice getTextHeightWithShowWidth:SCREENWIDTH AndTextFont:[UIFont systemFontOfSize:15.0] AndInsets:5];
            
            
            UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(22, 34+labelHeight+13, SCREENWIDTH-13, 13)];
            noticeLable.textAlignment=NSTextAlignmentLeft;
            noticeLable.text=@"注意事项";
            noticeLable.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:noticeLable];
            
            UILabel *noticeContent=[[UILabel alloc]initWithFrame:CGRectMake(13, 34+labelHeight+13+13+11, SCREENWIDTH-26, labelHeight2)];
            noticeContent.numberOfLines=0;
            noticeContent.font=[UIFont systemFontOfSize:15.0f];
            noticeContent.text=notice;
            noticeContent.textAlignment=NSTextAlignmentLeft;
            noticeContent.textColor=[UIColor grayColor];
            [cell addSubview:noticeContent];
            
            UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(noticeContent.frame)+11, 3, 15)];
            view3.backgroundColor=[UIColor colorWithRed:66/255.0 green:170/255.0 blue:250/255.0 alpha:1.0f];
            [cell addSubview:view3];
            
            UILabel *phoneLable=[[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(noticeContent.frame)+11, SCREENWIDTH-13, 13)];
            phoneLable.textAlignment=NSTextAlignmentLeft;
            phoneLable.text=@"商家电话:";
            phoneLable.font=[UIFont systemFontOfSize:15.0f];
            [cell addSubview:phoneLable];
            
            UILabel *phoneContent=[[UILabel alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(noticeContent.frame)+11+13+11, SCREENWIDTH-13, 13)];
            phoneContent.font=[UIFont systemFontOfSize:15.0f];
            phoneContent.numberOfLines=0;
            phoneContent.textAlignment=NSTextAlignmentLeft;
            phoneContent.textColor=[UIColor grayColor];
            phoneContent.text=[NSString getTheNoNullStr:[wholeInfoDic objectForKey:@"store_number"] andRepalceStr:[wholeInfoDic objectForKey:@"phone"]];
            [cell addSubview:phoneContent];
            
            UIButton *contactBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            contactBtn.frame=CGRectMake(13, CGRectGetMaxY(phoneContent.frame)+30, SCREENWIDTH-26, 45);
            [contactBtn setTitle:@"联系商家" forState:UIControlStateNormal];
            [contactBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            contactBtn.layer.borderColor=[[UIColor grayColor]CGColor];
            contactBtn.titleLabel.font=[UIFont systemFontOfSize:17.0f];
            contactBtn.layer.borderWidth=1.0f;
            [cell addSubview:contactBtn];
            [contactBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
            height2=CGRectGetMaxY(contactBtn.frame)+20;
            
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
    
}
//获取商家信息
#pragma mark 退出全屏
- (void)exitFullScreen
{
    NSLog(@"退出全屏");
    // [self.player.view removeFromSuperview];
}

#pragma mark -播放器事件监听
#pragma mark 视频截图 这个方法是异步方法
#pragma mark 播放器事件监听
#pragma mark 播放完成
- (void)finishedPlay
{
    NSLog(@"播放完成");
}

#pragma mark 播放器视频的监听
#pragma mark 播放状态变化
/*
 MPMoviePlaybackStateStopped,  //停止
 MPMoviePlaybackStatePlaying,  //播放
 MPMoviePlaybackStatePaused,   //暂停
 MPMoviePlaybackStateInterrupted,  //中断
 MPMoviePlaybackStateSeekingForward, //快进
 MPMoviePlaybackStateSeekingBackward  //快退
 */
- (void)stateChange
{
    switch (self.player.playbackState) {
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            self.playImageView.hidden=NO;
            _webView.hidden=YES;
            break;
        case MPMoviePlaybackStatePlaying:
            //设置全屏播放
            _webView.hidden=YES;
            self.playImageView.hidden=YES;
            NSLog(@"播放");
            break;
        case MPMoviePlaybackStateStopped:
            //注意：正常播放完成，是不会触发MPMoviePlaybackStateStopped事件的。
            //调用[self.player stop];方法可以触发此事件。
            _webView.hidden=YES;
            self.playImageView.hidden=NO;
            NSLog(@"停止");
            break;
        default:
            break;
    }
}
-(void)playBtnClick:(UIButton *)sender{
    //    [self.player play];
    [_videoPlayer play];
    self.playImageView.hidden=YES;
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
//获取商家所有信息
-(void)postRequestWholeInfo{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/infoGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self.infoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:@"1" forKey:@"index"];
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result====%@", result);
         self.appraiseArray=result[@"evaluate_list"];
         self.cardArray=result[@"card_list"];
         wholeInfoDic=[result copy];
         [self.shopTableView reloadData];
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}
@end
