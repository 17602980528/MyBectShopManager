//
//  LZDChartViewController.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//
#define LZDAnyViewSubviewHW (kWeChatScreenWidth - 4*kWeChatPadding)/3

#import "LZDChartViewController.h"
#import "LZDToolView.h"
#import "LZDChartCell.h"
#import "LZDAnyView.h"
#import "UIImage+WebP.h"
#import "UIImageView+WebCache.h"
#import "Database.h"
#import "EMCDDeviceManager.h"
#import "EaseRecordView.h"

#import "ChatGroupDetailViewController.h"

#import "MWPhotoBrowser.h"
#import "ExpressionKeyboardView.h"
#import "ExpressionCL.h"


@interface LZDChartViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate,LZDToolViewVoiceDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LZDChartCellShowImageDelegate,MWPhotoBrowserDelegate,ExpressionKeyboardDelegate>
{
    LZDButton *rightBtn;
    SDRefreshHeaderView     *_refesh;

    NSMutableString *contentStr;
    
    

}
@property(nonatomic,copy)NSString *messageID;
@property(nonatomic,strong)UITextView *r_textView;
@property (nonatomic, strong) EMMessage *photoMessage;
@property (nonatomic, weak) UITableView *chatTableView;
@property (nonatomic , strong) NSMutableArray *msg_A;/** 聊天消息 */
/** 更多功能 */
@property (nonatomic, weak) LZDAnyView *chatAnyView;
/** 更多功能需要拿到的textView */
@property (nonatomic, weak) UITextView *anyViewNeedTextView;

@property(nonatomic,weak)UIImagePickerController *imgPicker;//***图片选择器
/**
 *  表情视图
 */
@property (nonatomic, strong) ExpressionKeyboardView          *faceView;

@property(nonatomic,weak) LZDToolView *toolView ;//***<#Description#>

@property (nonatomic, strong) EaseRecordView *recordView;



@end

@implementation LZDChartViewController
-(NSMutableArray *)msg_A{
    if (!_msg_A) {
        _msg_A = [[NSMutableArray alloc]init];
    }
    return _msg_A;
}

- (UIView *)recordView
{
    if (_recordView == nil) {
        _recordView = [[EaseRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    
    return _recordView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [self.msg_A removeAllObjects];
    [self getdataWithId:nil];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[EMClient sharedClient].chatManager removeDelegate:self];

    self.contentView.top = 0;
    self.chatAnyView.top = kWeChatScreenHeight;
    _faceView.top = kWeChatScreenHeight;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];

    
    rightBtn = [LZDButton creatLZDButton];
    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 0, 30, 30);
    if (self.chatType ==EMChatTypeChat) {
        [rightBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];

    }else if (self.chatType == EMChatTypeGroupChat){
        [rightBtn setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];

    }
    
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];;
    
    __weak typeof(self) weakSelf = self;
    rightBtn.block = ^(LZDButton *btn){
        if (weakSelf.chatType==EMChatTypeChat) {
            UIAlertController *alertVC= [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该对话吗?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
                [[EMClient sharedClient].chatManager deleteConversation:weakSelf.username isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
                    if (!aError) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }];
           
            [alertVC addAction:OKAction];
            [alertVC addAction:cancle];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
            
        }

        if (weakSelf.chatType ==EMChatTypeGroupChat) {
            //键盘下去
            [weakSelf commentTableViewTouchInSide];
            
            ChatGroupDetailViewController *VC = [[ChatGroupDetailViewController alloc]initWithGroupId:weakSelf.username];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }
        NSLog(@"删除");
        
    };
    

    
    
    // 1. 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWeChatScreenWidth, kWeChatScreenHeight - 64 - 44) style:UITableViewStylePlain];
    DebugLog(@"=====%f",kWeChatScreenWidth);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableView];
    
    self.chatTableView = tableView;
   
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.chatTableView addGestureRecognizer:tableViewGesture];
    

    
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    // 2. 创建自定义控件
      LZDToolView *toolView = [[LZDToolView alloc]init];
    toolView.frame = CGRectMake(0, self.chatTableView.bottom, kWeChatScreenWidth, 44);
    
    DebugLog(@"=====%f",self.chatTableView.width);

    toolView.delegate = self;
    [self.contentView addSubview:toolView];
    self.toolView = toolView;
    
    // 发送消息

    toolView.sendTextBlock = ^(UITextView *textView ,LZDToolViewEditTextViewType tpye){
        NSLog(@"你点击了完成按钮==%d",tpye);
        if (tpye == LZDToolViewEditTextViewSend) {
            [self sendMsg:textView];
 
        }else{
            
            if (self.chatAnyView.top < kWeChatScreenHeight) {
                self.chatAnyView.top = kWeChatScreenHeight;
            }
            
            if (_faceView.top < kWeChatScreenHeight) {
                _faceView.top = kWeChatScreenHeight;
                
            }

            self.anyViewNeedTextView = textView;

        }
        
        
       
    };
    
    // 创建更多功能
    LZDAnyView *anyView = [[LZDAnyView alloc]initImageBlock:^{
        NSLog(@"你点击了图片");
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        self.imgPicker = picker;
        [self presentViewController:picker animated:YES completion:nil];
        
    } talkBlock:^{
        NSLog(@"你点击了相机");
        
       
#if TARGET_IPHONE_SIMULATOR//模拟器
        
#elif TARGET_OS_IPHONE//真机
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        self.imgPicker = picker;
        [self presentViewController:picker animated:YES completion:nil];
#endif
        
        

    } vedioBlock:^{
        NSLog(@"你点击了视频");
    }];
    anyView.frame = CGRectMake(0, kWeChatScreenHeight, kWeChatScreenWidth, LZDAnyViewSubviewHW);
    [[UIApplication sharedApplication].keyWindow addSubview:anyView];
    self.chatAnyView = anyView;

     //moreBtn的点击
    toolView.moreBtnBlock = ^(){
        
//        NSLog(@"你点击了更多==%@",self.anyViewNeedTextView);
        
        
        if (self.anyViewNeedTextView) {
            [self.anyViewNeedTextView resignFirstResponder];
        }

        [UIView animateWithDuration:0.5 animations:^{
            
            
            
            
            
            _faceView.top = kWeChatScreenHeight ;
            self.chatTableView.frame = CGRectMake(0, 0, kWeChatScreenWidth, kWeChatScreenHeight - 64 - 44-LZDAnyViewSubviewHW);
            //调整bottomView的高度
            anyView.top = kWeChatScreenHeight - LZDAnyViewSubviewHW;

            self.toolView.frame = CGRectMake(0, self.chatTableView.bottom, self.chatTableView.width, 44);

        }];
           };
    

    
    //表情点击
    toolView.emtionBlock = ^(UITextView*textView){
//        NSLog(@"%s--emtionClick",__func__);
        [self.anyViewNeedTextView resignFirstResponder];
        contentStr = [[NSMutableString alloc] init];

        NSLog(@"textView.text-----%@",textView.text);
        [contentStr appendString:textView.text];
        __block __weak LZDChartViewController *this = self;

        if (_faceView == nil) {
            
            for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
                if (![view isKindOfClass:[ExpressionKeyboardView class]]) {
                    
                    _faceView = [[ExpressionKeyboardView alloc] init];
                    _faceView.top = SCREENHEIGHT;
                    _faceView.delegate = self;
                    [[UIApplication sharedApplication].keyWindow addSubview:_faceView];
                    
                    
                }
            }
            
           self.r_textView = textView;
            _faceView.sendBlock = ^{
                NSLog(@"sendBlock----%@",weakSelf.r_textView.text);
                [this sendMsg:weakSelf.r_textView];
                [this cancelFocus:weakSelf.r_textView];
            };
        }
        float height = _faceView.height;
        //设置键盘动画
        
        [UIView animateWithDuration:0.3 animations:^{
            anyView.top = kWeChatScreenHeight;

            _faceView.top = kWeChatScreenHeight  - height;
            self.chatTableView.frame = CGRectMake(0, 0, kWeChatScreenWidth, kWeChatScreenHeight - 64 - 44-height);
            
            this.toolView.frame = CGRectMake(0, self.chatTableView.bottom, self.chatTableView.width, 44);

        }];
    };

    
    
    _refesh = [SDRefreshHeaderView refreshView];
    __block LZDChartViewController *blockSelf = self;
    [_refesh addToScrollView:blockSelf.chatTableView];
    
    _refesh.beginRefreshingOperation=^{
        [blockSelf getdataWithId:blockSelf.messageID];
        
        
    };
    _refesh.isEffectedByNavigationController=NO;

    
  }

/** 取消事件的焦点 */
- (void)cancelFocus:(UITextView*)textView
{
    self.r_textView.text = nil;
    NSRange range = NSMakeRange(0, contentStr.length);
    [contentStr deleteCharactersInRange:range];
}

// 通知回调的方法
- (void)keyboardWillChangeFrameNotification:(NSNotification *)noti
{
//    NSLog(@"    noti.userInfo = %@",    noti.userInfo);
    CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyboardF.origin.y < kWeChatScreenHeight) {
        NSLog(@"show");
//        self.chatTableView.top =keyboardF.size.height;
//        self.chatTableView.height = kWeChatScreenHeight-keyboardF.size.height-64-44;
//
//        
//        self.contentView.top = - keyboardF.size.height;
//
        self.chatAnyView.top =kWeChatScreenHeight;
        self.faceView.top = kWeChatScreenHeight;
        
        self.chatTableView.frame = CGRectMake(0, 0, kWeChatScreenWidth, kWeChatScreenHeight - 64 - 44-keyboardF.size.height);
        //调整bottomView的高度
        
        self.toolView.frame = CGRectMake(0, self.chatTableView.bottom, self.chatTableView.width, 44);
        
       

    }else{
        NSLog(@"hide");
        self.chatAnyView.top =kWeChatScreenHeight;

        self.faceView.top = kWeChatScreenHeight;
        self.chatTableView.frame = CGRectMake(0, 0, kWeChatScreenWidth, kWeChatScreenHeight - 64 - 44);
        
        self.toolView.frame = CGRectMake(0, self.chatTableView.bottom, self.chatTableView.width, 44);
        
       
    }
    [self scrollBottom];
}

- (void)scrollBottom
{
    // 滚到最后一行
    NSLog(@"----%f",self.chatTableView.contentSize.height);
    
    if (self.chatTableView.contentSize.height>self.chatTableView.height) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msg_A.count - 1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.contentView endEditing:YES];
    [UIView animateWithDuration:0.4f animations:^{

        self.chatAnyView.top =kWeChatScreenHeight;
        
        self.faceView.top = kWeChatScreenHeight;
        self.chatTableView.frame = CGRectMake(0, 0, kWeChatScreenWidth, kWeChatScreenHeight - 64 - 44);
        
        self.toolView.frame = CGRectMake(0, self.chatTableView.bottom, self.chatTableView.width, 44);
        if (self.contentView.top < 0) self.contentView.top = 0;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.msg_A.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CHATCELL";
    LZDChartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LZDChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.message = self.msg_A[indexPath.row];
    
    return cell.rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CHATCELL";
    LZDChartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LZDChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.msg_A.count!=0) {
        
   
    Person *my_p= [[Database searchPersonFromID:[[EMClient sharedClient] currentUsername]] firstObject];

    EMMessage *msg =self.msg_A[indexPath.row];
    cell.my_P = my_p;
    
//    NSLog(@"-msg---%@----%@",msg.from,msg.to);
    
     Person *uer_p= [[Database searchPersonFromID:msg.from] firstObject];
    
    cell.user_P= uer_p;
    cell.message = msg;
    cell.delegate = self;
    }

    return cell;
}


//收到消息调用
- (void)didReceiveMessages:(NSArray *)aMessages
{
    
    NSLog(@"didReceiveMessages");
    for (int i =0; i < aMessages.count; i ++) {
        EMMessage*message = aMessages[i];
//        EMMessageBody *msgbody = message.body;
        if ([message.conversationId isEqualToString: self.username]) {
                [self.msg_A addObject:message];

        }
        NSLog(@"-收到来自:%@ 的:-----%u--%@",message.from,message.chatType,message.conversationId);;
        
        
    }
    
    [_chatTableView reloadData];

    
    [self scrollBottom];

    
}
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages;
{
    NSLog(@"didReceiveCmdMessages");

}
- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages;
{
    NSLog(@"didReceiveHasDeliveredAcks");
}




// 获取本地的聊天消息

-(void)getdataWithId:(NSString*)messageId{
    EMConversationType mytype;
    if (self.chatType==EMChatTypeChat) {
        mytype = EMConversationTypeChat;
    }else if(self.chatType == EMChatTypeGroupChat){
        mytype = EMConversationTypeGroupChat;

    }
//    DebugLog(@"=self.username,mytype===%@==%u",self.username,mytype);
    EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:self.username type:mytype createIfNotExist:YES];
    [conver markAllMessagesAsRead:nil];
    
    [conver loadMessagesStartFromId:messageId count:100 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        for (int i =0; i < aMessages.count; i ++) {
            EMMessage*message = aMessages[i];
            if (i==0) {
                self.messageID =message.messageId;
            }
//            DebugLog(@"===%@===%lld",message.messageId,message.timestamp);
            [self.msg_A addObject:message];
        }
        
        
        [_refesh endRefreshing];
        [_chatTableView reloadData];
        
        [self scrollBottom];

    }];
    
    
    
    
   
}









#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 隐藏picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 取出图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // 发送图片
    [self sendImage:image];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];

    [self commentTableViewTouchInSide];
}

#pragma mark 发送图片
- (void)sendImage:(UIImage *)image
{
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    
    
    NSData *thumbnailData=UIImageJPEGRepresentation (image, 0.3);
    //生成图片的data
    
    EMImageMessageBody *body = [[EMImageMessageBody alloc]initWithData:data thumbnailData:thumbnailData];
    body.size = image.size;
    NSString *from=[[EMClient sharedClient] currentUsername];
    
    //生成Message
//    NSString *img_str = [NSString stringWithFormat:@"%@",[NSURL URLWithString:[HEADIMAGE stringByAppendingString:self.userInfo[1]]]];
//    
//    NSDictionary *dic = @{@"headerName":self.userInfo[0],@"headerImg":img_str};

    NSLog(@"self.username-------%@===%d",self.username,self.chatType);
    
    EMMessage *message=[[EMMessage alloc]initWithConversationID:self.username from:from to:self.username body:body ext:nil];
    message.chatType=self.chatType;
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"发送中...", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
        [[EMClient sharedClient].chatManager
        sendMessage:message progress:^(int progress) {
            if (progress==100)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];//隐藏菊花
            }
            
        } completion:^(EMMessage *message, EMError *error) {
            NSLog(@"发送图片Error%@",error.errorDescription);
            
            if (!error)
            {   //存入数组
                NSLog(@"发送成功");
                [self.msg_A addObject:message];
                
                
                [_chatTableView reloadData];
                
                
                [self scrollBottom];
                
                
            }
            
        }];
    
    [_imgPicker dismissViewControllerAnimated:YES completion:nil];//模态视图


}


#pragma mark - LZDChartCellShowImageDelegate 显示大图片
- (void)chartCellWithMessage:(EMMessage *)message
{
    self.photoMessage = message;
    NSLog(@"delegate message = %@",message);
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    
    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark - 图片浏览器的代理方法
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    EMImageMessageBody *body = (EMImageMessageBody*)self.photoMessage.body;
    
    NSString *path = body.localPath;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:path]) {
        // 设置图片浏览器中的图片对象 (本地获取的)
        return [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:path]];
    }else{
        // 设置图片浏览器中的图片对象 (使用网络请求)
        path = body.remotePath;
        return [MWPhoto photoWithURL:[NSURL URLWithString:path]];
    }
    
    return nil;
}


// 发送消息

-(void)sendMsg:(UITextView*)textView{
    if (textView.text.length!=0) {
        
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textView.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
//    NSString *img_str = [NSString stringWithFormat:@"%@",[NSURL URLWithString:[HEADIMAGE stringByAppendingString:self.userInfo[1]]]];
//
//    NSDictionary *dic = @{@"headerName":self.userInfo[0],@"headerImg":img_str};
    
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.username from:from to:self.username body:body ext:nil];
    message.chatType=self.chatType;

    NSLog(@"from--%@--self.username--%@==self.chatType==%u",from,self.username,self.chatType);
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        NSLog(@"===发送成功");
        
        // 添加数据
        {
            EMMessageBody *msgbody = message.body;
            
            switch (msgbody.type) {
                case EMMessageBodyTypeText:
                {
                    
                    [self.msg_A addObject:message];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }            // 刷新表格
        [_chatTableView reloadData];
        
        textView.text = @"";
        [self scrollBottom];
        
    }];
    
    
    }
  
    
}


- (void)deleteAllMessages:(NSNotification*)info
{
    if (self.msg_A.count == 0) {
        
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
        NSString *groupId = (NSString *)[info object];
    if (self.chatType ==EMChatTypeGroupChat) {
        
        EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:groupId type:EMConversationTypeGroupChat createIfNotExist:YES];

        [conver deleteAllMessages:nil];
        [self.msg_A removeAllObjects];
        [self.chatTableView reloadData];
    }
    
}



#pragma mark  LZDToolViewVoiceDelegate
-(void)toolViewWithType:(LZDToolViewVoiceType)type Button:(LZDButton *)btn{
    NSLog(@"-----%d",type);
    switch (type) {
        case LZDToolViewVoiceTypeStart:
        {
            [self.contentView addSubview:self.recordView];
            NSLog(@"开始录音");
            int fileNameNum = arc4random() % 1000;
            NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
            [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:[NSString stringWithFormat:@"%zd%d",fileNameNum,(int)time] completion:^(NSError *error) {
                if (!error) {
                    NSLog(@"录音成功");
                    
                }
            }];
        }
            break;
            
        case LZDToolViewVoiceTypeStop:
        {
            NSLog(@"停止录音");
            [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
                NSLog(@"recordPath = %@ , duration = %zd",recordPath,aDuration);
                [self sendVoiceWithFilePath:recordPath duration:aDuration];
                [self.recordView removeFromSuperview];

            }];
        }
            break;
            
        case LZDToolViewVoiceTypeCancel:
        {
            NSLog(@"退出录音");
            [self.recordView removeFromSuperview];

        }
            break;
            
        default:
            break;
    }

    
}

// 发送语音消息
- (void)sendVoiceWithFilePath:(NSString *)path duration:(NSInteger)aDuration
{


    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:path displayName:@"audio"];
    body.duration = (int)aDuration;
    if (aDuration<1) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"说话时间太短";
        hud.label.font = [UIFont systemFontOfSize:15];
        hud.label.textColor =[UIColor blackColor];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    
    NSString *from = [[EMClient sharedClient] currentUsername];

    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.username from:from to:self.username body:body ext:nil];
    message.chatType=self.chatType;

    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        NSLog(@"即将发送");

    } completion:^(EMMessage *message, EMError *error) {
    
        NSLog(@"发送完成==%@",error.errorDescription);
        // 添加数据
        [self.msg_A addObject:message];
        // 刷新表格
        [self.chatTableView reloadData];
        // 滚到最后一行
        [self scrollBottom];

    }];

    
  
}

- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark ExpressionKeyboardDelegate
//删除按钮
- (void)ExpressionDelete;
{
    [self deleteExpression:contentStr];
    
    self.r_textView.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:contentStr];
    
}
//输入的表情

- (void)ExpressionSelect:(NSString *)str;{
    [contentStr appendString:str];
    NSLog(@"ExpressionSelect----%@--%@",str,self.r_textView);
    
    self.r_textView.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:contentStr];
    
}

- (void)deleteExpression:(NSMutableString *)content{
    if([content length] <= 0){
        return;
    }
    //字符串末尾
    NSInteger length = [content length] - 1;
    
    //字符串末尾位置
    NSRange range = NSMakeRange(length, 1);
    
    //获取末尾位置字符串
    NSString *lastStr = [content substringWithRange:range];
    
    if ([lastStr isEqualToString:@"]"]) {
        //新浪,小浪花表情
        
        //获取[的位置
        NSRange biaoqingRang = [content rangeOfString:@"[" options:NSBackwardsSearch];
        
        //获取[]长度
        NSInteger biaoqingLength = range.location - biaoqingRang.location;
        
        //重置删除的range
        range = NSMakeRange(length - biaoqingLength, biaoqingLength + 1);
        
    }else if ([lastStr intValue] < 0x1F600 || [lastStr intValue] > 0x1F64F) {
        //系统表情
        
        //重置删除的range
        range = NSMakeRange(length - 1, 2);
    }
    [content deleteCharactersInRange:range];
}

- (void)commentTableViewTouchInSide{
    
    [self.contentView endEditing:YES];
    [UIView animateWithDuration:0.4f animations:^{
        
        self.chatAnyView.top =kWeChatScreenHeight;
        
        self.faceView.top = kWeChatScreenHeight;
        self.chatTableView.frame = CGRectMake(0, 0, kWeChatScreenWidth, kWeChatScreenHeight - 64 - 44);
        
        self.toolView.frame = CGRectMake(0, self.chatTableView.bottom, self.chatTableView.width, 44);
        if (self.contentView.top < 0) self.contentView.top = 0;
    }];
}


@end
