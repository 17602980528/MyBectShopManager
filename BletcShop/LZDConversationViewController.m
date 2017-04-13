//
//  LZDConversationViewController.m
//  BletcShop
//
//  Created by Bletc on 16/9/2.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDConversationViewController.h"
#import "LZDChartViewController.h"
#import "UIImageView+WebCache.h"
#import "Person.h"
#import "Database.h"
#import "NSString+Addition.h"

@interface LZDConversationViewController ()<EMClientDelegate,EMChatManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{

    
    SDRefreshHeaderView     *_refesh;

}
@property (nonatomic, weak) UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray *data_array;
@end

@implementation LZDConversationViewController

-(NSMutableArray *)data_array{
    if (!_data_array) {
        _data_array = [NSMutableArray array];
    }
    
    
  
    
    return _data_array;
}

-(void)getDataSourse{

    [self.data_array removeAllObjects];
   NSArray *da_array  =[[EMClient sharedClient].chatManager getAllConversations];
    
    for ( EMConversation* conver in da_array) {

        
        if (conver.latestMessage) {
        [self.data_array addObject:conver];

        }

    }
    NSLog(@"data_array.count---%ld",self.data_array.count);
    [_refesh endRefreshing];
    [self.myTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    
    
    [self getDataSourse];

}


- (void)messagesDidReceive:(NSArray *)aMessages;
{
    [self getDataSourse];

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    


   
    // 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , kWeChatScreenWidth, kWeChatScreenHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor =[UIColor clearColor];
    [self.view addSubview:tableView];
    self.myTableView = tableView;
    

    _refesh = [SDRefreshHeaderView refreshView];
    __block LZDConversationViewController *blockSelf = self;
    [_refesh addToScrollView:blockSelf.myTableView];
    
    _refesh.beginRefreshingOperation=^{
        [blockSelf getDataSourse];
        
        
    };
    _refesh.isEffectedByNavigationController=NO;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWeChatScreenWidth*0.2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _data_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellID = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    tableView.separatorColor=[UIColor clearColor];

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    
//    _data_array = [[EMClient sharedClient].chatManager getAllConversations];
    
    if (_data_array.count!=0) {
        EMConversation*conver=[_data_array objectAtIndex:indexPath.row];
        
        //    conver.enableUnreadMessagesCountEvent=YES;
        
        
        EMMessage*essage=conver.latestMessage;
        
        
        
        NSLog(@"%@essage.from========%@===%@",essage.from,essage.to,essage.conversationId);
        
        //    NSString*chatUser;
        //    if (USERID==nil) {
        //        chatUser=MANGERID;
        //    }else
        //    {
        //        chatUser=USERID;
        //    }
        //
        //    if ([chatUser isEqualToString:essage.from]) {
        //        chatUser=essage.to;
        //    }else
        //    {
        //    chatUser=essage.from;
        //    }
        
        
        
        
        UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.03, kWeChatScreenWidth*0.03, kWeChatScreenWidth*0.14, kWeChatScreenWidth*0.14)];
        [cell.contentView addSubview:image];
        
        NSLog(@"essage.ext---%@",essage.ext);
        //    [image sd_setImageWithURL:[NSURL URLWithString:essage.ext[@"headerImg"]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
        
        NSString *countRed =[NSString stringWithFormat:@"%lu",(unsigned long)[conver unreadMessagesCount]];
        
        UILabel*rednumbel=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth-15-10, 49/2, 15, 15)];
        rednumbel.backgroundColor=[UIColor redColor];
        rednumbel.text=countRed;
        if ([rednumbel.text intValue]==0) {
            rednumbel.hidden=YES;
        }
        rednumbel.textColor =[UIColor whiteColor];
        rednumbel.font=[UIFont systemFontOfSize:13];
        rednumbel.layer.cornerRadius=rednumbel.height/2;
        rednumbel.clipsToBounds=YES;
        rednumbel.textAlignment=NSTextAlignmentCenter;
        //    [image addSubview:rednumbel];
        [cell.contentView addSubview:rednumbel];
        
        CGFloat width_red = [rednumbel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:rednumbel.font} context:nil].size.width+7;
        NSLog(@"----%f",width_red);
        if (width_red>15) {
            rednumbel.frame = CGRectMake(kWeChatScreenWidth-width_red-10, 49/2, width_red, 15);

        }
        
        UIView *kuang=[[UIView alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.03-2, kWeChatScreenWidth*0.03-2, kWeChatScreenWidth*0.14+4, kWeChatScreenWidth*0.14+4)];
        kuang.layer.borderColor=RGB(234, 234, 234).CGColor;
        kuang.layer.borderWidth=1;
        [cell.contentView addSubview:kuang];
        
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.2, kWeChatScreenWidth*0.03, kWeChatScreenWidth*0.44, kWeChatScreenWidth*0.07)];
        
        
        
        
        if (conver.type==EMConversationTypeChat) {
            
            Person *p= [[Database searchPersonFromID:conver.conversationId] firstObject];
            
            
            NSString *header_S = [[p.idstring componentsSeparatedByString:@"_"] firstObject];
            
            if ([header_S isEqualToString:@"u"]) {
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,p.imgStr]] placeholderImage:[UIImage imageNamed:@"user"]];
                
            }else{
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,p.imgStr]] placeholderImage:[UIImage imageNamed:@"user"]];

                
                
            }

            
            
            label.text = p.name;
            
            if (!p) {
                label.text = essage.conversationId;
                
            }
            
        }else{
            EMGroup *agroup = [EMGroup groupWithId:conver.conversationId];
            NSLog(@"-----%@",agroup.subject);
            label.text=[NSString stringWithFormat:@"%@",agroup.subject];
            
            
            //        [EMClient sharedClient].groupManager
            //         [[EMClient sharedClient].groupManager searchPublicGroupWithId:conver.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
            //             NSLog(@"agroup ==%@",aGroup.subject);
            //
            //             if (!aError) {
            //                 label.text=[NSString stringWithFormat:@"%@",aGroup.subject];
            //
            //             }else{
            //                 label.text=[NSString stringWithFormat:@"%@",conver.conversationId];
            //
            //             }
            //
            //         }];
            
            image.image=[UIImage imageNamed:@"group"];
            
        }
        
        
        
        
        
        
        label.textAlignment=NSTextAlignmentLeft;
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        NSString*info;
        EMMessageBody *msgBody = essage.body;
        
        if (msgBody.type==EMMessageBodyTypeText) {
            info=((EMTextMessageBody *)msgBody).text;
        }else if(msgBody.type==EMMessageBodyTypeImage){
            info=@"[图片]";
        }else if(msgBody.type==EMMessageBodyTypeVoice){
            info=@"[语音]";
        }else {
            info=@"[未知类型]";
            
        }
        
        
        
        
        //信息
        UILabel*user_L=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.2, kWeChatScreenWidth*0.1, rednumbel.left-kWeChatScreenWidth*0.2-5, kWeChatScreenWidth*0.07)];

        user_L.text=[NSString stringWithFormat:@"%@",[ConvertToCommonEmoticonsHelper convertToSystemEmoticons:info]];
        user_L.textAlignment=NSTextAlignmentLeft;
        user_L.textColor=[UIColor grayColor];
        user_L.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:user_L];
        
        
        NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)essage.timestamp/1000];
        NSString*date=[NSString stringWithFormat:@"%@",confromTimesp];
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        fmt.dateFormat = @"YYYY-MM-dd HH:mm";
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [fmt setTimeZone:timeZone];
        NSString *newDate = [fmt stringFromDate:confromTimesp];
        
        
        NSLog(@"essage.timestamp----%lld===%@==%@",essage.timestamp,date,newDate);

        
        UILabel*time_L=[[UILabel alloc]initWithFrame:CGRectMake(kWeChatScreenWidth*0.65, 0, kWeChatScreenWidth*0.35-12, 32)];
        time_L.text=[NSString stringWithFormat:@"%@",newDate];
        time_L.textAlignment=NSTextAlignmentRight;
        time_L.textColor=[UIColor grayColor];
        time_L.font=[UIFont systemFontOfSize:12];
        [cell.contentView addSubview:time_L];
        

        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(10, kWeChatScreenWidth*0.2-1, SCREENWIDTH, 1)];
        line.backgroundColor = RGB(234, 234, 234);
        [cell.contentView addSubview:line];

        
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
//        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        EMConversation *conversation = _data_array[indexPath.row];
        
        
        switch (conversation.type) {
            case EMConversationTypeChat:
            {
                NSLog(@"EMConversationTypeChat");
//                NSMutableDictionary *dic= [NSMutableDictionary dictionary];
//                [dic setObject:[[[[EMClient sharedClient] currentUsername]componentsSeparatedByString:@"_"] lastObject] forKey:@"user"];
//                
//                
//                NSString *url = [NSString stringWithFormat:@"http://101.201.100.191/VipCard/user_info_get.php"];
//                [KKRequestDataService requestWithURL:url params:dic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//                    
//                    NSArray *usr_A = (NSArray*)result;
//                    
//               
//                    
//
//                    
//                    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
//                    
//                    [paramer setObject:[[conversation.conversationId componentsSeparatedByString:@"_"] lastObject] forKey:@"user"];
//                    NSLog(@"---%@",paramer);
//                    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//                        //                NSLog(@"----%@",result);
                
//                        NSArray *arr = (NSArray *)result;
                        LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
                        [chatCtr setHidesBottomBarWhenPushed:YES];
                        chatCtr.username = conversation.conversationId;
                        
                        chatCtr.chatType =EMConversationTypeChat;

//                        chatCtr.userInfo = usr_A;
//                        if (chatCtr.userInfo.count!=0) {
                
                Person *p= [[Database searchPersonFromID:conversation.conversationId] firstObject];

                            chatCtr.title = p.name;
                
                if (!p) {
                    chatCtr.title = @"陌生人";
                    chatCtr.title = conversation.conversationId;

                }
                            [self.navigationController pushViewController:chatCtr animated:YES];
                            
//                        }
                
//                    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        
//                    }];
                
                    
//                } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
                
        }

                break;
                case EMConversationTypeGroupChat:
                NSLog(@"EMConversationTypeGroupChat");
                
            {
//                NSMutableDictionary *dic= [NSMutableDictionary dictionary];
//                [dic setObject:[[EMClient sharedClient] currentUsername]  forKey:@"account"];
//                
//                
//                NSString *url = [NSString stringWithFormat:@"%@Extra/IM/get",BASEURL];
//                [KKRequestDataService requestWithURL:url params:dic httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//                    
//                    if ([result count]==0) {
//                        [self showHint:@"暂未获取到您的信息"];
//                        
//                    }else{
//                        NSArray *usr_A = (NSArray*)result;
//                        
                
                        
                        
                        
                        LZDChartViewController *chatCtr = [[LZDChartViewController alloc]init];
                        [chatCtr setHidesBottomBarWhenPushed:YES];
                        chatCtr.username = conversation.conversationId;
                        chatCtr.chatType =EMConversationTypeGroupChat;
                        
                        
//                        chatCtr.userInfo = usr_A;
//                        if (chatCtr.userInfo.count!=0) {
                            EMGroup *aGroup = [EMGroup groupWithId:conversation.conversationId];
                            
                            
                            //                            [[EMClient sharedClient].groupManager searchPublicGroupWithId:conversation.conversationId completion:^(EMGroup *aGroup, EMError *aError) {
                            //                                NSLog(@"errorDescription---%@",aError.errorDescription);
                            //                                if (!aError) {
                            chatCtr.title = [NSString stringWithFormat:@"%@",aGroup.subject];
                            [self.navigationController pushViewController:chatCtr animated:YES];
                            
                            
                            //                                }else{
                            //                                    chatCtr.title = conversation.conversationId;
                            //
                            //                                    [self.navigationController pushViewController:chatCtr animated:YES];
                            //                                }
                            //                    
                            //                            }];
                            
                            
//                        }
//
//                    }
//                    
//                
//                    
//                    
//                } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
                
            }
                break;
            default:
                break;
        }
        
    
        
        
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EMConversation*conver=[_data_array objectAtIndex:indexPath.row];
        
        [[EMClient sharedClient].chatManager deleteConversation:conver.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
            if (!aError) {
                [self getDataSourse];
            }
        }];
        
        
        
    }else{
        
    }
    
    
    
}




@end
