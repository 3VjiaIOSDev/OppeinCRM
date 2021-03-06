//
//  OpinionViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "OpinionViewController.h"

@interface OpinionViewController ()
{
    AFLoadIngView *afloading;
}
@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initNavigation];

}

//初始化导航栏
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"意见反馈";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
    
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//绘制界面
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *stateView = [[UIView alloc]initWithFrame:CGRectMake(10, 80, self.view.frame.size.width-20, 40)];
    stateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stateView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:stateView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = stateView.bounds;
    maskLayer.path = maskPath.CGPath;
    stateView.layer.mask = maskLayer;
    
    UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    stateLab.text = @"服务状态";
    stateLab.font = [UIFont systemFontOfSize:14.0f];
    [stateView addSubview:stateLab];
    
    QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"submit"];
    _radio1.frame =CGRectMake(125, 5, 60, 30);
    [_radio1 setTitle:@"售中" forState:UIControlStateNormal];
    [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_radio1.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [stateView addSubview:_radio1];
    [_radio1 setChecked:YES];
    
    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"submit"];
    _radio2.frame =CGRectMake(200, 5, 100, 30);
    
    [_radio2 setTitle:@"售后" forState:UIControlStateNormal];
    [_radio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_radio2.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [stateView addSubview:_radio2];
    
    communicateTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 135, self.view.frame.size.width-20, self.view.frame.size.height-235)];
    communicateTextView.delegate = self;
    communicateTextView.font =[UIFont systemFontOfSize:15.0f];
    [self.view addSubview:communicateTextView];
    
    placeholderLab = [[UILabel alloc]init];
    placeholderLab.frame =CGRectMake(15, 140, 250, 20);
    placeholderLab.text = @"您的宝贵意见或者建议";
    placeholderLab.font = [UIFont systemFontOfSize:15.0f];
    placeholderLab.enabled = NO;//lable必须设置为不可用
    placeholderLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:placeholderLab];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:communicateTextView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = communicateTextView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    communicateTextView.layer.mask = maskLayer2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0];
    button.frame = CGRectMake(10, self.view.frame.size.height-70, self.view.frame.size.width-20, 40);
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:button.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = button.bounds;
    maskLayer1.path = maskPath1.CGPath;
    button.layer.mask = maskLayer1;
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([radio.titleLabel.text isEqualToString:@"售中"]) {
        CommunicateType = 1;
    }
    else
    {
        CommunicateType = 2;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//textView提示文字

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        placeholderLab.text = @"您的宝贵意见或者建议";
    }else{
        placeholderLab.text = @"";
    }
}

#pragma mark 提交意见或者建议网络请求

-(void)submit
{
    if (communicateTextView.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，您没有给我们提供意见哟！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self sendOpinion];
}

-(void)sendOpinion
{
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    NSDictionary *dict = @{@"authCode":code,@"serviceId":self.ServiceId,@"CommunicateContext":communicateTextView.text,@"CommunicateType":[NSNumber numberWithInt:CommunicateType]};
    [HttpRequset post:dict method:@"Customer/AddCommunicateInfo" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        if (([dic[@"Status"]integerValue]==200)&&dic[@"JSON"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的建议已提交，谢谢您的配合！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
