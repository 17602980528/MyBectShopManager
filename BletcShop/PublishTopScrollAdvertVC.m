//
//  PublishTopScrollAdvertVC.m
//  BletcShop
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PublishTopScrollAdvertVC.h"

@interface PublishTopScrollAdvertVC ()<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel *limitDataLength;
}
@end

@implementation PublishTopScrollAdvertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"发布广告";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNextVC)];
    self.navigationItem.rightBarButtonItem=rightItem;
    //section1
    self.view.backgroundColor=RGB(238, 238, 238);
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *advertTitle=[[UILabel alloc]initWithFrame:CGRectMake(19, 16, SCREENWIDTH-19, 16)];
    advertTitle.text=@"广告标题";
    advertTitle.font=[UIFont systemFontOfSize:16.0f];
    [topView addSubview:advertTitle];
    
    UITextField *advertTitleTF=[[UITextField alloc]initWithFrame:CGRectMake(12, 35, SCREENWIDTH-24, 45)];
    advertTitleTF.delegate=self;
    advertTitleTF.backgroundColor=RGB(240, 240, 240);
    advertTitleTF.placeholder=@"  给你的广告起个响亮的名字吧           0/20字";
    advertTitleTF.font=[UIFont systemFontOfSize:16.0f];
    [topView addSubview:advertTitleTF];
    
    //section2
    UIView *middleView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 130)];
    middleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:middleView];
    
    UILabel *addDescription=[[UILabel alloc]initWithFrame:CGRectMake(17, 11, SCREENWIDTH-17, 16)];
    addDescription.text=@"添加描述";
    addDescription.font=[UIFont systemFontOfSize:16.0f];
    [middleView addSubview:addDescription];
    
    UITextView *_textView=[[UITextView alloc]initWithFrame:CGRectMake(12, 31 , SCREENWIDTH-24, 90)];
    _textView.backgroundColor=RGB(240, 240, 240);
    _textView.font=[UIFont systemFontOfSize:15.0f];
    _textView.delegate=self;
    [middleView addSubview:_textView];
    
    limitDataLength=[[UILabel alloc]initWithFrame:CGRectMake(_textView.width-100, 70+30, 100, 20)];
    limitDataLength.text=@"0/500字";
    limitDataLength.textColor=RGB(153, 153, 153);
    limitDataLength.textAlignment=NSTextAlignmentRight;
    limitDataLength.font=[UIFont systemFontOfSize:15.0f];
    [middleView addSubview:limitDataLength];
    
    //section3
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 240, SCREENWIDTH, 106)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adver_sample"]];
    imageView.frame=CGRectMake(27, 5, 90, 90);
    [bottomView addSubview:imageView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:advertTitleTF];
    UIButton *addPictureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addPictureBtn.frame=imageView.frame;
    [bottomView addSubview:addPictureBtn];
    [addPictureBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    limitDataLength.text = [NSString stringWithFormat:@"%lu/500", (unsigned long)textView.text.length];
    //字数限制操作
    if (textView.text.length >= 500) {
        
        textView.text = [textView.text substringToIndex:500];
        limitDataLength.text = @"500/500";
    }
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //limitDataLength.hidden=YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        //limitDataLength.hidden=NO;
    }
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 20)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:20];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:20];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 20)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
-(void)goNextVC{
    
}
-(void)addPicture{
    NSLog(@"点击上传图片");
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
