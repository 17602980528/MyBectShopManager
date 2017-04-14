//
//  SendMessageToAllVC.m
//  BletcShop
//
//  Created by apple on 17/4/10.
//  Copyright © 2017年 bletc. All rights reserved.
//
#define LZDAnyViewSubviewHW (kWeChatScreenWidth - 4*kWeChatPadding)/3
#import "SendMessageToAllVC.h"
#import "LZDToolView.h"
#import "ExpressionKeyboardView.h"
#import "ExpressionCL.h"
#import "LZDAnyView.h"
#import "EMCDDeviceManager.h"
#import "MWPhotoBrowser.h"
#import "LZDChartCell.h"
//#import "EMCDDeviceManager.h"
@interface SendMessageToAllVC ()<LZDToolViewVoiceDelegate,ExpressionKeyboardDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LZDChartCellShowImageDelegate,MWPhotoBrowserDelegate>
{
    UIScrollView *_scrollView;
    NSString *allPersons;
     NSMutableString *contentStr;
}
@property (nonatomic, weak) UITextView *anyViewNeedTextView;
@property (nonatomic, strong) ExpressionKeyboardView *faceView;
@property(nonatomic,strong)UITextView *r_textView;
@property(nonatomic,weak) LZDToolView *toolView;
@property(nonatomic,weak)UIImagePickerController *imgPicker;//***图片选择器
@property (nonatomic, strong) EMMessage *photoMessage;
/** 更多功能 */
@property (nonatomic, weak) LZDAnyView *chatAnyView;
@end

@implementation SendMessageToAllVC
-(void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
    self.chatAnyView.top = kWeChatScreenHeight;
    _faceView.top = kWeChatScreenHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"群发";
    NSLog(@"%@",self.dic);
    
       NSArray *persons=[self.dic allValues];
    for (int i=0; i<persons.count; i++) {
        if (persons.count==1) {
            allPersons=[NSString stringWithFormat:@"%@",persons[i][@"user"]];
        }else{
            if (i==0) {
                allPersons =persons[i][@"user"];
            }else{
                allPersons=[NSString stringWithFormat:@"%@,%@",allPersons,persons[i][@"user"]];
            }
        }
    }
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-109)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-10, 30)];
    noticeLable.text=[NSString stringWithFormat:@"您将发送信息给%lu个客户:",(unsigned long)persons.count];
    noticeLable.font=[UIFont systemFontOfSize:14.0f];
    noticeLable.textColor=[UIColor grayColor];
    [_scrollView addSubview:noticeLable];
    
    UILabel *personNameLable=[[UILabel alloc]initWithFrame:CGRectMake(15, 45, SCREENWIDTH-75, 30)];
    personNameLable.text=allPersons;
    personNameLable.textColor=RGB(51, 51, 51);
    personNameLable.font=[UIFont systemFontOfSize:18.0f];
    personNameLable.numberOfLines=0;
    [_scrollView addSubview:personNameLable];
    
    CGFloat height=[personNameLable.text boundingRectWithSize:CGSizeMake(SCREENWIDTH-75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : personNameLable.font} context:nil].size.height;
    CGRect frame = personNameLable.frame;
    frame.size.height = height;
    personNameLable.frame = frame;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(personNameLable.left-10, personNameLable.top-5, personNameLable.right+10, personNameLable.height+10)];
    view.layer.cornerRadius=8.0f;
    view.layer.borderWidth=0.6f;
    view.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    view.clipsToBounds=YES;
    [_scrollView addSubview:view];
    
    
    _scrollView.frame=CGRectMake(0, 0, SCREENWIDTH,view.bottom+10);
    if ((view.bottom+10)>=(SCREENHEIGHT-64-109)) {
        _scrollView.frame=CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT-64-109);
    }
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH,view.bottom+10);
    
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    // 2. 创建自定义控件
    
    LZDToolView *toolView = [[LZDToolView alloc]init];
    toolView.frame = CGRectMake(0, SCREENHEIGHT-44-64, SCREENWIDTH, 44);
    toolView.delegate = self;
    [self.view addSubview:toolView];
    self.toolView = toolView;
    __weak typeof(self) weakSelf = self;
    
    _toolView.sendTextBlock = ^(UITextView *textView ,LZDToolViewEditTextViewType tpye){
        NSLog(@"你点击了完成按钮==%d",tpye);
        if (tpye == LZDToolViewEditTextViewSend) {
            [weakSelf sendMsg:textView];
            
        }else{
            
//            if (self.chatAnyView.top < kWeChatScreenHeight) {
//                self.chatAnyView.top = kWeChatScreenHeight;
//            }
//            
//            if (_faceView.top < kWeChatScreenHeight) {
//                _faceView.top = kWeChatScreenHeight;
//                
//            }
//            
//            self.anyViewNeedTextView = textView;
            
        }
        
        
        
    };
    
    // 创建更多功能
    LZDAnyView *anyView = [[LZDAnyView alloc]initImageBlock:^{
        NSLog(@"你点击了图片");
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = weakSelf;
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
    weakSelf.toolView.moreBtnBlock = ^(){
        [self.anyViewNeedTextView resignFirstResponder];
        [self.view endEditing:YES];
    
        [UIView animateWithDuration:0.5 animations:^{
            
            _faceView.top = kWeChatScreenHeight ;
            //调整bottomView的高度
            anyView.top = kWeChatScreenHeight - LZDAnyViewSubviewHW;
            
            self.toolView.frame = CGRectMake(0, SCREENHEIGHT-64-44-LZDAnyViewSubviewHW, SCREENWIDTH, 44);
            
        }];
    };

    //表情点击------------
    _toolView.emtionBlock = ^(UITextView*textView){
        contentStr = [[NSMutableString alloc] init];

        //        NSLog(@"%s--emtionClick",__func__);
        [weakSelf.anyViewNeedTextView resignFirstResponder];
        [weakSelf.view endEditing:YES];
        
        //        NSLog(@"textView.text-----%@",textView.text);
        [contentStr appendString:textView.text];
      
        
        if (_faceView == nil) {
            
            for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
                if (![view isKindOfClass:[ExpressionKeyboardView class]]) {
                    
                    weakSelf.faceView = [[ExpressionKeyboardView alloc] init];
                    weakSelf.faceView.top = SCREENHEIGHT;
                    weakSelf.faceView.delegate = weakSelf;
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.faceView];
                }
            }
            
            weakSelf.r_textView = textView;
            weakSelf.faceView.sendBlock = ^{
                NSLog(@"sendBlock----%@",textView.text);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    weakSelf.faceView.top = kWeChatScreenHeight;
                weakSelf.toolView.frame = CGRectMake(0, SCREENHEIGHT-64-44, SCREENWIDTH, 44);
                    
                }];
               
                
                [weakSelf sendMsg:textView];
                [weakSelf cancelFocus:textView];
            };
        }
        float height = weakSelf.faceView.height;
        //设置键盘动画
        
        [UIView animateWithDuration:0.3 animations:^{
            anyView.top = kWeChatScreenHeight;
            
            weakSelf.faceView.top = kWeChatScreenHeight  - height;
            
            
            weakSelf.toolView.frame = CGRectMake(0, SCREENHEIGHT-64-height-44, SCREENWIDTH, 44);
            
        }];
    };
    

   
}
#pragma mark  LZDToolViewVoiceDelegate
-(void)toolViewWithType:(LZDToolViewVoiceType)type Button:(LZDButton *)btn{
    NSLog(@"-----%d",type);
    switch (type) {
        case LZDToolViewVoiceTypeStart:
        {
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
                
            }];
        }
            break;
            
        case LZDToolViewVoiceTypeCancel:
        {
            NSLog(@"退出录音");
            
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"发送中...", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];

    
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    NSArray *values=[self.dic allValues];
    
    
    NSDictionary *message_dic = [NSDictionary dictionaryWithObject:values forKey:@"persons"];

    for (int i=0; i<values.count; i++) {
        
        EMMessage *message = [[EMMessage alloc] initWithConversationID:from from:from to:values[i][@"uuid"] body:body ext:message_dic];
        message.chatType=EMChatTypeChat;
        
        [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
            
        } completion:^(EMMessage *message, EMError *error) {
            NSLog(@"===发送成功");
            
            if (i==values.count-1) {
                

                hud.label.text = @"发送成功";
                [hud hideAnimated:YES afterDelay:1];
                
                _toolView.top=SCREENHEIGHT-64-44;
                
               
            }
            
            if (values.count >1) {
                if (i !=0) {

                    EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:from type:EMConversationTypeGroupChat createIfNotExist:YES];
                    
                    [conver deleteMessageWithId:message.messageId error:nil];
                    

                    

                }
            }
            
            [self performSelector:@selector(popToView) withObject:nil afterDelay:1.5];

            
        }];
    }
}
#pragma mark----- 发送消息

-(void)sendMsg:(UITextView*)textView{
    if (textView.text.length!=0) {
        
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textView.text];
        NSString *from = [[EMClient sharedClient] currentUsername];
        
        //生成Message
        //    NSString *img_str = [NSString stringWithFormat:@"%@",[NSURL URLWithString:[HEADIMAGE stringByAppendingString:self.userInfo[1]]]];
        //
        //    NSDictionary *dic = @{@"headerName":self.userInfo[0],@"headerImg":img_str};
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = NSLocalizedString(@"发送中...", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        
        NSArray *values=[self.dic allValues];
        
        
        NSDictionary *message_dic = [NSDictionary dictionaryWithObject:values forKey:@"persons"];

        for (int i=0; i<values.count; i++) {
            
            EMMessage *message = [[EMMessage alloc] initWithConversationID:from from:from to:values[i][@"uuid"] body:body ext:message_dic];
            message.chatType=EMChatTypeChat;
            
            [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
                
            } completion:^(EMMessage *message, EMError *error) {
                NSLog(@"===发送成功");
                textView.text = @"";
                
                if (i==values.count-1) {
                    
                    hud.label.text = @"发送成功";
                    [hud hideAnimated:YES afterDelay:1];
                    [self.view endEditing:YES];

//                    _toolView.top=SCREENHEIGHT-44;
                }
                
                
                if (values.count >1) {
                    if (i !=0) {
                        
                        EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:from type:EMConversationTypeGroupChat createIfNotExist:YES];
                        
                        [conver deleteMessageWithId:message.messageId error:nil];
                        
                        
                        
                        
                    }
                }

                [self performSelector:@selector(popToView) withObject:nil afterDelay:1.5];

                
            }];
        }
    }
}
/** 取消事件的焦点 */
- (void)cancelFocus:(UITextView*)textView
{
    self.r_textView.text = nil;
    NSRange range = NSMakeRange(0, contentStr.length);
    [contentStr deleteCharactersInRange:range];
}
- (void)ExpressionSelect:(NSString *)str;{
    [contentStr appendString:str];
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
#pragma mark ----- 键盘通知回调的方法
- (void)keyboardWillChangeFrameNotification:(NSNotification *)noti
{
    //    NSLog(@"    noti.userInfo = %@",    noti.userInfo);
    CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyboardF.origin.y < kWeChatScreenHeight) {
        NSLog(@"show");
        _toolView.frame = CGRectMake(0, kWeChatScreenHeight - 64 - 44-keyboardF.size.height, _scrollView.width, 44);
    }else{
        NSLog(@"hide");
        
        _toolView.frame = CGRectMake(0, SCREENHEIGHT-64-44, SCREENWIDTH, 44);
    
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.4 animations:^{
        self.faceView.top=SCREENHEIGHT;
        _toolView.frame = CGRectMake(0, SCREENHEIGHT-64-44, SCREENWIDTH, 44);
        self.chatAnyView.top=SCREENHEIGHT;
    }];
    
}
- (void)ExpressionDelete{
    [self deleteExpression:contentStr];
    self.r_textView.text = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:contentStr];
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
- (void)commentTableViewTouchInSide{
    
    [UIView animateWithDuration:0.4f animations:^{
        
        self.chatAnyView.top =kWeChatScreenHeight;
        
        self.faceView.top = kWeChatScreenHeight;
        self.toolView.frame = CGRectMake(0, SCREENHEIGHT-64-44, SCREENWIDTH, 44);
    }];
}

#pragma mark 发送图片
- (void)sendImage:(UIImage *)image
{
    
                    _toolView.top=SCREENHEIGHT-64-44;

    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    NSData *thumbnailData=UIImageJPEGRepresentation (image, 0.3);
    //生成图片的data
    
    EMImageMessageBody *body = [[EMImageMessageBody alloc]initWithData:data thumbnailData:thumbnailData];
    body.size = image.size;
    NSString *from=[[EMClient sharedClient] currentUsername];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"发送中...", @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    NSArray *values=[self.dic allValues];
    NSDictionary *message_dic = [NSDictionary dictionaryWithObject:values forKey:@"persons"];
    for (int i=0; i<values.count; i++) {
        
        
        EMMessage *message = [[EMMessage alloc] initWithConversationID:from from:from to:values[i][@"uuid"] body:body ext:message_dic];
        message.chatType=EMChatTypeChat;
        [[EMClient sharedClient].chatManager
         sendMessage:message progress:^(int progress) {
             if (progress==100)
             {

             }
             
         } completion:^(EMMessage *message, EMError *error) {
             NSLog(@"发送图片Error%@",error.errorDescription);
             if (i==values.count-1) {
                 
                 hud.label.text = @"发送成功";
                 [hud hideAnimated:YES afterDelay:1];
                 
             }
             
             if (values.count >1) {
                 if (i !=0) {
                     
                     EMConversation*conver=[[EMClient sharedClient].chatManager getConversation:from type:EMConversationTypeGroupChat createIfNotExist:YES];
                     
                     [conver deleteMessageWithId:message.messageId error:nil];
                     
                     
                     
                     
                 }
             }

             if (!error)
             {   //存入数组
                 NSLog(@"发送成功");
             }
             
             [self performSelector:@selector(popToView) withObject:nil afterDelay:1.5];
         }];
        
    }
    
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


-(void)popToView{
    
    
    UIViewController *vc = self.navigationController.viewControllers[1];
    
    [self.navigationController popToViewController:vc animated:YES];
    
}

@end
