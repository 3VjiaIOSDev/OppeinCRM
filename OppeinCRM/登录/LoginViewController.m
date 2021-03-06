//
//  LoginViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"

@interface LoginViewController ()
{
    AFLoadIngView *afloading;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSecure = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    // Do any additional setup after loading the view.
    [self initView];
    
    [self initNavigation];

}

-(void)initNavigation
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"登录"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}

-(void)initView
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaultes arrayForKey:@"login"];
    NSString *name;
    NSString *pwd;
    
    if (array.count <= 0) {
        name = @"";
        pwd = @"";
    }
    else
    {
        
        name = [array objectAtIndex:0];
        pwd = [array objectAtIndex:1];
    }
    logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-40+viewWidth/2, 110, 80, 80)];
    logoImgView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImgView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:logoImgView.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = logoImgView.bounds;
    maskLayer.path = maskPath.CGPath;
    logoImgView.layer.mask = maskLayer;
    
    logoLab = [[UILabel alloc]initWithFrame:CGRectMake(-40+viewWidth/2, 210, 80, 40)];
    logoLab.text = @"易量尺";
    logoLab.textAlignment = NSTextAlignmentCenter;
    logoLab.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:logoLab];
    
    phoneview = [[UIView alloc]initWithFrame:CGRectMake(0, 290, viewWidth, 40)];
    phoneview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneview];
    
    UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    phoneLab.text = @"账号";
    phoneLab.textAlignment = NSTextAlignmentLeft;
    phoneLab.font = [UIFont systemFontOfSize:14.0f];
    [phoneview addSubview:phoneLab];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(80, 5, viewWidth-160, 30)];
    self.nameField.delegate = self;
    self.nameField.tag = 1000;
    self.nameField.text = name;
    self.nameField.textAlignment = NSTextAlignmentRight;
    self.nameField.keyboardType = UIKeyboardTypeDefault;
    self.nameField.font = [UIFont systemFontOfSize:14.0f];
    [phoneview addSubview:self.nameField];
    
    psdview = [[UIView alloc]initWithFrame:CGRectMake(0, 331, viewWidth, 40)];
    psdview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:psdview];
    
    UILabel *psdLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    psdLab.text = @"密码";
    psdLab.textAlignment = NSTextAlignmentLeft;
    psdLab.font = [UIFont systemFontOfSize:14.0f];
    [psdview addSubview:psdLab];
    
    self.pwdField = [[UITextField alloc]initWithFrame:CGRectMake(80, 5, viewWidth-160, 30)];
    self.pwdField.delegate = self;
    self.pwdField.tag = 1001;
    self.pwdField.text = pwd;
    self.pwdField.secureTextEntry = YES;
    self.pwdField.returnKeyType = UIReturnKeyDone;
    self.pwdField.textAlignment = NSTextAlignmentRight;
    self.pwdField.font = [UIFont systemFontOfSize:14.0f];
    [psdview addSubview:self.pwdField];
    
    UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //secureButton.backgroundColor = [UIColor redColor];
    secureButton.frame = CGRectMake(self.view.frame.size.width-60, 5, 40, 30);
    [secureButton setImage:[[UIImage imageNamed:@"secure.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [secureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [secureButton addTarget:self action:@selector(secureTextEntry) forControlEvents:UIControlEventTouchUpInside];
    [psdview addSubview:secureButton];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0];
    button.frame = CGRectMake(25, 390, viewWidth-50, 40);
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:button.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = button.bounds;
    maskLayer1.path = maskPath1.CGPath;
    button.layer.mask = maskLayer1;
}

-(void)secureTextEntry
{
    isSecure = !isSecure;
    self.pwdField.secureTextEntry = isSecure;
}
#pragma mark 键盘处理
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int pointY;
    if (textField == self.nameField) {
        pointY = 295;
    }
    else
        pointY = 336;
    int offset = pointY + 100 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark 用户登录

-(void)userLogin
{
    if (isSelect == YES) {
        return;
    }
    if ((self.nameField.text.length <= 0)||(self.pwdField.text.length <= 0)) {
        [SVProgressHUD showErrorWithStatus:@"用户名或者密码为空"];
        
        return;
    }
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    
    NSDictionary *dict = @{@"authCode":@"login",
                           @"username":self.nameField.text,
                           @"pwd":self.pwdField.text};
    [HttpRequset post:dict method:@"Login/Login" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        NSString *errorMsg = dic[@"ErrorMessage"];
        if (([dic[@"Status"]integerValue] == 200)&&(errorMsg.length <= 0)) {
            //登陆成功
            NSDictionary *JSON = [dic[@"JSON"]objectFromJSONString];
            NSString *Mobile = [JSON objectForKey:@"Mobile"];
            if (Mobile==nil) {
                Mobile = @"";
            }
            
            NSString *RealName = [JSON objectForKey:@"RealName"];
            NSArray *arr = [[NSArray alloc]initWithObjects:RealName,Mobile,nil];
            NSUserDefaults *userDefaul = [NSUserDefaults standardUserDefaults];
            [userDefaul setObject:arr forKey:@"userInfo"];
            
            userSingletion *user = [userSingletion inituserSingletion];
            user.name = RealName;
            user.phone = Mobile;
            
            NSArray *array = [[NSArray alloc]initWithObjects:self.nameField.text,self.pwdField.text, nil];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:array forKey:@"login"];
            
            NSString *AuthCode = [JSON objectForKey:@"AuthCode"];
            NSString *userID = [JSON objectForKey:@"UserId"];
            NSString *userName = [JSON objectForKey:@"UserName"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:AuthCode forKey:@"AuthCode"];
            [userDefaults setObject:userID forKey:@"userID"];
            [userDefaults setObject:userName forKey:@"userName"];
            [userDefaults setObject:JSON[@"DeptId"] forKey:@"DeptId"];
            
            AuthCode = [HttpRequset encodeToPercentEscapeString:AuthCode];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ViewController *vc = [[ViewController alloc]init];
                vc.selectedIndex = 0;
                [self addAnimation:self.view push:YES];
                [self presentViewController:vc animated:YES completion:nil];
            });

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

-(void)addAnimation:(UIView*)view push:(BOOL)push
{
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 1.0f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    if (push) {
        transition.subtype = kCAGravityTopRight;
    }
    else
    {
        transition.subtype = kCAGravityTopLeft;
    }
    
    [view.layer addAnimation:transition forKey:nil];
}

//-(void)login
//{//oppeinadmin //op123456
//
//    [self.view addSubview:afloading];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        [NSURLConnection sendAsynchronousRequest:[self initializtionRequest]
//                                           queue:[NSOperationQueue mainQueue]
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
//         {
//             //将得到的NSData数据转换成NSString
//             [afloading dismiss];
//             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//             
//             //将数据变成标准的json数据
//             NSLog(@"%@",[RequestDataParse newJsonStr:str]);
//             NSData *newData = [[RequestDataParse newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
//             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
//             
//             /*得到json中的key值
//              InfoMessage : 登录是否成功返回
//              JSON        : 登录返回数据
//              AuthCode    : 用户的授权码
//              */
//             
//             NSString *InfoMessage = [dic objectForKey:@"InfoMessage"];
//             NSDictionary *JSON = [dic objectForKey:@"JSON"];
//             
//             if (InfoMessage.length > 0) {
//                 
//                 //登陆成功
//                 
//                 
//                 
//                 NSString *Mobile = [JSON objectForKey:@"Mobile"];
//                 
//                 NSString *RealName = [JSON objectForKey:@"RealName"];
//                 NSArray *arr = [[NSArray alloc]initWithObjects:Mobile,RealName, nil];
//                 NSUserDefaults *userDefaul = [NSUserDefaults standardUserDefaults];
//                 
//                 NSArray *Permission = [JSON objectForKey:@"Permission"];
//                 [userDefaul setObject:Permission forKey:@"Permission"];
//                 
//                 [userDefaul setObject:arr forKey:@"userInfo"];
//                 
//                 userSingletion *user = [userSingletion inituserSingletion];
//                 user.name = RealName;
//                 user.phone = Mobile;
//                 
//                 NSArray *array = [[NSArray alloc]initWithObjects:self.nameField.text,self.pwdField.text, nil];
//                 NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                 [userDefault setObject:array forKey:@"login"];
//                 
//                 NSString *AuthCode = [JSON objectForKey:@"AuthCode"];
//                 
//                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                 [userDefaults setObject:AuthCode forKey:@"AuthCode"];
//                 
//                 AuthCode = [RequestDataParse encodeToPercentEscapeString:AuthCode];
//                 MainViewController *vc = [[MainViewController alloc]init];
//                 vc.selectedIndex = 0;
//                 [NSAlertView addAnimation:self.view push:YES];
//                 [self presentViewController:vc animated:YES completion:nil];
//             }
//             else
//             {
//                 //登录失败
//                 [NSAlertView alert:@"用户名或密码错误"];
//                 isSelect = NO;
//                 return;
//             }
//         }];
//    });
//}
//
////http://oppein.3weijia.com/oppein.axds?Params={"authCode":"login","username":"oppeinadmin","pwd":"op123456"}&Command=Login/Login
//-(NSMutableURLRequest*)initializtionRequest
//{
//    
//    NSURL *url = [NSURL URLWithString:[URLApi initURL]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    request.HTTPMethod = @"POST";
//    
//    NSString *loginStr = [NSString stringWithFormat:@"Params={\"authCode\":\"login\",\"username\":\"%@\",\"pwd\":\"%@\"}&Command=Login/Login",self.nameField.text,self.pwdField.text];
//    NSLog(@"http://oppein.3weijia.com/oppein.axds?%@",loginStr);
//    
//    NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:loginData];
//    
//    return request;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
