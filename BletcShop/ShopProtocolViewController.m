//
//  ShopProtocolViewController.m
//  BletcShop
//
//  Created by Bletc on 16/6/21.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ShopProtocolViewController.h"

@interface ShopProtocolViewController ()

@end

@implementation ShopProtocolViewController
-(void)backRegist
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 80, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    UILabel *userProtocolTitleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 30)];
    userProtocolTitleView.textAlignment = NSTextAlignmentCenter;
    userProtocolTitleView.text =@"商消乐平台商户协议";
    userProtocolTitleView.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:userProtocolTitleView];
    UIWebView *userProtocolView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 94, SCREENWIDTH, SCREENHEIGHT-94)];
    [self.view addSubview:userProtocolView];
    [userProtocolView loadHTMLString:@"商消乐平台商户协议<br>甲方：商消乐            乙方：<br> 地址：                     地址：<br> 电话：                     电话：<br> 为维护甲乙双方的合法权益，本着互惠互利的原则，双方经过友好协商，就乙方入驻甲方商消乐平台进行经营销售活动达成如下协议：<br> 一、乙方自愿在甲方商消乐平台宣传、推广并以预付卡的形式销售自己的服务产品。乙方保证在商消乐平台合法经营，提供优质服务及具有吸引力的价格。<br> 二、合作期限自乙方注册上线之日起至注销时止。<br> 三、甲方的责任与义务<br> 甲方承诺通过其商消乐平台提供如下服务：<br> 1、甲方以文字、图片介绍等形式，利用商消乐平台网站资源展示乙方店面形象、推广项目、特色服务产品等内容，对商家进行24小时的在线营销宣传。<br> 2、甲方可根据甲方的业务安排调整乙方服务产品上线销售的时间。<br> 3、甲方可根据需要要求乙方交纳一定金额的保证金，并在乙方按约定履行协议后予以退还。<br> 4、甲方有权监督乙方的经营及服务情况，发现违反规定及损害消费者利益的情况，有权制止。<br> 5、甲方应按约定向乙方转交销售款项。<br> 四、乙方责任与义务：<br> 1、乙方应具备以下条件：<br> （1）、具有独立的法人资格或者营业资格。<br> （2）、提供交易的服务产品应由自己提供相应服务。<br> （3）、应具备专职销售人员与消费者及甲方联系。<br> （4）、乙方公司及服务在行业内有有良好声誉。<br> 2、乙方应向甲方提供关于服务及商家的详细文字、图片介绍资料用于甲方在其平台上展示推广。并承诺该文字、图片等均为真实信息且不涉及第三人的合法权益。<br> 3、乙方有义务对持有通过商消乐平台购买其预付卡的消费者提供优质的服务，并做好每次的消费登记工作。如由乙方登记核对不善造成的用户重复消费给乙方带来的损失，由乙方独自承担。<br> 4、乙方有义务为购买乙方服务的消费者提供相应的服务，兑现本协议约定的产品服务的内容，否则视为乙方违约，由此产生的客户投诉、经济损失及不利后果由乙方自行承担。<br> 5、乙方应依法为消费者提供合法、安全的产品及服务并承诺为消费者提供产品或服务时，无论何种原因导致的损失或伤害，包括但不仅限于产品卫生质量问题、场所安全隐患问题、意外争执导致的人身安全，财产损失等状况发生时，由乙方负责，由此产生的一切后果与甲方无关。甲方对消费者先行赔付的，甲方有权向乙方追偿。<br> 6、乙方承诺，在本协议有效期内，本协议所描述的服务的性质为独家排他合作模式，否则视为乙方违约。<br> 7、乙方不得通过任何形式恶意刷单，否则一经发现甲方将采取包括但不限于警告、降级等措施予以惩罚。<br> 8、乙方对自己的经营状况应当定期向甲方报告，并以图片等形式上传其经营场所最新状况。<br> 9、乙方应对甲方通过商消乐平台展示的乙方公司信息及服务产品信息予以关注，如发现错误应及时与甲方沟通要求改正，如因乙方怠于审查，通知导致给乙方造成损失由乙方自行承担。<br> 10、乙方应根据消费者的请求，向消费者提供消费票据。<br> 五、结算方式<br> 1、甲方通过第三方支付机构收取该产品的销售金额。<br> 2、乙方进入甲方平台需缴纳保证金，在乙方履行完毕该合同约定的义务时，甲方将根据乙方的申请退还保证金。（详见附件2：保证金实施细则）<br> 3、甲方以7天为一个周期通过商消乐后台结算，在扣除服务费及保证金后，将其余款项汇入乙方提供的账户。<br> 六、协议的解除<br> 经双方友好协商，有下列情形之一的合同解除：<br> 1、在不损害消费者及第三人利益的情况下，经双方协商一致， 可以解除合同。<br> 2、甲方发现乙方在签订协议时提供虚假信息，或在实际经营中出现重大变更故意隐瞒或未及时告知，经甲方要求仍不如实告知的。<br> 3、根据消费者或第三方举报或消费者的评价过低达到一定程度时，甲方可暂停对乙方的宣传及服务产品的销售，并要求乙方整改，在规定的时间乙方无法达到甲方要求的标准时，甲方可与乙方解除合同，并且不予退还保证金，对尚未结算的销售金额，甲方有权在扣除服务费后，优先弥补因乙方违约行为给消费者造成的损失。<br> 4、乙方存在刷单等违规、违法行为的，甲方可警告、降级、暂停对乙方的宣传及服务产品的销售，若情节严重，或有两次以上上述行为的，甲方可与乙方解除合同，并且不予退还保证金，对尚未结算的销售金额，甲方有权在扣除服务费后，优先弥补因乙方违约行为给消费者造成的损失。<br> 5、如因乙方涉嫌违法行为，甲方可直接解除合同，并可要求乙方承担因其行为给甲方造成的损失。<br> 6、因乙方的违约、违法等行为导致甲方因维权所产生的律师费、差旅费等相关费用由乙方承担。<br> 七、本协议附件属于协议的组成部分，与协议具有同等法律效力。<br> 八、争议管辖<br> 本协议履行过程中，甲乙双方若发生争议，应友好协商解决。协商不成时，双方均同意以甲方管理者住所地人民法院为管辖法院。<br> 附件1：<br> 推荐人规则：<br> 1、商户可作为推荐人向平台推荐其他用户或商户使用或入驻商消乐平台。<br> 2、推荐人向商消乐平台推荐用户或商户，经平台审核通过，推荐人可获得推荐费。<br> 3、被推荐人为商户的，推荐费为被推荐商户入驻平台后营业额的1%，已计算的额度不重复计算。被推荐人为用户的，推荐费为被推荐用户在商消乐平台消费额的1%，被推荐用户再推荐其他用户的，原推荐人可以收取二级推荐费，推荐费为被推荐用户在商消乐平台消费额的0.5%，已计算的额度不重复计算。<br> 4、每7天为一个结算周期，通过平台直接转入推荐人的平台账户，推荐人可用于购买平台商品，抵扣服务费或按规则提现。<br> 5、出现下列情况推荐费终止发放：<br> （1）被推荐商户出现违反平台规则的行为导致其账户被冻结的，或商户退出商消乐平台的；<br> （2）推荐用户注销用户名或退出商消乐平台，或者该用户死亡的；<br> （3）推荐商户出现违反平台规则的行为导致其账户被冻结的，或商户退出商消乐平台的；" baseURL:nil];
    // Do any additional setup after loading the view.
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
