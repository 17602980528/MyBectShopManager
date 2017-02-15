//
//  thirdlogVC.h
//  TianXinManor
//
//  Created by apple on 15/11/5.
//  Copyright (c) 2015年 Liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface thirdlogVC : UIViewController
{
    
    UITableView     *_tableView;
    UITextField     *_phone_tf;
    UITextField     *_password_tf;//验证码
    UITextField     *_password_sure_tf;
    UITextField    *_phoneCode;

    UIButton *mybutton;
    UIView*line;
    UIButton*logInBtn;

    UIScrollView *_scrollView;
    UIImageView *_userFace;
    UITextField     *_recommend_person;
    UITextField     *_realName;
    
    UITextField *_nickName;
    //    UITextField     *_sex;
    UITextField     *_identifierCode;
    UITextField     *_addressText;
    UILabel *_sexlab;
    UILabel *_marrayStatu;
    NSString*checkCode;

    NSString        *_imageDataStr;
    UIImage         *_image;

    
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSString *selectedProvince;
    UIPickerView *_picker;

    

    
    NSDictionary *marDic;
    NSDictionary *sexDic;
    UIButton * _testBtn;

    int             _time;
    NSTimer         *_timer;

}
@property(nonatomic,copy)NSString *Auth_type;
@property(nonatomic,copy)NSString *uid;
@end
