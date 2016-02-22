//
//  AddFollowUpViewController.m
//  Crm
//
//  Created by 3Vjia on 15/10/22.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
//
#define SPACE 10

#import "AddFollowUpViewController.h"
#import "NSAlertView.h"

#import "TimePicker.h"
#import "CustomPicker.h"
#import "QRadioButton.h"


@interface AddFollowUpViewController ()<UITextFieldDelegate,UITextViewDelegate,TimePickerDelegate,CustomPickerDelegate,QRadioButtonDelegate,UITextFieldDelegate>
{
    TimePicker *timerPicker;
    CustomPicker *pick;
    UIButton *saveButton;
    UIScrollView * myScroll;
    AFLoadIngView *afLoading;
    UITextField *keyField;
    
    NSString *isAwoke;

}
@end

@implementation AddFollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   isAwoke = @"false";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self initUI];
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
    [navigationItem setTitle:@"添加跟进"];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"添加跟进" style:UIBarButtonItemStylePlain target:self action:@selector(addFollowUp)];    //把导航栏集合添加入导航栏中，设置动画关闭
    //rightButton.tintColor = [UIColor whiteColor];
    leftButton.tintColor = [UIColor blackColor];
    navigationItem.leftBarButtonItem = leftButton;
    //navigationItem.rightBarButtonItem = rightButton;
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

-(void)initUI
{
    
    
    myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    [self.view addSubview:myScroll];
    

    NSArray *messageArray = @[@"沟通时间",@"下次沟通时间",@"是否触发智能提醒"];
    for (int i = 0; i < messageArray.count; i++) {
        if ((i == 0)||(i == 1)) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15+40*i, 15, 15)];
            image.image = [UIImage imageNamed:@"xinghao"];
            [myScroll addSubview:image];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i==2?10:30, 15+40*i, 130, 20)];
        label.text = [messageArray objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:13.0f];
        [myScroll addSubview:label];
        if (i == 2) {
            for (int j = 0; j < 2; j++) {
                QRadioButton *radio = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                radio.frame =CGRectMake(self.view.frame.size.width-60*(j+1), 12.5+40*i, 50, 30);
                [radio setTitle:j == 0 ?@"否":@"是" forState:UIControlStateNormal];
                [radio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [radio.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [myScroll addSubview:radio];
                if (j == 0) {
                    [radio setChecked:YES];
                }
            }

        }
        
        else
        {
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5,15+40*i, 180, 20)];
            NSString *placeholder = [NSString stringWithFormat:@"请输入%@",[messageArray objectAtIndex:i]];
            field.font = [UIFont systemFontOfSize:14.0f];
            field.tag = i;
            field.textAlignment = NSTextAlignmentLeft;
            field.placeholder = placeholder;
            field.borderStyle = UITextBorderStyleNone;
            field.delegate = self;
            [myScroll addSubview:field];
            if (i == 0) {
                self.FollowUpTimeField = field;
            }
            else if(i == 1)
            {
                self.nextTimeField = field;//self.FollowUpStepField = field;
            }

        }
       
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SPACE, CGRectGetMaxY(label.frame)+10, self.view.frame.size.width-2*SPACE, 1)];
        line.tag = 100+i;
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [myScroll addSubview:line];
    }
    UIView * lineView = (UIView *)[self.view viewWithTag:100+2];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, CGRectGetMaxY(lineView.frame)+15, 60, 20)];
    label.text = @"沟通内容";
    label.font = [UIFont systemFontOfSize:14.0f];
    [myScroll addSubview:label];

    self.connectView = [[UITextView alloc]initWithFrame:CGRectMake(60+2*SPACE, CGRectGetMaxY(lineView.frame)+10, self.view.frame.size.width-90, 100)];
    self.connectView.font = [UIFont systemFontOfSize:15.0f];
    self.connectView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    self.connectView.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]CGColor];
    self.connectView.layer.borderWidth = 1.0;
    self.connectView.delegate = self;
    [self.connectView.layer setMasksToBounds:YES];
    self.connectView.delegate = self;
    [myScroll addSubview:self.connectView];
    
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(SPACE, CGRectGetMaxY(self.connectView.frame)+5, self.view.frame.size.width-2*SPACE, 1)];
    lines.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [myScroll addSubview:lines];
    
    UILabel *keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SPACE, CGRectGetMaxY(lines.frame)+15, 60, 20)];
    keyLabel.text = @"关键点";
    keyLabel.font = [UIFont systemFontOfSize:14.0f];
    [myScroll addSubview:keyLabel];
    
    
    keyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(keyLabel.frame)+10, CGRectGetMaxY(lines.frame)+10,self.view.frame.size.width-90, 30)];
    keyField.placeholder = @"请输入关键节点";
    keyField.delegate = self;
    keyField.tag = 999;
    keyField.font = [UIFont systemFontOfSize:14.0f];
    keyField.borderStyle = UITextBorderStyleNone;
    [myScroll addSubview:keyField];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.backgroundColor = [UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0];
    saveButton.frame = CGRectMake(2*SPACE, CGRectGetMaxY(keyLabel.frame)+20, self.view.frame.size.width-4*SPACE, 40);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    saveButton.layer.cornerRadius = 5.0f;
    [myScroll addSubview:saveButton];
    
    myScroll.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(saveButton.frame)+10);
}

-(void)save
{
    if (self.FollowUpTimeField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择沟通时间" message:@"请选择沟通时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (self.nextTimeField.text.length <=0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择下次沟通时间" message:@"选择下次沟通时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (self.connectView.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入沟通内容" message:@"请输入沟通内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self AddFollowUPData];
}
#pragma mark textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 999) {
        int pointY;
        pointY = 336;
        int offset = pointY + 100 - (self.view.frame.size.height - 216.0);//键盘高度216
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        if(offset > 0)
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
        return;
    }
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

    [textField resignFirstResponder];
    [self.connectView resignFirstResponder];
    [timerPicker dissPicker];
    [pick dissPicker];
    if (textField.tag == 0) {
    //[textField resignFirstResponder];
        timerPicker = [[TimePicker alloc]initWithDataArray];
        timerPicker.delegate = self;
        [timerPicker show];
        
        [self.view addSubview:timerPicker];
    }
    else{
        timerPicker = [[TimePicker alloc]initWithDataArray];
        timerPicker.delegate = self;
        [timerPicker show];
        timerPicker.tag = 10000;
        [self.view addSubview:timerPicker];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2) {
        [textField resignFirstResponder];
    }
    if (textField.tag == 999) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        self.FollowUpSpanField.text = tf.text;
    }
}

#pragma mark textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

#pragma mark---UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    myScroll.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(textView.frame)+10+252);
    int pointY;
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
    myScroll.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(saveButton.frame)+10);
}];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark 选择跟进时间

-(void)clickTimeWith:(TimePicker*)timePicker timer:(NSString*)timer
{
    if (timerPicker.tag ==10000) {
        self.nextTimeField.text = timer;
    }else
    self.FollowUpTimeField.text = timer;
}

#pragma mark 选择跟进进度

- (void)clickSureButtonWith:(CustomPicker *)picker currentTitle:(NSString *)title tag:(NSInteger)row
{
    self.FollowUpStepField.text = title;
}

#pragma mark 添加跟进

-(void)AddFollowUPData
{
    [afLoading removeFromSuperview];
    afLoading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afLoading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    

//    NSDictionary *linkUpInfo = @{@"authCode":code,@"ServiceId":self.serviceId,@"Content":self.connectView.text,@"FollowUpStep":self.FollowUpStepField.text,@"FollowUpTimeSpan":self.FollowUpSpanField.text,@"FollowUpTime":self.FollowUpTimeField.text,@"NextTime":self.nextTimeField.text};
   
    NSDictionary *dict = @{@"authCode":code,
                           @"IsTrigger":isAwoke,
                           @"FollowContext":self.connectView.text,
                           @"FollowTime":self.FollowUpTimeField.text,
                           @"NextFollowTime":self.nextTimeField.text,
                           @"ServiceId":self.serviceId,
                           @"ServiceNo":self.serviceNo,
                           @"KeyPoints":keyField.text};
    [HttpRequset post:dict method:@"FollowUp/FollowUpAdd" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        [afLoading removeFromSuperview];
        if ([dic[@"ErrorMessage"]isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"添加跟进成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"ErrorMessage"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([radio.titleLabel.text isEqualToString:@"是"]) {
        isAwoke = @"true";
    }
    else
    {
        isAwoke = @"false";
    }
}

@end
