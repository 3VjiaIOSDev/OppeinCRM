//
//  AddCommunicateVC.m
//  Crm
//
//  Created by svj on 15/10/22.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
//

#import "AddCommunicateVC.h"
#import "NSAlertView.h"

@interface AddCommunicateVC ()<UITextViewDelegate>
{
    UITextView *communicateTextView;
    UILabel * placeholderLab;
}
@end

@implementation AddCommunicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self initUI];
}
- (void)initUI
{

    communicateTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 75, self.view.frame.size.width-20, self.view.frame.size.height-235)];
    communicateTextView.delegate = self;
    communicateTextView.font =[UIFont systemFontOfSize:17.0f];
    communicateTextView.layer.borderColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1].CGColor;
    communicateTextView.layer.borderWidth = 1;
    communicateTextView.layer.cornerRadius = 5;
    [self.view addSubview:communicateTextView];
    
    placeholderLab = [[UILabel alloc]init];
    placeholderLab.frame =CGRectMake(15, 80, 250, 20);
    placeholderLab.text = @"输入您的交流意见";
    placeholderLab.font = [UIFont systemFontOfSize:17.0f];
    placeholderLab.enabled = NO;//lable必须设置为不可用
    placeholderLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:placeholderLab];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:5/255.0 green:82/255.0 blue:150/255.0 alpha:1];
    button.frame = CGRectMake(10, CGRectGetMaxY(communicateTextView.frame)+20, self.view.frame.size.width-20, 40);
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];
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
        placeholderLab.text = @"输入您的交流意见";
    }else{
        placeholderLab.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"添加交流意见"];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"添加交流" style:UIBarButtonItemStylePlain target:self action:@selector(addFollowUp)];    //把导航栏集合添加入导航栏中，设置动画关闭
  //  rightButton.tintColor = [UIColor blackColor];
    navigationItem.leftBarButtonItem = leftButton;
//    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)submit
{
    // authCode  serviceid content
    if (communicateTextView.text.length==0) {
        [NSAlertView alert:@"请输入交流意见!"];
        return;
    }
    [self analyseRequestData];
}

-(void)analyseRequestData
{
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *linkUpInfo = @{@"ServiceId":self.serviceId,@"Content":communicateTextView.text};
    
    NSData *linkUpInfoData = [NSJSONSerialization dataWithJSONObject:linkUpInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary *dict = @{@"authCode":code,@"LinkUpInfo":[[NSString alloc]initWithData:linkUpInfoData encoding:NSUTF8StringEncoding]};
    [HttpRequset post:dict method:@"LinkUpInfo/AddLinkUpInfo" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        NSString *ErrorMessage = [dic objectForKey:@"ErrorMessage"];
        NSDictionary * dictionary = dic[@"JSON"];
        if ([ErrorMessage isEqualToString:@""]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"添加交流意见成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
           // [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"ACId"] forKey:@"ACID"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:ErrorMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];

}



@end
