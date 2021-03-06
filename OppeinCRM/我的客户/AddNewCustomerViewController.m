//
//  AddNewCustomerViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "AddNewCustomerViewController.h"

@interface AddNewCustomerViewController ()
{
    AFLoadIngView *afloading;
}

@end

@implementation AddNewCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self.view addSubview:self.customerTable];
    
    self.AreaView = [[UIView alloc]init];
    
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    self.locatePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.customerAry1 = [[NSArray alloc]initWithObjects:@"姓名",@"手机号", nil];
    self.customerAry2 = [[NSArray alloc]initWithObjects:@"所在区域",@"详细地址", nil];
    self.customerProvice = @"北京市";
    self.customerCity = @"通州区";
    self.customerArea = @"";
    [self initNavigation];

}
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"新增客户"];
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(addNewCustomer)];    //把导航栏集合添加入导航栏中，设置动画关闭
    rightButton.tintColor = [UIColor blackColor];
    navigationItem.leftBarButtonItem = leftButton;
    navigationItem.rightBarButtonItem = rightButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}

-(void)back
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃上传客户信息" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续填写", nil];
    alert.tag = 1000;
    [alert show];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneField) {
        if (![self isPhoneNumber:self.phoneField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的手机号码格式不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.phoneField.text = @"";
        }
    }
}
-(void)addNewCustomer
{
    if ((self.nameField.text.length <= 0)||(self.phoneField.text.length <= 0)||(self.customerProvice.length <= 0)||
        (self.customerCity.length <= 0)||(self.addrField.text.length <= 0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传的信息不完整，请完善后重新上传" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1001;
        [alert show];
        return;
    }
    [self updataCustomer];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1000)&&(buttonIndex == 0)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.customerAry1.count;
    }
    else
        return self.customerAry2.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        if (indexPath.section == 0) {
            cell.textLabel.text = [self.customerAry1 objectAtIndex:indexPath.row];
            
            if (indexPath.row == 0) {
                self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(80, 6, 120, 30)];
                self.nameField.borderStyle = UITextBorderStyleNone;
                self.nameField.tag = 1000+indexPath.row;
                self.nameField.font = [UIFont systemFontOfSize:14.0f];
                self.nameField.textAlignment = NSTextAlignmentRight;
                self.nameField.returnKeyType = UIReturnKeyDone;
                self.nameField.placeholder = @"用户姓名";
                self.nameField.delegate = self;
                [cell.contentView addSubview:self.nameField];
                QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                _radio1.frame =CGRectMake(self.view.frame.size.width-100, 5, 50, 30);
                [_radio1 setTitle:@"先生" forState:UIControlStateNormal];
                [_radio1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [cell.contentView addSubview:_radio1];
                
                QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
                _radio2.frame = CGRectMake(self.view.frame.size.width-50, 5, 50, 30);
                [_radio2 setTitle:@"女士" forState:UIControlStateNormal];
                [_radio2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [cell.contentView addSubview:_radio2];
                [_radio1 setChecked:YES];
                
            }
            if (indexPath.row == 1) {
                self.phoneField = [[UITextField alloc]initWithFrame:CGRectMake(80, 6, 240, 30)];
                self.phoneField.borderStyle = UITextBorderStyleNone;
                self.phoneField.tag = 1000+indexPath.row;
                self.phoneField.font = [UIFont systemFontOfSize:14.0f];
                self.phoneField.textAlignment = NSTextAlignmentCenter;
                self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
                self.phoneField.returnKeyType = UIReturnKeyDone;
                self.phoneField.delegate = self;
                self.phoneField.placeholder = @"手机号码";
                [cell.contentView addSubview:self.phoneField];
            }
        }
        else
        {
            
            if (indexPath.row == 0) {
                //location
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 18)];
                img.image = [UIImage imageNamed:@"location.png"];
                [cell.contentView addSubview:img];
                
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 150, 20)];
                lab.text = [self.customerAry2 objectAtIndex:indexPath.row];
                lab.font = [UIFont systemFontOfSize:14.0f];
                lab.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:lab];
                
                self.areaLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, 10, 200, 20)];
                self.areaLab.font = [UIFont systemFontOfSize:12.0f];
                self.areaLab.text = [NSString stringWithFormat:@"%@ %@ %@",self.customerProvice,self.customerCity,self.customerArea];
                self.areaLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:self.areaLab];
            }
            else if (indexPath.row == 1)
            {
                cell.textLabel.text = [self.customerAry2 objectAtIndex:indexPath.row];
                self.addrField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width-220, 5, 200, 30)];
                self.addrField.borderStyle = UITextBorderStyleNone;
                self.addrField.delegate = self;
                self.addrField.textAlignment = NSTextAlignmentRight;
                self.addrField.font = [UIFont systemFontOfSize:14.0f];
                [cell.contentView addSubview:self.addrField];
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1)&&(indexPath.row == 0)) {
        [self.nameField resignFirstResponder];
        [self.phoneField resignFirstResponder];
        [self.addrField resignFirstResponder];
        [self.markField resignFirstResponder];
        [self showView:self.view];
    }
}

#pragma mark 性别选择

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if([radio.titleLabel.text isEqualToString:@"先生"])
    {
        self.sex = 1;
    }
    else
    {
        self.sex = 0;
    }
}

#pragma mark 区域选择器

- (void)showView:(UIView *) view
{
    self.AreaView.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, self.locatePicker.frame.size.height);
    [self.AreaView addSubview:self.locatePicker];
    self.AreaView.backgroundColor = [UIColor colorWithRed:0.5294 green:0.8078 blue:0.9803 alpha:1.0f];
    self.locatePicker.frame = CGRectMake(0, 40, self.view.frame.size.width, self.AreaView.frame.size.height);
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(30, 5, 40, 30);
    btn1.tag = 1001;
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(areaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.AreaView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(self.view.frame.size.width-70, 5, 40, 30);
    btn2.tag = 1002;
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(areaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.AreaView addSubview:btn2];
    
    [view addSubview:self.AreaView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.AreaView.frame = CGRectMake(0, view.frame.size.height - self.AreaView.frame.size.height, self.AreaView.frame.size.width, self.AreaView.frame.size.height);
    }];
    
}

- (void)cancelAreaView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.AreaView.frame = CGRectMake(0, self.AreaView.frame.origin.y+self.AreaView.frame.size.height, self.AreaView.frame.size.width, self.AreaView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.AreaView removeFromSuperview];
                     }];
}
-(void)areaAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 1001) {
        [self cancelAreaView];
        // self.areaLab.text = @"";
    }
    else
    {
        [self cancelAreaView];
    }
}
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        self.areaLab.text = str;
        self.customerProvice = picker.locate.state;
        self.customerCity = picker.locate.city;
        self.customerArea =  picker.locate.district;
    } else{
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self cancelAreaView];
}

-(void)updataCustomer
{
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    NSDictionary *dict = @{@"authCode":code,
                           @"CustomerName":self.nameField.text,
                           @"Sex":[NSNumber numberWithInt:self.sex],
                           @"Mobile":self.phoneField.text,
                           @"Province":self.customerProvice,
                           @"City":self.customerCity,
                           @"CArea":self.customerArea,
                           @"Adress":self.addrField.text};
    [HttpRequset post:dict method:@"Customer/CreateCustomer" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
         NSString *ErrorMessage = [dic objectForKey:@"ErrorMessage"];
        [afloading dismiss];
        if (([dic[@"Status"]integerValue]==200)&&(ErrorMessage.length<=0)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"添加客户成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该用户已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}


-(BOOL)isPhoneNumber:(NSString*)phoneNumber
{
    NSString * phoneRegex = @"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:phoneNumber] == YES)
    {
        return YES;
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
