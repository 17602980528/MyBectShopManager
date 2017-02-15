//
//  LZDChartCell.m
//  chartTest
//
//  Created by Bletc on 16/8/25.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "LZDChartCell.h"
#import "UIButton+WebCache.h"
#import "Database.h"
#import "UIButton+WebCache.h"
#import "EMCDDeviceManager.h"

#import "ExpressionCL.h"

#import "ConvertToCommonEmoticonsHelper.h"

@interface LZDChartCell ()

/** 时间 */
@property (nonatomic, weak) UILabel *chatTime;

/** 聊天内容 */
@property (nonatomic, weak) LZDButton *chatButton;

/** 头像 */
@property (nonatomic, weak) LZDButton *chatIcon;
/**
 *  用户名
 */
@property (nonatomic, weak) UILabel *name_lab;

@end

@implementation LZDChartCell

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
        
        // 聊天消息
        LZDButton *chatBtn = [LZDButton creatLZDButton];
        chatBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        // 需要设置内容的内边距
        chatBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 25, 20);
        [chatBtn addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        chatBtn.titleLabel.numberOfLines = 0;

        [self.contentView addSubview:chatBtn];
        
        // 头像
        LZDButton *iconBtn = [LZDButton creatLZDButton];
        iconBtn.layer.masksToBounds = YES;
        iconBtn.layer.cornerRadius = kWeChatAllSubviewHeight/2;
        [self.contentView addSubview:iconBtn];
        
        UILabel *name_lab = [[UILabel alloc]init];
        name_lab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:name_lab];
        
        
        self.chatButton = chatBtn;
        self.chatIcon = iconBtn;
        self.chatTime = timeLbl;
        self.name_lab = name_lab;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.chatTime.frame = CGRectMake(0, 0, kWeChatScreenWidth, 30);
    self.name_lab.frame = CGRectMake(kWeChatPadding, self.chatTime.bottom, kWeChatScreenWidth-2*kWeChatPadding, 20);

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
        
        CGSize size =  [textBody.text boundingRectWithSize:CGSizeMake(kWeChatScreenWidth/2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size;
//        NSLog(@"=length====%ld",textBody.text.length);
//        CGSize size = [attrStr boundingRectWithSize:CGSizeMake(kWeChatScreenWidth/2, CGFLOAT_MAX)options: NSStringDrawingUsesLineFragmentOrigin context:nil].size;

        CGSize realSize = CGSizeMake(size.width + 40, size.height + 40);
        // 聊天按钮的size
        self.chatButton.size = realSize;
        
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

        self.chatButton.size = CGSizeMake(kWeChatAllSubviewHeight + 40+width_duration, kWeChatAllSubviewHeight + 30);
        self.chatButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.chatButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    



    NSString *chatter = [[EMClient sharedClient] currentUsername];
    
    if ([message.from isEqualToString:chatter]) {
        
        
        if ([body isKindOfClass:[EMVoiceMessageBody class]]){// 语语音型
            [self.chatButton setImage:[UIImage imageNamed:@"chat_sender_audio_playing_full"] forState:UIControlStateNormal];
        }

        // 自己发送的
        
        [self.chatButton setBackgroundImage:[UIImage resizingImageWithName:@"bubbleSelf"] forState:UIControlStateNormal];
        [self.chatButton setBackgroundImage:[UIImage resizingImageWithName:@"bubbleSelf"] forState:UIControlStateHighlighted];

        
        
        
        
        self.name_lab.text =self.my_P.name;
        if (!self.my_P) {
//            self.name_lab.text = @"陌生人";
            self.name_lab.text = message.from;

        }
        
        NSString *header_S = [[self.my_P.idstring componentsSeparatedByString:@"_"] firstObject];
        
        if ([header_S isEqualToString:@"u"]) {
            [self.chatIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.my_P.imgStr]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user"]];
            
        }else{
            [self.chatIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,self.my_P.imgStr]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user"]];
            
        }

        

        // 头像在右边
        self.chatIcon.frame = CGRectMake(kWeChatScreenWidth - kWeChatAllSubviewHeight - kWeChatPadding,20 +30 + kWeChatPadding, kWeChatAllSubviewHeight, kWeChatAllSubviewHeight);
        self.name_lab.textAlignment = NSTextAlignmentRight;
        
        // 聊天消息是左边
        self.chatButton.left = kWeChatScreenWidth - self.chatButton.width - self.chatIcon.width - kWeChatPadding*2;
        
    }else{// 别人发的
        // 头像在右边
        
        if ([body isKindOfClass:[EMVoiceMessageBody class]]){// 语语音型
            [self.chatButton setImage:[UIImage imageNamed:@"chat_receiver_audio_playing_full"] forState:UIControlStateNormal];
        }
        self.name_lab.text =self.user_P.name;
        if (!self.user_P) {
//            self.name_lab.text = @"陌生人";
            self.name_lab.text = message.from;

        }
        
        
        NSString *header_S = [[self.user_P.idstring componentsSeparatedByString:@"_"] firstObject];
        if ([header_S isEqualToString:@"u"]) {
            [self.chatIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.user_P.imgStr]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user"]];

        }else{
            [self.chatIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHOPIMAGE_ADDIMAGE,self.user_P.imgStr]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user"]];

        }
        
        

        self.chatIcon.frame = CGRectMake(kWeChatPadding,20 +30 + kWeChatPadding, kWeChatAllSubviewHeight, kWeChatAllSubviewHeight);
        [self.chatIcon setBackgroundImage:[UIImage imageNamed:@"1.jpg"] forState:UIControlStateNormal];

        self.name_lab.textAlignment = NSTextAlignmentLeft;

        
        // 聊天消息是左边
        self.chatButton.left = self.chatIcon.right + kWeChatPadding;
        [self.chatButton setBackgroundImage:[UIImage resizingImageWithName:@"bubble"] forState:UIControlStateNormal];
        [self.chatButton setBackgroundImage:[UIImage resizingImageWithName:@"bubble"] forState:UIControlStateHighlighted];


    }
    // Y轴
    self.chatButton.top = self.chatIcon.top;
    
    if([body isKindOfClass:[EMImageMessageBody class]]){
        
//        [self.chatButton setBackgroundImage:nil forState:UIControlStateNormal];

    }
    
}

- (CGFloat)rowHeight
{
    return self.chatButton.bottom + kWeChatPadding;
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
