//
//  LZDChartCell.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AllmessageListCell.h"
#import "UIButton+WebCache.h"
#import "Database.h"
#import "UIButton+WebCache.h"
#import "EMCDDeviceManager.h"

#import "ExpressionCL.h"

#import "ConvertToCommonEmoticonsHelper.h"

@interface AllmessageListCell ()

/** 时间 */
@property (nonatomic, weak) UILabel *chatTime;

/** 聊天内容 */
@property (nonatomic, weak) LZDButton *chatButton;

@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIView *topView;
@property(nonatomic,weak)UIView *bottomView;

@property(nonatomic,weak)UILabel *title_lab;
@property(nonatomic,weak)UILabel *persons_lab;


@end

@implementation AllmessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        // 时间
        
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *timeLbl = [[UILabel alloc]init];
        timeLbl.textAlignment = NSTextAlignmentCenter;
        timeLbl.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:timeLbl];
        
        
        UIView *backView = [[UIView alloc]init];
        
        backView.backgroundColor = RGB(240, 238, 244);
        [self.contentView addSubview:backView];
        
        backView.layer.cornerRadius = 5;
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = RGB(51, 51, 51).CGColor;
        backView.layer.masksToBounds = YES;
        self.backView = backView;
        
        UIView *topView = [[UIView alloc]init];
        
        topView.backgroundColor = RGB(246, 246, 246);
        [backView addSubview:topView];
        self.topView = topView;
        
        
        
        UILabel *titleLab = [[UILabel alloc]init];
        [topView addSubview:titleLab];
        
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textColor = RGB(51, 51, 51);
        self.title_lab = titleLab;
        
        
        
        UILabel *personLab = [[UILabel alloc]init];
        [topView addSubview:personLab];
        
        personLab.font = [UIFont systemFontOfSize:14];
        personLab.textColor = RGB(51, 51, 51);
        self.persons_lab = personLab;

        
        UIView *bottomView = [[UIView alloc]init];
        
        bottomView.backgroundColor = RGB(255, 255, 255);
        [backView addSubview:bottomView];
        self.bottomView = bottomView;

        
//        LZDButton *againSend = [LZDButton creatLZDButton];
//        [againSend setTitle:@"再发一条" forState:0];
//        [againSend setTitleColor:RGB(51, 51, 51) forState:0];
//        againSend.titleLabel.font = [UIFont systemFontOfSize:12];
//        againSend.backgroundColor = RGB(246, 246, 246);
//        [self.bottomView addSubview:againSend];
//        againSend.layer.cornerRadius = 12;
//        againSend.layer.masksToBounds = YES;
//        self.againSend = againSend;
        
        
        // 聊天消息
        LZDButton *chatBtn = [LZDButton creatLZDButton];
        chatBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        // 需要设置内容的内边距
        chatBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 25, 20);
        [chatBtn addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        chatBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:chatBtn];
        
        
        self.chatButton = chatBtn;
        self.chatTime = timeLbl;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.chatTime.frame = CGRectMake(0, 0, kWeChatScreenWidth, 30);
    
}

- (void)setMessage:(EMMessage *)message
{
    _message = message;
    // 获取消息体
    id body = message.body;
    
    //    NSDictionary *userDic =  message.ext;
    
    self.chatTime.text = [self conversationTime:message.timestamp];
    
    if ([body isKindOfClass:[EMTextMessageBody class]]) {// 文本类型
        //        [self.chatButton setAttributedTitle:nil forState:0];
        //        [self.chatButton setTitle:nil forState:0];
        EMTextMessageBody *textBody = body;
        [self.chatButton setImage:nil forState:UIControlStateNormal];
        
        [self.chatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //        NSMutableAttributedString *attrStr = [LZDUtility emotionStrWithString:textBody.text plistName:@"emoticons.plist" y:0];
        
        NSString *ss = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:textBody.text];
        [self.chatButton setTitle:ss forState:UIControlStateNormal];
        
        //        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:ss];
        //        NSMutableString *mu_s = [NSMutableString stringWithString:textBody.text];
        //        NSMutableAttributedString *attrStr =  [self zhuanhuan:mu_s];
        
        //        [self.chatButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        
       
        
        CGSize size =  [textBody.text boundingRectWithSize:CGSizeMake(kWeChatScreenWidth-50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size;
        //        NSLog(@"=length====%ld",textBody.text.length);
        //        CGSize size = [attrStr boundingRectWithSize:CGSizeMake(kWeChatScreenWidth/2, CGFLOAT_MAX)options: NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGSize realSize = CGSizeMake(size.width + 10, size.height + 10);
        // 聊天按钮的size
        self.chatButton.size = realSize;
        
        
        self.chatButton.frame = CGRectMake(20, 80+20, realSize.width, realSize.height);
        self.chatButton.imageEdgeInsets = UIEdgeInsetsZero;
        
        
        
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        EMImageMessageBody *imgBody = body;
        CGFloat scale =imgBody.size.height/imgBody.size.width;
        
        self.chatButton.size = CGSizeMake(kWeChatAllSubviewHeight*3, kWeChatAllSubviewHeight*3 *scale);
        self.chatButton.contentEdgeInsets = UIEdgeInsetsZero;
        

        
        // 获得本地预览图片的路径
        
        NSString *path = imgBody.thumbnailLocalPath;
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // 使用sdWedImage下载图片
        // 设置URL
        NSURL *url = nil;
        if ([fileMgr fileExistsAtPath:path]) {
            url = [NSURL fileURLWithPath:path];
        }else{
            url = [NSURL URLWithString:imgBody.thumbnailRemotePath];
        }
        
        [self.chatButton setAttributedTitle:nil forState:UIControlStateNormal];
        [self.chatButton setTitle:nil forState:UIControlStateNormal];
        
        
        [self.chatButton sd_setImageWithURL:url forState:0 placeholderImage:[UIImage imageNamed:@"default_header"]];
        
        
        //        self.chatButton.titleEdgeInsets = UIEdgeInsetsZero;
        //        self.chatButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        
        
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){// 语语音型
        EMVoiceMessageBody *voiceBody = body;
        // 设置图片 和 时间
        [self.chatButton setTitle:nil forState:UIControlStateNormal];
        
        [self.chatButton setAttributedTitle:nil forState:UIControlStateNormal];
        [self.chatButton setTitleColor:[UIColor blackColor] forState:0];
        [self.chatButton setTitle:[NSString stringWithFormat:@"%zd'",voiceBody.duration] forState:UIControlStateNormal];
        
        CGFloat width_duration =  [[NSString stringWithFormat:@"%zd'",voiceBody.duration] boundingRectWithSize:CGSizeMake(kWeChatScreenWidth/2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size.width;
        
        self.chatButton.size = CGSizeMake(kWeChatAllSubviewHeight + 30+width_duration, kWeChatAllSubviewHeight + 20);
        self.chatButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.chatButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    

    
    if (![body isKindOfClass:[EMTextMessageBody class]]) {
        self.chatButton.center = CGPointMake(kWeChatScreenWidth/2, 80+20+self.chatButton.size.height/2);

 
    }
    
    
    self.backView.frame = CGRectMake(20, 30, kWeChatScreenWidth-2*20, self.chatButton.bottom+40);
    self.topView.frame = CGRectMake(0, 0, self.backView.width, 50);
    self.bottomView.frame = CGRectMake(0, self.topView.bottom, self.backView.width, self.backView.height -self.topView.bottom);

    
    
    self.title_lab.frame = CGRectMake(15, 2, self.topView.width, self.topView.height/2-2);
    self.persons_lab.frame = CGRectMake(15, self.title_lab.bottom, self.topView.width, self.topView.height/2);
    
    NSArray *persons = message.ext[@"persons"];
    self.title_lab.text = [NSString stringWithFormat:@"%ld位收信人:",persons.count];
    
    
    
    NSString *person_string;
    for (int i = 0; i <persons.count; i ++) {
        
        NSDictionary *personDic = persons[i];
        if (i ==0) {
            person_string =personDic[@"user"];
        }else{
            person_string = [NSString stringWithFormat:@"%@,%@",person_string,personDic[@"user"]];
 
        }
    }
    
    
    self.persons_lab.text = person_string;
    
    
    
    
    self.againSend.frame = CGRectMake(self.bottomView.width-65-20, self.bottomView.height-35, 65, 25);
    
    
        if ([body isKindOfClass:[EMVoiceMessageBody class]]){// 语语音型
            [self.chatButton setImage:[UIImage imageNamed:@"chat_sender_audio_playing_full"] forState:UIControlStateNormal];
        }
        
        // 自己发送的
        
        [self.chatButton setBackgroundImage:[UIImage resizingImageWithName:@"bubbleSelf"] forState:UIControlStateNormal];
        [self.chatButton setBackgroundImage:[UIImage resizingImageWithName:@"bubbleSelf"] forState:UIControlStateHighlighted];
        
        
    
    if([body isKindOfClass:[EMImageMessageBody class]] ||[body isKindOfClass:[EMTextMessageBody class]]){
        
              [self.chatButton setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
    
    
}

- (CGFloat)rowHeight
{
    return self.backView.bottom + kWeChatPadding;
}

// 消息按钮的点击
- (void)chatBtnClick:(LZDButton *)btn
{
    NSLog(@"message = %@",self.message);
    id body = self.message.body;
    if([body isKindOfClass:[EMImageMessageBody class]]){
        // 显示大图片
        if (self.delegate && [self.delegate respondsToSelector:@selector(chartCellWithMessage:)]) {
            [self.delegate chartCellWithMessage:self.message];
        }
    }else if([body isKindOfClass:[EMVoiceMessageBody class]]){
        
        
        [self playVoice:body];
        
    }
}

- (void)playVoice:(EMVoiceMessageBody *)body

{
    EMVoiceMessageBody *voiceBody = body;
    
    
    // 获取本地路径
    NSString *path = voiceBody.localPath;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    // 判断path是否存在
    // 如果是不存在
    if (![fileMgr fileExistsAtPath:path]) {
        // 从远程服务器获取地址
        path = voiceBody.remotePath;
    }
    
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
        if (!error) {
            NSLog(@"播放成功");
        }
    }];
}


// 时间的转换
- (NSString *)conversationTime:(long long)time
{
    // 今天 11:20
    // 昨天 23:23
    // 前天以前 11:11
    // 1. 创建一个日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 2. 获取当前时间
    NSDate *currentDate = [NSDate date];
    // 3. 获取当前时间的年月日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    // 4. 获取发送时间
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    // 5. 获取发送时间的年月日
    NSDateComponents *sendComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sendDate];
    NSInteger sendYear = sendComponents.year;
    NSInteger sendMonth =  sendComponents.month;
    NSInteger sendDay = sendComponents.day;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    // 6. 当前时间与发送时间的比较
    if (currentYear == sendYear &&
        currentMonth == sendMonth &&
        currentDay == sendDay) {// 今天
        fmt.dateFormat = @"今天 HH:mm";
    }else if(currentYear == sendYear &&
             currentMonth == sendMonth &&
             currentDay == sendDay + 1){
        fmt.dateFormat = @"昨天 HH:mm";
    }else{
        fmt.dateFormat = @"MM-dd HH:mm";
    }
    
    return  [fmt stringFromDate:sendDate];
}

- (NSMutableAttributedString *)zhuanhuan:(NSMutableString *)content{
    
    //创建可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:content];
    NSLog(@"content===%@",content);
    //通过正则表达式来匹配字符
    NSString *regex = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"[error localizedDescription]==%@",[error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [content substringWithRange:range];
        NSLog(@"subStr-----%@",subStr);
        //新建文字附件来存放我们的图片,iOS7才新加的对象
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
        
        //给附件添加图片
        textAttachment.image= [ExpressionCL ObtainPictureName:subStr];
        
        //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
        textAttachment.bounds=CGRectMake(0, -8,textAttachment.image.size.width, textAttachment.image.size.height);
        
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        //把图片和图片对应的位置存入字典中
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        
        [imageDic setObject:imageStr forKey:@"image"];
        
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        
        //把字典存入数组中
        [imageArray addObject:imageDic];
        
    }
    
    //4、从后往前替换，否则会引起位置问题
    for(int i = (int)imageArray.count-1; i >=0; i--) {
        
        NSRange range;
        
        [imageArray[i][@"range"] getValue:&range];
        
        //进行替换
        
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    NSLog(@"attributeString-----%@",attributeString);
    return attributeString;
}


@end
